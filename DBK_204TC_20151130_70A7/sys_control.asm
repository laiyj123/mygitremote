;============================================
;系统模式入口控制函数
;============================================
SysMode_Control:
	call	SysMode_End						;系统模式出口

	movfw	R_SysMode_OK
	xorwf	R_SysMode_BK,0	
    btfss	status,z
    goto	SysMode_Renew					;模式更新
    
    bcf		R_Flag,B_Check_TL431
;--------------------------------------------
;进入模式
	movfw	R_SysMode_BK
	andlw	00000111b
	addpcw
	goto	NullMode						;空闲模式(无任何操作)
	goto	NormalMode						;正常模式(升压，无输出)
	goto	ChargeMode						;充电模式(充电)
	goto	DisChargeMode					;放电模式(升压，有输出)
	goto	ChaDischargeMode				;边充边放模式(充电，有输出)
	goto	FirstOnMode						;第一次上电模式(客户自定义)
	goto	SleepMode						;睡眠模式(休眠)
	goto	ErrMode							;错误模式(保护机制，错误显示)
;--------------------------------------------
;空闲模式入口	
NullMode:
	btfsc	R_SysMode,B_NullMode
	return
	bsf		R_SysMode,B_NullMode
	return
;--------------------------------------------
;正常模式入口
NormalMode:
	;btfsc	R_SysMode,B_NormalMode
	;return
	;bsf		R_SysMode,B_NormalMode
	return
;--------------------------------------------
;充电模式入口
ChargeMode:
	btfsc	R_SysMode,B_ChargeMode
	return
	bsf		R_SysMode,B_ChargeMode
	movlw	20
	movwf	R_Charge_SmallCurCnt
;	bcf		R_TimeFlag,B_First1S_OK
;	clrf	R_time1s
	return
;--------------------------------------------
;放电模式入口
DisChargeMode:
	btfsc	R_SysMode,B_DisChargeMode
	return
	bsf		R_SysMode,B_DisChargeMode
	bsf		R_DischargeFlag,B_Boost_En
	bsf		PT_OUT_EN,IO_OUT_EN
	clrf	R_DisCharge_SmallCurCnt
	clrf	R_DisCharge_OutTime
	clrf	R_Lcd_DispTime
	bsf		R_DischargeFlag,B_Load1_IN
	bcf		R_DischargeFlag,B_Load2_IN
	bcf		R_TimeFlag,B_First1S_OK
	clrf	R_time1s
	movlw	250
	movwf	R_DisCharge_ProCurCnt
	return
;--------------------------------------------
;边充边放模式入口
ChaDischargeMode:
	;btfsc	R_SysMode,B_ChaDischargeMode
	;return
	;bsf		R_SysMode,B_ChaDischargeMode
	return
;--------------------------------------------
;第一次上电模式入口
FirstOnMode:
	;btfsc	R_SysMode,B_FirstOnMode
	;return
	;bsf		R_SysMode,B_FirstOnMode
	;call	BatVol_Disp
	movlw	C_NullMode
	movwf	R_SysMode_OK
	
	return
;--------------------------------------------
;睡眠模式入口
SleepMode:
	;btfsc	R_SysMode,B_SleepMode
	;return
	;bsf		R_SysMode,B_SleepMode
	return
;--------------------------------------------
;错误模式入口
ErrMode:
	;btfsc	R_SysMode,B_ErrMode
	;return
	;bsf		R_SysMode,B_ErrMode
	return
;--------------------------------------------
;模式切换时只进来一次		
SysMode_Renew:
	movfw	R_SysMode_OK
	movwf	R_SysMode_BK
	bsf		R_Flag,B_Check_TL431
	return

;============================================
;系统模式出口控制函数
;============================================
SysMode_End:
	btfsc	R_Flag,B_SysMode_Close
	goto	SysMode_End_Exit

	movfw	R_SysMode_OK
	xorwf	R_SysMode_BK2,0	
    btfsc	status,z
    return					  

	movfw	R_SysMode_BK2
	andlw	00000111b
	addpcw
	goto	NullMode_End					;空闲模式
	goto	NormalMode_End					;正常模式
	goto	ChargeMode_End					;充电模式
	goto	DisChargeMode_End  				;放电模式
	goto	ChaDischargeMode_End   			;边充边放模式
	goto	FirstOnMode_End   				;第一次上电模式
	goto	SleepMode_End					;睡眠模式
	goto	ErrMode_End						;错误模式
;--------------------------------------------
;空闲模式出口
NullMode_End:
	bcf		R_SysMode,B_NullMode

	goto	SysMode_End_Exit
;--------------------------------------------
;正常模式出口
NormalMode_End:
	
	goto	SysMode_End_Exit
;--------------------------------------------
;充电模式出口
ChargeMode_End:
	call	BuckPwm_Close
	bcf		B_ChargeFlag,B_Charge_Full
	bcf		B_ChargeFlag,B_Charge_Start
	bcf		R_SysMode,B_ChargeMode
	
	goto	SysMode_End_Exit
;--------------------------------------------
;放电模式出口
DisChargeMode_End:
	call	BoostPwm_Close
	bcf		pt1con,4						;关闭负载检测中断，一秒钟内不检测负载，防止一直循环检测
											;不同案子记住要改相应的IO配置！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！    							
	bcf		PT_OUT_EN,IO_OUT_EN
	bcf		R_DischargeFlag,B_Boost_En
	bcf		R_SysMode,B_DisChargeMode
	clrf	R_IntLoad1_En_Time
	bcf		R_DischargeFlag,B_Discharge_MaxCur	
	bsf		PT_TC_OUT_EN,IO_TC_OUT_EN
	bcf		R_DischargeFlag,B_LED_OFF
	goto	SysMode_End_Exit
;--------------------------------------------
;边充边放模式出口	
ChaDischargeMode_End:
	
	goto	SysMode_End_Exit
;--------------------------------------------
;第一次上电模式出口
FirstOnMode_End:
	call	BoostPwm_Close
	bcf		R_DischargeFlag,B_Boost_En
	bcf		R_SysMode,B_FirstOnMode
	goto	SysMode_End_Exit
;--------------------------------------------
;睡眠模式出口
SleepMode_End:
	
	goto	SysMode_End_Exit
;--------------------------------------------
;错误模式出口
ErrMode_End:
	
SysMode_End_Exit:
	movfw	R_SysMode_OK
	movwf	R_SysMode_BK2
	return
