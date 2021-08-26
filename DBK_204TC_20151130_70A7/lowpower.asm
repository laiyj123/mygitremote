;============================================
;SLEEP处理程序
;============================================
Sleep_Control:
	;----------------------------------------
	;进入睡眠判断
;	btfsc	R_Flag,B_LampOnFlag
;	goto	Clr_Sleep_Cnt
	btfss	R_SysMode,B_NullMode	
	goto	Clr_Sleep_Cnt
	incf	R_EnterSleep_Cnt,1
	movlw	2
	subwf	R_EnterSleep_Cnt,0
	btfsc	status,c
	bsf		R_Flag,B_Sleep_Enter
	return

Clr_Sleep_Cnt:
	clrf	R_EnterSleep_Cnt
	return

;============================================
;进入睡眠动作
;============================================
Enter_Sleep:
	;----------------------------------------
	;AD设置
	clrf	sradcon1
	clrf	sradcon2	
	;----------------------------------------
	;IO口设置
	
IF	K_LCD_Power
	clrf	pt1
	
	movlw	11110111b
	movwf	pt1en
	
	  
  	movlw	00010001b  						; 设置外部中断1和外部中断0
	movwf	pt1con   						; bit 7 PT11OD：PT1.1漏极开路使能位
											; 0 = 禁止PT1.1漏极开路
											; 1 = 使能PT1.1漏极开路
											
											; bit 6 PT1W[3]:PT1.5外部中断1使能
											; 0 = 禁止PT1.5外部中断1
											; 1 = 使能PT1.5外部中断1
											
											; bit 5 PT1W[2]:PT1.4外部中断1使能
											; 0 = 禁止PT1.4外部中断1
											; 1 = 使能PT1.4外部中断1
											
											; bit 4 PT1W[1]:PT1.3外部中断1使能
											; 0 = 禁止PT1.3外部中断1
											; 1 = 使能PT1.3外部中断1
											
											; bit 3 PT1W[0]:PT1.1外部中断1使能
											; 0 = 禁止PT1.1外部中断1
											; 1 = 使能PT1.1外部中断1
											
											; bit 2 E1M：外部中断1触发模式
											; 1 = 外部中断1为下降沿触发
											; 0 = 外部中断1在状态改变时触发
											
											; bit 1:0 E0M[1:0]：外部中断0触发模式
											; 11 = 外部中断0在状态改变时触发
											; 10 = 外部中断0在状态改变时触发
											; 01 = 外部中断0为上升沿触发
											; 00 = 外部中断0为下降沿触发
	movlw	00001000b
	movwf	pt1con1							; bit 3 PT1W2[3]:PT3.1外部中断1使能
											; 0 = 禁止PT3.1外部中断1
											; 1 = 使能PT3.1外部中断1
											; bit 2 PT1W2[2]:PT1.7外部中断1使能
											; 0 = 禁止PT1.7外部中断1
											; 1 = 使能PT1.7外部中断1
											; bit 1 PT1W2[1]:PT1.6外部中断1使能
											; 0 = 禁止PT1.6外部中断1
											; 1 = 使能PT1.6外部中断1
											; bit 0 PT1W2[0]:PT1.2外部中断1使能
											; 0 = 禁止PT1.2外部中断1
											; 1 = 使能PT1.2外部中断1
	movlw	10100000b
	movwf	pt3
	
	movlw	11111000b
	movwf	pt3en
	
	clrf	pt3pu  	  

	movlw	00000100b						;0 = 定义为数字口，1 = 定义为模拟口
	movwf	pt3con  	
    
    clrf	pt5
	
	movlw	11111111b
	movwf	pt5en
	
	clrf	pt5pu  	  

											; bit 2 控制标志位；0 = 禁止开漏输出，1 = 使能开漏输出
	clrf	pt5con 							; bit 1 控制标志位；0 = 禁止开漏输出，1 = 使能开漏输出
											; bit 0 控制标志位；0 = 定义为数字口，1 = 定义为模拟口
ENDIF  		

IF	K_88LED_Power
	clrf	pt1
	movlw	00000001b
	movwf	pt1en
	movlw	11110110b
	movwf	pt1pu	 
  	movlw	00011001b  						; 设置外部中断1和外部中断0
	movwf	pt1con   					
	movlw	00001000b
	movwf	pt1con1						
	
	movlw	10100000b
	movwf	pt3
	movlw	11111001b
	movwf	pt3en
	clrf	pt3pu   	  
	movlw	00000100b						;0 = 定义为数字口，1 = 定义为模拟口
	movwf	pt3con  	
    					
   	clrf	pt5
	movlw	11111000b
	movwf	pt5en
	movlw	00000111b
	movwf	pt5pu  	  									
	clrf	pt5con							

ENDIF

IF	K_188LED_Power
	clrf	pt1
	movlw	00000001b
	movwf	pt1en
	movlw	11111010b
	movwf	pt1pu	 
  	movlw	00011001b  						; 设置外部中断1和外部中断0
	movwf	pt1con   					
	movlw	00001001b
	movwf	pt1con1						
	
	movlw	10100000b
	movwf	pt3
	movlw	11111001b
	movwf	pt3en
	clrf	pt3pu   	  
	movlw	00000100b						;0 = 定义为数字口，1 = 定义为模拟口
	movwf	pt3con  	
    					
   	clrf	pt5
	movlw	11111000b
	movwf	pt5en
	movlw	00000111b
	movwf	pt5pu  	  									
	clrf	pt5con							

ENDIF

	;----------------------------------------
	;定时器设置
	call	pwm_init
	clrf	tm0con
							
	clrf	lcdcom							; 上电默认值：0uuu0000				
	clrf	lcdseg							; 上电默认值：uuu00000
	
	;----------------------------------------
	;中断设置
	clrf	intf      						; 清所有中断标志	                                                  
	clrf	intf2 
	clrf	intf3   
	
IF	K_LCD_Power     	                
	movlf	10000011B,inte   				; 开启总中断使能、TM0中断使能、外部中断不使能 
ENDIF										; B7    B6     B5   B4     B3      B2   B1    B0
						         	     	; GIE   TM2IE  /    TM0IE  SRADIE  /    E1IE  E0IE
IF	K_88LED_Power     	                
	movlf	10000010B,inte   				
ENDIF

IF	K_188LED_Power     	                
	movlf	10000010B,inte   				
ENDIF

	clrf    inte2  	    					
	clrf	inte3       	 
	
	;----------------------------------------
	;看门狗、时钟设置
	clrf	wdtcon
	clrwdt
	bsf		mck,5
	
	nop
	nop
	sleep
	nop
	nop
	clrwdt
	call	Delay25ms
;============================================
;唤醒后动作
;============================================	
Enter_Sleep_Out:
	;----------------------------------------
	;判断是否为按键唤醒	
IF	K_LCD_Power
	btfss	PT_Key,IO_Key					;高电平检测
	goto	LoadIN_Int
ENDIF

IF	K_88LED_Power
	btfsc	PT_Key,IO_Key					;低电平检测
	goto	LoadIN_Int
ENDIF

IF	K_188LED_Power
	btfsc	PT_Key,IO_Key					;低电平检测
	goto	LoadIN_Int
ENDIF

KeyIN_Int:
	call	sys_init						;确认按键唤醒
	movlw	1
	movwf	R_KeyCur
	incf	R_KeyDowmCnt,1
	clrf	R_KeyDubbleTime
	bsf		R_KeyFlag,B_KeyDubbleDown		;置位双键按下标志位
	goto	Sleep_Return
	;----------------------------------------
	;判断是否为负载唤醒	
LoadIN_Int:	
IF	K_LCD_Power
	btfss	PT_Load,IO_Load			  		;高电平检测负载
	goto	USBIN_Int
ENDIF

IF	K_88LED_Power
	btfss	PT_Load,IO_Load			  		;高电平检测负载
	goto	USBIN_Int
ENDIF

IF	K_188LED_Power
	btfsc	PT_Load,IO_Load			  		;低电平检测负载
	goto	USBIN_Int
ENDIF
	call	sys_init						;确认负载唤醒
	movlw	C_DisChargeMode
	movwf	R_SysMode_OK
	goto	Sleep_Return
	;----------------------------------------
	;判断是否为USB唤醒	
USBIN_Int:	
	btfss	PT_USB,IO_USB
	goto	TC_USBIN_Int
	call	sys_init						;确认负载唤醒
	call	USBState_Renew
	bsf		R_Flag,B_USB_IN					;置USB插入标志位
	movlw	C_ChargeMode
	movwf	R_SysMode_OK
	clrf	R_Lcd_DispTime 
	goto	Sleep_Return 

	;----------------------------------------
	;判断是否为TC_USB唤醒	
TC_USBIN_Int:	
	btfss	PT_TC_USB,IO_TC_USB
	goto	Enter_Sleep
	call	sys_init						;确认负载唤醒
	call	TC_USBState_Renew
	bsf		B_ChargeFlag,B_TC_USB_In		;置USB插入标志位
	bsf		R_Flag,B_USB_IN					;置USB插入标志位
	movlw	C_ChargeMode
	movwf	R_SysMode_OK
	clrf	R_Lcd_DispTime 
	goto	Sleep_Return 
	
Sleep_Return:
	call	HexToDex
	;movlw	6bh
	movlw	15h
	movwf	R_DisCharge_ProCurL
	movlw	1
	movwf	R_DisCharge_ProCurH
	bsf		R_KeyFlag,B_KeyDone				;置位按键执行完标志位
	goto	main


