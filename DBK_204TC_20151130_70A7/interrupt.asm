;============================================
;csu8rp30213�жϴ�����
;============================================
interrupt_deal:
	push									; ��work��status�Ĵ�����ջ����

int_ex0:
	btfss	intf,e0if		    			; �ж��Ƿ�Ϊ�ⲿ�ж�0
	goto	int_ex1
	bcf	    intf,e0if	        			; �����ⲿ�ж�0��־
	goto	i_e0

int_ex1:		                    
	btfss	intf,e1if		    			; �ж��Ƿ�Ϊ�ⲿ�ж�1
	goto	int_time0
	bcf	    intf,e1if	        			; �����ⲿ�ж�1��־
	goto	i_e1
	
int_time0:				        			
	btfss	intf,tm0if						; �ж��Ƿ�Ϊ��ʱ��0����ж�
	goto	int_time2
	bcf		intf,tm0if	        			; ���㶨ʱ��0����жϱ�־
	goto	i_t0

int_time2:                      
	btfss	intf,tm2if						; �ж��Ƿ�Ϊ��ʱ��2����ж�
	goto	no_int
	bcf		intf,tm2if						; ���㶨ʱ��1����жϱ�־
	goto	i_t2
	
;============================================
;��Ӧ �ⲿ�ж�0 �жϺ���Ҫִ�еĶ���
;============================================	
i_e0:

	goto	interrupt_exit
;============================================
;��Ӧ �ⲿ�ж�1 �жϺ���Ҫִ�еĶ���
;============================================
i_e1:
 	btfsc	PT_Load,IO_Load			  		;�ߵ�ƽ��⸺��
 	goto	USB_Interrupt
 	bsf		R_Flag,B_Load_Int
 	goto	interrupt_exit
USB_Interrupt:
	btfsc	PT_USB,IO_USB
	goto	interrupt_exit

	btfsc	PT_TC_USB,IO_TC_USB
	goto	interrupt_exit
	goto	int_time0

;============================================
;��Ӧ ��ʱ��0 �жϺ���Ҫִ�еĶ���
;============================================
i_t0:
	bsf		R_TimeFlag,B_Time1ms	
IF	K_188LED_Power	
;	btfss	R_SysMode,B_FirstOnMode
;	call	LedDrive						;LEDɨ��
ENDIF
/*	
	incf	R_time4ms,1
	movlw	5
	subwf	R_time4ms,0
	btfss	status,c
	goto	interrupt_exit
	clrf	R_time4ms
	
	btfsc	R_SysMode,B_FirstOnMode
	goto	interrupt_exit	
	
	call	LcdDrive
*/	
	goto	interrupt_exit	
;============================================
;��Ӧ ��ʱ��2 �жϺ���Ҫִ�еĶ���
;============================================
i_t2:
	
	goto	interrupt_exit
;============================================
no_int:	
    clrf	intf      						; �������жϱ�־	                                                  
	clrf	intf2 
	clrf	intf3      

interrupt_exit: 
	pop										; ��work��status�Ĵ�����ջ����
	retfie 									; ���жϷ���

	