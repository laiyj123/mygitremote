;============================================
;编译开关定义
;============================================
K_Vef_Vol					equ		1		;内部参考电压选择：0: 2.0V  1: 1.4V   
K_LCD_Power					equ     0		;LCD移动电源		     4CE7
K_88LED_Power				equ 	0		;88显示数码管移动电源    B422
K_188LED_Power				equ 	1		;188显示数码管移动电源
K_discharge_off				equ		0		;放电灭数码管

;============================================
;常数定义
;============================================
C_SegA						equ		0
C_SegB						equ		1
C_SegC						equ		2
C_SegD						equ		3
C_SegE						equ		4
C_SegF						equ		5
C_SegG						equ		6

;--------------------------------------------
;系统模式
C_NullMode					equ		0
C_NormalMode				equ		1
C_ChargeMode				equ		2
C_DisChargeMode				equ		3
C_ChaDischargeMode			equ		4
C_FirstOnMode				equ		5
C_SleepMode					equ		6
C_ErrMode					equ		7

;--------------------------------------------
;充电模式
C_TrickMode					equ		0
C_CCMode					equ		1
C_CVMode					equ		2
C_FullMode					equ		3

C_AdcCh_OutVol				equ		a0h
C_AdcCh_Cur					equ		20h
C_AdcCh_BatVol				equ		30h

C_Vef_Vdd					equ		00h
C_Vef_20V					equ		02h

if	K_Vef_Vol
;============================================
;内部参考电压:1.4V
;============================================
	C_VrefCurL					equ		45h
	C_VrefCurH					equ		01h
	
	C_TL431_AD_HighL			equ		4fh
	C_TL431_AD_HighH			equ		01h

	C_TL431_AD_LowL				equ		3ah
	C_TL431_AD_LowH				equ		01h
	
	;--------------------------------------------
	;放电常量（输出电压为8位AD）
	C_OutVol_L					equ		4Bh		;恒压电压4.58V-4.79V   4.8--5.02  
	C_OutVol_H					equ		48h		
	
	C_OutVol_Pro				equ		44h		;保护电压5.2V

	C_DisCharge_LimitCurL		equ		63h		
	C_DisCharge_LimitCurH		equ		00h		;恒流电流3.25A-3.35A	
	
	C_DisCharge_LimitCur2L		equ		66h		
	C_DisCharge_LimitCur2H		equ		00h		
	
	C_OutVol_MinL				equ		59h		;恒流输出最低输出电压4.0V-4.1V
	C_OutVol_MinH				equ		57h		
	
	C_DisCharge_DispCurL		equ		71h		
	C_DisCharge_DispCurH		equ		79h		;放电显示电流2.0A
	
	C_DisCharge_ProCurL			equ		cch		
	C_DisCharge_ProCurH			equ		00h		;过流保护电流3.5A
	
	C_DisCharge_ShortCurL		equ		5Fh		
	C_DisCharge_ShortCurH		equ		01h		;短路保护电流6A
	
	;C_DisCharge_ShortCurL		equ		31h		
	;C_DisCharge_ShortCurH		equ		00h		;短路保护电流4.7A(自己计算)
	
	C_DisCharge_SmallCurL		equ		0fh		
	C_DisCharge_SmallCurH		equ		00h		;放电小电流
	
	C_DisCharge_SmallCurL2		equ		10h		;放电小电流2
	
	C_DisCharge_SmallCur2L		equ		18h		
	C_DisCharge_SmallCur2H		equ		00h		;再放电小电流
	
	;--------------------------------------------
	;充电常量
	C_Charge_SmallCurL			equ		0bh		
	C_Charge_SmallCurH			equ		00h		;充电小电流200mA
	
	C_Charge_MosOnCur			equ		15h		;开MOS管电流:350mA
	C_Charge_MosOffCur			equ		0eh		;关MOS管电流:250mA
	
	;C_TrickVolL					equ		7ch	
	;C_TrickVolH					equ		02h		;涓流充电2.8V
	
	C_TrickVolL					equ		aah	
	C_TrickVolH					equ		02h		;涓流充电3.0V
	
	C_TrickVol2L				equ		d7h	
	C_TrickVol2H				equ		02h		;涓流充电3.2V
	
	C_CV_VolL					equ		c0h	
	C_CV_VolH					equ		03h		;充电恒压4.22V
	
	C_CC_VolL					equ		8dh	
	C_CC_VolH					equ		03h		;充电恒压4.0V
	
	C_ChargeVol_Low1L			equ		5eh	
	C_ChargeVol_Low1H			equ		00h		;充电降压-电压3.8V
	
	C_ChargeVol_Low2L			equ		5bh	
	C_ChargeVol_Low2H			equ		00h		;充电降压-电压3.9V
	
	C_TrickCur1L				equ		1ch		;涓流500mA充电			
	C_TrickCur1H				equ		00h	
	
	C_TrickCur2L				equ		1eh		;涓流500mA充电			
	C_TrickCur2H				equ		00h	
	
	
	;C_ConCur1L					equ		38h		;恒流1A充电		
	;C_ConCur1H					equ		00h	
	
	;C_ConCur2L					equ		3ch		;恒流1A充电			
	;C_ConCur2H					equ		00h		
	
	C_ConCur1L					equ		8Fh		;恒流2.4A充电		
	C_ConCur1H					equ		00h	
	
	C_ConCur2L					equ		94h		;恒流2.5A充电			
	C_ConCur2H					equ		00h		
	
		
	;--------------------------------------------
	;电池常量
	;C_MinBatVol_L				equ		7ch		;最小电池电压2.8V
	;C_MinBatVol_H				equ		02h	
	
	C_MinBatVol_L				equ		93h		;最小电池电压2.9V
	C_MinBatVol_H				equ		02h	
	
	;C_MinBatVol_L				equ		aah		;最小电池电压3.0V
	;C_MinBatVol_H				equ		02h	
	
	;C_MinBatVol_L				equ		d7h		;最小电池电压3.2V
	;C_MinBatVol_H				equ		02h	
	
	;--------------------------------------------
	;静态电量等级参数
	C_Charge_Bat_Level			equ		07h		;充电补偿值
	C_DisCharge_Bat_Level		equ		17h		;放电补偿值
	
	C_Normal_Bat_Level_1L		equ	    fch 
	C_Normal_Bat_Level_1H		equ 	02h		;3.36V
	
	;C_Normal_Bat_Level_2L		equ	    1fh 
	;C_Normal_Bat_Level_2H		equ	    02h		;3.414V
	
	C_Normal_Bat_Level_2L		equ	    0ch 
	C_Normal_Bat_Level_2H		equ	    03h		;3.43V
	
	C_Normal_Bat_Level_3L		equ	    13h 
	C_Normal_Bat_Level_3H		equ	    03h		;3.46V
	
	C_Normal_Bat_Level_4L		equ	    1ah 
	C_Normal_Bat_Level_4H		equ	    03h		;3.493V
	
	C_Normal_Bat_Level_5L		equ	    1eh 
	C_Normal_Bat_Level_5H		equ	    03h		;3.511V 
	
	C_Normal_Bat_Level_6L		equ	    23h 
	C_Normal_Bat_Level_6H		equ	    03h		;3.533V 
	
	C_Normal_Bat_Level_7L		equ	    28h 
	C_Normal_Bat_Level_7H		equ	    03h		;3.554V 
	
	C_Normal_Bat_Level_8L		equ	    2dh 
	C_Normal_Bat_Level_8H		equ	    03h		;3.575V 
	
	C_Normal_Bat_Level_9L		equ	    31h 
	C_Normal_Bat_Level_9H		equ	    03h		;3.592V 
	
	C_Normal_Bat_Level_10L		equ	    35h 
	C_Normal_Bat_Level_10H		equ	    03h		;3.609V 
	
	C_Normal_Bat_Level_11L		equ	    3bh 
	C_Normal_Bat_Level_11H		equ	    03h		;3.636V 
	
	C_Normal_Bat_Level_12L		equ	    41h 
	C_Normal_Bat_Level_12H		equ	    03h		;3.663V 
	
	C_Normal_Bat_Level_13L		equ	    49h 
	C_Normal_Bat_Level_13H		equ	    03h		;3.7V 
	
	C_Normal_Bat_Level_14L		equ	    55h 
	C_Normal_Bat_Level_14H		equ	    03h		;3.75V 
	
	C_Normal_Bat_Level_15L		equ	    60h 
	C_Normal_Bat_Level_15H		equ	    03h		;3.8V 
	
	C_Normal_Bat_Level_16L		equ	    6bh 
	C_Normal_Bat_Level_16H		equ	    03h		;3.849V 
	
	C_Normal_Bat_Level_17L		equ	    77h 
	C_Normal_Bat_Level_17H		equ	    03h		;3.899V 
	
	C_Normal_Bat_Level_18L		equ	    83h 
	C_Normal_Bat_Level_18H		equ	    03h		;3.952V 
	
	C_Normal_Bat_Level_19L		equ	    8eh 
	C_Normal_Bat_Level_19H		equ	    03h		;4.004V 
	
	C_Normal_Bat_Level_20L		equ	    9ch 
	C_Normal_Bat_Level_20H		equ	    03h		;4.065V 
	
	C_Normal_Bat_Level_21L		equ	    abh 
	C_Normal_Bat_Level_21H		equ	    03h		;4.129V 
	
	C_Bat_Level_UnitL			equ		50h		;公式：电池容量/100*3600(1小时)
	C_Bat_Level_UnitH			equ		46h		;例：10000mAh/100=100mAh --->100mA对应的值是5(十六进制) --->5*3600=18000 --->转16进制：4650H       

else
;============================================
;内部参考电压:2.0V
;============================================

	C_VrefCurL					equ		e3h
	C_VrefCurH					equ		00h
	
	C_TL431_AD_HighL			equ		edh
	C_TL431_AD_HighH			equ		00h

	C_TL431_AD_LowL				equ		d9h
	C_TL431_AD_LowH				equ		00h
	
	;--------------------------------------------
	;放电常量（输出电压为8位AD）
	C_OutVol_L					equ		6fh		;恒压电压4.58V-4.79V
	C_OutVol_H					equ		6ah		
	
	C_OutVol_Pro				equ		62h		;保护电压5.2V

	C_DisCharge_LimitCurL		equ		63h		
	C_DisCharge_LimitCurH		equ		00h		;恒流电流3.25A-3.35A	
	
	C_DisCharge_LimitCur2L		equ		66h		
	C_DisCharge_LimitCur2H		equ		00h		
	
	C_OutVol_MinL				equ		80h		;恒流输出最低输出电压4.0V-4.1V
	C_OutVol_MinH				equ		7ch		
	
	C_DisCharge_DispCurL		equ		3ah		
	C_DisCharge_DispCurH		equ		40h		;放电显示电流2.0A
	
	C_DisCharge_ProCurL			equ		65h		
	C_DisCharge_ProCurH			equ		00h		;过流保护电流3.5A
	
	C_DisCharge_ShortCurL		equ		90h		
	C_DisCharge_ShortCurH		equ		00h		;短路保护电流4.7A
	
	;C_DisCharge_ShortCurL		equ		31h		
	;C_DisCharge_ShortCurH		equ		00h		;短路保护电流4.7A(自己计算)
	
	C_DisCharge_SmallCurL		equ		04h		
	C_DisCharge_SmallCurH		equ		00h		;放电小电流
	
	C_DisCharge_SmallCurL2		equ		05h		;放电小电流2
	
	C_DisCharge_SmallCur2L		equ		0ah		
	C_DisCharge_SmallCur2H		equ		00h		;再放电小电流
	
	;--------------------------------------------
	;充电常量
	C_Charge_SmallCurL			equ		06h		
	C_Charge_SmallCurH			equ		00h		;充电小电流200mA
	
	C_Charge_MosOnCur			equ		0bh		;开MOS管电流:350mA
	C_Charge_MosOffCur			equ		07h		;关MOS管电流:250mA
	
	;C_TrickVolL					equ		bdh	
	;C_TrickVolH					equ		01h		;涓流充电2.8V
	
	C_TrickVolL					equ		ddh	
	C_TrickVolH					equ		01h		;涓流充电3.0V
	
	C_TrickVol2L				equ		fdh	
	C_TrickVol2H				equ		01h		;涓流充电3.2V
	
	C_CV_VolL					equ		A0h	
	C_CV_VolH					equ		02h		;充电恒压4.22V
	
	C_CC_VolL					equ		7Ch	
	C_CC_VolH					equ		02h		;充电恒压4.0V
	
	C_ChargeVol_Low1L			equ		86h	
	C_ChargeVol_Low1H			equ		00h		;充电降压-电压3.8V
	
	C_ChargeVol_Low2L			equ		83h	
	C_ChargeVol_Low2H			equ		00h		;充电降压-电压3.9V
	
	C_TrickCur1L				equ		0eh		;涓流500mA充电			
	C_TrickCur1H				equ		00h	
	
	C_TrickCur2L				equ		10h		;涓流500mA充电			
	C_TrickCur2H				equ		00h	
	
	
	;C_ConCur1L					equ		31h		;恒流1A充电		
	;C_ConCur1H					equ		00h	
	
	;C_ConCur2L					equ		35h		;恒流1A充电			
	;C_ConCur2H					equ		00h		
	
	C_ConCur1L					equ		3ah		;恒流2A充电		
	C_ConCur1H					equ		00h	
	
	C_ConCur2L					equ		40h		;恒流2A充电			
	C_ConCur2H					equ		00h		
	
		
	;--------------------------------------------
	;电池常量
	;C_MinBatVol_L				equ		bdh		;最小电池电压2.8V
	;C_MinBatVol_H				equ		01h	
	
	C_MinBatVol_L				equ		ddh		;最小电池电压3.0V
	C_MinBatVol_H				equ		01h	
	
	;C_MinBatVol_L				equ		fdh		;最小电池电压3.2V
	;C_MinBatVol_H				equ		01h	
	
	;--------------------------------------------
	;静态电量等级参数
	C_Charge_Bat_Level			equ		0ah		;充电补偿值
	C_DisCharge_Bat_Level		equ		22h		;放电补偿值
	
	C_Normal_Bat_Level_1L		equ	    17h 
	C_Normal_Bat_Level_1H		equ 	02h		;3.36V
	
	;C_Normal_Bat_Level_2L		equ	    1fh 
	;C_Normal_Bat_Level_2H		equ	    02h		;3.414V
	
	C_Normal_Bat_Level_2L		equ	    22h 
	C_Normal_Bat_Level_2H		equ	    02h		;3.43V
	
	C_Normal_Bat_Level_3L		equ	    26h 
	C_Normal_Bat_Level_3H		equ	    02h		;3.46V
	
	C_Normal_Bat_Level_4L		equ	    2ch 
	C_Normal_Bat_Level_4H		equ	    02h		;3.493V
	
	C_Normal_Bat_Level_5L		equ	    2fh 
	C_Normal_Bat_Level_5H		equ	    02h		;3.511V 
	
	C_Normal_Bat_Level_6L		equ	    32h 
	C_Normal_Bat_Level_6H		equ	    02h		;3.533V 
	
	C_Normal_Bat_Level_7L		equ	    35h 
	C_Normal_Bat_Level_7H		equ	    02h		;3.554V 
	
	C_Normal_Bat_Level_8L		equ	    39h 
	C_Normal_Bat_Level_8H		equ	    02h		;3.575V 
	
	C_Normal_Bat_Level_9L		equ	    3ch 
	C_Normal_Bat_Level_9H		equ	    02h		;3.592V 
	
	C_Normal_Bat_Level_10L		equ	    3eh 
	C_Normal_Bat_Level_10H		equ	    02h		;3.609V 
	
	C_Normal_Bat_Level_11L		equ	    43h 
	C_Normal_Bat_Level_11H		equ	    02h		;3.636V 
	
	C_Normal_Bat_Level_12L		equ	    47h 
	C_Normal_Bat_Level_12H		equ	    02h		;3.663V 
	
	C_Normal_Bat_Level_13L		equ	    4dh 
	C_Normal_Bat_Level_13H		equ	    02h		;3.7V 
	
	C_Normal_Bat_Level_14L		equ	    55h 
	C_Normal_Bat_Level_14H		equ	    02h		;3.75V 
	
	C_Normal_Bat_Level_15L		equ	    5dh 
	C_Normal_Bat_Level_15H		equ	    02h		;3.8V 
	
	C_Normal_Bat_Level_16L		equ	    64h 
	C_Normal_Bat_Level_16H		equ	    02h		;3.849V 
	
	C_Normal_Bat_Level_17L		equ	    6ch 
	C_Normal_Bat_Level_17H		equ	    02h		;3.899V 
	
	C_Normal_Bat_Level_18L		equ	    75h 
	C_Normal_Bat_Level_18H		equ	    02h		;3.952V 
	
	C_Normal_Bat_Level_19L		equ	    7dh 
	C_Normal_Bat_Level_19H		equ	    02h		;4.004V 
	
	C_Normal_Bat_Level_20L		equ	    87h 
	C_Normal_Bat_Level_20H		equ	    02h		;4.065V 
	
	C_Normal_Bat_Level_21L		equ	    91h 
	C_Normal_Bat_Level_21H		equ	    02h		;4.129V 
	
	;C_Bat_Level_UnitL			equ		00h		;公式：电池容量/100*3600(1小时)
	;C_Bat_Level_UnitH			equ		48h		;例：10000mAh/100=100mAh --->100mA对应的值是5.12(十进制) --->5.12*3600=18432 --->转16进制：4800H   
	
	;C_Bat_Level_UnitL			equ		00h		;公式：电池容量/100*3600(1小时)
	;C_Bat_Level_UnitH			equ		24h		;例：5000mAh/100=50mAh --->50mA对应的值是2.56(十进制) --->2.56*3600=9216 --->转16进制：2400H  
	
	C_Bat_Level_UnitL			equ		20h		;公式：电池容量/100*3600(1小时)
	C_Bat_Level_UnitH			equ		1Ch		;例：5000mAh/100=50mAh --->50mA对应的值是2.56(十六进制) --->2*3600=9216 --->转16进制：1C20H    
endif

	C_DisCharge_SmallCurTime	equ		3		;放电小电流检测时间
	C_DisCharge_OutTime			equ		90		;无负载关闭输出时间
	C_Lcd_DispTime				equ		15

;============================================
;IO口定义
;============================================
IF	K_LCD_Power
PT_Com						equ		pt1
PT_ComEn					equ		pt1en
	P_Com0					equ		4		;P1.4
	P_Com1					equ		5		;P1.5
	P_Com2					equ		6		;P1.6
	P_Com3					equ		7		;P1.7
	
PT_Seg0						equ		pt1
	P_Seg0					equ		1		;P1.1

PT_Seg1						equ		pt1
	P_Seg1					equ		2		;P1.2

PT_Seg2						equ		pt5
	P_Seg2					equ		0		;P5.0

PT_Seg3						equ		pt5
	P_Seg3					equ		1		;P5.1

PT_Seg4						equ		pt5
	P_Seg4					equ		2		;P5.2
	
ENDIF



IF	K_188LED_Power
PT_Com						equ		pt1
	P_Com0					equ		4		;P1.4
	P_Com1					equ		5		;P1.5
	P_Com2					equ		6		;P1.6
	P_Com3					equ		7		;P1.7

PT_Seg0						equ		pt1
	P_Seg0					equ		1		;P1.1

PT_Seg1						equ		pt5
	P_Seg1					equ		0		;P5.0

PT_Seg2						equ		pt5
	P_Seg2					equ		1		;P5.1

PT_Seg3						equ		pt5
	P_Seg3					equ		2		;P5.2
ENDIF




IF	K_88LED_Power
PT_DIG						equ		pt1
PT_DIGEn					equ		pt1en
	P_DIG1					equ		4		;P1.4
	P_DIG2					equ		5		;P1.5
	
PT_A						equ		pt1
	P_A						equ		1		;P1.1

PT_B						equ		pt1
	P_B						equ		2		;P1.2

PT_C						equ		pt1
	P_C						equ		6		;P1.6

PT_D						equ		pt1
	P_D						equ		7		;P1.7
	
PT_E						equ		pt5
	P_E						equ		2		;P5.2

PT_F						equ		pt5
	P_F						equ		1		;P5.1

PT_G						equ		pt5
	P_G						equ		0		;P5.0

;----------------------------------
;段码定义							DP G F E D C B A
Dis_A						equ		00000001B
Dis_B						equ		00000010B
Dis_C						equ		00000100B
Dis_D						equ		00001000B
Dis_E						equ		00010000B
Dis_F						equ		00100000B
Dis_G						equ		01000000B
Dis_DP						equ		10000001B

DIS_N0						equ 	Dis_A+Dis_B+Dis_C+Dis_D+Dis_E+Dis_F
DIS_N1						equ 	Dis_B+Dis_C
DIS_N2						equ 	Dis_A+Dis_B+Dis_G+Dis_E+Dis_D
DIS_N3						equ 	Dis_A+Dis_B+Dis_G+Dis_C+Dis_D
DIS_N4						equ 	Dis_F+Dis_G+Dis_B+Dis_C
DIS_N5						equ 	Dis_A+Dis_F+Dis_G+Dis_C+Dis_D
DIS_N6						equ 	Dis_A+Dis_F+Dis_G+Dis_C+Dis_D+Dis_E
DIS_N7						equ 	Dis_A+Dis_B+Dis_C
DIS_N8						equ 	Dis_A+Dis_B+Dis_C+Dis_D+Dis_E+Dis_F+Dis_G
DIS_N9						equ 	Dis_A+Dis_B+Dis_C+Dis_D+Dis_F+Dis_G

ENDIF






;--------------------------------------------
;按键检测控制
IF	K_LCD_Power
	PT_Key					equ		pt3
	PT_KeyEn				equ		pt3en
	PT_KeyPu				equ		pt3pu
		IO_Key				equ		0
ENDIF

IF	K_88LED_Power
	PT_Key					equ		pt1
	PT_KeyEn				equ		pt1en
	PT_KeyPu				equ		pt1pu
		IO_Key				equ		1		
ENDIF

IF	K_188LED_Power
	PT_Key					equ		pt1
	PT_KeyEn				equ		pt1en
	PT_KeyPu				equ		pt1pu
		IO_Key				equ		1		
ENDIF

;--------------------------------------------
;USB检测控制
PT_USB						equ		pt3
PT_USB_EN					equ		pt3en
	IO_USB					equ		1

;--------------------------------------------
;放电MOS开关控制
PT_OUT_EN					equ	  	pt3   
	IO_OUT_EN				equ  	4	

;--------------------------------------------
;照明灯控制
PT_LAMP					 	equ		pt3
	IO_LAMP					equ		3

;--------------------------------------------
;检测负载控制
PT_Load						equ		pt1
PT_Load_EN					equ		pt1en
	IO_Load					equ		3
	
;--------------------------------------------
;背光控制
PT_LED					 	equ		pt3
	IO_LED					equ		1
	
;--------------------------------------------
;充电MOS管控制
IF	K_88LED_Power
PT_PSW					 	equ		pt3
	IO_PSW					equ		7
ENDIF	
	
IF	K_LCD_Power
PT_PSW					 	equ		pt3
	IO_PSW					equ		7
ENDIF	
	
;--------------------------------------------
;TYPE-C充电USB检测
IF	K_188LED_Power
PT_TC_USB				 	equ		pt1
PT_TC_USB_EN				equ		pt1en
	IO_TC_USB				equ		2
	
PT_TC_OUT_EN				equ		pt3
	IO_TC_OUT_EN			equ     7
ENDIF		
	
	
	
	
	
	