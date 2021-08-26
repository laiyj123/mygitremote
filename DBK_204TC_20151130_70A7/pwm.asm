;============================================
;��ѹPWM������
;============================================
BoostPwm_Reset:
	clrf	tm3con

	movlw	00100111b						
	movwf	tm3con2	

	movlw	80
	movwf	tm3in
	
	movlw	10
	movwf	tm3r

	movlw	10000011b
	movwf	tm3con							;����PWM
	
	btfsc	R_SysMode,B_DisChargeMode		;�����Ὺ����ѹ�������п�IO��
	bcf		PT_TC_OUT_EN,IO_TC_OUT_EN
	return

BoostPwm_Close:
	movlw	0
	movwf	tm3r
	
	clrf	tm3con2

	call	pwm_init

	return
	
;-----------------------------------
;��ѹ����ռ�ձȶ���
BoostPwm_Inc:
	movlw	50
	subwf	tm3r,0
	btfss	status,c
	incf	tm3r,1
    return
    
;-----------------------------------
;��ѹ��Сռ�ձȶ���
BoostPwm_Dec:
	movlw	10
	subwf	tm3r,0
	btfsc	status,c	
	decf	tm3r,1
    return

;============================================
;��ѹPWM������
;============================================
BuckPwm_Reset:
	clrf	tm3con

	movlw	00000000b						
	movwf	tm3con2	

	movlw	246
	movwf	tm3in
	
	movlw	242
	movwf	tm3r

	movlw	10000011b
	movwf	tm3con							;����PWM

	return

BuckPwm_Close:
	bcf		B_ChargeFlag,B_Charge_Start
	movlw	248
	movwf	tm3r

	call	pwm_init

	return

;-----------------------------------
;��ѹ��Сռ�ձȶ���
BuckPwm_Dec:
	movlw	242
	subwf	tm3r,0
	btfss	status,c
	incf	tm3r,1
    return
    
;-----------------------------------
;��ѹ����ռ�ձȶ���
BuckPwm_Inc:
	movlw	5
	subwf	tm3r,0
	btfsc	status,c	
	decf	tm3r,1
    return



 
   

    
 