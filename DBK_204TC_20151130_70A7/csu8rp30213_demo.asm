;============================================
; filename: csu8rp30213_demo.asm
; chip    : CSU8RP3216
; author  :
; date    : 2015-10-15								
; checksum: 1356(��һ���ϵ�����OK)  C728(1.4V&0.02R)  275C(����ֵ)  5B84(С������ֵ)  A018(����У��)  6175(С������ֵ�޸�)  4CE7(��ͷ�޸�)
;============================================
	include CSU8RP3216.inc					;оƬͷ�ļ�
;============================================
; program start
;============================================
	org		000h
	goto	reset
	dw		ffffh
	dw		ffffh
	org		004h
	goto	interrupt_deal					;�жϴ��������ļ�interrupt.asm��
;============================================
; ��������ģ�麯���ļ�
;============================================
	include	macro.h							;����ת�ƺ궨��
	include	define_ram.inc					;���ݱ�����λ����
	include	Const_Define.inc
	include	interrupt.asm					;�жϴ������
	include	sys_init.asm					;ϵͳ��ʼ������	
	include	adc.asm							;ADת���������	
	include	delay_time.asm					;��ʱ��������
	include	pwm.asm							;PWM������
	
IF	K_LCD_Power	
	include	lcd.asm							;LCD������
ENDIF

IF	K_88LED_Power	
	include	led.asm							;LeD������	
ENDIF

IF	K_188LED_Power	
	include	led.asm							;LeD������	
ENDIF

	include	key.asm							;����������
	include	input_deal.asm					;�����⼰������
	include	discharge.asm					;�ŵ紦����
	include	charge.asm						;��紦����
	include	sys_control.asm					;ϵͳ���ƺ���
	include	battery_capacity.asm			;��ص���������
	include	lamp.asm						;�����ƴ�����
	include	lowpower.asm					;�͹��Ĵ�����
;	include	serial.asm						;�͹��Ĵ�����
;============================================
; оƬ��λ
;============================================	
reset:
	clrwdt
	bcf		pt3,5
	bsf		pt3en,5
	call	Delay25ms
	call	sys_init						;ϵͳ��ʼ���������ļ�sye_init.asm��

	bsf		R_KeyFlag,B_KeyDone				;��λ����ִ�����־λ	
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
; ������
;============================================	
main:
	clrwdt	
	call	AdcRead							;AD������
	call	SysMode_End						;ϵͳģʽ����
	
	btfss	PT_OUT_EN,IO_OUT_EN
	goto	1ms_task	
	btfss	R_DischargeFlag,B_Boost_En
	goto	1ms_task
	btfss	R_TimeFlag,B_First1S_OK
	goto	1ms_task
	
	btfss	status,LVD24					;�ж�VDD�Ƿ����2.4V
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
;�ж�1msʱ����û�е�
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
	;������1ms��Ҫִ�е�����
	;========================================
	btfsc	R_TimeFlag,B_First1S_OK	
	call	DisCharge_Pro	
IF	K_188LED_Power	
	btfss	R_SysMode,B_FirstOnMode
	call	LedDrive						;LEDɨ��
ENDIF
	
;--------------------------------------------
;�ж�5msʱ����û�е�		
5ms_task:								
	movlw	5
	subwf	r_time5ms,0
	btfss	status,c
	goto	100ms_task
	clrf	r_time5ms
	;========================================
	;������5ms��Ҫִ�е�����
	;========================================
	movlw	1
	subwf	R_AdcErrTime,0
	btfsc	status,c
	decf	R_AdcErrTime,1
	
	movlw	00100000b
	xorwf	R_Flag,1
	
IF	K_LCD_Power	
	call	LcdDrive						;LCDɨ��
ENDIF

IF	K_88LED_Power	
	call	LedDrive						;LEDɨ��
ENDIF
	
5ms_task1:	
	call	KeyScan							;����ɨ��
	call	Key_Deal						;��������
	call	TC_USB_Scan						;TC���USB���
	DW		FFFFH
	DW		FFFFH
	nop
	call	USB_Scan						;���USB���
	DW		FFFFH
	DW		FFFFH
	nop
	call	Load_Scan1						;����1���
	call	Lamp_Control					;�����ƿ���
IF	K_LCD_Power
	call	Led_Lamp_Control				;����ƿ���
ENDIF	
	;----------------------------------------
	;����˫������
	incf	R_KeyDubbleTime,1
	movlw	80
	subwf	R_KeyDubbleTime,0
	btfss	status,c
	goto	IntLoad1_En_Time
	clrf	R_KeyDubbleTime
	bsf		R_KeyFlag,B_KeyDubbleTmOver
	clrf	R_KeyDowmCnt		

	;----------------------------------------
	;�Զ����ؼ���жϿ��� 
IntLoad1_En_Time:
	incf	R_IntLoad1_En_Time,1			;��ͬ���Ӽ�סҪ����Ӧ��IO���ã����������������������������������������������������������������� 
	btfsc	pt1con,4
	goto	100ms_task
	movlw	80
	subwf	R_IntLoad1_En_Time,0
	btfsc	status,c
	bsf		pt1con,4   						;��ͬ���Ӽ�סҪ����Ӧ��IO���ã�����������������������������������������������������������������

;--------------------------------------------
;�ж�100msʱ����û�е�		
100ms_task:							
	movlw	100
	subwf	r_time100ms,0
	btfss	status,c
	goto	500ms_task
	clrf	r_time100ms
	;========================================
	;������100ms��Ҫִ�е�����
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
;�ж�500msʱ����û�е�		
500ms_task:					
	movlw	5
	subwf	r_time500ms,0
	btfss	status,c
	goto	1s_task
	clrf	r_time500ms
	;========================================
	;������500ms��Ҫִ�е�����
	;========================================
	incf	R_KeyLongTime,1					;���㰴����ʱ��+1
	
	movlw	00000100b
	xorwf	R_TimeFlag,1
	
	btfsc	B_ChargeFlag,B_Charge_Full
	bsf		R_TimeFlag,B_Disp_Flash			 

	call	Charge_Control					;��س䱥���
	call	Check_Battery					;�͵�ѹ���
	
;IFDEF  COMM_EN	
;	call	COMM_PRO
;endif	

;--------------------------------------------
;�ж�1sʱ����û�е�		
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
	;������1s��Ҫִ�е�����
	;========================================
	bsf		R_TimeFlag,B_First1S_OK
	bcf		R_TimeFlag,B_FirstOnMode2
	call	BatVol_Disp
	call	ChargeMode_Control				;���ģʽ����
	call	DisCharge_SmallCur				;�ŵ�С�������
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
