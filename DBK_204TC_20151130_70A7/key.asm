;============================================
;按键扫描
;============================================
KeyScan:
IF	K_LCD_Power
	bcf		PT_KeyEn,IO_Key
	call	delay10us
	btfss	PT_Key,IO_Key					;低电平检测
	goto	No_KeyPress
	nop
	nop
	btfss	PT_Key,IO_Key					;低电平检测
	goto	No_KeyPress		
	call	KeyScan_Renew					;尽快恢复IO口
ENDIF

IF	K_88LED_Power
	movfw	PT_Key
	movwf	PT_Key_back						;IO口数据备份
	bsf		PT_Key,IO_Key					;电平上拉

	movlw	00000001b
	movwf	pt1en
	movlw	11111000b
	movwf	pt5en							;全部口设置为输入口	
		
	call	delay10us
	btfsc	PT_Key,IO_Key					;低电平检测
	goto	No_KeyPress
	nop
	nop
	btfsc	PT_Key,IO_Key					;低电平检测
	goto	No_KeyPress		
	call	KeyScan_Renew					;尽快恢复IO口
ENDIF

IF	K_188LED_Power
	movfw	PT_Key
	movwf	PT_Key_back						;IO口数据备份
	bsf		PT_Key,IO_Key					;电平上拉
	
	movlw	00000001b
	movwf	pt1en
	movlw	11111000b
	movwf	pt5en							;全部口设置为输入口	

	call	delay10us
	btfsc	PT_Key,IO_Key					;低电平检测
	goto	No_KeyPress
	nop
	nop
	btfsc	PT_Key,IO_Key					;低电平检测
	goto	No_KeyPress		
	call	KeyScan_Renew					;尽快恢复IO口
ENDIF
;--------------------------------------------
;判断短按，按键弹起才执行操作
	incf	R_KeyTime,1
	movlw	3								;按键消抖时间
	subwf	R_KeyTime,0
	btfss	status,c
	goto	KeyScan_Exit
	movlw	3
	movwf	R_KeyTime
	
	movlw	1
	movwf	R_KeyTem						;赋予短按键值
;--------------------------------------------
;判断双按  				
	btfsc	R_KeyFlag,B_KeyDubbleDown		;判断上次按键是否弹起
	goto	KeyScan_Long					;如果没有弹起，结束双击扫描  

	incf	R_KeyDowmCnt,1
	movlw	2
	subwf	R_KeyDowmCnt,0
	btfss	status,c
	goto	DubbleKey_First	
	
	clrf	R_KeyDowmCnt
	movlw	3		
	movwf	R_KeyTem
	bsf		R_KeyFlag,B_KeyDone				;置位按键已执行标志，为了下次进入键值判
	goto	Key_Judge  						;判断键值				  	
DubbleKey_First:
	clrf	R_KeyDubbleTime
	bsf		R_KeyFlag,B_KeyDubbleDown		;置位双键按下标志位
	goto	KeyScan_Long
;--------------------------------------------
;判断长按，按键按下就执行操作
KeyScan_Long:
	btfsc	R_KeyFlag,B_KeyLongDown			;避免长时间按下按键重复执行长按操作
	goto	Key_Judge
		
	movlw	4
	subwf	R_KeyLongTime,0
	btfss	status,c
	goto	Key_Judge	
	bsf		R_KeyFlag,B_KeyLongDown			;置位长按按下标志位
	bcf		R_KeyFlag,B_KeyDown				;清除按键按下标志位，为了下次进入键值判断
	bsf		R_KeyFlag,B_KeyDone				;置位按键已执行标志，为了下次进入键值判
	movlw	2
	movwf	R_KeyTem						;赋予长按键值
	goto	Key_Judge	
;--------------------------------------------
;按键弹起 	
No_KeyPress:
	call	KeyScan_Renew					;尽快恢复IO口
	clrf	R_KeyTime						;清除短按计时器
	clrf	R_KeyLongTime					;清除长按计时器
	bcf		R_KeyFlag,B_KeyDown				;清除按键按下标志位
	bcf		R_KeyFlag,B_KeyLongDown			;清除长按按键按下标志位		
	bcf		R_KeyFlag,B_KeyDubbleDown		;清除双键按下标志位
	goto	KeyScan_Exit	
;--------------------------------------------
;判断键值
Key_Judge:	
	bcf		R_KeyFlag,B_KeyDubbleTmOver
											;-------------------------------------------
	btfsc	R_KeyFlag,B_KeyDown				;判断上次按键是否弹起
	goto	KeyScan_Exit					;如果没有弹起，结束扫描
	bsf		R_KeyFlag,B_KeyDown				;置位按键按下标志
											;-------------------------------------------	
	btfss	R_KeyFlag,B_KeyDone				;上次有效按键是否已经执行
	goto	KeyScan_Exit					;如果上次的有效按键还没有执行，退出子程序
	bcf		R_KeyFlag,B_KeyDone				;清按键已执行标志
											;-------------------------------------------		
	movfw	R_KeyTem
	movwf	R_KeyCur						;更新有效按键值															
	goto	KeyScan_Exit
;--------------------------------------------
;按键扫描出口
KeyScan_Renew:
IF	K_88LED_Power
	movfw	PT_Key_back
	movwf	PT_Key							;IO口数据恢复
	movlw	11110111b
	movwf	pt1en
	movlw	11111111b
	movwf	pt5en							;恢复输出口
ENDIF

IF	K_188LED_Power
	movfw	PT_Key_back
	movwf	PT_Key							;IO口数据恢复
	movlw	11110011b
	movwf	pt1en
	movlw	11111111b
	movwf	pt5en							;恢复输出口
ENDIF

	bsf		PT_KeyEn,IO_Key
KeyScan_Exit:
	return									;退出
;============================================
;按键处理子程序
;============================================	
Key_Deal:
	bsf		R_KeyFlag,B_KeyEn
	
	btfsc	R_KeyFlag,B_KeyDone				;检测有效按键是否已经被执行	
	bcf		R_KeyFlag,B_KeyEn				;如果按键已被执行，则按键不使能，防止重复执行

	btfsc	R_KeyFlag,B_KeyLongDown			;如果是长按则不用按键弹起才执行按键操作
	goto	Key_Deal_Enter
	
	btfsc	R_KeyFlag,B_KeyDown				;检测按键是否弹起
	bcf		R_KeyFlag,B_KeyEn				;如果按键不弹起，则按键不使能
	
	btfss	R_KeyFlag,B_KeyDubbleTmOver
	bcf		R_KeyFlag,B_KeyEn
Key_Deal_Enter:	
	btfss	R_KeyFlag,B_KeyEn				;如果按键使能，才进行按键处理
	return
	movfw	R_KeyCur
	andlw	00000011b
	addpcw
	return
	goto	Key_ShortDeal					;短按
	goto	Key_LongDeal					;长按
	goto	Key_DubbleDeal					;双按
;--------------------------------------------
;短按处理
Key_ShortDeal:
	;incf	R_LcdDate_OK,1

	clrf	R_DisCharge_SmallCurCnt
	clrf	R_DisCharge_OutTime
	clrf	R_Lcd_DispTime
	bsf		R_TimeFlag,B_Disp_Flash
	clrf	r_time500ms
	btfsc	R_Flag,B_USB_IN
	goto	KeyDeal_End	
	
	movlw	250
	movwf	R_DisCharge_ProCurCnt
	
	;btfsc	R_SysMode,B_DisChargeMode
	;goto	KeyDeal_End
	
	movlw	C_DisChargeMode
	movwf	R_SysMode_OK
	
	goto	KeyDeal_End			
;--------------------------------------------
;长按处理
Key_LongDeal: 
	;movlw	0
	;movwf	R_LcdDate_OK
	
	btfsc	R_Flag,B_USB_IN
	goto	KeyDeal_End	
	
	btfss	R_SysMode,B_DisChargeMode
	goto	KeyDeal_End
	
	movlw	C_NullMode
	movwf	R_SysMode_OK
			
    goto	KeyDeal_End	
;--------------------------------------------
;双按处理
Key_DubbleDeal:
	;decf	R_LcdDate_OK,1   
;	movlw	00000100b						;控制照明灯
;	xorwf	R_Flag,1	
		
	goto	KeyDeal_End	
;--------------------------------------------
;按键处理出口
KeyDeal_End:
	bsf		R_KeyFlag,B_KeyDone				;置位按键执行完标志位		
	;call	HexToDex
	return

