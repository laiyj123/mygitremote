;============================================
;充电USB扫描
;============================================
USB_Scan:
	btfsc	R_SysMode,B_FirstOnMode
	return
	
	btfsc	B_ChargeFlag,B_TC_USB_In
	goto	Close_USB_P
		
	bcf		PT_USB_EN,IO_USB
	call	delay10us
	movfw	PT_USB
	bsf		PT_USB_EN,IO_USB
	movwf	R_USB_BK2
	andlw	00000010b						;记住不同案子要改相应的IO口！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
	xorwf	R_USB_BK,0	
    btfss	status,z
    goto	USBState_Renew					;USB状态更新       
   
	movlw	100
	subwf	R_USB_Cnt,0				 
	btfss	status,c
	incf	R_USB_Cnt,1
	
	movlw	8
	subwf	R_USB_Cnt,0
	btfss	status,c
	return
	
	btfss	R_USB_BK,IO_USB
	goto	No_USBinput
;============================================
;检测到USB后的动作 
;============================================
	btfsc	R_Flag,B_USB_IN
	goto	USB_In_Deal	
;--------------------------------------------
;只进来一次			
USB_In_First:
	bsf		R_Flag,B_USB_IN					;置USB插入标志位
	movlw	C_ChargeMode
	movwf	R_SysMode_OK
	clrf	R_Lcd_DispTime  
	;----------
;	bsf		PT_USB,IO_USB					;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;--------------------------------------------
;执行USB插入后动作	
USB_In_Deal:	

	return 	
;============================================
;没检测到USB后的动作  
;============================================ 
No_USBinput: 
	btfss	R_Flag,B_USB_IN					;充电USB拔掉瞬间不检测负载
	goto	No_USBinput_Deal
;--------------------------------------------
;只进来一次		
USB_Out_First:								;刚拔出USB动作	
	movlw	C_NullMode
	movwf	R_SysMode_OK
	bcf		R_Flag,B_USB_IN					;清USB插入标志位 
	bcf		R_SysFlag,B_BatteryStudy_EN		;清除学习使能标志位
	bcf		B_ChargeFlag,B_BatteryStudy_OK	;清除学习完毕标志位	
	bcf		R_ChargeMode,B_ChargeVolLow_Flag
	
	btfsc	R_SysFlag,B_TL431_Flag
	goto	No_USBinput_Deal
	
	movlw	C_FirstOnMode
	movwf	R_SysMode_OK
	bsf		R_SysMode,B_FirstOnMode
	bsf		R_DischargeFlag,B_Boost_En 
;--------------------------------------------  
No_USBinput_Deal: 

  	return  

;============================================
;刚开始检测到USB后的动作
;============================================          
USBState_Renew:
	clrf	R_USB_Cnt						;清除计数器
	movfw	R_USB_BK2
	andlw	00000010b						;记住不同案子要改相应的IO口！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
	movwf	R_USB_BK
	return
 
Close_USB_P: 
	bcf		PT_USB,IO_USB
	return
  
  
;============================================
;LOAD1扫描,负载检测
;============================================  
Load_Scan1:
	btfsc	R_Flag,B_USB_IN	
	goto	Clr_LoadScan_TM1

	btfsc	R_SysMode,B_DisChargeMode
	goto	Judge_Load_Volt	
	
	btfss	R_Flag,B_Load_Int
	goto	Clr_LoadScan_TM1
IF	K_188LED_Power	
	btfsc	PT_Load,IO_Load			  		;低电平检测负载
ELSE
	btfss	PT_Load,IO_Load			  		;低电平检测负载
ENDIF
	goto	Clr_LoadScan_TM1
	incf	R_Load1IN_Cnt,1
	movlw	40
	subwf	R_Load1IN_Cnt,0
	btfss	status,c
	return
	
Go_DischargeMode1:
	movlw	C_DisChargeMode
	movwf	R_SysMode_OK
	return
	
Clr_LoadScan_TM1:
	clrf	R_Load1IN_Cnt	
	bcf		R_Flag,B_Load_Int
	return
 
	;--------------------------------------
	;放电情况下检测到负载
Judge_Load_Volt:
	btfss	R_Flag,B_Load_Int
	goto	Clr_LoadScan_TM1
	
	btfsc	PT_Load,IO_Load
	goto	Clr_LoadScan_TM1

	clrf	R_DisCharge_OutTime
	goto	Clr_LoadScan_TM1
		
 
;============================================
;TYPE-C 充电USB扫描
;============================================
TC_USB_Scan:
	btfsc	R_SysMode,B_FirstOnMode
	return

	btfsc	R_SysMode,B_DisChargeMode		;在放电不检测充电USB
	goto	No_TCUSBinput
	
	movfw	PT_TC_USB
	andlw	00000100b						;记住不同案子要改相应的IO口！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
	xorwf	R_TCUSB_BK,0	
    btfss	status,z
    goto	TC_USBState_Renew				;USB状态更新       
   
	movlw	100
	subwf	R_TCUSB_Cnt,0				 
	btfss	status,c
	incf	R_TCUSB_Cnt,1
	
	movlw	8
	subwf	R_TCUSB_Cnt,0
	btfss	status,c
	return
	
	btfss	PT_TC_USB,IO_TC_USB
	goto	No_TCUSBinput
;============================================
;检测到USB后的动作 
;============================================
	btfsc	B_ChargeFlag,B_TC_USB_In
	goto	TCUSB_In_Deal	
;--------------------------------------------
;只进来一次			
	bsf		B_ChargeFlag,B_TC_USB_In
	bsf		R_Flag,B_USB_IN					;置USB插入标志位
	movlw	C_ChargeMode
	movwf	R_SysMode_OK
	clrf	R_Lcd_DispTime  
;--------------------------------------------
;执行USB插入后动作	
TCUSB_In_Deal:	
;	bcf		PT_TC_OUT_EN,IO_TC_OUT_EN		;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	return 	
	
	
;============================================
;没检测到USB后的动作  
;============================================ 
No_TCUSBinput: 
	btfss	B_ChargeFlag,B_TC_USB_In		;充电USB拔掉瞬间不检测负载
	goto	No_TCUSBinput_Deal
;--------------------------------------------
;只进来一次		
	movlw	C_NullMode
	movwf	R_SysMode_OK
	bcf		B_ChargeFlag,B_TC_USB_In 
	bsf		PT_TC_OUT_EN,IO_TC_OUT_EN		;拔出TC充电IO口职高
	
	btfsc	PT_USB,IO_USB
	return
	
	bcf		R_Flag,B_USB_IN					;清USB插入标志位
	bcf		R_SysFlag,B_BatteryStudy_EN		;清除学习使能标志位
	bcf		B_ChargeFlag,B_BatteryStudy_OK	;清除学习完毕标志位	
	bcf		R_ChargeMode,B_ChargeVolLow_Flag
	
	btfsc	R_SysFlag,B_TL431_Flag
	goto	No_TCUSBinput_Deal
	
	movlw	C_FirstOnMode
	movwf	R_SysMode_OK
	bsf		R_SysMode,B_FirstOnMode
	bsf		R_DischargeFlag,B_Boost_En 
;--------------------------------------------  
No_TCUSBinput_Deal: 
;	bsf		PT_TC_OUT_EN,IO_TC_OUT_EN		;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  	return  
	
;============================================
;刚开始检测到USB后的动作
;============================================          
TC_USBState_Renew:
	clrf	R_TCUSB_Cnt						;清除计数器
	movfw	PT_TC_USB
	andlw	00000100b						;记住不同案子要改相应的IO口！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
	movwf	R_TCUSB_BK
	return
	
	
		