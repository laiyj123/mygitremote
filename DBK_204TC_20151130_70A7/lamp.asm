;============================================
;普通照明灯控制函数
;============================================
Lamp_Control:
	btfss	R_Flag,B_LampOnFlag
	goto	Lamp_Off
	bsf		PT_LAMP,IO_LAMP
	return
Lamp_Off:
	bcf		PT_LAMP,IO_LAMP
	return
	
;============================================
;背光灯控制函数
;============================================	
Led_Lamp_Control:	
 	btfsc	R_Flag,B_USB_IN
	goto	Led_Lamp_On
	btfss	R_SysMode,B_DisChargeMode
	goto	Led_Lamp_Off

Led_Lamp_On:
	movlw	C_Lcd_DispTime
	subwf	R_Lcd_DispTime,0
	btfsc	status,c
	goto	Led_Lamp_Off
	
	bsf		PT_LED,IO_LED
	return

Led_Lamp_Off:
	bcf		PT_LED,IO_LED
	return	
	
	
	
	
	
	
	
	