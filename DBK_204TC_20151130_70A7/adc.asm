;============================================
;AD转换程序
;============================================
AdcRead:
	movlw	1
	subwf	R_AdcErrTime,0
	btfss	status,c
	goto	AdcReset						;复位AD
	
	btfsc	sradcon1,srads					;转换完成标志
	return	
	
	;=======================================
	movlw	00000100b
	xorwf	sradcon1,1						;OFFSET交换
	;=======================================
	
	movlf	2,R_AdcErrTime	
	movlw	1
	subwf	R_AdcCount,0
	btfsc	status,c
	goto	AdcDeal
;--------------------------------------------
;去掉前三次采集的数据
	incf	R_AdcCount,1
AdcDataUpdte:
	clrf	R_AdcSumL
	clrf	R_AdcSumH
	clrf	R_MaxDataL
	clrf	R_MaxDataH
	movlw	ffh
	movwf	R_MinDataL
	movwf	R_MinDataH	
	goto	AdcExit	
;--------------------------------------------
;有效采集的数据
AdcDeal:
/*
;--------------------------------------------
;短路保护检测
	movlw	C_AdcCh_Cur
	xorwf	R_AdcCh,0
	btfss	status,z
	goto	AdcDeal2

	btfss	R_DischargeFlag,B_Boost_En
	goto	AdcDeal2
	
	movlw	C_DisCharge_ShortCurL
	subwf	sradl,0
	movlw	C_DisCharge_ShortCurH
	subwfc	sradh,0
	btfss	status,c
	goto	DisCharge_ShortDeal	
	movlw	3
	movwf	R_DisCharge_ShortCurCnt
	goto	AdcDeal2
	
DisCharge_ShortDeal:
	decfsz	R_DisCharge_ShortCurCnt,1
	goto	AdcDeal2
	incf	R_DisCharge_ShortCurCnt,1
	call	DisCharge_Protect_Deal

AdcDeal2:
*/	
	movfw	sradl
	subwf	R_MaxDataL,0
	movfw	sradh
	subwfc	R_MaxDataH,0
	btfsc	status,c
	goto	JudgeMinData
    movff	sradl,R_MaxDataL
    movff	sradh,R_MaxDataH
    
JudgeMinData:    
	movfw	R_MinDataL
	subwf	sradl,0
	movfw	R_MinDataH
	subwfc	sradh,0
	btfsc	status,c
	goto	AdcSum
    movff	sradl,R_MinDataL
    movff	sradh,R_MinDataH			  	

AdcSum:
	movfw	sradl
	addwf	R_AdcSumL,1
	movfw	sradh
	andlw	00001111b
	addwfc	R_AdcSumH,1
	incf	R_AdcCount,1
	
	movlw	11
	subwf	R_AdcCount,0
	btfss	status,c
	goto	AdcExit
;--------------------------------------------
;AD数据处理	
	movfw	R_MaxDataL
	subwf	R_AdcSumL,1
	movfw	R_MaxDataH
	subwfc	R_AdcSumH,1
	
	movfw	R_MinDataL
	subwf	R_AdcSumL,1
	movfw	R_MinDataH
	subwfc	R_AdcSumH,1
;--------------------------------------------
;AD数据处理：求8次平均值	
	movlf	3,R_Count
AdcAverage:
	bcf		status,c
	rrf		R_AdcSumH,1
	rrf		R_AdcSumL,1
	decfsz	R_Count,1
	goto	AdcAverage	
;--------------------------------------------
;AD数据赋值
;--------------------------------------------
;输出电压数据
AdcCh_OutVol:
	movlw	C_AdcCh_OutVol
	xorwf	R_AdcCh,0
	btfss	status,z
	goto	AdcCh_Cur
	
	movlw	11110000b
	andwf	R_AdcSumL,1
	
	movlw	00001111b
	andwf	R_AdcSumH,0
	
	iorwf	R_AdcSumL,1
	swapf	R_AdcSumL,1
	
	movff	R_AdcSumL,R_OutVol_DateL
	;movff	R_OutVol_TestDateL,R_OutVol_DateL
	
	call	DisChargeVol_Deal

	;----------------------------------
	;通道选择
;	incf	R_channal_cnt,1
;	btfss	R_channal_cnt,0
;	goto	Bat_channal_cel
	
	;----------------------------------
	;电流通道
	movlf	C_AdcCh_Cur,R_AdcCh
	movlf	C_Vef_20V,R_AdcVef
	;bsf		pt3con,0
	bsf		pt3con,2
;	goto	AdcChSwitch
		
	;----------------------------------
	;电池通道
;Bat_channal_cel:
;	movlf	C_AdcCh_BatVol,R_AdcCh
;	movlf	C_Vef_20V,R_AdcVef
;	bcf		pt3con,2
;	bcf		pt3en,3
;	bsf		pt3con,3
	goto	AdcChSwitch
	
;--------------------------------------------
;充放电电流数据		
AdcCh_Cur:	
 	movlw	C_AdcCh_Cur
	xorwf	R_AdcCh,0
	btfss	status,z
	goto	AdcCh_BatVol

;	movff	R_AdcSumL,R_Cur_DateL
;	movff	R_AdcSumH,R_Cur_DateH
	
	btfsc	R_Flag,B_USB_IN				
	goto	Check_TL431
	
	btfss	R_DischargeFlag,B_Boost_En
	goto	AdcCh_Cur_JUD
	
Check_TL431:	
	btfss	R_Flag,B_Check_TL431
	goto	AdcCh_Cur_JUD		

	btfsc	R_SysFlag,B_TL431_Flag
	goto	AdcCh_Cur_JUD

	incf	R_TL431_AD_Cnt,1
	
	movfw	R_AdcSumL
	addwf	R_TL431_AD_SumL,1
	movfw	R_AdcSumH
	andlw	00001111b
	addwfc	R_TL431_AD_SumH,1
	movlw	8
	subwf	R_TL431_AD_Cnt,0
	btfss	status,c
	goto	AdcCh_Cur_JUD
	
	movlf	3,R_TL431_AD_Cnt
TL431_AD_Loop:
	bcf		status,c
	rrf		R_TL431_AD_SumH,1
	rrf		R_TL431_AD_SumL,1
	decfsz	R_TL431_AD_Cnt,1
	goto	TL431_AD_Loop
	
	clrf	R_TL431_AD_Cnt
	
	movlw	C_TL431_AD_HighL
	subwf	R_TL431_AD_SumL,0
	movlw	C_TL431_AD_HighH
	subwfc	R_TL431_AD_SumH,0
	btfsc	status,c
	goto	Exit_Check_TL431
	
	movlw	C_TL431_AD_LowL
	subwf	R_TL431_AD_SumL,0
	movlw	C_TL431_AD_LowH                       
	subwfc	R_TL431_AD_SumH,0
	btfss	status,c
	goto	Exit_Check_TL431
	 
	btfss	R_Flag,B_USB_IN	
	bsf		R_SysFlag,B_TL431_Flag
                 
	movfw	R_TL431_AD_SumL
	movwf	R_VrefCurL				  	
	movfw	R_TL431_AD_SumH
	movwf	R_VrefCurH
	
	btfss	R_DischargeFlag,B_Boost_En
	goto	Exit_Check_TL431
	
	movlw	1
	addwf	R_VrefCurL,1
	movlw	0
	addwfc	R_VrefCurH,1
	
Exit_Check_TL431:
	clrf	R_TL431_AD_SumL
	clrf	R_TL431_AD_SumH                       
		
AdcCh_Cur_JUD:
	btfss	R_Flag,B_USB_IN
	goto	BoostCur

BuckCur:
	movff	R_AdcSumL,R_BuckCur_DateL
	movff	R_AdcSumH,R_BuckCur_DateH
	
	movfw	R_VrefCurL
	subwf	R_BuckCur_DateL,1
	movfw	R_VrefCurH
	subwfc	R_BuckCur_DateH,1
	btfsc	status,c
	goto	BuckCur_Fun
	clrf	R_BuckCur_DateL
	clrf	R_BuckCur_DateH
		
BuckCur_Fun:	
;--------------------------------------------
;充电电流积分处理
	movfw	R_BuckSmallCur_DateL
	subwf	R_BuckCur_DealDateL,1
	movfw	R_BuckSmallCur_DateH
	subwfc	R_BuckCur_DealDateH,1
	
	movfw	R_BuckCur_DateL
	addwf	R_BuckCur_DealDateL,1
	movfw	R_BuckCur_DateH
	addwfc	R_BuckCur_DealDateH,1
	
	movff	R_BuckCur_DealDateL,R_BuckSmallCur_DateL
	movff	R_BuckCur_DealDateH,R_BuckSmallCur_DateH
	
;--------------------------------------------
;AD数据处理：求16次平均值	
	movlf	4,R_Count
BuckCur_AD_Loop:
	bcf		status,c
	rrf		R_BuckSmallCur_DateH,1
	rrf		R_BuckSmallCur_DateL,1
	decfsz	R_Count,1
	goto	BuckCur_AD_Loop	
	
	goto	AdcCh_Cur2

BoostCur:	
	movff	R_AdcSumL,R_BoostCur_DateL
	movff	R_AdcSumH,R_BoostCur_DateH
	
	movff	R_VrefCurL,R_AdcSumL
	movff	R_VrefCurH,R_AdcSumH
	
	movfw	R_BoostCur_DateL
	subwf	R_AdcSumL,1
	movfw	R_BoostCur_DateH
	subwfc	R_AdcSumH,1
	btfsc	status,c
	goto	BoostCur_Renew
	clrf	R_AdcSumL
	clrf	R_AdcSumH

BoostCur_Renew:	
	movff	R_AdcSumL,R_BoostCur_DateL
	movff	R_AdcSumH,R_BoostCur_DateH
;--------------------------------------------
;放电电流积分处理
	movfw	R_BoostSmallCur_DateL
	subwf	R_BoostCur_DealDateL,1
	movfw	R_BoostSmallCur_DateH
	subwfc	R_BoostCur_DealDateH,1
	
	movfw	R_BoostCur_DateL
	addwf	R_BoostCur_DealDateL,1
	movfw	R_BoostCur_DateH
	addwfc	R_BoostCur_DealDateH,1
	
	movff	R_BoostCur_DealDateL,R_BoostSmallCur_DateL
	movff	R_BoostCur_DealDateH,R_BoostSmallCur_DateH
	
;--------------------------------------------
;AD数据处理：求16次平均值	
	movlf	4,R_Count
BoostCur_AD_Loop:
	bcf		status,c
	rrf		R_BoostSmallCur_DateH,1
	rrf		R_BoostSmallCur_DateL,1
	decfsz	R_Count,1
	goto	BoostCur_AD_Loop			
	
AdcCh_Cur2:	
	;movff	R_BoostCur_TestDateL,R_BoostCur_DateL
	;movff	R_BoostCur_TestDateH,R_BoostCur_DateH
	
	;movff	R_BuckCur_TestDateL,R_BuckCur_DateL
	;movff	R_BuckCur_TestDateH,R_BuckCur_DateH

	call	Charge_Deal						;充电控制
	
	movlf	C_AdcCh_BatVol,R_AdcCh
	movlf	C_Vef_20V,R_AdcVef
	bcf		pt3con,2
	bcf		pt3en,3
	bsf		pt3con,3

;	movlf	C_AdcCh_OutVol,R_AdcCh
;	movlf	C_Vef_Vdd,R_AdcVef
;	clrf	pt3con
;	bsf		pt3en,3
	goto	AdcChSwitch

;--------------------------------------------
;电池电压数据	
AdcCh_BatVol:	
	movlw	C_AdcCh_BatVol
	xorwf	R_AdcCh,0
	btfss	status,z
	goto	AdcCh_Else
/*	
	movff	R_AdcSumL,R_BatVol_DateL	
	movff	R_AdcSumH,R_BatVol_DateH
	
	btfsc	R_SysMode,B_FirstOnMode
	goto	AdcCh_Else	
*/	
;--------------------------------------------
;电池电压积分处理	
	movfw	R_BatVol_DealDate0
	iorwf	R_BatVol_DealDate1,0
	iorwf	R_BatVol_DealDate2,0
	xorlw	0
	btfss	status,z
	goto	BatVol_Deal
	
	movff	R_AdcSumL,R_BatVol_DealDate1	
	movff	R_AdcSumH,R_BatVol_DealDate2
	
BatVol_Deal:
	movfw	R_BatVol_DealDate1
	subwf	R_BatVol_DealDate0,1
	movfw	R_BatVol_DealDate2
	subwfc	R_BatVol_DealDate1,1
	movlw	0
	subwfc	R_BatVol_DealDate2,1
	
	movfw	R_AdcSumL
	addwf	R_BatVol_DealDate0,1
	movfw	R_AdcSumH
	addwfc	R_BatVol_DealDate1,1
	movlw	0
	addwfc	R_BatVol_DealDate2,1
			
	movff	R_BatVol_DealDate1,R_BatVol_DateL
	movff	R_BatVol_DealDate2,R_BatVol_DateH
	
	;movff	R_BatVol_TestDateL,R_BatVol_DateL
	;movff	R_BatVol_TestDateH,R_BatVol_DateH
	
AdcCh_Else:
	movlf	C_AdcCh_OutVol,R_AdcCh
	movlf	C_Vef_Vdd,R_AdcVef
	clrf	pt3con
	bsf		pt3en,3
	goto	AdcChSwitch

AdcChSwitch:
	movlw	00001111b
	andwf	sradcon2,1	
	movfw	R_AdcCh 
	iorwf	sradcon2,1						;通道赋值	
	movlw	11111100b
	andwf	sradcon1,1
	movfw	R_AdcVef
	iorwf	sradcon1,1						;参考电压赋值
	clrf	R_AdcCount
	
	goto	AdcDataUpdte

AdcReset:
	call	ad_init
	movlf	C_AdcCh_OutVol,R_AdcCh
	movlf	C_Vef_Vdd,R_AdcVef
	movlf	2,R_AdcErrTime
	clrf	R_AdcCount
	clrf	pt3con
	goto	AdcDataUpdte

AdcExit:
	bsf		sradcon1,srads					;启动ADC
	
	return
	