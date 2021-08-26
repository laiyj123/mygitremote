;============================================
;LCD处理函数
;============================================
LcdOff:
	bcf		PT_ComEn,P_Com0					;关LCD显示驱动COM口，设为输入口
	bcf		PT_ComEn,P_Com1
	bcf		PT_ComEn,P_Com2
	bcf		PT_ComEn,P_Com3
	bcf		PT_Seg0,P_Seg0					;关LCD显示驱动SEG口，设为输出口低电平
	bcf		PT_Seg1,P_Seg1
	bcf		PT_Seg2,P_Seg2
	bcf		PT_Seg3,P_Seg3
	bcf		PT_Seg4,P_Seg4
	return

LcdDrive:
	btfsc	R_TimeFlag,B_FirstOnMode2
	goto	LcdDrive_OK
	btfsc	R_Flag,B_USB_IN
	goto	LcdDrive_OK
	btfss	R_SysMode,B_DisChargeMode
	goto	LcdOff

	movlw	C_DisCharge_OutTime
	subwf	R_DisCharge_OutTime,0
	btfsc	status,c
	goto	LcdOff

;LcdDrive_OK_First:
	;btfsc	R_TimeFlag,B_FirstOnMode_OK	
	;goto	LcdOff
LcdDrive_OK:
	incf	R_LcdCom_Cnt,1
	movlw	4
	subwf	R_LcdCom_Cnt,0
	btfss	status,c
	goto	LcdDrive_init
	clrf	R_LcdCom_Cnt
	movlw	00000001b
	xorwf	R_Flag,1
	
LcdDrive_init:
	btfsc	R_Flag,B_LcdScan
	goto	LcdDrive_High
	goto	LcdDrive_Low
		
LcdDrive_Low:
	call	LcdOff	
	
	btfss	R_TimeFlag,B_FirstOnMode2
	goto	LcdDrive_Low_Deal	
	bsf		PT_Seg0,P_Seg0					;全显
	bsf		PT_Seg1,P_Seg1
	bsf		PT_Seg2,P_Seg2
	bsf		PT_Seg3,P_Seg3
	bsf		PT_Seg4,P_Seg4	
LcdDrive_Low_Deal:	
						
	movfw	R_LcdCom_Cnt
	andlw	00000011b
	addpcw
	goto	LcdDrive_LowCom0
	goto	LcdDrive_LowCom1
	goto	LcdDrive_LowCom2
	goto	LcdDrive_LowCom3
	
LcdDrive_LowCom0:
	call	Shi_Tab
	btfsc	R_Data1,C_SegF
	bsf		PT_Seg0,P_Seg0
	btfsc	R_Data1,C_SegA
	bsf		PT_Seg1,P_Seg1
	
	call	Ge_Tab
	btfsc	R_Data1,C_SegF
	bsf		PT_Seg2,P_Seg2
	btfsc	R_Data1,C_SegA
	bsf		PT_Seg3,P_Seg3
	
	btfss	R_Flag,B_USB_IN
	goto	LcdDrive_LowCom0_com
	
	btfsc	R_TimeFlag,B_Disp_Flash
	bsf		PT_Seg4,P_Seg4	

LcdDrive_LowCom0_com:	
	bcf		PT_Com,P_Com0
	bsf		PT_ComEn,P_Com0
	return

LcdDrive_LowCom1:
	call	Shi_Tab
	btfsc	R_Data1,C_SegG
	bsf		PT_Seg0,P_Seg0
	btfsc	R_Data1,C_SegB
	bsf		PT_Seg1,P_Seg1
	
	call	Ge_Tab
	btfsc	R_Data1,C_SegG
	bsf		PT_Seg2,P_Seg2
	btfsc	R_Data1,C_SegB
	bsf		PT_Seg3,P_Seg3
	
	btfsc	R_DischargeFlag,B_Discharge_MaxCur
	bsf		PT_Seg4,P_Seg4
	
	bcf		PT_Com,P_Com1
	bsf		PT_ComEn,P_Com1
	return

LcdDrive_LowCom2:
	call	Shi_Tab
	btfsc	R_Data1,C_SegE
	bsf		PT_Seg0,P_Seg0
	btfsc	R_Data1,C_SegC
	bsf		PT_Seg1,P_Seg1
	
	call	Ge_Tab
	btfsc	R_Data1,C_SegE
	bsf		PT_Seg2,P_Seg2
	btfsc	R_Data1,C_SegC
	bsf		PT_Seg3,P_Seg3
	
	btfss	R_DischargeFlag,B_Discharge_MaxCur
	goto	LcdDrive_LowCom2_com
	
	btfsc	R_DischargeFlag,B_Load2_IN	
	bsf		PT_Seg4,P_Seg4

LcdDrive_LowCom2_com:	
	bcf		PT_Com,P_Com2
	bsf		PT_ComEn,P_Com2
	return

LcdDrive_LowCom3:
	bsf		PT_Seg2,P_Seg2			;%
	
	btfsc	R_LcdDate_Bai,0
	bsf		PT_Seg0,P_Seg0
	
	call	Shi_Tab
	btfsc	R_Data1,C_SegD
	bsf		PT_Seg1,P_Seg1
	
	call	Ge_Tab
	btfsc	R_Data1,C_SegD
	bsf		PT_Seg3,P_Seg3
	
	btfss	R_DischargeFlag,B_Discharge_MaxCur
	goto	LcdDrive_LowCom3_com
	
	btfsc	R_DischargeFlag,B_Load1_IN	
	bsf		PT_Seg4,P_Seg4
	
LcdDrive_LowCom3_com:	
	bcf		PT_Com,P_Com3
	bsf		PT_ComEn,P_Com3
	return

LcdDrive_High:
	bcf		PT_ComEn,P_Com0					;关LCD显示驱动COM口，设为输入口
	bcf		PT_ComEn,P_Com1
	bcf		PT_ComEn,P_Com2
	bcf		PT_ComEn,P_Com3
	bsf		PT_Seg0,P_Seg0
	bsf		PT_Seg1,P_Seg1
	bsf		PT_Seg2,P_Seg2
	bsf		PT_Seg3,P_Seg3
	bsf		PT_Seg4,P_Seg4
	
	btfss	R_TimeFlag,B_FirstOnMode2
	goto	LcdDrive_High_Deal	
	bcf		PT_Seg0,P_Seg0					;全显
	bcf		PT_Seg1,P_Seg1
	bcf		PT_Seg2,P_Seg2
	bcf		PT_Seg3,P_Seg3
	bcf		PT_Seg4,P_Seg4	
LcdDrive_High_Deal:	

	movfw	R_LcdCom_Cnt
	andlw	00000011b
	addpcw
	goto	LcdDrive_HighCom0
	goto	LcdDrive_HighCom1
	goto	LcdDrive_HighCom2
	goto	LcdDrive_HighCom3
	
LcdDrive_HighCom0:
	call	Shi_Tab
	btfsc	R_Data1,C_SegF
	bcf		PT_Seg0,P_Seg0
	btfsc	R_Data1,C_SegA
	bcf		PT_Seg1,P_Seg1
	
	call	Ge_Tab
	btfsc	R_Data1,C_SegF
	bcf		PT_Seg2,P_Seg2
	btfsc	R_Data1,C_SegA
	bcf		PT_Seg3,P_Seg3
	
	btfss	R_Flag,B_USB_IN
	goto	LcdDrive_HighCom0_com
	
	btfsc	R_TimeFlag,B_Disp_Flash
	bcf		PT_Seg4,P_Seg4	
	
LcdDrive_HighCom0_com:	
	bsf		PT_Com,P_Com0
	bsf		PT_ComEn,P_Com0
	return

LcdDrive_HighCom1:
	call	Shi_Tab
	btfsc	R_Data1,C_SegG
	bcf		PT_Seg0,P_Seg0
	btfsc	R_Data1,C_SegB
	bcf		PT_Seg1,P_Seg1
	
	call	Ge_Tab
	btfsc	R_Data1,C_SegG
	bcf		PT_Seg2,P_Seg2
	btfsc	R_Data1,C_SegB
	bcf		PT_Seg3,P_Seg3
	
	btfsc	R_DischargeFlag,B_Discharge_MaxCur
	bcf		PT_Seg4,P_Seg4
	
	bsf		PT_Com,P_Com1
	bsf		PT_ComEn,P_Com1
	return

LcdDrive_HighCom2:
	call	Shi_Tab
	btfsc	R_Data1,C_SegE
	bcf		PT_Seg0,P_Seg0
	btfsc	R_Data1,C_SegC
	bcf		PT_Seg1,P_Seg1
	
	call	Ge_Tab
	btfsc	R_Data1,C_SegE
	bcf		PT_Seg2,P_Seg2
	btfsc	R_Data1,C_SegC
	bcf		PT_Seg3,P_Seg3
	
	btfss	R_DischargeFlag,B_Discharge_MaxCur
	goto	LcdDrive_HighCom2_com
	
	btfsc	R_DischargeFlag,B_Load2_IN
	bcf		PT_Seg4,P_Seg4
	
LcdDrive_HighCom2_com:	
	bsf		PT_Com,P_Com2	
	bsf		PT_ComEn,P_Com2
	return

LcdDrive_HighCom3:
	bcf		PT_Seg2,P_Seg2			;%
	
	btfsc	R_LcdDate_Bai,0
	bcf		PT_Seg0,P_Seg0
	
	call	Shi_Tab
	btfsc	R_Data1,C_SegD
	bcf		PT_Seg1,P_Seg1
	
	call	Ge_Tab
	btfsc	R_Data1,C_SegD
	bcf		PT_Seg3,P_Seg3
	
	btfss	R_DischargeFlag,B_Discharge_MaxCur
	goto	LcdDrive_HighCom3_com
	
	btfsc	R_DischargeFlag,B_Load1_IN	
	bcf		PT_Seg4,P_Seg4
	
LcdDrive_HighCom3_com:	
	bsf		PT_Com,P_Com3
	bsf		PT_ComEn,P_Com3
	return	

Shi_Tab:	
	movfw	R_LcdDate_Shi
	call	LcdData_Tab
	movwf	R_Data1
	return

Ge_Tab:
	movfw	R_LcdDate_Ge
	call	LcdData_Tab
	movwf	R_Data1
	return

;--------------------------------------------
;LCD显示数值表
LcdData_Tab:
	andlw	0fh
	addpcw
	retlw	00111111b	;0
	retlw	00000110b	;1
	retlw	01011011b	;2
	retlw	01001111b	;3
	retlw	01100110b	;4
	retlw	01101101b	;5
	retlw	01111101b	;6
	retlw	00000111b	;7
	retlw	01111111b	;8
	retlw	01101111b	;9
	retlw	00000000b	;0
	retlw	00000000b	;0
	retlw	00000000b	;0
	retlw	00000000b	;0
	retlw	00000000b	;0
	retlw	00000000b	;0
	
;============================================
;十六进制转十进制
;输入：R_LcdDate_Disp
;输出：R_LcdDate_Bai、R_LcdDate_Shi、R_LcdDate_Ge
;============================================
HexToDex:
	movff	R_LcdDate_OK,R_LcdDate_Disp
	movlw	100
	subwf	R_LcdDate_Disp,0
	btfsc	status,c
	goto	HexToDex_100
	
	clrf	R_LcdDate_Bai
	clrf	R_LcdDate_Shi
	clrf	R_LcdDate_Ge
	
HexToDex_loop:
	movfw	R_LcdDate_Disp
	movwf	R_LcdDate_Ge
	movlw	10
	subwf	R_LcdDate_Disp,1
	btfss	status,c
	return
	incf	R_LcdDate_Shi,1
	goto	HexToDex_loop
	
HexToDex_100:
	movlw	1
	movwf	R_LcdDate_Bai
	clrf	R_LcdDate_Shi
	clrf	R_LcdDate_Ge

	return     
