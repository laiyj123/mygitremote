;============================================
;充电控制函数
;============================================
Charge_Control:
	;========================================
	;进入控制的条件
	btfss	R_SysMode,B_ChargeMode
	return
	
	btfsc	B_ChargeFlag,B_Charge_Full
	return
	;========================================
Charge_SmallCur:
	btfss	R_ChargeMode,B_CVMode
	goto	Charge_SmallCur_End	

	movlw	C_Charge_SmallCurL
	subwf	R_BuckCur_DateL,0
	movlw	C_Charge_SmallCurH
	subwfc	R_BuckCur_DateH,0
	btfss	status,c
	goto	Charge_SmallCur_Deal
	movlw	20
	movwf	R_Charge_SmallCurCnt

Charge_SmallCur_Deal:	
	decfsz	R_Charge_SmallCurCnt,1
	goto	Charge_SmallCur_End
	incf	R_Charge_SmallCurCnt,1
	;========================================
	;小电流处理动作
	;========================================	
	movlw	100
	subwf	R_LcdDate_OK,0
	btfsc	status,c
	goto	Charge_Full_Deal		
	
	movlw	30
	subwf	R_Time1min,0
	btfss	status,c
	return
	clrf	R_Time1min
	incf	R_LcdDate_OK,1
	goto	BatteryCap_Fun_Exit
	
Charge_Full_Deal:	
	call	BuckPwm_Close
	bsf		B_ChargeFlag,B_Charge_Full
	
	movlw	100
	movwf	R_LcdDate_OK

	goto	BatteryCap_Fun_Exit	
	
Charge_SmallCur_End:	
	return
	
;============================================
;充电模式判断函数
;============================================
ChargeMode_Control:	
	;========================================
	;进入控制的条件
	;========================================
	btfss	R_SysMode,B_ChargeMode
	return
	
	btfsc	B_ChargeFlag,B_Charge_Full
	return
/*	
	bcf		R_ChargeMode,B_TrickMode
	movlw	C_TrickVolL
	subwf	R_BatVol_DateL,0
	movlw	C_TrickVolH
	subwfc	R_BatVol_DateH,0
	btfss	status,c
	bsf		R_ChargeMode,B_TrickMode

	movlw	C_CV_VolL
	subwf	R_BatVol_DateL,0
	movlw	C_CV_VolH
	subwfc	R_BatVol_DateH,0
	btfsc	status,c
	bsf		R_ChargeMode,B_CVMode
*/	
		
	movlw	C_TrickVolL						;涓流充电2.8V
	subwf	R_BatVol_DateL,0
	movlw	C_TrickVolH
	subwfc	R_BatVol_DateH,0
	btfsc	status,c
	goto	ChargeMode_CCJud
	clrf	R_ChargeMode_OK
	goto	ChargeMode_Deal

ChargeMode_CCJud:
	movlw	C_TrickVol2L					;涓流充电3.0V
	subwf	R_BatVol_DateL,0
	movlw	C_TrickVol2H
	subwfc	R_BatVol_DateH,0
	btfss	status,c
	goto	ChargeMode_Deal
	
	movlw	C_CV_VolL
	subwf	R_BatVol_DateL,0				;充电恒压4.22V
	movlw	C_CV_VolH
	subwfc	R_BatVol_DateH,0
	btfss	status,c
	goto	ChargeMode_CVJud
	movlw	C_CVMode
	movwf	R_ChargeMode_OK
	goto	ChargeMode_Deal
	
ChargeMode_CVJud:
	movlw	C_CC_VolL						;充电恒压4.0V	
	subwf	R_BatVol_DateL,0
	movlw	C_CC_VolH
	subwfc	R_BatVol_DateH,0
	btfsc	status,c
	goto	ChargeMode_Deal
	movlw	C_CCMode
	movwf	R_ChargeMode_OK		
			
ChargeMode_Deal:	
	movfw	R_ChargeMode_OK
	xorwf	R_ChargeMode_BK,0	
    btfss	status,z
    goto	ChargeMode_Renew				;模式更新
;--------------------------------------------
;进入模式
	movfw	R_ChargeMode_BK
	andlw	00000011b
	addpcw
	goto	TrickMode						;涓流充电模式
	goto	CCMode							;恒流充电模式
	goto	CVMode							;恒压充电模式
	return
	
TrickMode:
	bsf		R_ChargeMode,B_TrickMode
	bcf		R_ChargeMode,B_CVMode
	goto	Reset_Charge

CCMode:
	bcf		R_ChargeMode,B_TrickMode
	bcf		R_ChargeMode,B_CVMode
	goto	Reset_Charge
	
CVMode:
	bcf		R_ChargeMode,B_TrickMode
	bsf		R_ChargeMode,B_CVMode
	goto	Reset_Charge
	
ChargeMode_Renew:
	movfw	R_ChargeMode_OK
	movwf	R_ChargeMode_BK
	return

Reset_Charge:	
	btfsc	B_ChargeFlag,B_Charge_Start
	return
	bsf		B_ChargeFlag,B_Charge_Start
	bcf		R_ChargeMode,B_CVMode
	goto	BuckPwm_Reset

;============================================
;充电模式判断函数
;============================================
Charge_Deal:
	;========================================
	;进入控制的条件
	;========================================
	btfss	B_ChargeFlag,B_Charge_Start
	goto	Charge_Deal_End
	
	btfsc	B_ChargeFlag,B_Charge_Full
	goto	Charge_Deal_End

IF	K_188LED_Power
	DW		FFFFH
	DW		FFFFH
	nop
	movlw	C_Charge_MosOffCur				;关MOS管电流:300mA
	subwf	R_BuckCur_DateL,0
	btfsc	status,c
	goto	Charge_Deal_NT
	bcf		PT_USB,IO_USB
	bsf		PT_TC_OUT_EN,IO_TC_OUT_EN

Charge_Deal_NT:
	movlw	C_Charge_MosOnCur				;开MOS管电流:500mA
	subwf	R_BuckCur_DateL,0
	btfss	status,c
	goto	ChargeVolLow_Deal
	btfss	B_ChargeFlag,B_TC_USB_In		;有TYPE-C充电的时候不开启Mir_USB的MOS
	bsf		PT_USB,IO_USB
	btfsc	B_ChargeFlag,B_TC_USB_In
	bcf		PT_TC_OUT_EN,IO_TC_OUT_EN		;开启充电

else	
	movlw	C_Charge_MosOffCur				;关MOS管电流:300mA
	subwf	R_BuckCur_DateL,0
	btfss	status,c
	bsf		PT_PSW,IO_PSW

	movlw	C_Charge_MosOnCur				;开MOS管电流:500mA
	subwf	R_BuckCur_DateL,0
	btfss	status,c
	goto	ChargeVolLow_Deal
	bcf		PT_PSW,IO_PSW
ENDIF	

ChargeVolLow_Deal:	
	btfsc	R_ChargeMode,B_TrickMode
	goto	ChargeCur_Deal

	movlw	C_ChargeVol_Low2L
	subwf	R_OutVol_DateL,0
	btfss	status,c
;	bcf		R_ChargeMode,B_ChargeVolLow_Flag ;单向充电
	
	movlw	C_ChargeVol_Low1L
	subwf	R_OutVol_DateL,0
	btfss	status,c
	goto	ChargeCur_Deal
	bsf		R_ChargeMode,B_ChargeVolLow_Flag
	goto	BuckPwm_Dec

ChargeCur_Deal:
	btfsc	R_ChargeMode,B_TrickMode
	goto	ChargeCur_TrickLow
	
	btfss	R_ChargeMode,B_CVMode
	goto	ChargeCur_CCLow
	
	movlw	C_CV_VolL
	subwf	R_BatVol_DateL,0
	movlw	C_CV_VolH
	subwfc	R_BatVol_DateH,0
	btfss	status,c
	goto	Charge_Deal_End
	goto	BuckPwm_Dec
	
ChargeCur_CCLow:
	btfsc	R_ChargeMode,B_ChargeVolLow_Flag
	goto	ChargeCur_CCHigh
	
	btfss	R_Flag,B_ChargeControl_Time
	goto	ChargeCur_CCHigh
	
	movlw	C_ConCur1L
	subwf	R_BuckCur_DateL,0
	movlw	C_ConCur1H
	subwfc	R_BuckCur_DateH,0
	btfss	status,c
	goto	BuckPwm_Inc

ChargeCur_CCHigh:
	movlw	C_ConCur2L
	subwf	R_BuckCur_DateL,0
	movlw	C_ConCur2H
	subwfc	R_BuckCur_DateH,0
	btfsc	status,c
	goto	BuckPwm_Dec
	goto	Charge_Deal_End

ChargeCur_TrickLow:
	btfsc	R_ChargeMode,B_ChargeVolLow_Flag
	goto	ChargeCur_TrickHigh
	
	btfss	R_Flag,B_ChargeControl_Time
	goto	ChargeCur_TrickHigh
	
	movlw	C_TrickCur1L
	subwf	R_BuckCur_DateL,0
	movlw	C_TrickCur1H
	subwfc	R_BuckCur_DateH,0
	btfss	status,c
	goto	BuckPwm_Inc
	
ChargeCur_TrickHigh:
	movlw	C_TrickCur2L
	subwf	R_BuckCur_DateL,0
	movlw	C_TrickCur2H
	subwfc	R_BuckCur_DateH,0
	btfsc	status,c
	goto	BuckPwm_Dec
	
Charge_Deal_End:
	return	
