;============================================
;升压PWM处理函数
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
	movwf	tm3con							;开启PWM
	
	btfsc	R_SysMode,B_DisChargeMode		;开机会开启升压，不进行开IO口
	bcf		PT_TC_OUT_EN,IO_TC_OUT_EN
	return

BoostPwm_Close:
	movlw	0
	movwf	tm3r
	
	clrf	tm3con2

	call	pwm_init

	return
	
;-----------------------------------
;升压增大占空比动作
BoostPwm_Inc:
	movlw	50
	subwf	tm3r,0
	btfss	status,c
	incf	tm3r,1
    return
    
;-----------------------------------
;升压减小占空比动作
BoostPwm_Dec:
	movlw	10
	subwf	tm3r,0
	btfsc	status,c	
	decf	tm3r,1
    return

;============================================
;降压PWM处理函数
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
	movwf	tm3con							;开启PWM

	return

BuckPwm_Close:
	bcf		B_ChargeFlag,B_Charge_Start
	movlw	248
	movwf	tm3r

	call	pwm_init

	return

;-----------------------------------
;降压减小占空比动作
BuckPwm_Dec:
	movlw	242
	subwf	tm3r,0
	btfss	status,c
	incf	tm3r,1
    return
    
;-----------------------------------
;降压增大占空比动作
BuckPwm_Inc:
	movlw	5
	subwf	tm3r,0
	btfsc	status,c	
	decf	tm3r,1
    return



 
   

    
 