;============================================
;csu8rp30213系统初始化函数
;============================================
sys_init:
	call	mck_wdt_init					;时钟、看门狗、状态寄存器初始化
	call	io_init							;IO口初始化
	call	clrram0							;清普通数字寄存器
	call	Lcd_Init						;LCD初始化
	call	time_init						;定时器初始化
	call	ad_init							;AD初始化
	call	int_init						;中断初始化		
	return

;============================================
;时钟、看门狗、状态寄存器 初始化函数
;============================================
mck_wdt_init:
	clrf	status							;清状态寄存器
											;状态寄存器（上电复位值为：xxu00000）
											;Bit 7   	LVD36：3.6V LVD工作电压标志，只有当代码选项LVD_SEL为2'b01和2'b10有效
											;	1：系统工作电压低于3.6V，说明低电压检测器已处于监控状态
											;	0：系统工作电压超过3.6V，低电压检测器没有工作
											
											;Bit 6   	LVD24：2.4V LVD工作电压标志，只有当代码选项LVD_SEL为2'b01有效
											;	1：系统工作电压低于2.4V，说明低电压检测器已处于监控状态
											;	0：系统工作电压超过2.4V，低电压检测器没有工作
											
											;Bit 4    	PD：掉电标志位。通过对此位写0清零，sleep后置此位
											;	1：执行SLEEP指令后
											;	0：上电复位后或硬件复位或CLRWDT指令之后
											
											;Bit 3    	TO：看门狗定时溢出标志。通过对此位写0清零，看门狗定时溢出设置此位
											;	1：看门狗定时溢出发生
											;	0：上电复位后或硬件复位或CLRWDT指令后或SLEEP指令后
											
											;Bit 2     	DC：半字节进位标志/借位标志(用于借位时，极性相反)
											;	1：结果的第4位出现进位溢出
											;	0：结果的第4位不出现进位溢出
											
											;Bit 1 		C：   进位标志/借位标志(用于借位时，极性相反)
											;	1：结果的最高位（MSB）出现进位溢出
											;	0：结果的最高位（MSB）不出现进位溢出
											
											;Bit 0	  	Z：零标志
											;	1：算术或逻辑操作是结果为0
											;	0：算术或逻辑操作是结果不为0
											
	movlf	10000000b,mck		    		; 打开内部晶振、打开内部WDT晶振
											; mck：(上电复位值为：1010uuu0)
										 	; bit7(CST)：   外部晶振启动开关   
											;	1：外部晶振关闭   0：外部晶振打开
											
											; bit6(CST_IN): 内部晶振启动开关   
											;	1：内部晶振关闭   0：内部晶振打开
											
											; bit5(CST_WDT):内部WDT晶振启动开关
											;	1：内部WDT晶振关闭0：内部WDT晶振打开
											
											; bit4(EO_SLP): 外部低速晶振控制位 
											;	1：如果选择的是外部低速晶振（32768Hz），在sleep模式下不关闭外部晶振
											;	0：sleep模式下关闭外部晶振
											
											; bit0(CLKSEL):时钟源选择位(CPU时钟)
											;	1:外部晶振系统时钟
											;	0:内部晶振系统时钟
	NOP		         
	NOP
	movlf	11111111b,wdtin					; wdtin：(上电复位值为：11111111)
	movlf	10000001b,wdtcon				; 使能开门狗、1.024S溢出复位			
							 				; wdtcon:(上电复位置为：0uuuu000)	
							 				; bit7(wdten):开门狗时能位; 
							 				
							 				; bit[2-0](wdts): 当wdtin为ffh时
											;	000    		溢出时间为 2048ms
											;	001    		溢出时间为 1024ms
											;	010    		溢出时间为 512ms
											;	011    		溢出时间为 256ms
											;	100    		溢出时间为 128ms
											;	101    		溢出时间为 64ms
											;	110    		溢出时间为 32ms
											;	111    		溢出时间为 16ms
	return

;============================================
;IO口 初始化函数
;端口定义说明：
;ptx:	0:端口输出时为低电平；1：端口输出时为高电平；
;ptxen:	0:输入口；			  1：输出口；
;ptxpu:	0:内部上拉禁止；	  1：内部上拉使能；
;============================================
io_init:
	clrf	pt1
	
	movlw	11110111b
	movwf	pt1en
	
IF	K_LCD_Power	
	clrf	pt1pu  
ENDIF	

IF	K_88LED_Power
	movlw	00000010b
	movwf	pt1pu 
ENDIF

IF	K_188LED_Power
	movlw	11110011b
	movwf	pt1en
	movlw	00001010b
	movwf	pt1pu 
ENDIF	    
	  
  	movlw	00010001b  						; 设置外部中断1和外部中断0
	movwf	pt1con   						; bit 7 PT11OD：PT1.1漏极开路使能位
											; 0 = 禁止PT1.1漏极开路
											; 1 = 使能PT1.1漏极开路
											
											; bit 6 PT1W[3]:PT1.5外部中断1使能
											; 0 = 禁止PT1.5外部中断1
											; 1 = 使能PT1.5外部中断1
											
											; bit 5 PT1W[2]:PT1.4外部中断1使能
											; 0 = 禁止PT1.4外部中断1
											; 1 = 使能PT1.4外部中断1
											
											; bit 4 PT1W[1]:PT1.3外部中断1使能
											; 0 = 禁止PT1.3外部中断1
											; 1 = 使能PT1.3外部中断1
											
											; bit 3 PT1W[0]:PT1.1外部中断1使能
											; 0 = 禁止PT1.1外部中断1
											; 1 = 使能PT1.1外部中断1
											
											; bit 2 E1M：外部中断1触发模式
											; 1 = 外部中断1为下降沿触发
											; 0 = 外部中断1在状态改变时触发
											
											; bit 1:0 E0M[1:0]：外部中断0触发模式
											; 11 = 外部中断0在状态改变时触发
											; 10 = 外部中断0在状态改变时触发
											; 01 = 外部中断0为上升沿触发
											; 00 = 外部中断0为下降沿触发
	clrf	pt1con1							; bit 3 PT1W2[3]:PT3.1外部中断1使能
											; 0 = 禁止PT3.1外部中断1
											; 1 = 使能PT3.1外部中断1
											; bit 2 PT1W2[2]:PT1.7外部中断1使能
											; 0 = 禁止PT1.7外部中断1
											; 1 = 使能PT1.7外部中断1
											; bit 1 PT1W2[1]:PT1.6外部中断1使能
											; 0 = 禁止PT1.6外部中断1
											; 1 = 使能PT1.6外部中断1
											; bit 0 PT1W2[0]:PT1.2外部中断1使能
											; 0 = 禁止PT1.2外部中断1
											; 1 = 使能PT1.2外部中断1
	movlw	10100001b
	movwf	pt3
	
	movlw	11111011b
	movwf	pt3en
	
	clrf	pt3pu  	  
					
	clrf	pt3con  						;0 = 定义为数字口，1 = 定义为模拟口
    
    
    								
	clrf	pt5
	
	movlw	11111111b
	movwf	pt5en
	
	clrf	pt5pu  	  
											; bit 2 控制标志位；0 = 禁止开漏输出，1 = 使能开漏输出
	clrf	pt5con 							; bit 1 控制标志位；0 = 禁止开漏输出，1 = 使能开漏输出
											; bit 0 控制标志位；0 = 定义为数字口，1 = 定义为模拟口
	return  		
		
;============================================
; 清普通数字寄存器
; 80H----电量等级显示最终值----该SRAM单元不清; 
;============================================
clrram0:									;clr ram 89h-FFh      清普通数字寄存器
	movlw	89h
	movwf	fsr0	        				;以FSR0 中的值作为地址去访问数据存储器得到数据			 	     	
clrram0_loop:	
	clrf	ind0					
	incfsz	fsr0,1 
	goto	clrram0_loop 
	return
	
;============================================
; LCD初始化
;============================================	
Lcd_Init:
If	K_LCD_Power
	movlw	10001111b						; 上电默认值：0uuu0000
	movwf	lcdcom

											; bit 7	VLCD_SEL	VLCD电压选择
											; 0：VLCD电压为VDD
											; 1：VLCD电压为3V
											
											; bit 3	COM[3]	COM3口控制标志位
											; 0 = PT1.7不做COM3口
											; 1 = PT1.7做COM3口
											
											; bit 2	COM[2]	COM2口控制标志位
											; 0 = PT1.6不做COM2口
											; 1 = PT1.6做COM2口
											
											; bit 1	COM[1]	COM1口控制标志位
											; 0 = PT1.5不做COM1口
											; 1 = PT1.5做COM1口
											
											; bit 0	COM[0]	COM0口控制标志位
											; 0 = PT1.4不做COM0口
											; 1 = PT1.4做COM0口
	
	movlw	00011111b						; 上电默认值：uuu00000
	movwf	lcdseg							; bit 4	SEG[4]	SEG4口控制标志位
											; 0 = PT5.2不做SEG4口
											; 1 = PT5.2做SEG4口
											
											; bit 3	SEG [3]	SEG3口控制标志位
											; 0 = PT5.1不做SEG3口
											; 1 = PT5.1做SEG3口
											
											; bit 2	SEG [2]	SEG2口控制标志位
											; 0 = PT5.0不做SEG2口
											; 1 = PT5.0做SEG2口
											
											; bit 1	SEG [1]	SEG1口控制标志位
											; 0 = PT1.2不做SEG1口
											; 1 = PT1.2做SEG1口
											
											; bit 0	SEG [0]	SEG0口控制标志位
											; 0 = PT1.1不做SEG0口
											; 1 = PT1.1做SEG0口
Endif

If	K_88LED_Power
	clrf	lcdcom
	clrf	lcdseg
Endif

If	K_188LED_Power
	clrf	lcdcom
	clrf	lcdseg
Endif

	return
	
;============================================
; 定时器初始化
;============================================
time_init:
	movlw	11010000b 						; 上电默认值：0000u100
	movwf	tm0con
										    ; T0EN  T0RATE[2:0]   /   T0RSTB  T0SEL[1:0]  T0RATE=CPU/32=4M/32=125K
										    ;												周期=8us							
										    ; bit 7  T0EN  定时器0使能位
										    ; 1：使能定时器0
										    ; 0：禁止定时器0
										 
										    ; bit 6:4 T0RATE[2:0]  定时器0时钟选择
				             			    ; T0RATE [2:0]     TM0CLK
										    ;	000		         CKT0
										    ;   001				 CKT0/2
										    ; 	010				 CKT0/4
										    ; 	011				 CKT0/8
										    ; 	100				 CKT0/16
										    ; 	101				 CKT0/32
										    ; 	110				 CKT0/64
									 	    ; 	111				 CKT0/128
									 	    
										    ; bit 2 T0RSTB 定时器0复位
										    ; 1：禁止定时器0复位
										    ; 0：使能定时器0复位，当将该位为0时，定时器0复位后，T0RSTB会自动置1
										 
										    ; bit 1:0 T0SEL[1:0] 时钟源选择
										    ; T0SEL[1:0]		定时器0时钟源
										    ; 00                  CPUCLK
										    ; 01				  MCK
										    ; 10				  外部32768Hz晶振时钟，仅当外部接32768Hz晶振，且晶振打开时有效
										    ; 11				  内部32K WDT时钟，仅当内部WDT晶振打开时有效
	
	movlw	124								;TM0溢出时间 8us*(124+1)=1.000ms
	movwf	tm0in  
	 
;--------------------------------------------
;定时/计数器2初始化 
	movlw	00000100b						; (上电默认值：00000100)
	movwf	tm2con
											; bit 7 T2EN 定时/计数器2使能位
											; 1：使能定时器2
											; 0：禁止定时器2
											
											; bit 6:4 T2RATE[2:0] 定时/计数器2时钟选择
											; 定时/计数器2时钟分频选择选择(时钟源选择见TMCON2寄存器的T2SEL位)
											;	T2RATE [2:0]	TM2CLK
											;	000				CKT2
											;	001				CKT2/2
											;	010				CKT2/4
											;	011				CKT2/8
											;	100				CKT2/16
											;	101				CKT2/32
											;	110				CKT2/64
											;	111				CKT2/128

											; bit 3 T2CKS 定时/计数器2时钟源选择位
											; 1：PT3.0作为时钟
											; 0：CKT2的分频时钟
											
											; bit 2 T2RSTB 定时/计数器2复位
											; 1：禁止定时/计数器2复位
											; 0：使能定时/计数器2复位，当将该位为0时，定时器2复位后，T2RSTB会自动置1
											
											; bit 1:0  T2OUT PWM2OUT 	PT1.4口输出控制
											;			0	 	0	 	IO输出
											;		 	0		1		蜂鸣器输出
											;			1		0		PWM2输出
											;			1		1		PWM2输出

;--------------------------------------------
;定时/计数器4初始化 
	movlw	00000100b						; (上电默认值：00000100)
	movwf	tm4con
											; bit 7 T4EN 定时/计数器4使能位
											; 1：使能定时器4
											; 0：禁止定时器4
											
											; bit 6:4 T4RATE[2:0] 定时/计数器4时钟选择
											; 定时/计数器4时钟分频选择选择(时钟源选择见TMCON2寄存器的T4SEL位)
											;	T4RATE [2:0]	TM4CLK
											;	000				CKT4
											;	001				CKT4/2
											;	010				CKT4/4
											;	011				CKT4/8
											;	100				CKT4/16
											;	101				CKT4/32
											;	110				CKT4/64
											;	111				CKT4/128

											; bit 3 T4CKS 定时/计数器4时钟源选择位
											; 1：PT1.4作为时钟
											; 0：CKT4的分频时钟
											
											; bit 2 T4RSTB 定时/计数器4复位
											; 1：禁止定时/计数器4复位
											; 0：使能定时/计数器4复位，当将该位为0时，定时器4复位后，T4RSTB会自动置1
											
											; bit 1:0  T4OUT PWM4OUT 	PT1.6口输出控制
											;			0	 	0	 	IO输出
											;		 	0		1		蜂鸣器输出
											;			1		0		PWM4输出
											;			1		1		PWM4输出
	
;--------------------------------------------
;定时/计数器3初始化 
pwm_init:
	;movlw	10000011b						; (上电默认值：00000100)
	;movwf	tm3con
	
	movlw	00000100b						; (上电默认值：00000100)
	movwf	tm3con
											; bit 7 T3EN 定时/计数器3使能位
											; 1：使能定时器3
											; 0：禁止定时器3
											
											; bit 6:4 T3RATE[2:0] 定时/计数器3时钟选择
											; 定时/计数器3时钟分频选择选择(时钟源选择见TMCON2寄存器的T3SEL位)
											;	T3RATE [2:0]	TM3CLK
											;	000				CKT3
											;	001				CKT3/2
											;	010				CKT3/4
											;	011				CKT3/8
											;	100				CKT3/16
											;	101				CKT3/32
											;	110				CKT3/64
											;	111				CKT3/128

											; bit 3 T3CKS 定时/计数器3时钟源选择位
											; 1：PT3.1作为时钟
											; 0：CKT3的分频时钟
											
											; bit 2 T3RSTB 定时/计数器3复位
											; 1：禁止定时/计数器3复位
											; 0：使能定时/计数器3复位，当将该位为0时，定时器3复位后，T3RSTB会自动置1
											
											; bit 1:0  T3OUT PWM3OUT 	PT1.5口输出控制(仅当PT1.5配置为输出有效)
											;			0	 	0	 	IO输出
											;		 	0		1		蜂鸣器输出
											;			1		0		PWM3输出
											;			1		1		PWM3输出
	
	movlw	ffh								;PWM周期：1/((1/16M)*80)=200K
	movwf	tm3in
	clrf	tm3inh
	
	movlw	0								;PWM高电平：0
	movwf	tm3r
	clrf	tm3rh
	
	;movlw	00100111b						; (上电默认值：00000000)
	;movwf	tm3con2	
	
											; (上电默认值：00000000)
	clrf	tm3con2							; bit 7:6	DT3CK[1:0]	定时器3死区时间时钟选择
											; DT3CK[1:0]	DT3_CLK
											; 00	MCK
											; 01	MCK/2
											; 10	MCK/4
											; 11	MCK/8
											
											; bit 5:3	DT3CNT[2:0]	死区时间选择
											; 死区时间=DT3CNT[2:0]*DT3_CLK
											
											; bit 2	DT3_EN	死区发生器3使能位
											; 0：不使能死区发生器3
											; 1：使能死区发生器3
											
											; bit 1	P3H_OEN	互补PWM3H输出使能
											; 0：PWM3H不输出
											; 1：PWM3H从PT3.6输出
											
											; bit 0	P3L_OEN	互补PWM3L输出使能
											; 0：PWM3L不输出
											; 1：PWM3L从PT3.5输出
	
	movlw	00000010b						; (上电默认值：00uuu000)
	movwf	tmcon							; bit 7	P3HINV	互补PWM3H取反控制位
											; 0：PWM3H不取反
											; 1：PWM3H取反输出
											
											; bit 6	P3LINV	互补PWM3L取反控制位
											; 0：PWM3L不取反
											; 1：PWM3L取反输出
											
											; bit 2	PWM4PO	PWM4输出脚选择
											; 0：PT1.6做为PWM4输出口
											; 1：PT3.6做为PWM4输出口
											
											; bit 1	PWM3PO	PWM3输出脚选择
											; 0：PT1.5做为PWM3输出口
											; 1：PT3.5做为PWM3输出口
											
											; bit 0	PWM2PO	PWM2输出脚选择
											; 0：PT1.4做为PWM2输出口
											; 1：PT5.0做为PWM2输出口

											
	movlw	00000100b						; (上电默认值：uu000000)
	movwf	tmcon2					
											; bit 5：4	T4SEL[1:0]	定时器4时钟源选择
											; T4SEL[1:0]	定时器4时钟源
											; 00	CPUCLK
											; 01	MCK
											; 1x	外部晶振时钟ECK，(仅当外部接外部晶振，且晶振打开时有效)

											; bit 3：2	T3SEL[1:0]	定时器3时钟源选择
											; T3SEL[1:0]	定时器3时钟源
											; 00	CPUCLK
											; 01	MCK
											; 1x	外部晶振时钟ECK，(仅当外部接外部晶振，且晶振打开时有效)
											
											; bit 1：0	T2SEL[1:0]	定时器2时钟源选择
											; T2SEL[1:0]	定时器2时钟源(CKT2)
											; 00	CPUCLK
											; 01	MCK
											; 1x	外部晶振时钟ECK，(仅当外部接外部晶振，且晶振打开时有效)

	return
	
;============================================
; ADC初始化
;============================================
ad_init:
	movlw	00000011b						;ADC CLOCK = CPUCLK/8=4M/2=500K    转换所需时间约56us 
	movwf	sradcon0						;bit 7	QDIF	SAR_ADC准差分输入使能位
											;	0：禁止SAR_ADC准差分输入
											;	1：使能SAR_ADC准差分输入
											;	使能SAR_ADC准差分输入后，PT3.2口接输入信号的地端，其他模拟输入口接输入信号，这样可以抵消SAR_ADC的系统失调电压。
											;bit 5：4	SRADACKS[1:0]	ADC输入信号获取时间
											;	SRADACKS[1:0]	ADC输入信号获取时间
											;	00	16个ADC时钟
											;	01	8个ADC时钟
											;	10	4个ADC时钟
											;	11	2个ADC时钟
												
											;bit 1：0	SRADCKS[1:0]	ADC时钟
											;	SRADCKS[1:0]	ADC采样时钟
											;	00	CPUCLK
											;	01	CPUCLK/2
											;	10	CPUCLK/4
											;	11	CPUCLK/8
	
	movlw	10000000b						;结果放在SRAD中
 	movwf	sradcon1						;B[1:0]10 内部2.0V作参考					  
											; bit 7 SRADEN ADC使能位
											; 1：使能, 0：禁止
											
											; bit 6 SRADS ADC启动位/状态控制位
											; 1：开始，转换过程中, 0：停止，转换结束
											; 当置位后，启动ADC转换，转换完成会自动清0
											
											; bit 5 OFTEN 转换结果选择控制位
											; 1：转换结果放在SROFT寄存器中
											; 0：转换结果放在SRAD寄存器中
											
											; bit 4 CALIF 校正控制位(OFTEN为0时有效)
											; 1：使能校正，即AD转换的结果是减去了SROFT失调电压值
											; 0：禁止校正，即AD转换结果是没有减去SROFT失调电压值
											
											; bit 3 ENOV 使能比较器溢出模式(CALIF为1时有效)
											; 1：使能，上溢或下溢直接是减去后的结果
											; 0：禁止，下溢为000h，上溢为fffh
											
											; bit 2 OFFEX OFFSET交换
											; 1：比较器两端信号交换
											; 0：比较器两端信号不交换（正端为信号，负端为参考电压）
											
											; bit 1:0 VREFS[1:0] ADC参考电源选择 
											; (注：不同参考电压切换，建议延迟10uS再做AD转换)
											; VREFS[1:0]		AD参考电压
											; 00				VDD
											; 01				PT3.0外部参考电源输入
											; 10				内部参考电压（参考电压的设置为METCH寄存器中）
											; 11				内部参考电压，PT3.0可外接电容作为内置参考电压滤波使用，以提高精度。
	
if	K_Vef_Vol	
	movlw	10100000b						;内部参考电压1.4V
else
	movlw	10100001b						;内部参考电压2.0V
endif							
	movwf	sradcon2						;内部参考电压2.0V
											;bit 7：4	CHS[3:0]	ADC输入通道选择位
											;	0000	AIN0输入
											;	0001	AIN1输入
											;	0010	AIN2输入
											;	0011	AIN3输入
											;	0100	AIN4输入
											;	0101	AIN5输入
											;	0110	AIN6输入
											;	0111	AIN7输入
											;	1000	AIN8输入
											;	1001	AIN9输入，内部1/8VDD
											;	1010	AIN10输入，内部参考电压
											;	1011	AIN11输入，内部接地
											;	其它	内短
												
											;bit 1：0	REF_SEL[1:0]	VREFS[1:0]配置为2'b10或2'b11，则可通过REF_SEL [1:0]选择参考如下电压，若VREFS[1:0]不是配置为2'b10或2'b11，则以下位无效。
											;	REF_SEL [1:0]	内部参考电压
											;	00	1.4V
											;	01	2.0V
											;	10	3.0V
											;	11	4.0V
	
	movlw	10000000b
	movwf	syscfg0  

If	K_LCD_Power											
	movlw	10110000b
	movwf	syscfg1  
ENDIF

If	K_88LED_Power											
	movlw	11110000b
	movwf	syscfg1  
ENDIF

If	K_188LED_Power											
	movlw	00110000b
	movwf	syscfg1  
ENDIF
	
	movlw	11000000b
	movwf	curcon
	
	return		
;============================================
; 中断初始化
;============================================
int_init:	
    clrf	intf      						; 清所有中断标志	                                                  
	clrf	intf2 
	clrf	intf3        	                
	movlf	10010010B,inte   				; 开启总中断使能、TM0中断使能、外部中断不使能 
											; B7    B6     B5   B4     B3      B2   B1    B0
						         	     	; GIE   TM2IE  /    TM0IE  SRADIE  /    E1IE  E0IE
	clrf    inte2  	    					
	clrf	inte3 
;	movlf	10010000B,inte      	 
	return		
	  