;============================================
; �궨���ļ�
;============================================
;********************************************
movlf	macro	d1,f1      
		movlw	d1
		movwf	f1
		endm
		
;********************************************
movff	macro	f1,f2      
		movfw	f1
		movwf	f2
		endm
		
;********************************************