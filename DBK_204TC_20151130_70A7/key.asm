;============================================
;����ɨ��
;============================================
KeyScan:
IF	K_LCD_Power
	bcf		PT_KeyEn,IO_Key
	call	delay10us
	btfss	PT_Key,IO_Key					;�͵�ƽ���
	goto	No_KeyPress
	nop
	nop
	btfss	PT_Key,IO_Key					;�͵�ƽ���
	goto	No_KeyPress		
	call	KeyScan_Renew					;����ָ�IO��
ENDIF

IF	K_88LED_Power
	movfw	PT_Key
	movwf	PT_Key_back						;IO�����ݱ���
	bsf		PT_Key,IO_Key					;��ƽ����

	movlw	00000001b
	movwf	pt1en
	movlw	11111000b
	movwf	pt5en							;ȫ��������Ϊ�����	
		
	call	delay10us
	btfsc	PT_Key,IO_Key					;�͵�ƽ���
	goto	No_KeyPress
	nop
	nop
	btfsc	PT_Key,IO_Key					;�͵�ƽ���
	goto	No_KeyPress		
	call	KeyScan_Renew					;����ָ�IO��
ENDIF

IF	K_188LED_Power
	movfw	PT_Key
	movwf	PT_Key_back						;IO�����ݱ���
	bsf		PT_Key,IO_Key					;��ƽ����
	
	movlw	00000001b
	movwf	pt1en
	movlw	11111000b
	movwf	pt5en							;ȫ��������Ϊ�����	

	call	delay10us
	btfsc	PT_Key,IO_Key					;�͵�ƽ���
	goto	No_KeyPress
	nop
	nop
	btfsc	PT_Key,IO_Key					;�͵�ƽ���
	goto	No_KeyPress		
	call	KeyScan_Renew					;����ָ�IO��
ENDIF
;--------------------------------------------
;�ж϶̰������������ִ�в���
	incf	R_KeyTime,1
	movlw	3								;��������ʱ��
	subwf	R_KeyTime,0
	btfss	status,c
	goto	KeyScan_Exit
	movlw	3
	movwf	R_KeyTime
	
	movlw	1
	movwf	R_KeyTem						;����̰���ֵ
;--------------------------------------------
;�ж�˫��  				
	btfsc	R_KeyFlag,B_KeyDubbleDown		;�ж��ϴΰ����Ƿ���
	goto	KeyScan_Long					;���û�е��𣬽���˫��ɨ��  

	incf	R_KeyDowmCnt,1
	movlw	2
	subwf	R_KeyDowmCnt,0
	btfss	status,c
	goto	DubbleKey_First	
	
	clrf	R_KeyDowmCnt
	movlw	3		
	movwf	R_KeyTem
	bsf		R_KeyFlag,B_KeyDone				;��λ������ִ�б�־��Ϊ���´ν����ֵ��
	goto	Key_Judge  						;�жϼ�ֵ				  	
DubbleKey_First:
	clrf	R_KeyDubbleTime
	bsf		R_KeyFlag,B_KeyDubbleDown		;��λ˫�����±�־λ
	goto	KeyScan_Long
;--------------------------------------------
;�жϳ������������¾�ִ�в���
KeyScan_Long:
	btfsc	R_KeyFlag,B_KeyLongDown			;���ⳤʱ�䰴�°����ظ�ִ�г�������
	goto	Key_Judge
		
	movlw	4
	subwf	R_KeyLongTime,0
	btfss	status,c
	goto	Key_Judge	
	bsf		R_KeyFlag,B_KeyLongDown			;��λ�������±�־λ
	bcf		R_KeyFlag,B_KeyDown				;����������±�־λ��Ϊ���´ν����ֵ�ж�
	bsf		R_KeyFlag,B_KeyDone				;��λ������ִ�б�־��Ϊ���´ν����ֵ��
	movlw	2
	movwf	R_KeyTem						;���賤����ֵ
	goto	Key_Judge	
;--------------------------------------------
;�������� 	
No_KeyPress:
	call	KeyScan_Renew					;����ָ�IO��
	clrf	R_KeyTime						;����̰���ʱ��
	clrf	R_KeyLongTime					;���������ʱ��
	bcf		R_KeyFlag,B_KeyDown				;����������±�־λ
	bcf		R_KeyFlag,B_KeyLongDown			;��������������±�־λ		
	bcf		R_KeyFlag,B_KeyDubbleDown		;���˫�����±�־λ
	goto	KeyScan_Exit	
;--------------------------------------------
;�жϼ�ֵ
Key_Judge:	
	bcf		R_KeyFlag,B_KeyDubbleTmOver
											;-------------------------------------------
	btfsc	R_KeyFlag,B_KeyDown				;�ж��ϴΰ����Ƿ���
	goto	KeyScan_Exit					;���û�е��𣬽���ɨ��
	bsf		R_KeyFlag,B_KeyDown				;��λ�������±�־
											;-------------------------------------------	
	btfss	R_KeyFlag,B_KeyDone				;�ϴ���Ч�����Ƿ��Ѿ�ִ��
	goto	KeyScan_Exit					;����ϴε���Ч������û��ִ�У��˳��ӳ���
	bcf		R_KeyFlag,B_KeyDone				;�尴����ִ�б�־
											;-------------------------------------------		
	movfw	R_KeyTem
	movwf	R_KeyCur						;������Ч����ֵ															
	goto	KeyScan_Exit
;--------------------------------------------
;����ɨ�����
KeyScan_Renew:
IF	K_88LED_Power
	movfw	PT_Key_back
	movwf	PT_Key							;IO�����ݻָ�
	movlw	11110111b
	movwf	pt1en
	movlw	11111111b
	movwf	pt5en							;�ָ������
ENDIF

IF	K_188LED_Power
	movfw	PT_Key_back
	movwf	PT_Key							;IO�����ݻָ�
	movlw	11110011b
	movwf	pt1en
	movlw	11111111b
	movwf	pt5en							;�ָ������
ENDIF

	bsf		PT_KeyEn,IO_Key
KeyScan_Exit:
	return									;�˳�
;============================================
;���������ӳ���
;============================================	
Key_Deal:
	bsf		R_KeyFlag,B_KeyEn
	
	btfsc	R_KeyFlag,B_KeyDone				;�����Ч�����Ƿ��Ѿ���ִ��	
	bcf		R_KeyFlag,B_KeyEn				;��������ѱ�ִ�У��򰴼���ʹ�ܣ���ֹ�ظ�ִ��

	btfsc	R_KeyFlag,B_KeyLongDown			;����ǳ������ð��������ִ�а�������
	goto	Key_Deal_Enter
	
	btfsc	R_KeyFlag,B_KeyDown				;��ⰴ���Ƿ���
	bcf		R_KeyFlag,B_KeyEn				;��������������򰴼���ʹ��
	
	btfss	R_KeyFlag,B_KeyDubbleTmOver
	bcf		R_KeyFlag,B_KeyEn
Key_Deal_Enter:	
	btfss	R_KeyFlag,B_KeyEn				;�������ʹ�ܣ��Ž��а�������
	return
	movfw	R_KeyCur
	andlw	00000011b
	addpcw
	return
	goto	Key_ShortDeal					;�̰�
	goto	Key_LongDeal					;����
	goto	Key_DubbleDeal					;˫��
;--------------------------------------------
;�̰�����
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
;��������
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
;˫������
Key_DubbleDeal:
	;decf	R_LcdDate_OK,1   
;	movlw	00000100b						;����������
;	xorwf	R_Flag,1	
		
	goto	KeyDeal_End	
;--------------------------------------------
;�����������
KeyDeal_End:
	bsf		R_KeyFlag,B_KeyDone				;��λ����ִ�����־λ		
	;call	HexToDex
	return

