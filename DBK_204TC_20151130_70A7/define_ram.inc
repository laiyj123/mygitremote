;============================================
;��־λ����		f0h -- ffh
;============================================
R_SysFlag					equ		80h
	B_TL431_Flag			equ		0		;��׼��־
	B_BatteryCap_OK			equ		1
	B_BatteryStudy_EN		equ		2
	B_LcdDate_OK			equ		3		;�ϵ��ص�ѹ�����ɱ�־

R_Flag						equ		f0h
	B_LcdScan				equ		0		;LCD����ɨ���־
	B_USB_IN				equ		1		;USB�����־
	B_LampOnFlag			equ		2		;�ֵ�Ͳ���ر�־
	B_Load_Int				equ		3		;���ؼ���жϱ�־
	B_Sleep_Enter			equ		4		;����˯�߱�־
	B_ChargeControl_Time	equ		5		;������ʱ��
	B_SysMode_Close			equ		6		;ϵͳģʽ�ر���ִ��
	B_Check_TL431			equ		7		;���TL431

R_KeyFlag					equ		f1h
	B_KeyEn					equ		0		;������Ч��־λ
	B_KeyLongDown			equ		1		;�������±�־λ
	B_KeyDown				equ		2		;�������±�־λ
	B_KeyDone				equ		3		;����ִ�����־λ	
 	B_KeyDubbleDown			equ		4		;˫�����±�־λ	
	B_KeyDubbleTmOver		equ		5		;˫������ʱ������־λ	
	
R_TimeFlag					equ		f2h
	B_Time1ms				equ		0
	B_OutVol_AdcOKFlag		equ		1	
	B_Disp_Flash			equ		2
	B_First1S_OK			equ		3
	B_FirstOnMode2			equ		4
	
R_SysMode					equ		f3h
	B_NullMode				equ		0
	B_NormalMode			equ		1
	B_ChargeMode			equ		2
	B_DisChargeMode			equ		3
	B_ChaDischargeMode		equ		4
	B_FirstOnMode			equ		5
	B_SleepMode				equ		6
	B_ErrMode				equ		7
	
R_ChargeMode				equ		f4h
	B_TrickMode				equ		0
	B_CCMode				equ		1
	B_CVMode				equ		2
	B_FullMode				equ		3
	B_ChargeVolLow_Flag		equ		4
	
R_DischargeFlag				equ		f5h
	B_Boost_En				equ		0		;��ѹʹ��
	B_Load1_IN				equ		1		;����1�����־λ
	B_Load2_IN				equ		2		;����2�����־λ
	B_Discharge_MaxCur		equ		3		;�ŵ�������־
	B_Discharge_MinCur		equ		4		;�ŵ�С������־
	B_Discharge_DispCur		equ		5		;������ʾ��־
	B_LED_OFF				equ		6
	B_Clrf_DisTime			equ		7
	
B_ChargeFlag				equ		f6h
	B_Charge_Full			equ		0		;�䱥��־
	B_Charge_Start			equ		1		;��ʼ����־
	B_BatteryStudy_OK		equ		2
	B_TC_USB_In				equ     3
/*	
R_OutVol_TestDateL			equ		f8h
R_OutVol_TestDateH			equ		f9h
R_BoostCur_TestDateL		equ		fah
R_BoostCur_TestDateH		equ		fbh
R_BuckCur_TestDateL			equ		fch
R_BuckCur_TestDateH			equ		fdh
R_BatVol_TestDateL			equ		feh
R_BatVol_TestDateH			equ		ffh
*/
;============================================
;�Ĵ�������		80h -- efh
;============================================
R_LcdDate_OK				equ		81h
R_VrefCurL					equ		82h
R_VrefCurH					equ		83h

R_BatteryCap_SumOK0			equ		84h
R_BatteryCap_SumOK1			equ		85h
R_BatteryCap_SumOK2			equ		86h

R_BatteryCapOK_UnitL		equ		87h
R_BatteryCapOK_UnitH		equ		88h

;--------------------------------------------
;��ʱ����
R_Data1						equ		89h
;R_Data2						equ		8ah
R_Count						equ		8bh

R_Delay1					equ		8ch
R_Delay2					equ		8dh
R_Delay3					equ		8eh

;R_TEMP1						equ		8fh
;R_TEMP2						equ		90h

;R_TEMP3						equ		91h
;R_TEMP4						equ		92h

R_LcdDate					equ		93h
R_LcdDate_Buffer			equ		94h

;--------------------------------------------
;ϵͳʱ�����
R_time5ms					equ		96h
R_time100ms					equ		97h
;R_time200ms					equ		98h
R_time500ms					equ		99h
;R_usetime					equ		9ah
R_AdcErrTime				equ		9bh
R_time1s					equ		9ch
R_Time1min					equ		9dh

;--------------------------------------------
;ADCת������
R_AdcVef					equ		9eh
R_AdcCh						equ		9fh
R_AdcCount					equ		a0h
R_AdcSumL					equ		a1h
R_AdcSumH					equ		a2h
R_MinDataL					equ		a3h
R_MinDataH					equ		a4h
R_MaxDataL					equ		a5h
R_MaxDataH					equ		a6h

R_OutVol_DateL				equ		a7h
R_OutVol_DateH				equ		a8h
R_BoostCur_DateL			equ		a9h
R_BoostCur_DateH			equ		aah
R_BuckCur_DateL				equ		abh
R_BuckCur_DateH				equ		ach
R_BatVol_DateL				equ		adh
R_BatVol_NormalDateL		equ		aeh
R_BatVol_DateH				equ		afh
R_BatVol_NormalDateH			equ		9ah

R_Cur_DateL					equ		b0h
R_Cur_DateH					equ		b1h

R_BatVol_DealDate0			equ		b2h
R_BatVol_DealDate1			equ		b3h
R_BatVol_DealDate2			equ		b4h

R_BoostCur_DealDateL		equ		b5h
R_BoostCur_DealDateH		equ		b6h

R_BoostSmallCur_DateL		equ		b7h
R_BoostSmallCur_DateH		equ		b8h

R_BuckCur_DealDateL			equ		b9h
R_BuckCur_DealDateH			equ		bah

R_BuckSmallCur_DateL		equ		bbh
R_BuckSmallCur_DateH		equ		bch

R_TL431_AD_Cnt				equ		bdh

R_TL431_AD_SumL				equ		beh
R_TL431_AD_SumH				equ		bfh

;--------------------------------------------
;LCD��ʾ����
R_LcdCom_Cnt				equ		c0h
R_LcdDate_Bai				equ		c1h
R_LcdDate_Shi				equ		c2h
R_LcdDate_Ge				equ		c3h

R_LcdDate_Disp				equ		c4h
R_Lcd_DispTime				equ		c5h

;--------------------------------------------
;���USB��⴦������
R_USB_Cnt					equ		c6h		;USB��������	
R_USB_BK					equ		c7h		;USB��ⱸ�ݼĴ���	
R_USB_BK2					equ		c8h		;USB��ⱸ�ݼĴ���    

;--------------------------------------------
;������������
R_KeyTime					equ		c9h		;�����̰�ʱ�������	
R_KeyDubbleTime				equ		cah		;����˫�������ʱ��
R_KeyLongTime				equ		cbh		;����������ʱ��
R_KeyDowmCnt				equ		cch		;�������µĴ���
R_KeyTem					equ		cdh		;��ʱ��ֵ
R_KeyCur					equ		ceh		;��ǰ��ֵ
R_Lcd_BK					equ		cfh 

;--------------------------------------------
;�ŵ紦������
R_DisCharge_ShortCurCnt		equ		d0h
R_DisCharge_ProCurCnt		equ		d1h
R_DisCharge_SmallCurCnt		equ		d2h
R_DisCharge_OutTime			equ		d3h

;--------------------------------------------
;��紦������
R_Charge_SmallCurCnt		equ		d4h

;--------------------------------------------
;ϵͳ����
R_SysMode_OK				equ		d5h
R_SysMode_BK				equ		d6h
R_SysMode_BK2				equ		d7h
;--------------------------------------------
;���߱���
R_EnterSleep_Cnt			equ		d8h

R_Load1IN_Cnt				equ		d9h
;R_Load2IN_Cnt					equ		dah
R_IntLoad1_En_Time			equ		dbh

R_BatteryVol_Low_Cnt		equ		dch

R_BatteryCap_StudySum0		equ		ddh
R_BatteryCap_StudySum1		equ		deh
R_BatteryCap_StudySum2		equ		dfh

R_BatteryCap_UnitL			equ		e0h
R_BatteryCap_UnitH			equ		e1h

R_BatteryCapCharge_UnitL	equ		e2h
R_BatteryCapCharge_UnitH	equ		e3h

R_BatteryCapDisCharge_UnitL	equ		e4h
R_BatteryCapDisCharge_UnitH	equ		e5h

R_Bat_Level_ChargeUnitL		equ		e6h	
R_Bat_Level_ChargeUnitH		equ		e7h

R_Bat_Level_DisChargeUnitL	equ		e8h	
R_Bat_Level_DisChargeUnitH	equ		e9h

R_DisCharge_ProCurL			equ		eah		
R_DisCharge_ProCurH			equ		ebh		;������������

R_BatVol_PC					equ		eeh			;��ص�ѹ���ָ��
R_BatVol_Level_TempL		equ		ech			;��ص�ѹ����ʱ�Ĵ���
R_BatVol_Level_TempH		equ		edh			;��ص�ѹ����ʱ�Ĵ���

R_ChargeMode_OK				equ		8ah
R_ChargeMode_BK				equ		8fh

R_LowVdd_Num				equ		90h
PT_Key_back					equ		91h

R_TCUSB_BK					equ     92h
R_TCUSB_Cnt					equ     93h
R_channal_cnt				equ		95h
;--------------------------------------------
;ʣ��SRAM:   98h dah  efh f7h-ffh



					 
	

