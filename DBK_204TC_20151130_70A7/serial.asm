
COMM_EN  EQU   1
IFDEF  COMM_EN
F_COMM_PRO:                ;Tick 10ms
;    Model Name:        COMM
;    Created:           2015-07-05
;    Revision:          1.0
; 	 author  :          TangWei
;    功能：串口115200波特率发送 I_CKA_H, I_CKA_L
;    使用变量 全局：COMMMODE
;             临时变量：TEMP0、TEMP1、TEMP2、TEMP3
     ;Include  :COMM_PRO, COMM_SendByte, COMM_Send_DELAY

/*
R_OutVol_DateL				equ		a0h
R_OutVol_DateH				equ		a1h
R_BoostCur_DateL			equ		a2h
R_BoostCur_DateH			equ		a3h
R_BuckCur_DateL				equ		aeh
R_BuckCur_DateH				equ		afh
R_BatVol_DateL				equ		a4h
R_BatVol_DateH				equ		a5h
R_Cur_DateL					equ		c5h
R_Cur_DateH					equ		c6h

*/



COMM_SEND_TEM0  EQU    R_Cur_DateH
COMM_SEND_TEM1  EQU    R_Cur_DateL
COMM_SEND_TEM2  EQU    R_BoostCur_DateH

COMM_SEND_TEM3  EQU    R_BoostCur_DateL
COMM_SEND_TEM4  EQU    R_BatVol_DateH

COMM_SEND_TEM5  EQU    R_BatVol_DateL
COMM_SEND_TEM6  EQU    R_BatVol_DateL

COMM_SEND_BUF   EQU    R_TEMP1
COMM_SEND_COUNT EQU    R_TEMP2
COMM_DELAY_TEMP EQU    R_TEMP3
COMM_IO_TEMP    EQU    R_TEMP4

TXDPIN          EQU    0
OE_TXDPIN       EQU    PT3EN      ;out
P_TXDPIN        EQU    PT3

COMM_PRO:
        MOVFW   OE_TXDPIN
        MOVWF   COMM_IO_TEMP
IFDEF  COMM_SEND_TEM0 
        MOVFW   COMM_SEND_TEM0
        ;MOVLW   0XAA                
        CALL    COMM_SendByte1
        CALL    COMM_Send_DELY20
ENDIF

IFDEF  COMM_SEND_TEM1 
        MOVFW   COMM_SEND_TEM1
       ;MOVLW   0X55               
        CALL    COMM_SendByte1
        CALL    COMM_Send_DELY20
ENDIF

IFDEF  COMM_SEND_TEM2 
        MOVFW   COMM_SEND_TEM2
       ; MOVLW   0XAA                
        CALL    COMM_SendByte1
        CALL    COMM_Send_DELY20
ENDIF
IFDEF  COMM_SEND_TEM3 
        MOVFW   COMM_SEND_TEM3
       ; MOVLW   0XAA                
        CALL    COMM_SendByte1
        CALL    COMM_Send_DELY20
ENDIF

IFDEF  COMM_SEND_TEM4
        MOVFW   COMM_SEND_TEM4
       ; MOVLW   0XAA                
        CALL    COMM_SendByte1
        CALL    COMM_Send_DELY20
ENDIF 
IFDEF  COMM_SEND_TEM5 
        MOVFW   COMM_SEND_TEM5
        ;MOVLW   0XAA                
        CALL    COMM_SendByte1
        CALL    COMM_Send_DELY20
ENDIF
IFDEF  COMM_SEND_TEM6 
        MOVFW   COMM_SEND_TEM6
        MOVLW   0XAA                
        CALL    COMM_SendByte1
        CALL    COMM_Send_DELY20
ENDIF
        ;MOVLW   0x0D
        ;CALL    COMM_SendByte1
       ; MOVLW   0x0A
       ; CALL    COMM_SendByte1
        BTFSS   COMM_IO_TEMP, TXDPIN
        BCF    OE_TXDPIN, TXDPIN
        RETURN
E_EXIT_COMM0:

;======================================
F_COMM_SendByte:

/*COMM_SendByte:
        MOVWF   COMM_SEND_BUF
        MOVLW   0x09
        SUBWF   COMM_SEND_BUF, W
        BTFSS   STATUS , C
        GOTO    COMM_SendByte0
        MOVLW   0x30
        IORWF    COMM_SEND_BUF, W
        GOTO    COMM_SendByte1
COMM_SendByte0:
        MOVLW   0x37
        ADDWF   COMM_SEND_BUF, W*/
       
COMM_SendByte1:
        MOVWF   COMM_SEND_BUF
        MOVLW   0x09
        MOVWF   COMM_SEND_COUNT
        bcf		inte,7
        BSF    OE_TXDPIN, TXDPIN
        GOTO    COMM_SendByte_L
COMM_SendByte2:
        RRF     COMM_SEND_BUF, F
        BTFSS   STATUS , C
        GOTO    COMM_SendByte_L
COMM_SendByte_H:
        BSF    P_TXDPIN, TXDPIN
        MOVLW   0x05
        MOVLW   6
        CALL    COMM_Send_DELAY
        GOTO    COMM_SendByte4
COMM_SendByte_L:
        BCF    P_TXDPIN, TXDPIN
        MOVLW   0x05
        MOVLW   7
        CALL    COMM_Send_DELAY
COMM_SendByte4:
        NOP
        DECFSZ    COMM_SEND_COUNT, F
        GOTO    COMM_SendByte2
        GOTO    $+1
        GOTO    $+1
        BSF    P_TXDPIN, TXDPIN
        bsf		inte,7
        MOVLW   4
        CALL    COMM_Send_DELAY
        RETURN
E_EXIT_COMM1:
;======================================
F_COMM_Send_DELAY:

COMM_Send_DELY20:
         MOVLW  5
COMM_Send_DELAY:
        MOVWF   COMM_DELAY_TEMP
COMM_Send_DELAY_A:
        DECFSZ    COMM_DELAY_TEMP, F
        GOTO    COMM_Send_DELAY_A
        RETURN

E_EXIT_COMM2 :               ;endr
ENDIF
