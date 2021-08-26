;============================================
;ϵͳģʽ��ڿ��ƺ���
;============================================
SysMode_Control:
	call	SysMode_End						;ϵͳģʽ����

	movfw	R_SysMode_OK
	xorwf	R_SysMode_BK,0	
    btfss	status,z
    goto	SysMode_Renew					;ģʽ����
    
    bcf		R_Flag,B_Check_TL431
;--------------------------------------------
;����ģʽ
	movfw	R_SysMode_BK
	andlw	00000111b
	addpcw
	goto	NullMode						;����ģʽ(���κβ���)
	goto	NormalMode						;����ģʽ(��ѹ�������)
	goto	ChargeMode						;���ģʽ(���)
	goto	DisChargeMode					;�ŵ�ģʽ(��ѹ�������)
	goto	ChaDischargeMode				;�߳�߷�ģʽ(��磬�����)
	goto	FirstOnMode						;��һ���ϵ�ģʽ(�ͻ��Զ���)
	goto	SleepMode						;˯��ģʽ(����)
	goto	ErrMode							;����ģʽ(�������ƣ�������ʾ)
;--------------------------------------------
;����ģʽ���	
NullMode:
	btfsc	R_SysMode,B_NullMode
	return
	bsf		R_SysMode,B_NullMode
	return
;--------------------------------------------
;����ģʽ���
NormalMode:
	;btfsc	R_SysMode,B_NormalMode
	;return
	;bsf		R_SysMode,B_NormalMode
	return
;--------------------------------------------
;���ģʽ���
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
;�ŵ�ģʽ���
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
;�߳�߷�ģʽ���
ChaDischargeMode:
	;btfsc	R_SysMode,B_ChaDischargeMode
	;return
	;bsf		R_SysMode,B_ChaDischargeMode
	return
;--------------------------------------------
;��һ���ϵ�ģʽ���
FirstOnMode:
	;btfsc	R_SysMode,B_FirstOnMode
	;return
	;bsf		R_SysMode,B_FirstOnMode
	;call	BatVol_Disp
	movlw	C_NullMode
	movwf	R_SysMode_OK
	
	return
;--------------------------------------------
;˯��ģʽ���
SleepMode:
	;btfsc	R_SysMode,B_SleepMode
	;return
	;bsf		R_SysMode,B_SleepMode
	return
;--------------------------------------------
;����ģʽ���
ErrMode:
	;btfsc	R_SysMode,B_ErrMode
	;return
	;bsf		R_SysMode,B_ErrMode
	return
;--------------------------------------------
;ģʽ�л�ʱֻ����һ��		
SysMode_Renew:
	movfw	R_SysMode_OK
	movwf	R_SysMode_BK
	bsf		R_Flag,B_Check_TL431
	return

;============================================
;ϵͳģʽ���ڿ��ƺ���
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
	goto	NullMode_End					;����ģʽ
	goto	NormalMode_End					;����ģʽ
	goto	ChargeMode_End					;���ģʽ
	goto	DisChargeMode_End  				;�ŵ�ģʽ
	goto	ChaDischargeMode_End   			;�߳�߷�ģʽ
	goto	FirstOnMode_End   				;��һ���ϵ�ģʽ
	goto	SleepMode_End					;˯��ģʽ
	goto	ErrMode_End						;����ģʽ
;--------------------------------------------
;����ģʽ����
NullMode_End:
	bcf		R_SysMode,B_NullMode

	goto	SysMode_End_Exit
;--------------------------------------------
;����ģʽ����
NormalMode_End:
	
	goto	SysMode_End_Exit
;--------------------------------------------
;���ģʽ����
ChargeMode_End:
	call	BuckPwm_Close
	bcf		B_ChargeFlag,B_Charge_Full
	bcf		B_ChargeFlag,B_Charge_Start
	bcf		R_SysMode,B_ChargeMode
	
	goto	SysMode_End_Exit
;--------------------------------------------
;�ŵ�ģʽ����
DisChargeMode_End:
	call	BoostPwm_Close
	bcf		pt1con,4						;�رո��ؼ���жϣ�һ�����ڲ���⸺�أ���ֹһֱѭ�����
											;��ͬ���Ӽ�סҪ����Ӧ��IO���ã���������������������������������������������������������������������������������    							
	bcf		PT_OUT_EN,IO_OUT_EN
	bcf		R_DischargeFlag,B_Boost_En
	bcf		R_SysMode,B_DisChargeMode
	clrf	R_IntLoad1_En_Time
	bcf		R_DischargeFlag,B_Discharge_MaxCur	
	bsf		PT_TC_OUT_EN,IO_TC_OUT_EN
	bcf		R_DischargeFlag,B_LED_OFF
	goto	SysMode_End_Exit
;--------------------------------------------
;�߳�߷�ģʽ����	
ChaDischargeMode_End:
	
	goto	SysMode_End_Exit
;--------------------------------------------
;��һ���ϵ�ģʽ����
FirstOnMode_End:
	call	BoostPwm_Close
	bcf		R_DischargeFlag,B_Boost_En
	bcf		R_SysMode,B_FirstOnMode
	goto	SysMode_End_Exit
;--------------------------------------------
;˯��ģʽ����
SleepMode_End:
	
	goto	SysMode_End_Exit
;--------------------------------------------
;����ģʽ����
ErrMode_End:
	
SysMode_End_Exit:
	movfw	R_SysMode_OK
	movwf	R_SysMode_BK2
	return
