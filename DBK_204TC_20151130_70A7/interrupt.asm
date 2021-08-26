;============================================
;csu8rp30213中断处理函数
;============================================
interrupt_deal:
	push									; 把work和status寄存器入栈保护

int_ex0:
	btfss	intf,e0if		    			; 判断是否为外部中断0
	goto	int_ex1
	bcf	    intf,e0if	        			; 清零外部中断0标志
	goto	i_e0

int_ex1:		                    
	btfss	intf,e1if		    			; 判断是否为外部中断1
	goto	int_time0
	bcf	    intf,e1if	        			; 清零外部中断1标志
	goto	i_e1
	
int_time0:				        			
	btfss	intf,tm0if						; 判断是否为定时器0溢出中断
	goto	int_time2
	bcf		intf,tm0if	        			; 清零定时器0溢出中断标志
	goto	i_t0

int_time2:                      
	btfss	intf,tm2if						; 判断是否为定时器2溢出中断
	goto	no_int
	bcf		intf,tm2if						; 清零定时器1溢出中断标志
	goto	i_t2
	
;============================================
;响应 外部中断0 中断后所要执行的动作
;============================================	
i_e0:

	goto	interrupt_exit
;============================================
;响应 外部中断1 中断后所要执行的动作
;============================================
i_e1:
 	btfsc	PT_Load,IO_Load			  		;高电平检测负载
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
;响应 定时器0 中断后所要执行的动作
;============================================
i_t0:
	bsf		R_TimeFlag,B_Time1ms	
IF	K_188LED_Power	
;	btfss	R_SysMode,B_FirstOnMode
;	call	LedDrive						;LED扫描
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
;响应 定时器2 中断后所要执行的动作
;============================================
i_t2:
	
	goto	interrupt_exit
;============================================
no_int:	
    clrf	intf      						; 清所有中断标志	                                                  
	clrf	intf2 
	clrf	intf3      

interrupt_exit: 
	pop										; 把work和status寄存器出栈处理
	retfie 									; 从中断返回

	