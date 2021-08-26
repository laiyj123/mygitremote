;============================================
;�ŵ��ѹ���ƺ���
;============================================
DisChargeVol_Deal:
	btfss	R_DischargeFlag,B_Boost_En
	return	
;--------------------------------------------
;���PWM3ռ�ձ�Ϊ0����ʼ��PWM3
	movlw	0
	xorwf	tm3r,0
	btfsc	status,z
	goto	BoostPwm_Reset   
		
	;movlw	6ch
	;subwf	R_OutVol_DateL,0
	;btfss	status,c
	;goto	DisChargeVol_High		
;--------------------------------------------
;�ж��Ƿ���ں�ѹֵ
DisChargeVol_Low:
	movlw	C_OutVol_L   
	DW		FFFFH
	DW		FFFFH
	nop
	subwf	R_OutVol_DateL,0   
	btfss	status,c
	goto	DisChargeVol_High
/*	
	movlw	C_DisCharge_LimitCur2L
	subwf	R_BoostCur_DateL,0
	movlw	C_DisCharge_LimitCur2H
	subwfc	R_BoostCur_DateH,0
	btfsc	status,c
	goto	BoostPwm_Dec
	
	;----------------------------------------
    ;�ж��Ƿ���ں�������
    movlw	C_DisCharge_LimitCurL
	subwf	R_BoostCur_DateL,0
	movlw	C_DisCharge_LimitCurH
	subwfc	R_BoostCur_DateH,0
	btfss	status,c*/
	goto	BoostPwm_Inc
/*	
	movlw	C_OutVol_MinL
	subwf	R_OutVol_DateL,0
	btfsc	status,c
	goto	BoostPwm_Inc
	
	movlw	C_OutVol_MinH
	subwf	R_OutVol_DateL,0
	btfss	status,c
	goto	BoostPwm_Dec
	return	
*/
DisChargeVol_High:
	movlw	C_OutVol_H   
	DW		FFFFH
	DW		FFFFH
	nop
	subwf	R_OutVol_DateL,0
	btfss	status,c
	goto	BoostPwm_Dec
	
DisChargeCur_High:		
/*	movlw	C_DisCharge_LimitCur2L
	subwf	R_BoostCur_DateL,0
	movlw	C_DisCharge_LimitCur2H
	subwfc	R_BoostCur_DateH,0
	btfsc	status,c
	goto	BoostPwm_Dec*/
	return
	
;============================================
;�ŵ籣������
;============================================
DisCharge_Pro:
	btfss	R_DischargeFlag,B_Boost_En
	goto	DisCharge_Protect_End

	;----------------------------------------
    ;�жϷŵ��ѹ�Ƿ���ڱ�����ѹ
;	movlw	C_OutVol_Pro
;	subwf	R_OutVol_DateL,0
;	btfss	status,c
;	goto	BoostPwm_Dec				
	
	btfss	PT_OUT_EN,IO_OUT_EN
	goto	DisCharge_Protect_End
	
	btfsc	R_SysMode,B_FirstOnMode
	goto	DisCharge_Protect_End
	
	movlw	C_DisCharge_ShortCurL
	subwf	R_BoostCur_DateL,0
	movlw	C_DisCharge_ShortCurH
	subwfc	R_BoostCur_DateH,0
	btfsc	status,c
	goto	DisCharge_ShortDeal
	
	movlw	2
	movwf	R_DisCharge_ShortCurCnt
	
	movfw	R_DisCharge_ProCurL
	subwf	R_BoostCur_DateL,0
	;movlw	C_DisCharge_ProCurH
	movfw	R_DisCharge_ProCurH
	subwfc	R_BoostCur_DateH,0
	btfsc	status,c
	goto	DisCharge_ProDeal
	
	movlw	250
	movwf	R_DisCharge_ProCurCnt
	goto	DisCharge_Protect_End
	
DisCharge_ShortDeal:
	decfsz	R_DisCharge_ShortCurCnt,1
	goto	DisCharge_Protect_End
	incf	R_DisCharge_ShortCurCnt,1
	goto	DisCharge_Protect_Deal
	
DisCharge_ProDeal:
	decfsz	R_DisCharge_ProCurCnt,1
	goto	DisCharge_Protect_End
	incf	R_DisCharge_ProCurCnt,1
DisCharge_Protect_Deal:
	;========================================
	;����������
	;========================================
	call	BoostPwm_Close
	bcf		R_DischargeFlag,B_Boost_En
	
	bcf		pt1con,4						;�رո��ؼ���жϣ�һ�����ڲ���⸺�أ���ֹһֱѭ�����
											;��ͬ���Ӽ�סҪ����Ӧ��IO���ã���������������������������������������������������������������������������������    						
	bcf		PT_OUT_EN,IO_OUT_EN
	clrf	R_IntLoad1_En_Time	
	bcf		R_SysMode,B_DisChargeMode
;	bcf		R_DischargeFlag,B_Discharge_MaxCur	
	bsf		R_Flag,B_SysMode_Close
    bsf		PT_TC_OUT_EN,IO_TC_OUT_EN
	movlw	C_NullMode
	movwf	R_SysMode_OK

DisCharge_Protect_End:
	return

;============================================
;�ŵ�С�����жϺ���
;============================================
DisCharge_SmallCur:
	btfss	PT_OUT_EN,IO_OUT_EN
	goto	DisCharge_SmallCur_End
/*	
	movlw	C_DisCharge_DispCurL
	subwf	R_BoostCur_DateL,0
	btfss	status,c
	bcf		R_DischargeFlag,B_Discharge_DispCur
	
	movlw	C_DisCharge_DispCurH
	subwf	R_BoostCur_DateL,0
	btfss	status,c
	goto	DisCharge_SmallCur_Jud
	bsf		R_DischargeFlag,B_Discharge_DispCur	
*/	
DisCharge_SmallCur_Jud:	
	movlw	C_DisCharge_SmallCurL
	btfsc	R_DischargeFlag,B_Discharge_MinCur
	movlw	C_DisCharge_SmallCurL2
	subwf	R_BoostSmallCur_DateL,0
	movlw	C_DisCharge_SmallCurH
	subwfc	R_BoostSmallCur_DateH,0
	btfss	status,c
	goto	DisCharge_SmallCur_Deal
	;========================================
	;����С����������
	;========================================
	movlw	C_DisCharge_SmallCur2L
	subwf	R_BoostSmallCur_DateL,0
	movlw	C_DisCharge_SmallCur2H
	subwfc	R_BoostSmallCur_DateH,0
	btfss	status,c
	goto	DisCharge_SmallCur_Jud2
	
	bcf		R_DischargeFlag,B_Discharge_MinCur
	
DisCharge_SmallCur_Jud2:		
	bsf		R_DischargeFlag,B_Discharge_MaxCur	
	
	btfss	R_DischargeFlag,B_Load2_IN
	goto	Load1_IN_Jud	
	movlw	C_DisCharge_DispCurL
	subwf	R_BoostCur_DateL,0
	btfsc	status,c
	goto	DisCharge_HighCur_Deal
	bcf		R_DischargeFlag,B_Load2_IN
	bsf		R_DischargeFlag,B_Load1_IN
	goto	DisCharge_HighCur_Deal
	
Load1_IN_Jud:	
	movlw	C_DisCharge_DispCurH
	subwf	R_BoostCur_DateL,0
	btfss	status,c
	goto	DisCharge_HighCur_Deal
	bsf		R_DischargeFlag,B_Load2_IN
	bcf		R_DischargeFlag,B_Load1_IN

DisCharge_HighCur_Deal:	
	clrf	R_DisCharge_SmallCurCnt
	clrf	R_DisCharge_OutTime
	goto	DisCharge_SmallCur_End
	
DisCharge_SmallCur_Deal:
	incf	R_DisCharge_SmallCurCnt,1
	movlw	C_DisCharge_SmallCurTime
	subwf	R_DisCharge_SmallCurCnt,0
	btfss	status,c
	goto	DisCharge_SmallCur_End

	;========================================
	;С����������
	;========================================
	bcf		R_DischargeFlag,B_Discharge_MaxCur
	bsf		R_DischargeFlag,B_Discharge_MinCur
	
	incf	R_DisCharge_OutTime,1
	movlw	C_DisCharge_OutTime
	subwf	R_DisCharge_OutTime,0
	btfss	status,c
	goto	DisCharge_SmallCur_End
	
	bcf		R_DischargeFlag,B_Load1_IN
	bcf		R_DischargeFlag,B_Load2_IN
	
	movlw	C_NullMode
	movwf	R_SysMode_OK

DisCharge_SmallCur_End:
	return
