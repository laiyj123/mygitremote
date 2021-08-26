;============================================
; filename: csu8rp30213_demo.asm
; chip    : CSU8RP3216
; author  :
; date    : 2015-10-15								
; checksum: 1356(第一次上电检测电池OK)  C728(1.4V&0.02R)  275C(过流值)  5B84(小电流阀值)  A018(电量校正)  6175(小电流阀值修改)  4CE7(两头修改)
;============================================
	include CSU8RP3216.inc					;芯片头文件
;============================================
; program start
;============================================
	org		000h
	goto	reset
	dw		ffffh
	dw		ffffh
	org		004h
	goto	interrupt_deal					;中断处理函数在文件interrupt.asm中
;============================================
; 其他功能模块函数文件
;============================================
	include	macro.h							;数据转移宏定义
	include	define_ram.inc					;数据变量及位定义
	include	Const_Define.inc
	include	interrupt.asm					;中断处理程序
	include	sys_init.asm					;系统初始化程序	
	include	adc.asm							;AD转换处理程序	
	include	delay_time.asm					;延时函数定义
	include	pwm.asm							;PWM处理函数
	
IF	K_LCD_Power	
	include	lcd.asm							;LCD处理函数
ENDIF

IF	K_88LED_Power	
	include	led.asm							;LeD处理函数	
ENDIF

IF	K_188LED_Power	
	include	led.asm							;LeD处理函数	
ENDIF

	include	key.asm							;按键处理函数
	include	input_deal.asm					;输入检测及处理函数
	include	discharge.asm					;放电处理函数
	include	charge.asm						;充电处理函数
	include	sys_control.asm					;系统控制函数
	include	battery_capacity.asm			;电池电量处理函数
	include	lamp.asm						;照明灯处理函数
	include	lowpower.asm					;低功耗处理函数
;	include	serial.asm						;低功耗处理函数
;============================================
; 芯片复位
;============================================	
reset:
	clrwdt
	bcf		pt3,5
	bsf		pt3en,5
	call	Delay25ms
	call	sys_init						;系统初始化函数在文件sye_init.asm中

	bsf		R_KeyFlag,B_KeyDone				;置位按键执行完标志位	
	clrf	R_LcdDate_OK
	clrf	R_SysFlag
	
	clrf	R_BatteryCap_SumOK0		
	clrf	R_BatteryCap_SumOK1		
	clrf	R_BatteryCap_SumOK2		

	clrf	R_BatteryCapOK_UnitL		
	clrf	R_BatteryCapOK_UnitH		
	
	movlw	C_VrefCurL
	movwf	R_VrefCurL
	movlw	C_VrefCurH
	movwf	R_VrefCurH
	
	movlw	15h
	movwf	R_DisCharge_ProCurL
	movlw	1
	movwf	R_DisCharge_ProCurH
	
	movlw	250
	movwf	R_DisCharge_ProCurCnt
	
	movlw	C_FirstOnMode
	movwf	R_SysMode_OK
	bsf		R_SysMode,B_FirstOnMode
	
	bsf		R_DischargeFlag,B_Boost_En
	
	bcf		PT_TC_USB_EN,IO_TC_USB
	call	delay10us
	btfsc	PT_TC_USB,IO_TC_USB
	bcf  	R_DischargeFlag,B_Boost_En
	bsf		PT_TC_USB_EN,IO_TC_USB
	
	bcf		PT_USB_EN,IO_USB
	call	delay10us
	btfsc	PT_USB,IO_USB
	bcf 	R_DischargeFlag,B_Boost_En
	bsf		PT_USB_EN,IO_USB
	
	bsf		R_TimeFlag,B_FirstOnMode2	
	goto	main	
	
;============================================
; 主程序
;============================================	
main:
	clrwdt	
	call	AdcRead							;AD处理函数
	call	SysMode_End						;系统模式出口
	
	btfss	PT_OUT_EN,IO_OUT_EN
	goto	1ms_task	
	btfss	R_DischargeFlag,B_Boost_En
	goto	1ms_task
	btfss	R_TimeFlag,B_First1S_OK
	goto	1ms_task
	
	btfss	status,LVD24					;判断VDD是否低于2.4V
	goto	1ms_task1
	
	incf	R_LowVdd_Num,1
	movlw	3
	subwf	R_LowVdd_Num,0
	btfss	status,c
	goto	1ms_task
	;call	DisCharge_Protect_Deal
	DW		FFFFH
	DW		FFFFH
	nop			
;--------------------------------------------
;判断1ms时间有没有到
1ms_task1:
	clrf	R_LowVdd_Num
	
1ms_task:									
	btfss	R_TimeFlag,B_Time1ms
	goto	5ms_task
	bcf		R_TimeFlag,B_Time1ms
	
	movlw	250
	subwf	r_time5ms,0
	btfss	status,c
	incf	r_time5ms,1
	
	movlw	250
	subwf	r_time100ms,0
	btfss	status,c
	incf	r_time100ms,1
	
	;========================================
	;主程序1ms所要执行的任务
	;========================================
	btfsc	R_TimeFlag,B_First1S_OK	
	call	DisCharge_Pro	
IF	K_188LED_Power	
	btfss	R_SysMode,B_FirstOnMode
	call	LedDrive						;LED扫描
ENDIF
	
;--------------------------------------------
;判断5ms时间有没有到		
5ms_task:								
	movlw	5
	subwf	r_time5ms,0
	btfss	status,c
	goto	100ms_task
	clrf	r_time5ms
	;========================================
	;主程序5ms所要执行的任务
	;========================================
	movlw	1
	subwf	R_AdcErrTime,0
	btfsc	status,c
	decf	R_AdcErrTime,1
	
	movlw	00100000b
	xorwf	R_Flag,1
	
IF	K_LCD_Power	
	call	LcdDrive						;LCD扫描
ENDIF

IF	K_88LED_Power	
	call	LedDrive						;LED扫描
ENDIF
	
5ms_task1:	
	call	KeyScan							;按键扫描
	call	Key_Deal						;按键处理
	call	TC_USB_Scan						;TC充电USB检测
	DW		FFFFH
	DW		FFFFH
	nop
	call	USB_Scan						;充电USB检测
	DW		FFFFH
	DW		FFFFH
	nop
	call	Load_Scan1						;负载1检测
	call	Lamp_Control					;照明灯控制
IF	K_LCD_Power
	call	Led_Lamp_Control				;背光灯控制
ENDIF	
	;----------------------------------------
	;按键双按处理
	incf	R_KeyDubbleTime,1
	movlw	80
	subwf	R_KeyDubbleTime,0
	btfss	status,c
	goto	IntLoad1_En_Time
	clrf	R_KeyDubbleTime
	bsf		R_KeyFlag,B_KeyDubbleTmOver
	clrf	R_KeyDowmCnt		

	;----------------------------------------
	;自动负载检测中断控制 
IntLoad1_En_Time:
	incf	R_IntLoad1_En_Time,1			;不同案子记住要改相应的IO配置！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！ 
	btfsc	pt1con,4
	goto	100ms_task
	movlw	80
	subwf	R_IntLoad1_En_Time,0
	btfsc	status,c
	bsf		pt1con,4   						;不同案子记住要改相应的IO配置！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！

;--------------------------------------------
;判断100ms时间有没有到		
100ms_task:							
	movlw	100
	subwf	r_time100ms,0
	btfss	status,c
	goto	500ms_task
	clrf	r_time100ms
	;========================================
	;主程序100ms所要执行的任务
	;========================================
	movlw	250
	subwf	r_time500ms,0
	btfss	status,c
	incf	r_time500ms,1
	
	movlw	250
	subwf	R_time1s,0
	btfss	status,c
	incf	R_time1s,1
		
	call	SysMode_Control
		
;--------------------------------------------
;判断500ms时间有没有到		
500ms_task:					
	movlw	5
	subwf	r_time500ms,0
	btfss	status,c
	goto	1s_task
	clrf	r_time500ms
	;========================================
	;主程序500ms所要执行的任务
	;========================================
	incf	R_KeyLongTime,1					;计算按键长时间+1
	
	movlw	00000100b
	xorwf	R_TimeFlag,1
	
	btfsc	B_ChargeFlag,B_Charge_Full
	bsf		R_TimeFlag,B_Disp_Flash			 

	call	Charge_Control					;电池充饱检测
	call	Check_Battery					;低电压检测
	
;IFDEF  COMM_EN	
;	call	COMM_PRO
;endif	

;--------------------------------------------
;判断1s时间有没有到		
1s_task:					
	movlw	10
	subwf	R_time1s,0
	btfss	status,c
	goto	main
	clrf	R_time1s
	
	movlw	250
	subwf	R_Lcd_DispTime,0
	btfss	status,c
	incf	R_Lcd_DispTime,1
	
	incf	R_Time1min,1
	;========================================
	;主程序1s所要执行的任务
	;========================================
	bsf		R_TimeFlag,B_First1S_OK
	bcf		R_TimeFlag,B_FirstOnMode2
	call	BatVol_Disp
	call	ChargeMode_Control				;充电模式控制
	call	DisCharge_SmallCur				;放电小电流检测
	call	BatVol_Fun
	call	BatteryCap_Fun
	call	Battery_Study
	call	Sleep_Control
	
	btfsc	R_Flag,B_Sleep_Enter
	goto	Enter_Sleep

;-----------------------
;	incf	R_LcdDate_OK,1
;	call	HexToDex
	goto	main						
	end
;============================================
