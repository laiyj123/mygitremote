;============================================
;SLEEP�������
;============================================
Sleep_Control:
	;----------------------------------------
	;����˯���ж�
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
;����˯�߶���
;============================================
Enter_Sleep:
	;----------------------------------------
	;AD����
	clrf	sradcon1
	clrf	sradcon2	
	;----------------------------------------
	;IO������
	
IF	K_LCD_Power
	clrf	pt1
	
	movlw	11110111b
	movwf	pt1en
	
	  
  	movlw	00010001b  						; �����ⲿ�ж�1���ⲿ�ж�0
	movwf	pt1con   						; bit 7 PT11OD��PT1.1©����·ʹ��λ
											; 0 = ��ֹPT1.1©����·
											; 1 = ʹ��PT1.1©����·
											
											; bit 6 PT1W[3]:PT1.5�ⲿ�ж�1ʹ��
											; 0 = ��ֹPT1.5�ⲿ�ж�1
											; 1 = ʹ��PT1.5�ⲿ�ж�1
											
											; bit 5 PT1W[2]:PT1.4�ⲿ�ж�1ʹ��
											; 0 = ��ֹPT1.4�ⲿ�ж�1
											; 1 = ʹ��PT1.4�ⲿ�ж�1
											
											; bit 4 PT1W[1]:PT1.3�ⲿ�ж�1ʹ��
											; 0 = ��ֹPT1.3�ⲿ�ж�1
											; 1 = ʹ��PT1.3�ⲿ�ж�1
											
											; bit 3 PT1W[0]:PT1.1�ⲿ�ж�1ʹ��
											; 0 = ��ֹPT1.1�ⲿ�ж�1
											; 1 = ʹ��PT1.1�ⲿ�ж�1
											
											; bit 2 E1M���ⲿ�ж�1����ģʽ
											; 1 = �ⲿ�ж�1Ϊ�½��ش���
											; 0 = �ⲿ�ж�1��״̬�ı�ʱ����
											
											; bit 1:0 E0M[1:0]���ⲿ�ж�0����ģʽ
											; 11 = �ⲿ�ж�0��״̬�ı�ʱ����
											; 10 = �ⲿ�ж�0��״̬�ı�ʱ����
											; 01 = �ⲿ�ж�0Ϊ�����ش���
											; 00 = �ⲿ�ж�0Ϊ�½��ش���
	movlw	00001000b
	movwf	pt1con1							; bit 3 PT1W2[3]:PT3.1�ⲿ�ж�1ʹ��
											; 0 = ��ֹPT3.1�ⲿ�ж�1
											; 1 = ʹ��PT3.1�ⲿ�ж�1
											; bit 2 PT1W2[2]:PT1.7�ⲿ�ж�1ʹ��
											; 0 = ��ֹPT1.7�ⲿ�ж�1
											; 1 = ʹ��PT1.7�ⲿ�ж�1
											; bit 1 PT1W2[1]:PT1.6�ⲿ�ж�1ʹ��
											; 0 = ��ֹPT1.6�ⲿ�ж�1
											; 1 = ʹ��PT1.6�ⲿ�ж�1
											; bit 0 PT1W2[0]:PT1.2�ⲿ�ж�1ʹ��
											; 0 = ��ֹPT1.2�ⲿ�ж�1
											; 1 = ʹ��PT1.2�ⲿ�ж�1
	movlw	10100000b
	movwf	pt3
	
	movlw	11111000b
	movwf	pt3en
	
	clrf	pt3pu  	  

	movlw	00000100b						;0 = ����Ϊ���ֿڣ�1 = ����Ϊģ���
	movwf	pt3con  	
    
    clrf	pt5
	
	movlw	11111111b
	movwf	pt5en
	
	clrf	pt5pu  	  

											; bit 2 ���Ʊ�־λ��0 = ��ֹ��©�����1 = ʹ�ܿ�©���
	clrf	pt5con 							; bit 1 ���Ʊ�־λ��0 = ��ֹ��©�����1 = ʹ�ܿ�©���
											; bit 0 ���Ʊ�־λ��0 = ����Ϊ���ֿڣ�1 = ����Ϊģ���
ENDIF  		

IF	K_88LED_Power
	clrf	pt1
	movlw	00000001b
	movwf	pt1en
	movlw	11110110b
	movwf	pt1pu	 
  	movlw	00011001b  						; �����ⲿ�ж�1���ⲿ�ж�0
	movwf	pt1con   					
	movlw	00001000b
	movwf	pt1con1						
	
	movlw	10100000b
	movwf	pt3
	movlw	11111001b
	movwf	pt3en
	clrf	pt3pu   	  
	movlw	00000100b						;0 = ����Ϊ���ֿڣ�1 = ����Ϊģ���
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
  	movlw	00011001b  						; �����ⲿ�ж�1���ⲿ�ж�0
	movwf	pt1con   					
	movlw	00001001b
	movwf	pt1con1						
	
	movlw	10100000b
	movwf	pt3
	movlw	11111001b
	movwf	pt3en
	clrf	pt3pu   	  
	movlw	00000100b						;0 = ����Ϊ���ֿڣ�1 = ����Ϊģ���
	movwf	pt3con  	
    					
   	clrf	pt5
	movlw	11111000b
	movwf	pt5en
	movlw	00000111b
	movwf	pt5pu  	  									
	clrf	pt5con							

ENDIF

	;----------------------------------------
	;��ʱ������
	call	pwm_init
	clrf	tm0con
							
	clrf	lcdcom							; �ϵ�Ĭ��ֵ��0uuu0000				
	clrf	lcdseg							; �ϵ�Ĭ��ֵ��uuu00000
	
	;----------------------------------------
	;�ж�����
	clrf	intf      						; �������жϱ�־	                                                  
	clrf	intf2 
	clrf	intf3   
	
IF	K_LCD_Power     	                
	movlf	10000011B,inte   				; �������ж�ʹ�ܡ�TM0�ж�ʹ�ܡ��ⲿ�жϲ�ʹ�� 
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
	;���Ź���ʱ������
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
;���Ѻ���
;============================================	
Enter_Sleep_Out:
	;----------------------------------------
	;�ж��Ƿ�Ϊ��������	
IF	K_LCD_Power
	btfss	PT_Key,IO_Key					;�ߵ�ƽ���
	goto	LoadIN_Int
ENDIF

IF	K_88LED_Power
	btfsc	PT_Key,IO_Key					;�͵�ƽ���
	goto	LoadIN_Int
ENDIF

IF	K_188LED_Power
	btfsc	PT_Key,IO_Key					;�͵�ƽ���
	goto	LoadIN_Int
ENDIF

KeyIN_Int:
	call	sys_init						;ȷ�ϰ�������
	movlw	1
	movwf	R_KeyCur
	incf	R_KeyDowmCnt,1
	clrf	R_KeyDubbleTime
	bsf		R_KeyFlag,B_KeyDubbleDown		;��λ˫�����±�־λ
	goto	Sleep_Return
	;----------------------------------------
	;�ж��Ƿ�Ϊ���ػ���	
LoadIN_Int:	
IF	K_LCD_Power
	btfss	PT_Load,IO_Load			  		;�ߵ�ƽ��⸺��
	goto	USBIN_Int
ENDIF

IF	K_88LED_Power
	btfss	PT_Load,IO_Load			  		;�ߵ�ƽ��⸺��
	goto	USBIN_Int
ENDIF

IF	K_188LED_Power
	btfsc	PT_Load,IO_Load			  		;�͵�ƽ��⸺��
	goto	USBIN_Int
ENDIF
	call	sys_init						;ȷ�ϸ��ػ���
	movlw	C_DisChargeMode
	movwf	R_SysMode_OK
	goto	Sleep_Return
	;----------------------------------------
	;�ж��Ƿ�ΪUSB����	
USBIN_Int:	
	btfss	PT_USB,IO_USB
	goto	TC_USBIN_Int
	call	sys_init						;ȷ�ϸ��ػ���
	call	USBState_Renew
	bsf		R_Flag,B_USB_IN					;��USB�����־λ
	movlw	C_ChargeMode
	movwf	R_SysMode_OK
	clrf	R_Lcd_DispTime 
	goto	Sleep_Return 

	;----------------------------------------
	;�ж��Ƿ�ΪTC_USB����	
TC_USBIN_Int:	
	btfss	PT_TC_USB,IO_TC_USB
	goto	Enter_Sleep
	call	sys_init						;ȷ�ϸ��ػ���
	call	TC_USBState_Renew
	bsf		B_ChargeFlag,B_TC_USB_In		;��USB�����־λ
	bsf		R_Flag,B_USB_IN					;��USB�����־λ
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
	bsf		R_KeyFlag,B_KeyDone				;��λ����ִ�����־λ
	goto	main


