;============================================
; CSU8RP3216 Special Register Address Definition
;============================================

; Data Memory Organization 00h-07h
IND0      EQU     000H    ; Uses contents of FSR0 to address data memory
FSR0      EQU     002H    ; Indirect data memory, address point 0
STATUS    EQU     004H    ; { LVD36,LVD24, 0, PD, TO, DC, C, Z}
WORK      EQU     005H
INTF      EQU     006H    ; { 0,TM2IF,0, TM0IF, SRADIF, 0, E1IF, E0IF}
INTE      EQU     007H    ; {GIE, TM2IE,0, TM0IE, SRADIE, 0, E1IE, E0IE}

; Peripheral special registers  0Ah-07Fh
EADRH     EQU     00AH    ; PAR[9:8]
EADRL     EQU     00BH    ; PAR[7:0]
EDATH     EQU     00CH    ; EDATH[5:0]
WDTCON    EQU     00DH    ; {WDTEN, 0, 0, 0, 0, WTS[2:0]}
WDTIN     EQU     00EH    ; WDTIN[7:0]
TM0CON    EQU     00FH    ; {T0EN, T0RATE[2:0], 0, T0RSTB, T0SEL[1:0]}
TM0IN     EQU     010H    ; TM0IN[7:0]
TM0CNT    EQU     011H    ; TM0CNT[7:0]
MCK       EQU     016H    ; {CST,CST_IN,CST_WDT,EO_SLP,0,0,0,CLKSEL}
TM2CON    EQU     017H    ; {T2EN, T2RATE[2:0], T2CKS, T2RSTB, T2OUT, PWM2OUT}
TM2IN     EQU     018H    ; TM2IN[7:0]
TM2CNT    EQU     019H    ; TM2CNT[7:0]
TM2R      EQU     01AH    ; TM2R[7:0]
TM3CON    EQU     01BH    ; {T3EN, T3RATE[2:0], T3CKS, T3RSTB, T3OUT, PWM3OUT}
TM3IN     EQU     01CH    ; TM3IN[7:0]
TM3CNT    EQU     01DH    ; TM3CNT[7:0]
TM3R      EQU     01EH    ; TM3R[7:0]
PT1       EQU     020H    ; {PT1[7:1]}
PT1EN     EQU     021H    ; {PT1EN[7:1]}
PT1PU     EQU     022H    ; {PT1PU[7:1]}
PT1CON    EQU     023H    ; {PT11OD,PT1W[3:0],E1M,E0M[1:0]}
PT3       EQU     028H    ; {PT3[7:0]}
PT3EN     EQU     029H    ; {PT3EN[7:0]}
PT3PU     EQU     02AH    ; {PT3PU[7:0]}
PT3CON    EQU     02BH    ; {PT3CON[7:0]}
PT3OD     EQU     02CH    ; {0,PT36OD,PT35OD,0,0,0,0,0}
TM3CON2   EQU     02DH    ; {DT3CK[1:0],DT3CNT[2:0],DT3_EN,P3H_OEN,P3L_OEN}
TMCON     EQU     02EH    ; {P3HINV,P3LINV,0,0,0,PWM4PO,PWM3PO,PWM2PO}
TMCON2    EQU     02FH    ; {0,0,T4SEL[1:0],T3SEL[1:0],T2SEL[1:0]}
PT5	  EQU     030H    ; {0,0,0,0,0,PT5[2:0]}
PT5EN     EQU     031H    ; {0,0,0,0,0,PT5EN[2:0]}
PT5PU     EQU     032H    ; {0,0,0,0,0,PT5PU[2:0]}
PT5CON    EQU     033H    ; {0,0,0,0,0,PT51OD,PT50OD,PT5CON0}
PT1CON1   EQU     038H    ; {0,0,0,0,PT1W2[3:0]}
EX0CFG    EQU     039H    ; {PWMRL[1:0],POLSEL,0,0,0,EX0FILT[1:0]}
INTF2     EQU     03CH    ; {0,0,TM4IF,TM3IF,0,0,0,0}
INTE2     EQU     03DH    ; {0,0,TM4IE,TM3IE,0,0,0,0}
INTF3     EQU     03EH    ; {CMP0IF,0,0,0,0,0,URTIF,URRIF}
INTE3     EQU     03FH    ; {CMP0IE,0,0,0,0,0,URTIE,URRIE}
TM4CON    EQU	  040H    ; {T4EN,T4RATE[2:0],T4CKS,T4RSTB,T4OUT,PWM4OUT}
TM4IN	  EQU     041H    ; {TM4IN[7:0]}
TM4CNT	  EQU     042H    ; {TM4CNT[7:0]}
TM4R	  EQU     043H    ; {TM4R[7:0]}
TM2INH	  EQU     044H    ; {0,0,,0,0,TM2IN[11:8]}
TM2CNTH	  EQU     045H    ; {0,0,0,0,TM2CNT[11:8]}
TM2RH	  EQU     046H    ; {0,0,0,0,TM2R[11:8]}
TM3INH	  EQU     047H    ; {0,0,0,0,TM3IN[11:8]}
TM3CNTH	  EQU     048H    ; {0,0,0,0,TM3CNT[11:8]}
TM3RH	  EQU     049H    ; {0,0,0,0,TM3R[11:8]}
TM4INH	  EQU     04AH    ; {0,0,0,0,TM4IN[11:8]}
TM4CNTH	  EQU     04BH    ; {0,0,0,0,TM4CNT[11:8]}
TM4RH	  EQU     04CH    ; {0,0,0,0,TM4R[11:8]}
SRADCON0  EQU     050H    ; {QDIF,0,SRADACKS[1:0],0,0,SRADCKS[1:0]}
SRADCON1  EQU     051H    ; {SRADEN,SRADS,OFTEN,CALIF,ENOV,OFFEX,VREFS[1:0]}
SRADCON2  EQU     052H    ; {CHS[3:0],0,0,SRADCKS[1:0]}
SRADL     EQU     054H    ; {SRAD[7:0]]}
SRADH     EQU     055H    ; {0,0,0,0,SRAD[11:8]}
SROFTL    EQU     056H    ; {SROFT[7:0]]}
SROFTH    EQU     057H    ; {0,0,0,0,SROFT[11:8]}
TRIM_EX   EQU     059H    ; {TRIM_EX[7:0]}
TRIM_REF  EQU     05AH    ; {TRIM_REF[7:0]}
LCDCOM	  EQU     05BH    ; {VLCD_SEL,0,0,0,COM[3:0]}
LCDSEG	  EQU     05CH    ; {0,0,0,SEG[4:0]}
LVDCON	  EQU     05EH    ; {LVD36,0,0,0,LVD_TRIM[3:0]}
METCH	  EQU     05FH    ; {METCH[7:0]}
CMPCON	  EQU     06AH    ; {CMPEN,0,0,0,0,0,CMP_OEN,CMPOUT}
SCON1	  EQU     077H    ; {SM0,SM1,SM2,REN,TB8,RB8,0,0}
SCON2	  EQU     078H    ; {SMOD,URCLK [1:0],0,UARTEN,PINCTL[2:0]}
SBUF	  EQU     079H    ; {SBUF[7:0]}
CURCON	  EQU     07AH    ; {P36CUR,P35CUR,P14CUR[1:0],0,CURP17[1:0],0}
SYSCFG0   EQU     07BH    ; {VTHSEL,RST20_SEL,VTHP30[1:0],P30REFEN,LFILT_EN,LFILT_S[1:0]}
SYSCFG1   EQU     07CH    ; {PDP13,PDP31,PDP34,PDP36,CURP16[1:0],CURP15[1:0]}
TESTOP0   EQU     07DH    ; {RES_OP_T[3:0],MCKOP_T,ICK_SEL_T[2:0]}
TESTOP1   EQU     07EH    ; {CLKDIV_T[1:0],LVD_SEL_T[1:0],RSTPIN_T,XTAL_PIN_T[1:0],0}
TEST      EQU     07FH    ; {TEST[7:0]}
; 80H~0FFH is Gereral Data Memory

;-------------------------------------------
; Status register bit map
;-------------------------------------------
Z       EQU     0
C       EQU     1
DC      EQU     2
TO      EQU     3
PD      EQU     4
LVD24   EQU     6
LVD36   EQU     7
;-------------------------------------------
; Interrupt flag register bit map
;-------------------------------------------
E0IF    EQU     0
E1IF    EQU     1
SRADIF  EQU     3
TM0IF   EQU     4
TM2IF   EQU     6
;-------------------------------------------
; Interrupt enable register bit map
;-------------------------------------------
E0IE    EQU     0
E1IE    EQU     1
SRADIE  EQU     3
TM0IE   EQU     4
TM2IE   EQU     6
GIE     EQU     7
;-------------------------------------------
; WDTCON register bit map
;-------------------------------------------
WTS0    EQU     0
WTS1    EQU     1
WTS2    EQU     2
WTDTEN  EQU     7
;-------------------------------------------
; TM0CON register bit map
;-------------------------------------------
T0SEL0  EQU     0
T0SEL1  EQU     1
T0RSTB  EQU     2
T0RATE0 EQU     4
T0RATE1 EQU     5
T0RATE2 EQU     6
T0EN    EQU     7
;-------------------------------------------
; TM2CON register bit map
;-------------------------------------------
PWM2OUT  EQU     0
T2OUT    EQU     1
T2RSTB   EQU     2
T2CKS    EQU     3
T2RATE0  EQU     4
T2RATE1  EQU     5
T2RATE2  EQU     6
T2EN     EQU     7
;-------------------------------------------
; TM3CON register bit map
;-------------------------------------------
PWM3OUT  EQU     0
T3OUT    EQU     1
T3RST    EQU     2
T3CKS    EQU     3
T3RATE0  EQU     4
T3RATE1  EQU     5
T3RATE2  EQU     6
T3EN     EQU     7
;-------------------------------------------
; TM3CON2 register bit map
;-------------------------------------------
DT3CK1   EQU     7
DT3CK0   EQU     6
DT3CNT2  EQU     5
DT3CNT1  EQU     4
DT3CNT0  EQU     3
DT3_EN   EQU     2
P3H_OEN  EQU     1
P3L_OEN  EQU     0
;-------------------------------------------
; METCH1 register bit map
;-------------------------------------------
OFT_ADJ   EQU     0
RST20_SEL EQU     1
PWM2PO    EQU     2
PT1W4     EQU     3
PT1W5     EQU     4
PT1W6     EQU     5
P3LINV    EQU     6
P3HINV    EQU     7
;-------------------------------------------
; METCH register bit map
;-------------------------------------------
T2RATE3   EQU     1
T3RATE3   EQU     2
PWMIS     EQU     3
REF_SEL0  EQU     4
REF_SEL1  EQU     5
REF_SEL2  EQU     6
VTHSEL    EQU     7
;-------------------------------------------
; SRADCON1 register bit map
;-------------------------------------------
VREFS0   EQU     0
VREFS1   EQU     1
OFFEX    EQU     2
ENOV     EQU     3
CALIF    EQU     4
OFTEN    EQU     5
SRADS    EQU     6
SRADEN   EQU     7
;-------------------------------------------
; MCK register bit map
;-------------------------------------------
CLKSEL  EQU     0
EO_SLP  EQU     4
CST_WDT EQU     5
CST_IN  EQU     6
CST     EQU     7
W       EQU     0
F       EQU     1
