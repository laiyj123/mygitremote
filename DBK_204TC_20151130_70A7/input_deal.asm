;============================================
;���USBɨ��
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
	andlw	00000010b						;��ס��ͬ����Ҫ����Ӧ��IO�ڣ���������������������������������������������������������������
	xorwf	R_USB_BK,0	
    btfss	status,z
    goto	USBState_Renew					;USB״̬����       
   
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
;��⵽USB��Ķ��� 
;============================================
	btfsc	R_Flag,B_USB_IN
	goto	USB_In_Deal	
;--------------------------------------------
;ֻ����һ��			
USB_In_First:
	bsf		R_Flag,B_USB_IN					;��USB�����־λ
	movlw	C_ChargeMode
	movwf	R_SysMode_OK
	clrf	R_Lcd_DispTime  
	;----------
;	bsf		PT_USB,IO_USB					;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;--------------------------------------------
;ִ��USB�������	
USB_In_Deal:	

	return 	
;============================================
;û��⵽USB��Ķ���  
;============================================ 
No_USBinput: 
	btfss	R_Flag,B_USB_IN					;���USB�ε�˲�䲻��⸺��
	goto	No_USBinput_Deal
;--------------------------------------------
;ֻ����һ��		
USB_Out_First:								;�հγ�USB����	
	movlw	C_NullMode
	movwf	R_SysMode_OK
	bcf		R_Flag,B_USB_IN					;��USB�����־λ 
	bcf		R_SysFlag,B_BatteryStudy_EN		;���ѧϰʹ�ܱ�־λ
	bcf		B_ChargeFlag,B_BatteryStudy_OK	;���ѧϰ��ϱ�־λ	
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
;�տ�ʼ��⵽USB��Ķ���
;============================================          
USBState_Renew:
	clrf	R_USB_Cnt						;���������
	movfw	R_USB_BK2
	andlw	00000010b						;��ס��ͬ����Ҫ����Ӧ��IO�ڣ���������������������������������������������������������������
	movwf	R_USB_BK
	return
 
Close_USB_P: 
	bcf		PT_USB,IO_USB
	return
  
  
;============================================
;LOAD1ɨ��,���ؼ��
;============================================  
Load_Scan1:
	btfsc	R_Flag,B_USB_IN	
	goto	Clr_LoadScan_TM1

	btfsc	R_SysMode,B_DisChargeMode
	goto	Judge_Load_Volt	
	
	btfss	R_Flag,B_Load_Int
	goto	Clr_LoadScan_TM1
IF	K_188LED_Power	
	btfsc	PT_Load,IO_Load			  		;�͵�ƽ��⸺��
ELSE
	btfss	PT_Load,IO_Load			  		;�͵�ƽ��⸺��
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
	;�ŵ�����¼�⵽����
Judge_Load_Volt:
	btfss	R_Flag,B_Load_Int
	goto	Clr_LoadScan_TM1
	
	btfsc	PT_Load,IO_Load
	goto	Clr_LoadScan_TM1

	clrf	R_DisCharge_OutTime
	goto	Clr_LoadScan_TM1
		
 
;============================================
;TYPE-C ���USBɨ��
;============================================
TC_USB_Scan:
	btfsc	R_SysMode,B_FirstOnMode
	return

	btfsc	R_SysMode,B_DisChargeMode		;�ڷŵ粻�����USB
	goto	No_TCUSBinput
	
	movfw	PT_TC_USB
	andlw	00000100b						;��ס��ͬ����Ҫ����Ӧ��IO�ڣ���������������������������������������������������������������
	xorwf	R_TCUSB_BK,0	
    btfss	status,z
    goto	TC_USBState_Renew				;USB״̬����       
   
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
;��⵽USB��Ķ��� 
;============================================
	btfsc	B_ChargeFlag,B_TC_USB_In
	goto	TCUSB_In_Deal	
;--------------------------------------------
;ֻ����һ��			
	bsf		B_ChargeFlag,B_TC_USB_In
	bsf		R_Flag,B_USB_IN					;��USB�����־λ
	movlw	C_ChargeMode
	movwf	R_SysMode_OK
	clrf	R_Lcd_DispTime  
;--------------------------------------------
;ִ��USB�������	
TCUSB_In_Deal:	
;	bcf		PT_TC_OUT_EN,IO_TC_OUT_EN		;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	return 	
	
	
;============================================
;û��⵽USB��Ķ���  
;============================================ 
No_TCUSBinput: 
	btfss	B_ChargeFlag,B_TC_USB_In		;���USB�ε�˲�䲻��⸺��
	goto	No_TCUSBinput_Deal
;--------------------------------------------
;ֻ����һ��		
	movlw	C_NullMode
	movwf	R_SysMode_OK
	bcf		B_ChargeFlag,B_TC_USB_In 
	bsf		PT_TC_OUT_EN,IO_TC_OUT_EN		;�γ�TC���IO��ְ��
	
	btfsc	PT_USB,IO_USB
	return
	
	bcf		R_Flag,B_USB_IN					;��USB�����־λ
	bcf		R_SysFlag,B_BatteryStudy_EN		;���ѧϰʹ�ܱ�־λ
	bcf		B_ChargeFlag,B_BatteryStudy_OK	;���ѧϰ��ϱ�־λ	
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
;�տ�ʼ��⵽USB��Ķ���
;============================================          
TC_USBState_Renew:
	clrf	R_TCUSB_Cnt						;���������
	movfw	PT_TC_USB
	andlw	00000100b						;��ס��ͬ����Ҫ����Ӧ��IO�ڣ���������������������������������������������������������������
	movwf	R_TCUSB_BK
	return
	
	
		