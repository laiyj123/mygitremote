;============================================
; 延时函数
;============================================
; 入口变量：没有
; 出口变量：没有
; 中间变量：R_Delay1、R_Delay2
; 标志位：没有
; 实现的功能：
;        用指令实现比较粗略的延时
;        大约25ms(指令周期为4M)
;============================================
Delay25ms:
	CLRWDT
	movlw	157
	movwf	R_Delay2
	decfsz	R_Delay1,f
	goto	$-1
	decfsz	R_Delay2,f
	goto	$-3
	return
;============================================
; 延时函数1
;============================================
; 入口变量：没有
; 出口变量：没有
; 中间变量：R_Delay3
; 标志位：没有
; 实现的功能：
;        用指令实现比较粗略的延时       
;============================================
/*
Delay125ms:
	movlw	5
	movwf	R_Delay3	
	call	Delay25ms
	decfsz	R_Delay3,f
	goto	$-2
	return
;============================================
*/
delay10us:
	movlw	10
	movwf	R_Delay3
delay10us_loop:
	clrwdt
	nop
	decfsz	R_Delay3,1
	goto	delay10us_loop
	return






