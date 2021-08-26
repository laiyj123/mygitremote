
if	K_88LED_Power
;============================================
;LED处理函数
;============================================
LedOff:
	bcf		PT_A,P_A
	bcf		PT_B,P_B
	bcf		PT_C,P_C
	bcf		PT_D,P_D
	bcf		PT_E,P_E
	bcf		PT_F,P_F
	bcf		PT_G,P_G
	return
	
LedDrive:
	btfsc	R_Flag,B_USB_IN
	goto	LedDrive_OK
	btfss	R_SysMode,B_DisChargeMode
	goto	LedOff
	
IF	K_discharge_off
	movlw	C_Lcd_DispTime
	subwf	R_Lcd_DispTime,0
	btfsc	status,c
	goto	LedOff
ENDIF	

LedDrive_OK:
	movlw	00000001b				;B_LcdScan标志位
	xorwf	R_Flag,1	
	
LedDrive_init:
	bcf		PT_A,P_A
	bcf		PT_B,P_B
	bcf		PT_C,P_C
	bcf		PT_D,P_D
	bcf		PT_E,P_E
	bcf		PT_F,P_F
	bcf		PT_G,P_G
	bcf		PT_DIG,P_DIG1
	bcf		PT_DIG,P_DIG2
	bcf		PT_DIGEn,P_DIG1
	bcf		PT_DIGEn,P_DIG2	
	
	btfsc	R_Flag,B_LcdScan
	goto	LedDrive_Dig1			;扫描个位数码管
	goto	LedDrive_Dig2			;扫描十位数码管

;----------------------------
;第一位数码管
LedDrive_Dig1:
	movfw	R_LcdDate_Ge
	call	LedData_Tab
	movwf	R_Data1					;提取个位数据
	
	btfss	R_Flag,B_USB_IN
	goto	LedDrive_Dig1_Nt	
	
	btfss	R_TimeFlag,B_Disp_Flash
	return

LedDrive_Dig1_Nt:	
	btfsc	R_Data1,C_SegA
	bsf		PT_A,P_A
	btfsc	R_Data1,C_SegB
	bsf		PT_B,P_B
	btfsc	R_Data1,C_SegC
	bsf		PT_C,P_C	
	btfsc	R_Data1,C_SegD
	bsf		PT_D,P_D	
	btfsc	R_Data1,C_SegE
	bsf		PT_E,P_E	
	btfsc	R_Data1,C_SegF
	bsf		PT_F,P_F	
	btfsc	R_Data1,C_SegG
	bsf		PT_G,P_G	
	
	bsf		PT_DIGEn,P_DIG2			;位选
	return
;----------------------------
;第二位数码管
LedDrive_Dig2:
	movfw	R_LcdDate_Shi
	call	LedData_Tab
	movwf	R_Data1
	btfsc	R_Data1,C_SegA
	bsf		PT_A,P_A
	btfsc	R_Data1,C_SegB
	bsf		PT_B,P_B
	btfsc	R_Data1,C_SegC
	bsf		PT_C,P_C	
	btfsc	R_Data1,C_SegD
	bsf		PT_D,P_D	
	btfsc	R_Data1,C_SegE
	bsf		PT_E,P_E	
	btfsc	R_Data1,C_SegF
	bsf		PT_F,P_F	
	btfsc	R_Data1,C_SegG
	bsf		PT_G,P_G
	
	bsf		PT_DIGEn,P_DIG1			;位选
	return	

;--------------------------------------------
;LED显示数值表
LedData_Tab:
	andlw	0fh
	addpcw
	retlw	DIS_N0	;0
	retlw	DIS_N1	;1
	retlw	DIS_N2	;2
	retlw	DIS_N3	;3
	retlw	DIS_N4	;4
	retlw	DIS_N5	;5
	retlw	DIS_N6	;6
	retlw	DIS_N7	;7
	retlw	DIS_N8	;8
	retlw	DIS_N9	;9
	retlw	DIS_N0	;0
	retlw	DIS_N0	;0
	retlw	DIS_N0	;0
	retlw	DIS_N0	;0
	retlw	DIS_N0	;0
	retlw	DIS_N0	;0

ENDIF


if	K_188LED_Power
;============================================
;188数码管处理函数
;============================================
	
;--------------------------------------------
;关数码管
188LedOff:
	bsf		PT_Com,P_Com0					;关位显示驱动COM口，设为输出口高电平
	bsf		PT_Com,P_Com1
	bsf		PT_Com,P_Com2
	bsf		PT_Com,P_Com3
	bcf		PT_Seg0,P_Seg0					;关段显示驱动SEG口，设为输出口低电平
	bcf		PT_Seg1,P_Seg1
	bcf		PT_Seg2,P_Seg2
	bcf		PT_Seg3,P_Seg3
	return	
	
188LedDrive_Charge:
	btfss	R_TimeFlag,B_Disp_Flash
	goto	188LedOff
	goto	188LedDrive_OK	

;--------------------------------------------
;188数码管驱动程序
LedDrive:
	btfsc	R_Flag,B_USB_IN
	goto	188LedDrive_Charge
	
	btfss	R_SysMode,B_DisChargeMode
	goto	188LedOff
	
	movlw	30
	subwf	R_DisCharge_OutTime,0
	btfsc	status,c
;	goto	LedDrive_NT							;时间要达到5s
;	btfsc	R_DischargeFlag,B_LED_OFF			;闪烁标志位为0才关灯
	goto	188LedOff
;	btfss	R_TimeFlag,B_Disp_Flash
;	bsf		R_DischargeFlag,B_LED_OFF

;LedDrive_NT:	
	movlw	5
	subwf	R_LcdDate_OK,0
	btfss	status,c
	goto	188LedDrive_Charge					;电量小于5%闪烁

188LedDrive_OK:
	incf	R_LcdCom_Cnt,1
	movlw	16
	subwf	R_LcdCom_Cnt,0
	btfss	status,c
	goto	188LedDrive_init
	clrf	R_LcdCom_Cnt
	
188LedDrive_init:
	bsf		PT_Com,P_Com0					;关位显示驱动COM口，设为输出口高电平
	bsf		PT_Com,P_Com1
	bsf		PT_Com,P_Com2
	bsf		PT_Com,P_Com3
	bcf		PT_Seg0,P_Seg0					;关段显示驱动SEG口，设为输出口低电平
	bcf		PT_Seg1,P_Seg1
	bcf		PT_Seg2,P_Seg2
	bcf		PT_Seg3,P_Seg3

	movfw	R_LcdCom_Cnt
	andlw	00001111b
	addpcw
	goto	188LedDrive_LowCom0
	goto	188LedDrive_LowCom1
	goto	188LedDrive_LowCom2
	goto	188LedDrive_LowCom3
	goto	188LedDrive_LowCom4
	goto	188LedDrive_LowCom5
	goto	188LedDrive_LowCom6
	goto	188LedDrive_LowCom7
	goto	188LedDrive_LowCom8
	goto	188LedDrive_LowCom9
	goto	188LedDrive_LowCom10
	goto	188LedDrive_LowCom11
	goto	188LedDrive_LowCom12
	goto	188LedDrive_LowCom13
	goto	188LedDrive_LowCom14
	goto	188LedDrive_LowCom15
	
188LedDrive_LowCom0:	
	movfw	R_LcdDate_Shi
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegA
	bsf		PT_Seg2,P_Seg2	;pt5.1
	
	bcf		PT_Com,P_Com1	;pt1.5
	return
	
188LedDrive_LowCom1:
	movfw	R_LcdDate_Shi
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegB
	bsf		PT_Seg3,P_Seg3	;pt5.2
	
	bcf		PT_Com,P_Com1	;pt1.5
	return
	
188LedDrive_LowCom2:
	movfw	R_LcdDate_Shi
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegC
	bsf		PT_Seg1,P_Seg1	;pt1.2
	
	bcf		PT_Com,P_Com1	;pt1.5
	return	

188LedDrive_LowCom3:
	movfw	R_LcdDate_Shi
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegD
	bsf		PT_Seg0,P_Seg0	;pt1.1
	
	bcf		PT_Com,P_Com1	;pt1.5
	return
	
188LedDrive_LowCom4:
	movfw	R_LcdDate_Shi
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegE
	bsf		PT_Seg1,P_Seg1	;pt1.2
	
	bcf		PT_Com,P_Com0	;pt1.4
	return	
	
188LedDrive_LowCom5:
	movfw	R_LcdDate_Shi
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegF
	bsf		PT_Seg2,P_Seg2	;pt5.1
	
	bcf		PT_Com,P_Com0	;pt1.4
	return	
	
188LedDrive_LowCom6:
	movfw	R_LcdDate_Shi
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegG
	bsf		PT_Seg3,P_Seg3	;pt5.2
	
	bcf		PT_Com,P_Com0	;pt1.4
	return		

188LedDrive_LowCom7:
	btfsc	R_LcdDate_Bai,0
	bsf		PT_Seg0,P_Seg0	;pt1.1

	bcf		PT_Com,P_Com0	;pt1.4
	return		

	
188LedDrive_LowCom8:	
	movfw	R_LcdDate_Ge
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegA
	bsf		PT_Seg2,P_Seg2	;pt5.1
	
	bcf		PT_Com,P_Com3	;pt1.7
	return
	
188LedDrive_LowCom9:
	movfw	R_LcdDate_Ge
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegB
	bsf		PT_Seg3,P_Seg3	;pt5.2
	
	bcf		PT_Com,P_Com3	;pt1.7
	return
	
188LedDrive_LowCom10:
	movfw	R_LcdDate_Ge
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegC
	bsf		PT_Seg1,P_Seg1	;pt1.2
	
	bcf		PT_Com,P_Com3	;pt1.7
	return	

188LedDrive_LowCom11:
	movfw	R_LcdDate_Ge
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegD
	bsf		PT_Seg0,P_Seg0	;pt1.1
	
	bcf		PT_Com,P_Com3	;pt1.7
	return
	
188LedDrive_LowCom12:
	movfw	R_LcdDate_Ge
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegE
	bsf		PT_Seg1,P_Seg1	;pt1.2
	
	bcf		PT_Com,P_Com2	;pt1.6
	return	
	
188LedDrive_LowCom13:
	movfw	R_LcdDate_Ge
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegF
	bsf		PT_Seg2,P_Seg2	;pt5.1
	
	bcf		PT_Com,P_Com2	;pt1.6
	return	
	
188LedDrive_LowCom14:
	movfw	R_LcdDate_Ge
	call	188LedData_Tab
	movwf	R_Data1
	
	btfsc	R_Data1,C_SegG
	bsf		PT_Seg3,P_Seg3	;pt5.2
	
	bcf		PT_Com,P_Com2	;pt1.6
	return		

188LedDrive_LowCom15:
	btfsc	R_LcdDate_Bai,0
	bsf		PT_Seg0,P_Seg0	;pt1.1

	bcf		PT_Com,P_Com2	;pt1.6
	return		

;--------------------------------------------
;188数码管显示数值表
188LedData_Tab:
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
	  
endif


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

	
      