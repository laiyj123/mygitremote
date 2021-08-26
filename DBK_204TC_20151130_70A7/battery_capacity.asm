;============================================
;��ص�ѹ��⺯��
;============================================
Check_Battery:
	btfsc	R_Flag,B_USB_IN
	return

	movlw	C_MinBatVol_L
	subwf	R_BatVol_DateL,0
	movlw	C_MinBatVol_H
	subwfc	R_BatVol_DateH,0
	btfss	status,c
	goto	BatteryVol_Low
	clrf	R_BatteryVol_Low_Cnt
	return
;--------------------------------------------
;��ص�ѹ����2.8V 	
BatteryVol_Low:
	incf	R_BatteryVol_Low_Cnt,1
	movlw	4
	subwf	R_BatteryVol_Low_Cnt,0
	btfss	status,c
	return
	;========================================
	;��ص�ѹ�ʹ�����
	;========================================
	movlw	1
	subwf	R_LcdDate_OK,0
	btfss	status,c
	goto	BatVolLow_SysOff		
	
	movlw	10
	subwf	R_Time1min,0
	btfss	status,c
	return
	clrf	R_Time1min
	decf	R_LcdDate_OK,1
	goto	BatteryCap_Fun_Exit
	
BatVolLow_SysOff:	
	movlw	C_NullMode
	movwf	R_SysMode_OK

	bsf		R_SysFlag,B_BatteryStudy_EN
	clrf	R_BatteryCap_StudySum0
	clrf	R_BatteryCap_StudySum1
	clrf	R_BatteryCap_StudySum2
	
	movlw	0
	movwf	R_LcdDate_OK

	goto	BatteryCap_Fun_Exit	

;============================================
;��ص�����ʾ
;============================================
BatVol_Disp:
	movfw	R_BatVol_DateL
	movwf	R_BatVol_NormalDateL
	movfw	R_BatVol_DateH
	movwf	R_BatVol_NormalDateH	
		
	btfss	R_SysMode,B_ChargeMode
	goto	BatVol_Disp1
	movlw	C_Charge_Bat_Level
	subwf	R_BatVol_NormalDateL,1
	movlw	0
	subwfc	R_BatVol_NormalDateH,1
	goto	BatVol_Disp2
	
BatVol_Disp1:
	btfss	R_SysMode,B_DisChargeMode
	goto	BatVol_Disp2
	
	movlw	C_DisCharge_Bat_Level
	addwf	R_BatVol_NormalDateL,1
	movlw	0
	addwfc	R_BatVol_NormalDateH,1	

BatVol_Disp2:
	clrf	R_BatVol_PC
BatVol_Jud:
	call	BatVol_Tab
	movwf	R_BatVol_Level_TempL
	incf	R_BatVol_PC,1
	call	BatVol_Tab
	movwf	R_BatVol_Level_TempH
	;----------------------------------------
	;��ص�ѹ�Ƚ�
	movfw	R_BatVol_Level_TempL
	subwf	R_BatVol_NormalDateL,0
	movfw	R_BatVol_Level_TempH
	subwfc	R_BatVol_NormalDateH,0
	btfsc	status,c
	goto	BatLevel_Deal
	incf	R_BatVol_PC,1
	movlw	42
	subwf	R_BatVol_PC,0
	btfss	status,c
	goto	BatVol_Jud
	incf	R_BatVol_PC,1
	
BatLevel_Deal:
	decf	R_BatVol_PC,1
	call	BatVol_Deal_Tab
	movwf	R_DisCharge_ProCurL
	;----------------------------
	movlw	38
	subwf	R_BatVol_PC,0
	movlw	1
	btfss	status,c
	movlw	0	
	movwf	R_DisCharge_ProCurH
	;----------------------------
	
	incf	R_BatVol_PC,1
	call	BatVol_Deal_Tab

BatVol_Disp_COM:
	btfsc	B_ChargeFlag,B_Charge_Full
	movlw	100								;�ж��Ƿ������״̬
	movwf	R_LcdDate
	
	movlw	0
	xorwf	R_LcdDate_OK,0
	btfss	status,z
	return
	
	btfsc	R_SysFlag,B_LcdDate_OK
	return
	bsf		R_SysFlag,B_LcdDate_OK
	movfw	R_LcdDate
	movwf	R_LcdDate_OK					;���µ�����ʾ
	call	HexToDex
	return

;--------------------------------------------
;��ص�ѹ�ȼ���ֵ��
BatVol_Tab:
	movlw	42
	subwf	R_BatVol_PC,0
	btfsc	status,c
	clrf	R_BatVol_PC
	movfw	R_BatVol_PC
	addpcw
	;----------------------------------------
	;��ص�ѹ4.129V
	retlw	C_Normal_Bat_Level_21L	;0		
	retlw	C_Normal_Bat_Level_21H	;1
	;----------------------------------------
	;��ص�ѹ4.065V
	retlw	C_Normal_Bat_Level_20L	;2		
	retlw	C_Normal_Bat_Level_20H	;3
	;----------------------------------------
	;��ص�ѹ4.004V 
	retlw	C_Normal_Bat_Level_19L	;4		
	retlw	C_Normal_Bat_Level_19H	;5
	;----------------------------------------
	;��ص�ѹ3.952V 
	retlw	C_Normal_Bat_Level_18L	;6		
	retlw	C_Normal_Bat_Level_18H	;7
	;----------------------------------------
	;��ص�ѹ3.899V 
	retlw	C_Normal_Bat_Level_17L	;8		
	retlw	C_Normal_Bat_Level_17H	;9
	;----------------------------------------
	;��ص�ѹ3.849V  
	retlw	C_Normal_Bat_Level_16L	;10
	retlw	C_Normal_Bat_Level_16H	;11
	;----------------------------------------
	;��ص�ѹ3.8V
	retlw	C_Normal_Bat_Level_15L	;12		
	retlw	C_Normal_Bat_Level_15H	;13
	;----------------------------------------
	;��ص�ѹ3.75V
	retlw	C_Normal_Bat_Level_14L	;14		
	retlw	C_Normal_Bat_Level_14H	;15
	;----------------------------------------
	;��ص�ѹ3.7V
	retlw	C_Normal_Bat_Level_13L	;16		
	retlw	C_Normal_Bat_Level_13H	;17	
	;----------------------------------------
	;��ص�ѹ3.663V 
	retlw	C_Normal_Bat_Level_12L	;18		
	retlw	C_Normal_Bat_Level_12H	;19
	;----------------------------------------
	;��ص�ѹ3.636V 
	retlw	C_Normal_Bat_Level_11L	;20		
	retlw	C_Normal_Bat_Level_11H	;21
	;----------------------------------------
	;��ص�ѹ3.609V 
	retlw	C_Normal_Bat_Level_10L	;22		
	retlw	C_Normal_Bat_Level_10H	;23
	;----------------------------------------
	;��ص�ѹ3.592V 
	retlw	C_Normal_Bat_Level_9L	;24		
	retlw	C_Normal_Bat_Level_9H	;25
	;----------------------------------------
	;��ص�ѹ3.575V 
	retlw	C_Normal_Bat_Level_8L	;26		
	retlw	C_Normal_Bat_Level_8H	;27
	;----------------------------------------
	;��ص�ѹ3.554V  
	retlw	C_Normal_Bat_Level_7L	;28		
	retlw	C_Normal_Bat_Level_7H	;29
	;----------------------------------------
	;��ص�ѹ3.533V
	retlw	C_Normal_Bat_Level_6L	;30		
	retlw	C_Normal_Bat_Level_6H	;31
	;----------------------------------------
	;��ص�ѹ3.511V
	retlw	C_Normal_Bat_Level_5L	;32		
	retlw	C_Normal_Bat_Level_5H	;33
	;----------------------------------------
	;��ص�ѹ3.493V 
	retlw	C_Normal_Bat_Level_4L	;34		
	retlw	C_Normal_Bat_Level_4H	;35
	;----------------------------------------
	;��ص�ѹ3.46V 
	retlw	C_Normal_Bat_Level_3L	;36		
	retlw	C_Normal_Bat_Level_3H	;37
	;----------------------------------------
	;��ص�ѹ3.43V
	retlw	C_Normal_Bat_Level_2L	;38		
	retlw	C_Normal_Bat_Level_2H	;39
	;----------------------------------------
	;��ص�ѹ3.36V 
	retlw	C_Normal_Bat_Level_1L	;40		
	retlw	C_Normal_Bat_Level_1H	;41
	
;--------------------------------------------
;��ص�ѹ�ȼ���ֵ��
BatVol_Deal_Tab:
	movlw	44
	subwf	R_BatVol_PC,0
	btfsc	status,c
	clrf	R_BatVol_PC
	movfw	R_BatVol_PC
	addpcw
	;----------------------------------------
	;Level_21
	retlw	C_DisCharge_ProCurL				;0
	retlw	99								;1
	;----------------------------------------
	;Level_20
	retlw	C_DisCharge_ProCurL				;2	
	retlw	95								;3
	;----------------------------------------
	;Level_19
	retlw	C_DisCharge_ProCurL+03h			;4	66h
	retlw	90								;5
	;----------------------------------------
	;Level_18
	retlw	C_DisCharge_ProCurL+06h			;6	68h
	retlw	85								;7
	;----------------------------------------
	;Level_17
	retlw	C_DisCharge_ProCurL+09h			;8	69h
	retlw	80								;9
	;----------------------------------------
	;Level_16
	retlw	C_DisCharge_ProCurL+0ch			;10	6bh
	retlw	75								;11
	;----------------------------------------
	;Level_15
	retlw	C_DisCharge_ProCurL+0fh			;12	6dh	
	retlw	70								;13
	;----------------------------------------
	;Level_14
	retlw	C_DisCharge_ProCurL+12h			;14	6eh
	retlw	65								;15
	;----------------------------------------
	;Level_13
	retlw	C_DisCharge_ProCurL+15h			;16	70h
	retlw	60								;17
	;----------------------------------------
	;Level_12
	retlw	C_DisCharge_ProCurL+18h			;18	71h	
	retlw	55								;19
	;----------------------------------------
	;Level_11
	retlw	C_DisCharge_ProCurL+1bh			;20	73h
	retlw	50								;21
	;----------------------------------------
	;Level_10
	retlw	C_DisCharge_ProCurL+1eh			;22	74h
	retlw	45								;23
	;----------------------------------------
	;Level_9
	retlw	C_DisCharge_ProCurL+21h			;24	76h	
	retlw	40								;25
	;----------------------------------------
	;Level_8
	retlw	C_DisCharge_ProCurL+24h			;26	77h	
	retlw	35								;27
	;----------------------------------------
	;Level_7
	retlw	C_DisCharge_ProCurL+27h			;28	79h
	retlw	30								;29
	;----------------------------------------
	;Level_6
	retlw	C_DisCharge_ProCurL+2ah			;30	7ah										
	retlw	25								;31
	;----------------------------------------
	;Level_5
	retlw	C_DisCharge_ProCurL+2dh			;32	7ch										
	retlw	20      						;33
	;----------------------------------------
	;Level_4
	retlw	C_DisCharge_ProCurL+30h			;34	7dh										
	retlw	15								;35
	;----------------------------------------
	;Level_3
	retlw	C_DisCharge_ProCurL+33h			;36	7fh										
	retlw	10								;37
	;----------------------------------------
	;Level_2
	retlw	09h								;38	81h	�����������������������������������������������������������������									
	retlw	5								;39
	;----------------------------------------
	;Level_1
	retlw	10h								;40	82h									
	retlw	1								;41
	;----------------------------------------
	;Level_0
	retlw	15h								;42	84h									
	retlw	0								;43

;============================================
;��ص�ѹ������ʾ
;============================================
BatVol_Fun:
	btfsc	R_SysFlag,B_BatteryCap_OK
	return
	
	btfsc	R_SysMode,B_FirstOnMode
	return

	btfsc	R_Flag,B_USB_IN
	goto	BatVol_UP	
;============================================
;��طŵ��ѹ�ۼƺ���
;============================================
BatVol_DOWN:
	movlw	10
	subwf	R_LcdDate_OK,0					;������С��10%
	btfsc	status,c
	goto	BatVol_DOWN_Fun
;--------------------------------------------		
;�ж���ʾ�����ȼ����ѹ�ȼ���С		
	movfw	R_LcdDate
	subwf	R_LcdDate_OK,0
	btfss	status,c
	goto	DisChargeDisp_Low
	
;--------------------------------------------
;��ʾ����
DisChargeDisp_High:
	movfw	R_LcdDate
	subwf	R_LcdDate_OK,0
	movwf	R_LcdDate_Buffer
	
;--------------------------------------------
;�ж������� 	
	movlw	3
	subwf	R_LcdDate_Buffer,0
	btfss	status,c
	goto	BatVol_DOWN_Fun
;--------------------------------------------
;�ŵ����С��10%���ж����3%���϶��� 
	rlf		R_Bat_Level_DisChargeUnitL,1
	rlf		R_Bat_Level_DisChargeUnitH,1
	goto	BatVol_DOWN_Fun	
	
;--------------------------------------------
;��ʾС����
DisChargeDisp_Low:	
	movfw	R_LcdDate_OK
	subwf	R_LcdDate,0
	movwf	R_LcdDate_Buffer
							
;--------------------------------------------
;�ж�������
	movlw	3
	subwf	R_LcdDate_Buffer,0
	btfss	status,c
	goto	BatVol_DOWN_Fun
;--------------------------------------------
;������С��10%���ж����3%���϶���
	clrf	R_Bat_Level_DisChargeUnitL
	clrf	R_Bat_Level_DisChargeUnitH

BatVol_DOWN_Fun:
;--------------------------------------------
;�ŵ��ѹ��Ԫ->�ۼӷŵ����	
	movfw	R_BoostSmallCur_DateL
	addwf	R_Bat_Level_DisChargeUnitL,1
	movfw	R_BoostSmallCur_DateH
	addwfc	R_Bat_Level_DisChargeUnitH,1
	
;--------------------------------------------
;�ж��Ƿ񵽴�1%�ĵ�ѹ��Ԫ
	movlw	C_Bat_Level_UnitL
	subwf	R_Bat_Level_DisChargeUnitL,0
	movlw	C_Bat_Level_UnitH
	subwfc	R_Bat_Level_DisChargeUnitH,0
	btfss	status,c
	return
	
;--------------------------------------------	
;�ŵ��ѹ��Ԫ->���¸�ֵ	
	movlw	C_Bat_Level_UnitL
	subwf	R_Bat_Level_DisChargeUnitL,1
	movlw	C_Bat_Level_UnitH
	subwfc	R_Bat_Level_DisChargeUnitH,1
	
;--------------------------------------------
;��ѹ��ʾ--	
	movlw	2
	subwf	R_LcdDate_OK,0
	btfss	status,c
	return

	decf	R_LcdDate_OK,1 
	goto	BatVol_Fun_Exit

;============================================
;��س���ѹ�ۼƺ���
;============================================
BatVol_UP:
	movlw	90
	subwf	R_LcdDate_OK,0					;����������90%	
	btfss	status,c
	goto	BatVol_UP_Fun
;--------------------------------------------
;�ж���ʾ�����ȼ����ѹ�ȼ���С	
	movfw	R_LcdDate
	subwf	R_LcdDate_OK,0
	btfss	status,c
	goto	ChargeDisp_Low
	
;--------------------------------------------
;��ʾ����
ChargeDisp_High:
	movfw	R_LcdDate
	subwf	R_LcdDate_OK,0
	movwf	R_LcdDate_Buffer
	
;--------------------------------------------
;�ж������� 	
	movlw	3
	subwf	R_LcdDate_Buffer,0
	btfss	status,c
	goto	BatVol_UP_Fun
;--------------------------------------------
;����������90%���ж����3%���϶��� 	
	clrf	R_Bat_Level_ChargeUnitL
	clrf	R_Bat_Level_ChargeUnitH
	goto	BatVol_UP_Fun	
	
;--------------------------------------------
;��ʾС����
ChargeDisp_Low:	
	movfw	R_LcdDate_OK
	subwf	R_LcdDate,0
	movwf	R_LcdDate_Buffer
							
;--------------------------------------------
;�ж�������
	movlw	3
	subwf	R_LcdDate_Buffer,0
	btfss	status,c
	goto	BatVol_UP_Fun
;--------------------------------------------
;����������90%���ж����3%���϶���
	rlf		R_Bat_Level_ChargeUnitL,1
	rlf		R_Bat_Level_ChargeUnitH,1

BatVol_UP_Fun:
;--------------------------------------------
;����ѹ��Ԫ->�ۼӳ�����	
	movfw	R_BuckSmallCur_DateL
	addwf	R_Bat_Level_ChargeUnitL,1
	movfw	R_BuckSmallCur_DateH
	addwfc	R_Bat_Level_ChargeUnitH,1
	
;--------------------------------------------	
;�ж��Ƿ񵽴�1%�ĵ�ѹ��Ԫ
	movlw	C_Bat_Level_UnitL
	subwf	R_Bat_Level_ChargeUnitL,0
	movlw	C_Bat_Level_UnitH
	subwfc	R_Bat_Level_ChargeUnitH,0
	btfss	status,c
	return

;--------------------------------------------
;����ѹ��Ԫ->���¸�ֵ	
	movlw	C_Bat_Level_UnitL
	subwf	R_Bat_Level_ChargeUnitL,1
	movlw	C_Bat_Level_UnitH
	subwfc	R_Bat_Level_ChargeUnitH,1

;--------------------------------------------
;��ѹ��ʾ++	
	movlw	99
	subwf	R_LcdDate_OK,0
	btfsc	status,c
	return	
	incf	R_LcdDate_OK,1 

BatVol_Fun_Exit:
	call	HexToDex	
	return
 
;============================================
;���ѧϰ����
;============================================
Battery_Study: 
	btfss	B_ChargeFlag,B_Charge_Full
	return

	btfss	R_SysFlag,B_BatteryStudy_EN
	return

	btfsc	B_ChargeFlag,B_BatteryStudy_OK
	return
	bsf		B_ChargeFlag,B_BatteryStudy_OK
	bsf		R_SysFlag,B_BatteryCap_OK
	
	movff	R_BatteryCap_StudySum0,R_BatteryCap_SumOK0
	movff	R_BatteryCap_StudySum1,R_BatteryCap_SumOK1
	movff	R_BatteryCap_StudySum2,R_BatteryCap_SumOK2
	
BatteryCap_Renew_Loop:
	movlw	64h
	subwf	R_BatteryCap_StudySum0,1	
	movlw	00h
	subwfc	R_BatteryCap_StudySum1,1
	movlw	00h
	subwfc	R_BatteryCap_StudySum2,1
	btfss	status,c
	goto	BatteryCap_Renew_Exit
	movlw	1
	addwf	R_BatteryCap_UnitL,1
	movlw	0
	addwfc	R_BatteryCap_UnitH,1
	goto	BatteryCap_Renew_Loop
		
BatteryCap_Renew_Exit:		
	movff	R_BatteryCap_UnitL,R_BatteryCapOK_UnitL
	movff	R_BatteryCap_UnitH,R_BatteryCapOK_UnitH	   

	return
	
;============================================
;��ص����ۼƺ���
;============================================	
BatteryCap_Fun: 
	btfss	R_Flag,B_USB_IN
	goto	BatteryCap_DOWN	
;============================================
;��س������ۼƺ���
;============================================
BatteryCap_UP: 

	btfsc	B_ChargeFlag,B_Charge_Full
	return

	btfss	R_SysFlag,B_BatteryStudy_EN
	goto	BatteryCap_UP2
;--------------------------------------------
;ѧϰ������Ԫ->�ۼӳ�����		
	movfw	R_BuckSmallCur_DateL
	addwf	R_BatteryCap_StudySum0,1
	movfw	R_BuckSmallCur_DateH
	addwfc	R_BatteryCap_StudySum1,1
	movlw	0
	addwfc	R_BatteryCap_StudySum2,1
;--------------------------------------------
;����ܵ���->�ۼӳ�����	
BatteryCap_UP2:
	btfss	R_SysFlag,B_BatteryCap_OK
	return
	
	movfw	R_BuckSmallCur_DateL
	addwf	R_BatteryCap_SumOK0,1
	movfw	R_BuckSmallCur_DateH
	addwfc	R_BatteryCap_SumOK1,1
	movlw	0
	addwfc	R_BatteryCap_SumOK2,1

;--------------------------------------------
;��������Ԫ->�ۼӳ�����		
	movfw	R_BuckSmallCur_DateL
	addwf	R_BatteryCapCharge_UnitL,1
	movfw	R_BuckSmallCur_DateH
	addwfc	R_BatteryCapCharge_UnitH,1

;--------------------------------------------
;�ж��Ƿ񵽴�1%�ĵ�����Ԫ	
	movfw	R_BatteryCapOK_UnitL
	subwf	R_BatteryCapCharge_UnitL,0
	movfw	R_BatteryCapOK_UnitH
	subwfc	R_BatteryCapCharge_UnitH,0
	btfss	status,c
	return

;--------------------------------------------
;��������Ԫ->���¸�ֵ	
	movfw	R_BatteryCapOK_UnitL
	subwf	R_BatteryCapCharge_UnitL,1
	movfw	R_BatteryCapOK_UnitH
	subwfc	R_BatteryCapCharge_UnitH,1

;--------------------------------------------
;������ʾ++	
	movlw	99
	subwf	R_LcdDate_OK,0
	btfsc	status,c
	return
	
	incf	R_LcdDate_OK,1 
	goto	BatteryCap_Fun_Exit	

;============================================
;��طŵ�����ۼƺ���
;============================================
BatteryCap_DOWN: 
	btfss	R_SysFlag,B_BatteryCap_OK
	return
;--------------------------------------------
;����ܵ���->�ۼӷŵ�����	
	movfw	R_BoostSmallCur_DateL
	subwf	R_BatteryCap_SumOK0,0
	movfw	R_BoostSmallCur_DateH
	subwfc	R_BatteryCap_SumOK1,0
	movlw	0
	subwfc	R_BatteryCap_SumOK2,0
	btfss	status,c
	goto	BatteryCap_DOWN2

	movfw	R_BoostSmallCur_DateL
	subwf	R_BatteryCap_SumOK0,1
	movfw	R_BoostSmallCur_DateH
	subwfc	R_BatteryCap_SumOK1,1
	movlw	0
	subwfc	R_BatteryCap_SumOK2,1
	
;--------------------------------------------
;�ŵ������Ԫ->�ۼӷŵ����	
BatteryCap_DOWN2:
	movfw	R_BoostSmallCur_DateL
	addwf	R_BatteryCapDisCharge_UnitL,1
	movfw	R_BoostSmallCur_DateH
	addwfc	R_BatteryCapDisCharge_UnitH,1
	
;--------------------------------------------
;�ж��Ƿ񵽴�1%�ĵ�����Ԫ	
	movfw	R_BatteryCapOK_UnitL
	subwf	R_BatteryCapDisCharge_UnitL,0
	movfw	R_BatteryCapOK_UnitH
	subwfc	R_BatteryCapDisCharge_UnitH,0
	btfss	status,c
	return
	
;--------------------------------------------
;�ŵ������Ԫ->���¸�ֵ	
	movfw	R_BatteryCapOK_UnitL
	subwf	R_BatteryCapDisCharge_UnitL,1
	movfw	R_BatteryCapOK_UnitH
	subwfc	R_BatteryCapDisCharge_UnitH,1
	
;--------------------------------------------
;������ʾ--	
	movlw	2
	subwf	R_LcdDate_OK,0
	btfss	status,c
	return

	decf	R_LcdDate_OK,1 

BatteryCap_Fun_Exit:
	call	HexToDex	
	return	  