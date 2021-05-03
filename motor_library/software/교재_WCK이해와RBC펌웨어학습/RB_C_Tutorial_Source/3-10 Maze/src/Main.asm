
;CodeVisionAVR C Compiler V1.24.8d Professional
;(C) Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 14.745600 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "main.vec"
	.INCLUDE "main.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x1000)
	LDI  R25,HIGH(0x1000)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

	OUT  RAMPZ,R24

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x10FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x10FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x500)
	LDI  R29,HIGH(0x500)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500
;       1 //==============================================================================
;       2 //	 RoboBuilder MainController
;       3 //==============================================================================
;       4 #include <mega128.h>
;       5 #include <stdio.h>
;       6 #include <delay.h>
;       7 
;       8 #include "Macro.h"
;       9 #include "Main.h"
;      10 #include "Comm.h"
;      11 #include "Dio.h"
;      12 #include "Adc.h"
;      13 #include "math.h"
;      14 #include "accel.h"
;      15 
;      16 BYTE	F_PF;
;      17 BYTE	F_ERR_CODE;
;      18 bit 	F_SCENE_PLAYING;
;      19 bit 	F_ACTION_PLAYING;
;      20 bit 	F_DIRECT_C_EN;
;      21 bit 	F_MOTION_STOPPED;
;      22 bit     F_DOWNLOAD;
;      23 bit 	F_PS_PLUGGED;
;      24 bit 	F_CHARGING;
;      25 bit     F_AD_CONVERTING;
;      26 bit     F_MIC_INPUT;
;      27 bit     F_PF_CHANGED;
;      28 bit     F_IR_RECEIVED;
;      29 bit     F_FIRST_M;
;      30 bit		F_RSV_MOTION;
;      31 bit		F_RSV_SOUND_READ;
;      32 bit		F_RSV_BTN_READ;
;      33 bit		F_RSV_PSD_READ;
;      34 BYTE	F_EEPROM_BUSY;
;      35 
;      36 char	gTx0Buf[TX0_BUF_SIZE];
_gTx0Buf:
	.BYTE 0xBA
;      37 BYTE	gTx0Cnt;
_gTx0Cnt:
	.BYTE 0x1
;      38 BYTE	gRx0Cnt;
_gRx0Cnt:
	.BYTE 0x1
;      39 BYTE	gTx0BufIdx;
_gTx0BufIdx:
	.BYTE 0x1
;      40 char	gRx0Buf[RX0_BUF_SIZE];
_gRx0Buf:
	.BYTE 0x8
;      41 char	gRx1Buf[RX1_BUF_SIZE];
_gRx1Buf:
	.BYTE 0x14
;      42 WORD	gRx1Step;
_gRx1Step:
	.BYTE 0x2
;      43 WORD	gRx1_DStep;
_gRx1_DStep:
	.BYTE 0x2
;      44 WORD	gFieldIdx;
_gFieldIdx:
	.BYTE 0x2
;      45 BYTE	gFileCheckSum;
_gFileCheckSum:
	.BYTE 0x1
;      46 BYTE	gRxData;
_gRxData:
	.BYTE 0x1
;      47 
;      48 WORD	gPF1BtnCnt;
_gPF1BtnCnt:
	.BYTE 0x2
;      49 WORD	gPF2BtnCnt;
_gPF2BtnCnt:
	.BYTE 0x2
;      50 WORD	gPF12BtnCnt;
_gPF12BtnCnt:
	.BYTE 0x2
;      51 BYTE	gBtn_val;
_gBtn_val:
	.BYTE 0x1
;      52 
;      53 WORD    g10MSEC;
_g10MSEC:
	.BYTE 0x2
;      54 BYTE    gSEC;
_gSEC:
	.BYTE 0x1
;      55 BYTE    gMIN;
_gMIN:
	.BYTE 0x1
;      56 BYTE    gHOUR;
_gHOUR:
	.BYTE 0x1
;      57 WORD	gSEC_DCOUNT;
_gSEC_DCOUNT:
	.BYTE 0x2
;      58 WORD	gMIN_DCOUNT;
_gMIN_DCOUNT:
	.BYTE 0x2
;      59 
;      60 WORD    gPSplugCount;
_gPSplugCount:
	.BYTE 0x2
;      61 WORD    gPSunplugCount;
_gPSunplugCount:
	.BYTE 0x2
;      62 WORD	gPwrLowCount;
_gPwrLowCount:
	.BYTE 0x2
;      63 
;      64 char	gIrBuf[IR_BUFFER_SIZE];
_gIrBuf:
	.BYTE 0x4
;      65 BYTE	gIrBitIndex = 0;
_gIrBitIndex:
	.BYTE 0x1
;      66 
;      67 signed char	gAccX;
_gAccX:
	.BYTE 0x1
;      68 signed char	gAccY;
_gAccY:
	.BYTE 0x1
;      69 signed char	gAccZ;
_gAccZ:
	.BYTE 0x1
;      70 
;      71 BYTE	gSoundMinTh;
_gSoundMinTh:
	.BYTE 0x1
;      72 
;      73 int		gFrameIdx = 0;
_gFrameIdx:
	.BYTE 0x2
;      74 WORD	TxInterval = 0;
_TxInterval:
	.BYTE 0x2
;      75 float	gUnitD[MAX_wCK];
_gUnitD:
	.BYTE 0x7C
;      76 BYTE	gLastID;
_gLastID:
	.BYTE 0x1
;      77 BYTE flash	*gpT_Table;
_gpT_Table:
	.BYTE 0x2
;      78 BYTE flash	*gpE_Table;
_gpE_Table:
	.BYTE 0x2
;      79 BYTE flash	*gpPg_Table;
_gpPg_Table:
	.BYTE 0x2
;      80 BYTE flash	*gpDg_Table;
_gpDg_Table:
	.BYTE 0x2
;      81 BYTE flash	*gpIg_Table;
_gpIg_Table:
	.BYTE 0x2
;      82 WORD flash	*gpFN_Table;
_gpFN_Table:
	.BYTE 0x2
;      83 WORD flash	*gpRT_Table;
_gpRT_Table:
	.BYTE 0x2
;      84 BYTE flash	*gpPos_Table;
_gpPos_Table:
	.BYTE 0x2
;      85 
;      86 
;      87 BYTE flash	StandardZeroPos[16]={

	.CSEG
;      88 /* ID
;      89   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
;      90 125,202,162, 66,108,124, 48, 88,184,142, 90, 40,125,161,210,127};
;      91 
;      92 BYTE flash	U_Boundary_Huno[16]={
;      93 /* ID
;      94   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
;      95 174,228,254,130,185,254,180,126,208,208,254,224,198,254,228,254};
;      96 
;      97 BYTE flash	L_Boundary_Huno[16]={
;      98 /* ID
;      99   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
;     100   1, 70,124, 40, 41, 73, 22,  1,120, 57,  1, 23,  1,  1, 25, 40};
;     101 
;     102 BYTE flash	U_Boundary_Dino[16]={
;     103 /* ID
;     104   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
;     105 174,228,254,130,185,254,185,126,208,230,254,254,205,254,254,254};
;     106 
;     107 BYTE flash	L_Boundary_Dino[16]={
;     108 /* ID
;     109   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
;     110   1, 75,124, 40, 41, 73, 22,  1,120, 45,  1,  1, 25,  1, 45, 45};
;     111 
;     112 BYTE flash	U_Boundary_Dogy[16]={
;     113 /* ID
;     114   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
;     115 254,225,225,210,254,254,225,185,203,205,254,230,205,254,230,254};
;     116 
;     117 BYTE flash	L_Boundary_Dogy[16]={
;     118 /* ID
;     119   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
;     120   1, 25, 25, 25, 45,  1, 25, 82,  5,  1,  1, 20,  1,  1, 17, 40};
;     121 
;     122 struct TwCK_in_Motion{
;     123 	BYTE	Exist;
;     124 	BYTE	RPgain;
;     125 	BYTE	RDgain;
;     126 	BYTE	RIgain;
;     127 	BYTE	PortEn;
;     128 	BYTE	InitPos;
;     129 };
;     130 
;     131 struct TwCK_in_Scene{
;     132 	BYTE	Exist;
;     133 	BYTE	SPos;
;     134 	BYTE	DPos;
;     135 	BYTE	Torq;
;     136 	BYTE	ExPortD;
;     137 };
;     138 
;     139 struct TMotion{
;     140 	BYTE	RIdx;
;     141 	DWORD	AIdx;
;     142 	BYTE	PF;
;     143 	WORD	NumOfScene;
;     144 	WORD	NumOfwCK;
;     145 	struct	TwCK_in_Motion  wCK[MAX_wCK];
;     146 	WORD	FileSize;
;     147 }Motion;

	.DSEG
_Motion:
	.BYTE 0xC6
;     148 
;     149 struct TScene{
;     150 	WORD	Idx;
;     151 	WORD	NumOfFrame;
;     152 	WORD	RTime;
;     153 	struct	TwCK_in_Scene   wCK[MAX_wCK];
;     154 }Scene;
_Scene:
	.BYTE 0xA1
;     155 
;     156 WORD	gScIdx;
_gScIdx:
	.BYTE 0x2
;     157 
;     158 eeprom  char    eData[13];

	.ESEG
_eData:
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
;     159 eeprom	BYTE	eRCodeH[NUM_OF_REMOCON];
_eRCodeH:
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
;     160 eeprom	BYTE	eRCodeM[NUM_OF_REMOCON];
_eRCodeM:
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
;     161 eeprom	BYTE	eRCodeL[NUM_OF_REMOCON];
_eRCodeL:
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
;     162 eeprom	BYTE	eM_OriginPose[NUM_OF_WCK_HUNO]={
_eM_OriginPose:
;     163 /* ID
;     164   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
;     165 124,202,162, 65,108,125, 46, 88,184,142, 90, 40,125,161,210,126};
	.DB  0x7C
	.DB  0xCA
	.DB  0xA2
	.DB  0x41
	.DB  0x6C
	.DB  0x7D
	.DB  0x2E
	.DB  0x58
	.DB  0xB8
	.DB  0x8E
	.DB  0x5A
	.DB  0x28
	.DB  0x7D
	.DB  0xA1
	.DB  0xD2
	.DB  0x7E
;     166 
;     167 int		gPoseDelta[31];

	.DSEG
_gPoseDelta:
	.BYTE 0x3E
;     168 eeprom	BYTE	ePF = 1;

	.ESEG
_ePF:
	.DB  0x1
;     169 
;     170 eeprom  BYTE    eNumOfM = 0;
_eNumOfM:
	.DB  0x0
;     171 eeprom  BYTE    eNumOfA = 0;
_eNumOfA:
	.DB  0x0
;     172 eeprom  WORD    eM_Addr[20];
_eM_Addr:
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
;     173 eeprom  WORD    eM_FSize[20];
_eM_FSize:
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
;     174 eeprom  WORD    eA_Addr[10];
_eA_Addr:
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
;     175 eeprom  WORD    eA_FSize[10];
_eA_FSize:
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
;     176 
;     177 BYTE    gDownNumOfM;

	.DSEG
_gDownNumOfM:
	.BYTE 0x1
;     178 BYTE    gDownNumOfA;
_gDownNumOfA:
	.BYTE 0x1
;     179 
;     180 WORD Sound_Length[25]={
_Sound_Length:
;     181 2268,1001,832,365,838,417,5671,5916,780,2907,552,522,1525,2494,438,402,433,461,343,472,354,461,458,442,371};
	.BYTE 0x32
;     182 
;     183 
;     184 int Round(float num,int precision)
;     185 {

	.CSEG
_Round:
;     186 	float tempNum;
;     187 	tempNum = num;
	SBIW R28,4
;	num -> Y+6
;	precision -> Y+4
;	tempNum -> Y+0
	__GETD1S 6
	CALL SUBOPT_0x0
;     188 	if(tempNum - floor(tempNum) >= 0.5)
	CALL SUBOPT_0x1
	CALL _floor
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL __CMPF12
	BRLO _0x4
;     189 		return (int)( ceil(tempNum)  );
	CALL SUBOPT_0x1
	CALL _ceil
	CALL __CFD1
	RJMP _0x331
;     190 	else return (int)(floor(tempNum));
_0x4:
	CALL SUBOPT_0x1
	CALL _floor
	CALL __CFD1
;     191 }
_0x331:
	ADIW R28,10
	RET
;     192 
;     193 
;     194 void U1I_case100(void)
;     195 {
_U1I_case100:
;     196 	Motion.PF = gRxData;
	LDS  R30,_gRxData
	__PUTB1MN _Motion,5
;     197 	gFieldIdx = 0;
	LDI  R30,0
	STS  _gFieldIdx,R30
	STS  _gFieldIdx+1,R30
;     198 	gRx1Step++;
	CALL SUBOPT_0x4
;     199 }
	RET
;     200 
;     201 
;     202 void U1I_case301(BYTE LC)
;     203 {
_U1I_case301:
;     204 	gFieldIdx++;
;	LC -> Y+0
	CALL SUBOPT_0x5
;     205 	if(gFieldIdx == 4){
	LDS  R26,_gFieldIdx
	LDS  R27,_gFieldIdx+1
	SBIW R26,4
	BRNE _0x6
;     206 		gFieldIdx = 0;
	LDI  R30,0
	STS  _gFieldIdx,R30
	STS  _gFieldIdx+1,R30
;     207 		gFileCheckSum = 0;
	LDI  R30,LOW(0)
	STS  _gFileCheckSum,R30
;     208 		if(gRxData == LC)	
	LD   R30,Y
	LDS  R26,_gRxData
	CP   R30,R26
	BRNE _0x7
;     209 			gRx1Step++;
	CALL SUBOPT_0x4
;     210 		else{
	RJMP _0x8
_0x7:
;     211 			gRx1Step = 0;
	CALL SUBOPT_0x6
;     212 			F_DOWNLOAD = 0;
;     213 			RUN_LED2_OFF;
;     214 		}
_0x8:
;     215 	}
;     216 }
_0x6:
	RJMP _0x330
;     217 
;     218 
;     219 void U1I_case302(void)
;     220 {
_U1I_case302:
;     221 	gFileCheckSum ^= gRxData;
	CALL SUBOPT_0x7
;     222 	if(gRxData == 1)
	LDS  R26,_gRxData
	CPI  R26,LOW(0x1)
	BRNE _0x9
;     223 		gRx1Step++;
	CALL SUBOPT_0x4
;     224 	else{
	RJMP _0xA
_0x9:
;     225 		gRx1Step = 0;
	CALL SUBOPT_0x6
;     226 		F_DOWNLOAD = 0;
;     227 		RUN_LED2_OFF;
;     228 	}
_0xA:
;     229 }
	RET
;     230 
;     231 
;     232 void U1I_case303(void)
;     233 {
_U1I_case303:
;     234 	int		i;
;     235 	if(gRxData == 1){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDS  R26,_gRxData
	CPI  R26,LOW(0x1)
	BRNE _0xB
;     236 		SendToPC(11,16);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x8
;     237 		gFileCheckSum = 0;
;     238 		for(i = 0; i < 16; i++){
_0xD:
	__CPWRN 16,17,16
	BRGE _0xE
;     239 			sciTx1Data(eM_OriginPose[i]);
	CALL SUBOPT_0x9
	ST   -Y,R30
	CALL _sciTx1Data
;     240 			gFileCheckSum ^= eM_OriginPose[i];
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
;     241 		}
	__ADDWRN 16,17,1
	RJMP _0xD
_0xE:
;     242 		sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     243 	}
;     244 	gRx1Step = 0;
_0xB:
	CALL SUBOPT_0x6
;     245 	F_DOWNLOAD = 0;
;     246 	RUN_LED2_OFF;
;     247 }
	RJMP _0x32F
;     248 
;     249 
;     250 void U1I_case502(BYTE LC)
;     251 {
_U1I_case502:
;     252 	gFileCheckSum ^= gRxData;
;	LC -> Y+0
	CALL SUBOPT_0x7
;     253 	gFieldIdx++;
	CALL SUBOPT_0x5
;     254 	if(gFieldIdx == LC){
	LD   R30,Y
	LDS  R26,_gFieldIdx
	LDS  R27,_gFieldIdx+1
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0xF
;     255 		gRx1Step++;
	CALL SUBOPT_0x4
	SBIW R30,1
;     256 	}
;     257 }
_0xF:
_0x330:
	ADIW R28,1
	RET
;     258 
;     259 
;     260 void U1I_case603(void)
;     261 {
_U1I_case603:
;     262 	int		i;
;     263 
;     264 	if(gFileCheckSum == gRxData){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CALL SUBOPT_0xC
	BREQ PC+3
	JMP _0x10
;     265 		F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;     266 		for(i = 0; i < 16; i++){
	__GETWRN 16,17,0
_0x12:
	__CPWRN 16,17,16
	BRGE _0x13
;     267 			if((StandardZeroPos[i]+15) < gRx1Buf[RX1_BUF_SIZE-17+i]
;     268 			 ||(StandardZeroPos[i]-15) > gRx1Buf[RX1_BUF_SIZE-17+i]){
	CALL SUBOPT_0xD
	SUBI R30,-LOW(15)
	CALL SUBOPT_0xE
	CP   R26,R30
	BRLO _0x15
	CALL SUBOPT_0xD
	SUBI R30,LOW(15)
	CALL SUBOPT_0xE
	CP   R30,R26
	BRSH _0x14
_0x15:
;     269 				F_ERR_CODE = ZERO_SET_ERR;
	LDI  R30,LOW(7)
	MOV  R13,R30
;     270 				break;
	RJMP _0x13
;     271 			}
;     272 		}
_0x14:
	__ADDWRN 16,17,1
	RJMP _0x12
_0x13:
;     273 		if(F_ERR_CODE == NO_ERR){
	LDI  R30,LOW(255)
	CP   R30,R13
	BRNE _0x17
;     274 			for(i = 0; i < 16; i++)
	__GETWRN 16,17,0
_0x19:
	__CPWRN 16,17,16
	BRGE _0x1A
;     275 				eM_OriginPose[i] = gRx1Buf[RX1_BUF_SIZE-17+i];
	MOVW R26,R16
	SUBI R26,LOW(-_eM_OriginPose)
	SBCI R27,HIGH(-_eM_OriginPose)
	MOVW R30,R16
	__ADDW1MN _gRx1Buf,3
	LD   R30,Z
	CALL __EEPROMWRB
;     276 
;     277 			SendToPC(14,16);
	__ADDWRN 16,17,1
	RJMP _0x19
_0x1A:
	LDI  R30,LOW(14)
	CALL SUBOPT_0x8
;     278 			gFileCheckSum = 0;
;     279 			for(i = 0; i < 16; i++){
_0x1C:
	__CPWRN 16,17,16
	BRGE _0x1D
;     280 				sciTx1Data(eM_OriginPose[i]);
	CALL SUBOPT_0x9
	ST   -Y,R30
	CALL _sciTx1Data
;     281 				gFileCheckSum ^= eM_OriginPose[i];
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
;     282 			}
	__ADDWRN 16,17,1
	RJMP _0x1C
_0x1D:
;     283 			sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     284 		}
;     285 	}
_0x17:
;     286 	gRx1Step = 0;
_0x10:
	CALL SUBOPT_0x6
;     287 	F_DOWNLOAD = 0;
;     288 	RUN_LED2_OFF;
;     289 }
_0x32F:
	LD   R16,Y+
	LD   R17,Y+
	RET
;     290 
;     291 
;     292 void U1I_case703(void)
;     293 {
_U1I_case703:
;     294 	WORD    lwtmp;
;     295 	BYTE	lbtmp;
;     296 
;     297 	if(gFileCheckSum == gRxData){
	CALL __SAVELOCR3
;	lwtmp -> R16,R17
;	lbtmp -> R18
	CALL SUBOPT_0xC
	BREQ PC+3
	JMP _0x1E
;     298 		if(gDownNumOfM == 0){
	LDS  R30,_gDownNumOfM
	CPI  R30,0
	BRNE _0x1F
;     299 			if(gRx1Buf[RX1_BUF_SIZE-2] == 1)
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x1)
	BRNE _0x20
;     300 				lwtmp = 0x6000;
	__GETWRN 16,17,24576
;     301 			else if(gRx1Buf[RX1_BUF_SIZE-2] == 2)
	RJMP _0x21
_0x20:
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x2)
	BRNE _0x22
;     302 				lwtmp = 0x2000;
	__GETWRN 16,17,8192
;     303 		}
_0x22:
_0x21:
;     304 		else{
	RJMP _0x23
_0x1F:
;     305 			if(gRx1Buf[RX1_BUF_SIZE-2] == 1){
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x1)
	BRNE _0x24
;     306 				lwtmp = eM_Addr[gDownNumOfM-1] + eM_FSize[gDownNumOfM-1];
	LDS  R30,_gDownNumOfM
	SUBI R30,LOW(1)
	MOV  R22,R30
	LDI  R26,LOW(_eM_Addr)
	LDI  R27,HIGH(_eM_Addr)
	CALL SUBOPT_0xF
	MOVW R0,R30
	MOV  R30,R22
	LDI  R26,LOW(_eM_FSize)
	LDI  R27,HIGH(_eM_FSize)
	CALL SUBOPT_0xF
	ADD  R30,R0
	ADC  R31,R1
	MOVW R16,R30
;     307 				lwtmp = lwtmp + 64 - (eM_FSize[gDownNumOfM-1]%64);
	LDS  R30,_gDownNumOfM
	SUBI R30,LOW(1)
	LDI  R26,LOW(_eM_FSize)
	LDI  R27,HIGH(_eM_FSize)
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
;     308 				lwtmp = 0x6000 - lwtmp;
	LDI  R30,LOW(24576)
	LDI  R31,HIGH(24576)
	RJMP _0x332
;     309 			}
;     310 			else if(gRx1Buf[RX1_BUF_SIZE-2] == 2){
_0x24:
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x2)
	BRNE _0x26
;     311 				lwtmp = eA_Addr[gDownNumOfA-1] + eA_FSize[gDownNumOfA-1];
	LDS  R30,_gDownNumOfA
	SUBI R30,LOW(1)
	MOV  R22,R30
	LDI  R26,LOW(_eA_Addr)
	LDI  R27,HIGH(_eA_Addr)
	CALL SUBOPT_0xF
	MOVW R0,R30
	MOV  R30,R22
	LDI  R26,LOW(_eA_FSize)
	LDI  R27,HIGH(_eA_FSize)
	CALL SUBOPT_0xF
	ADD  R30,R0
	ADC  R31,R1
	MOVW R16,R30
;     312 				lwtmp = lwtmp + 64 - (eA_FSize[gDownNumOfA-1]%64);
	LDS  R30,_gDownNumOfA
	SUBI R30,LOW(1)
	LDI  R26,LOW(_eA_FSize)
	LDI  R27,HIGH(_eA_FSize)
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
;     313 				lwtmp = 0x8000 - lwtmp;
	LDI  R30,LOW(32768)
	LDI  R31,HIGH(32768)
_0x332:
	SUB  R30,R16
	SBC  R31,R17
	MOVW R16,R30
;     314 			}
;     315 		}
_0x26:
_0x23:
;     316 		SendToPC(15,4);
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(4)
	CALL SUBOPT_0x11
;     317 		gFileCheckSum = 0;
;     318 		sciTx1Data(0x00);
	CALL SUBOPT_0x12
;     319 		sciTx1Data(0x00);
	CALL SUBOPT_0x12
;     320 		lbtmp = (BYTE)((lwtmp>>8) & 0xFF);
	MOV  R18,R17
;     321 		sciTx1Data(lbtmp);
	CALL SUBOPT_0x13
;     322 		gFileCheckSum ^= lbtmp;
;     323 		lbtmp = (BYTE)(lwtmp & 0xFF);
	MOVW R30,R16
	MOV  R18,R30
;     324 		sciTx1Data(lbtmp);
	CALL SUBOPT_0x13
;     325 		gFileCheckSum ^= lbtmp;
;     326 		sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     327 	}
;     328 	gRx1Step = 0;
_0x1E:
	CALL SUBOPT_0x6
;     329 	F_DOWNLOAD = 0;
;     330 	RUN_LED2_OFF;
;     331 }
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;     332 
;     333 
;     334 //------------------------------------------------------------------------------
;     335 // UART0 송신 인터럽트(패킷 송신용)
;     336 //------------------------------------------------------------------------------
;     337 interrupt [USART0_TXC] void usart0_tx_isr(void)
;     338 {
_usart0_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     339 	if(gTx0BufIdx < gTx0Cnt){
	LDS  R30,_gTx0Cnt
	LDS  R26,_gTx0BufIdx
	CP   R26,R30
	BRSH _0x27
;     340 		while(!(UCSR0A & DATA_REGISTER_EMPTY));
_0x28:
	SBIS 0xB,5
	RJMP _0x28
;     341 		UDR0 = gTx0Buf[gTx0BufIdx];
	LDS  R30,_gTx0BufIdx
	CALL SUBOPT_0x14
	LD   R30,Z
	OUT  0xC,R30
;     342     	gTx0BufIdx++;
	CALL SUBOPT_0x15
;     343 	}
;     344 	else if(gTx0BufIdx == gTx0Cnt){
	RJMP _0x2B
_0x27:
	LDS  R30,_gTx0Cnt
	LDS  R26,_gTx0BufIdx
	CP   R30,R26
	BRNE _0x2C
;     345 		gTx0BufIdx = 0;
	LDI  R30,LOW(0)
	STS  _gTx0BufIdx,R30
;     346 		gTx0Cnt = 0;
	STS  _gTx0Cnt,R30
;     347 	}
;     348 }
_0x2C:
_0x2B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;     349 
;     350 
;     351 //------------------------------------------------------------------------------
;     352 // UART0 수신 인터럽트(wCK, 사운드모듈에서 받은 신호)
;     353 //------------------------------------------------------------------------------
;     354 interrupt [USART0_RXC] void usart0_rx_isr(void)
;     355 {
_usart0_rx_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     356 	int		i;
;     357 	char	data;
;     358 	data = UDR0;
	CALL __SAVELOCR3
;	i -> R16,R17
;	data -> R18
	IN   R18,12
;     359 	if(F_DIRECT_C_EN){
	SBRS R2,2
	RJMP _0x2D
;     360 		while ( (UCSR1A & DATA_REGISTER_EMPTY) == 0 );
_0x2E:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0x2E
;     361 		UDR1 = data;
	STS  156,R18
;     362 		return;
	CALL SUBOPT_0x16
	RETI
;     363 	}
;     364 	gRx0Cnt++;
_0x2D:
	LDS  R30,_gRx0Cnt
	SUBI R30,-LOW(1)
	STS  _gRx0Cnt,R30
;     365 	for(i = 1; i < RX0_BUF_SIZE; i++) gRx0Buf[i-1] = gRx0Buf[i];
	__GETWRN 16,17,1
_0x32:
	__CPWRN 16,17,8
	BRGE _0x33
	MOVW R30,R16
	SBIW R30,1
	SUBI R30,LOW(-_gRx0Buf)
	SBCI R31,HIGH(-_gRx0Buf)
	MOVW R0,R30
	LDI  R26,LOW(_gRx0Buf)
	LDI  R27,HIGH(_gRx0Buf)
	CALL SUBOPT_0x17
;     366 	gRx0Buf[RX0_BUF_SIZE-1] = data;
	__ADDWRN 16,17,1
	RJMP _0x32
_0x33:
	__PUTBMRN _gRx0Buf,7,18
;     367 }
	CALL SUBOPT_0x16
	RETI
;     368 
;     369 
;     370 //------------------------------------------------------------------------------
;     371 // UART1 수신 인터럽트(RF모듈, PC에서 받은 신호)
;     372 //------------------------------------------------------------------------------
;     373 interrupt [USART1_RXC] void usart1_rx_isr(void)
;     374 {
_usart1_rx_isr:
	CALL SUBOPT_0x18
;     375     WORD    i;
;     376     
;     377     gRxData = UDR1;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDS  R30,156
	STS  _gRxData,R30
;     378 	if(F_DIRECT_C_EN){
	SBRS R2,2
	RJMP _0x34
;     379 		while( (UCSR0A & DATA_REGISTER_EMPTY) == 0 );
_0x35:
	SBIS 0xB,5
	RJMP _0x35
;     380 		UDR0 = gRxData;
	LDS  R30,_gRxData
	OUT  0xC,R30
;     381 		if(gRxData == 0xff){
	LDS  R26,_gRxData
	CPI  R26,LOW(0xFF)
	BRNE _0x38
;     382 			gRx1_DStep = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x19
;     383 			gFileCheckSum = 0;
	LDI  R30,LOW(0)
	STS  _gFileCheckSum,R30
;     384 			return;
	CALL SUBOPT_0x1A
	RETI
;     385 		}
;     386 		switch(gRx1_DStep){
_0x38:
	LDS  R30,_gRx1_DStep
	LDS  R31,_gRx1_DStep+1
;     387 			case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3C
;     388 				if(gRxData == 0xe0) gRx1_DStep = 2;
	LDS  R26,_gRxData
	CPI  R26,LOW(0xE0)
	BRNE _0x3D
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x19
;     389 				else gRx1_DStep = 0;
	RJMP _0x3E
_0x3D:
	CALL SUBOPT_0x1B
;     390 				gFileCheckSum ^= gRxData;
_0x3E:
	CALL SUBOPT_0x7
;     391 				break;
	RJMP _0x3B
;     392 			case 2:
_0x3C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3F
;     393 				if(gRxData == 251) gRx1_DStep = 3;
	LDS  R26,_gRxData
	CPI  R26,LOW(0xFB)
	BRNE _0x40
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x19
;     394 				else gRx1_DStep = 0;
	RJMP _0x41
_0x40:
	CALL SUBOPT_0x1B
;     395 				gFileCheckSum ^= gRxData;
_0x41:
	CALL SUBOPT_0x7
;     396 				break;
	RJMP _0x3B
;     397 			case 3:
_0x3F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x42
;     398 				if(gRxData == 1) gRx1_DStep = 4;
	LDS  R26,_gRxData
	CPI  R26,LOW(0x1)
	BRNE _0x43
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x19
;     399 				else gRx1_DStep = 0;
	RJMP _0x44
_0x43:
	CALL SUBOPT_0x1B
;     400 				gFileCheckSum ^= gRxData;
_0x44:
	CALL SUBOPT_0x7
;     401 				break;
	RJMP _0x3B
;     402 			case 4:
_0x42:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x45
;     403 				gRx1_DStep = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x19
;     404 				gFileCheckSum ^= gRxData;
	CALL SUBOPT_0x7
;     405 				gFileCheckSum &= 0x7F;
	LDS  R30,_gFileCheckSum
	ANDI R30,0x7F
	STS  _gFileCheckSum,R30
;     406 				break;
	RJMP _0x3B
;     407 			case 5:
_0x45:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x3B
;     408 				if(gRxData == gFileCheckSum){
	LDS  R30,_gFileCheckSum
	LDS  R26,_gRxData
	CP   R30,R26
	BRNE _0x47
;     409 				    TIMSK |= 0x01;
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
;     410 					EIMSK |= 0x40;
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;     411 					UCSR0B &= 0x7F;
	CBI  0xA,7
;     412 					UCSR0B |= 0x40;
	SBI  0xA,6
;     413 					F_DIRECT_C_EN = 0;
	CLT
	BLD  R2,2
;     414 				}
;     415 				gRx1_DStep = 0;
_0x47:
	CALL SUBOPT_0x1B
;     416 				break;
;     417 		}
_0x3B:
;     418 		return;
	CALL SUBOPT_0x1A
	RETI
;     419 	}
;     420 	UCSR0B &= 0xBF;
_0x34:
	CBI  0xA,6
;     421 	EIMSK &= 0xBF;
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;     422 
;     423    	for(i = 1; i < RX1_BUF_SIZE; i++) gRx1Buf[i-1] = gRx1Buf[i];
	__GETWRN 16,17,1
_0x49:
	__CPWRN 16,17,20
	BRSH _0x4A
	MOVW R30,R16
	SBIW R30,1
	SUBI R30,LOW(-_gRx1Buf)
	SBCI R31,HIGH(-_gRx1Buf)
	MOVW R0,R30
	LDI  R26,LOW(_gRx1Buf)
	LDI  R27,HIGH(_gRx1Buf)
	CALL SUBOPT_0x17
;     424    	gRx1Buf[RX1_BUF_SIZE-1] = gRxData;
	__ADDWRN 16,17,1
	RJMP _0x49
_0x4A:
	__POINTW2MN _gRx1Buf,19
	LDS  R30,_gRxData
	ST   X,R30
;     425 
;     426     if(F_DOWNLOAD == 0
;     427      && gRx1Buf[RX1_BUF_SIZE-8] == 0xFF
;     428      && gRx1Buf[RX1_BUF_SIZE-7] == 0xFF
;     429      && gRx1Buf[RX1_BUF_SIZE-6] == 0xAA
;     430      && gRx1Buf[RX1_BUF_SIZE-5] == 0x55
;     431      && gRx1Buf[RX1_BUF_SIZE-4] == 0xAA
;     432      && gRx1Buf[RX1_BUF_SIZE-3] == 0x55
;     433      && gRx1Buf[RX1_BUF_SIZE-2] == 0x37
;     434      && gRx1Buf[RX1_BUF_SIZE-1] == 0xBA){
	SBRC R2,4
	RJMP _0x4C
	__GETB1MN _gRx1Buf,12
	CPI  R30,LOW(0xFF)
	BRNE _0x4C
	__GETB1MN _gRx1Buf,13
	CPI  R30,LOW(0xFF)
	BRNE _0x4C
	__GETB1MN _gRx1Buf,14
	CPI  R30,LOW(0xAA)
	BRNE _0x4C
	__GETB1MN _gRx1Buf,15
	CPI  R30,LOW(0x55)
	BRNE _0x4C
	__GETB1MN _gRx1Buf,16
	CPI  R30,LOW(0xAA)
	BRNE _0x4C
	__GETB1MN _gRx1Buf,17
	CPI  R30,LOW(0x55)
	BRNE _0x4C
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x37)
	BRNE _0x4C
	__GETB1MN _gRx1Buf,19
	CPI  R30,LOW(0xBA)
	BREQ _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
;     435 		F_DOWNLOAD = 1;
	SET
	BLD  R2,4
;     436 		F_RSV_SOUND_READ = 0;
	CLT
	BLD  R3,5
;     437 		F_RSV_BTN_READ = 0;
	BLD  R3,6
;     438 		RUN_LED2_ON;
	CBI  0x1B,6
;     439 		gRx1Step = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x1C
;     440 
;     441 		UCSR0B |= 0x40;
	CALL SUBOPT_0x1D
;     442 		EIMSK |= 0x40;
;     443 		return;
	CALL SUBOPT_0x1A
	RETI
;     444 	}
;     445 
;     446 	switch(gRx1Step){          	
_0x4B:
	LDS  R30,_gRx1Step
	LDS  R31,_gRx1Step+1
;     447 		case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x51
;     448     	    if(gRxData == 11){
	LDS  R26,_gRxData
	CPI  R26,LOW(0xB)
	BRNE _0x52
;     449     	        gRx1Step = 300;
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL SUBOPT_0x1C
;     450     	    }
;     451     	    else if(gRxData == 14){
	RJMP _0x53
_0x52:
	LDS  R26,_gRxData
	CPI  R26,LOW(0xE)
	BRNE _0x54
;     452     	        gRx1Step = 600;
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	CALL SUBOPT_0x1C
;     453     	    }
;     454     	    else if(gRxData == 15){
	RJMP _0x55
_0x54:
	LDS  R26,_gRxData
	CPI  R26,LOW(0xF)
	BRNE _0x56
;     455     	        gRx1Step = 700;
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CALL SUBOPT_0x1C
;     456     	    }
;     457     	    else if(gRxData == 16){
	RJMP _0x57
_0x56:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x10)
	BRNE _0x58
;     458     	        gRx1Step = 800;
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	CALL SUBOPT_0x1C
;     459     	    }
;     460     	    else if(gRxData == 17){
	RJMP _0x59
_0x58:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x11)
	BRNE _0x5A
;     461     	        gRx1Step = 900;
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CALL SUBOPT_0x1C
;     462     	    }
;     463     	    else if(gRxData == 18){
	RJMP _0x5B
_0x5A:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x12)
	BRNE _0x5C
;     464     	        gRx1Step = 1000;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x1C
;     465     	    }
;     466     	    else if(gRxData == 20){
	RJMP _0x5D
_0x5C:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x14)
	BRNE _0x5E
;     467     	        gRx1Step = 1200;
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	CALL SUBOPT_0x1C
;     468     	    }
;     469     	    else if(gRxData == 21){
	RJMP _0x5F
_0x5E:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x15)
	BRNE _0x60
;     470     	        gRx1Step = 1300;
	LDI  R30,LOW(1300)
	LDI  R31,HIGH(1300)
	CALL SUBOPT_0x1C
;     471     	    }
;     472     	    else if(gRxData == 22){
	RJMP _0x61
_0x60:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x16)
	BRNE _0x62
;     473     	        gRx1Step = 1400;
	LDI  R30,LOW(1400)
	LDI  R31,HIGH(1400)
	CALL SUBOPT_0x1C
;     474     	    }
;     475     	    else if(gRxData == 23){
	RJMP _0x63
_0x62:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x17)
	BRNE _0x64
;     476     	        gRx1Step = 1500;
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	CALL SUBOPT_0x1C
;     477     	    }
;     478     	    else if(gRxData == 24){
	RJMP _0x65
_0x64:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x18)
	BRNE _0x66
;     479     	        gRx1Step = 1600;
	LDI  R30,LOW(1600)
	LDI  R31,HIGH(1600)
	CALL SUBOPT_0x1C
;     480     	    }
;     481     	    else if(gRxData == 26){
	RJMP _0x67
_0x66:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x1A)
	BRNE _0x68
;     482     	        gRx1Step = 1800;
	LDI  R30,LOW(1800)
	LDI  R31,HIGH(1800)
	CALL SUBOPT_0x1C
;     483     	    }
;     484     	    else if(gRxData == 31){
	RJMP _0x69
_0x68:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x1F)
	BRNE _0x6A
;     485     	        gRx1Step = 2300;
	LDI  R30,LOW(2300)
	LDI  R31,HIGH(2300)
	CALL SUBOPT_0x1C
;     486     	    }
;     487     	    else{
	RJMP _0x6B
_0x6A:
;     488 				gRx1Step = 0;
	RJMP _0x333
;     489 				F_DOWNLOAD = 0;
;     490 				RUN_LED2_OFF;
;     491 				break;
;     492 			}    	    	
_0x6B:
_0x69:
_0x67:
_0x65:
_0x63:
_0x61:
_0x5F:
_0x5D:
_0x5B:
_0x59:
_0x57:
_0x55:
_0x53:
;     493     	    break;
	RJMP _0x50
;     494     	case 300:
_0x51:
	CPI  R30,LOW(0x12C)
	LDI  R26,HIGH(0x12C)
	CPC  R31,R26
	BRNE _0x6C
;     495 			U1I_case100();
	CALL _U1I_case100
;     496     	    break;
	RJMP _0x50
;     497     	case 301:
_0x6C:
	CPI  R30,LOW(0x12D)
	LDI  R26,HIGH(0x12D)
	CPC  R31,R26
	BRNE _0x6D
;     498 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     499        	 	break;
	RJMP _0x50
;     500     	case 302:
_0x6D:
	CPI  R30,LOW(0x12E)
	LDI  R26,HIGH(0x12E)
	CPC  R31,R26
	BRNE _0x6E
;     501 			U1I_case302();
	CALL _U1I_case302
;     502        	 	break;
	RJMP _0x50
;     503     	case 303:
_0x6E:
	CPI  R30,LOW(0x12F)
	LDI  R26,HIGH(0x12F)
	CPC  R31,R26
	BRNE _0x6F
;     504     		U1I_case303();
	CALL _U1I_case303
;     505        	 	break;
	RJMP _0x50
;     506     	case 600:
_0x6F:
	CPI  R30,LOW(0x258)
	LDI  R26,HIGH(0x258)
	CPC  R31,R26
	BRNE _0x70
;     507 			U1I_case100();
	CALL _U1I_case100
;     508     	    break;
	RJMP _0x50
;     509     	case 601:
_0x70:
	CPI  R30,LOW(0x259)
	LDI  R26,HIGH(0x259)
	CPC  R31,R26
	BRNE _0x71
;     510 			U1I_case301(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _U1I_case301
;     511        	 	break;
	RJMP _0x50
;     512     	case 602:
_0x71:
	CPI  R30,LOW(0x25A)
	LDI  R26,HIGH(0x25A)
	CPC  R31,R26
	BRNE _0x72
;     513 			U1I_case502(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _U1I_case502
;     514        	 	break;
	RJMP _0x50
;     515     	case 603:
_0x72:
	CPI  R30,LOW(0x25B)
	LDI  R26,HIGH(0x25B)
	CPC  R31,R26
	BRNE _0x73
;     516     		U1I_case603();
	CALL _U1I_case603
;     517        	 	break;
	RJMP _0x50
;     518     	case 700:
_0x73:
	CPI  R30,LOW(0x2BC)
	LDI  R26,HIGH(0x2BC)
	CPC  R31,R26
	BRNE _0x74
;     519 			U1I_case100();
	CALL _U1I_case100
;     520     	    break;
	RJMP _0x50
;     521     	case 701:
_0x74:
	CPI  R30,LOW(0x2BD)
	LDI  R26,HIGH(0x2BD)
	CPC  R31,R26
	BRNE _0x75
;     522 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     523        	 	break;
	RJMP _0x50
;     524     	case 702:
_0x75:
	CPI  R30,LOW(0x2BE)
	LDI  R26,HIGH(0x2BE)
	CPC  R31,R26
	BRNE _0x76
;     525     		gFileCheckSum ^= gRxData;
	CALL SUBOPT_0x7
;     526 			if(gRxData == 1 || gRxData == 2){
	LDS  R26,_gRxData
	CPI  R26,LOW(0x1)
	BREQ _0x78
	CPI  R26,LOW(0x2)
	BRNE _0x77
_0x78:
;     527 				gRx1Step = 703;
	LDI  R30,LOW(703)
	LDI  R31,HIGH(703)
	CALL SUBOPT_0x1C
;     528 			}
;     529 			else{
	RJMP _0x7A
_0x77:
;     530 				gRx1Step = 0;
	CALL SUBOPT_0x6
;     531 				F_DOWNLOAD = 0;
;     532 				RUN_LED2_OFF;
;     533 			}
_0x7A:
;     534        	 	break;
	RJMP _0x50
;     535     	case 703:
_0x76:
	CPI  R30,LOW(0x2BF)
	LDI  R26,HIGH(0x2BF)
	CPC  R31,R26
	BRNE _0x7B
;     536     		U1I_case703();
	CALL _U1I_case703
;     537        	 	break;
	RJMP _0x50
;     538     	case 800:
_0x7B:
	CPI  R30,LOW(0x320)
	LDI  R26,HIGH(0x320)
	CPC  R31,R26
	BRNE _0x7C
;     539 			U1I_case100();
	CALL _U1I_case100
;     540     	    break;
	RJMP _0x50
;     541     	case 801:
_0x7C:
	CPI  R30,LOW(0x321)
	LDI  R26,HIGH(0x321)
	CPC  R31,R26
	BRNE _0x7D
;     542 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     543        	 	break;
	RJMP _0x50
;     544     	case 802:
_0x7D:
	CPI  R30,LOW(0x322)
	LDI  R26,HIGH(0x322)
	CPC  R31,R26
	BRNE _0x7E
;     545 			U1I_case302();
	CALL _U1I_case302
;     546        	 	break;
	RJMP _0x50
;     547     	case 803:
_0x7E:
	CPI  R30,LOW(0x323)
	LDI  R26,HIGH(0x323)
	CPC  R31,R26
	BRNE _0x7F
;     548 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x80
;     549 				SendToPC(16,1);
	LDI  R30,LOW(16)
	CALL SUBOPT_0x1F
;     550 				gFileCheckSum = 0;
;     551 				sciTx1Data(0x01);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x20
;     552 				gFileCheckSum ^= 0x01;
	CALL SUBOPT_0x21
;     553 				sciTx1Data(gFileCheckSum);
;     554 				gRx1Step = 0;
	CALL SUBOPT_0x6
;     555 				F_DOWNLOAD = 0;
;     556 				RUN_LED2_OFF;
;     557 			    TIMSK &= 0xFE;
	CALL SUBOPT_0x22
;     558 				EIMSK &= 0xBF;
;     559 				UCSR0B |= 0x80;
;     560 				UCSR0B &= 0xBF;
;     561 				F_DIRECT_C_EN = 1;
;     562 				PF1_LED1_ON;
	CBI  0x1B,2
;     563 				PF1_LED2_OFF;
	SBI  0x1B,3
;     564 				PF2_LED_ON;
	CBI  0x1B,4
;     565 				return;
	CALL SUBOPT_0x1A
	RETI
;     566 			}
;     567 			gRx1Step = 0;
_0x80:
	RJMP _0x333
;     568 			F_DOWNLOAD = 0;
;     569 			RUN_LED2_OFF;
;     570        	 	break;
;     571     	case 900:
_0x7F:
	CPI  R30,LOW(0x384)
	LDI  R26,HIGH(0x384)
	CPC  R31,R26
	BRNE _0x81
;     572 			U1I_case100();
	CALL _U1I_case100
;     573     	    break;
	RJMP _0x50
;     574     	case 901:
_0x81:
	CPI  R30,LOW(0x385)
	LDI  R26,HIGH(0x385)
	CPC  R31,R26
	BRNE _0x82
;     575 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     576        	 	break;
	RJMP _0x50
;     577     	case 902:
_0x82:
	CPI  R30,LOW(0x386)
	LDI  R26,HIGH(0x386)
	CPC  R31,R26
	BRNE _0x83
;     578 			U1I_case302();
	CALL _U1I_case302
;     579        	 	break;
	RJMP _0x50
;     580     	case 903:
_0x83:
	CPI  R30,LOW(0x387)
	LDI  R26,HIGH(0x387)
	CPC  R31,R26
	BRNE _0x84
;     581 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x85
;     582 				SendToPC(17,2);
	LDI  R30,LOW(17)
	CALL SUBOPT_0x23
;     583 				gFileCheckSum = 0;
;     584 				sciTx1Data(F_ERR_CODE);
	ST   -Y,R13
	CALL _sciTx1Data
;     585 				gFileCheckSum ^= F_ERR_CODE;
	MOV  R30,R13
	CALL SUBOPT_0xA
;     586 				sciTx1Data(F_PF);
	ST   -Y,R12
	CALL _sciTx1Data
;     587 				gFileCheckSum ^= F_PF;
	MOV  R30,R12
	CALL SUBOPT_0xA
;     588 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     589 			}
;     590 			gRx1Step = 0;
_0x85:
	RJMP _0x333
;     591 			F_DOWNLOAD = 0;
;     592 			RUN_LED2_OFF;
;     593        	 	break;
;     594     	case 1000:
_0x84:
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0x86
;     595 			U1I_case100();
	CALL _U1I_case100
;     596     	    break;
	RJMP _0x50
;     597     	case 1001:
_0x86:
	CPI  R30,LOW(0x3E9)
	LDI  R26,HIGH(0x3E9)
	CPC  R31,R26
	BRNE _0x87
;     598 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     599        	 	break;
	RJMP _0x50
;     600     	case 1002:
_0x87:
	CPI  R30,LOW(0x3EA)
	LDI  R26,HIGH(0x3EA)
	CPC  R31,R26
	BRNE _0x88
;     601 			U1I_case302();
	CALL _U1I_case302
;     602        	 	break;
	RJMP _0x50
;     603     	case 1003:
_0x88:
	CPI  R30,LOW(0x3EB)
	LDI  R26,HIGH(0x3EB)
	CPC  R31,R26
	BRNE _0x89
;     604 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x8A
;     605 				SendToPC(18,2);
	LDI  R30,LOW(18)
	CALL SUBOPT_0x23
;     606 				gFileCheckSum = 0;
;     607 				sciTx1Data(9);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x20
;     608 				gFileCheckSum ^= 9;
	LDI  R30,LOW(9)
	EOR  R30,R26
	STS  _gFileCheckSum,R30
;     609 				sciTx1Data(99);
	LDI  R30,LOW(99)
	CALL SUBOPT_0x20
;     610 				gFileCheckSum ^= 99;
	LDI  R30,LOW(99)
	EOR  R30,R26
	STS  _gFileCheckSum,R30
;     611 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     612 			}
;     613 			gRx1Step = 0;
_0x8A:
	RJMP _0x333
;     614 			F_DOWNLOAD = 0;
;     615 			RUN_LED2_OFF;
;     616        	 	break;
;     617     	case 1200:
_0x89:
	CPI  R30,LOW(0x4B0)
	LDI  R26,HIGH(0x4B0)
	CPC  R31,R26
	BRNE _0x8B
;     618 			U1I_case100();
	CALL _U1I_case100
;     619     	    break;
	RJMP _0x50
;     620     	case 1201:
_0x8B:
	CPI  R30,LOW(0x4B1)
	LDI  R26,HIGH(0x4B1)
	CPC  R31,R26
	BRNE _0x8C
;     621 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     622        	 	break;
	RJMP _0x50
;     623     	case 1202:
_0x8C:
	CPI  R30,LOW(0x4B2)
	LDI  R26,HIGH(0x4B2)
	CPC  R31,R26
	BRNE _0x8D
;     624 			gFileCheckSum ^= gRxData;
	CALL SUBOPT_0x7
;     625 			if(gRxData < 64)
	LDS  R26,_gRxData
	CPI  R26,LOW(0x40)
	BRSH _0x8E
;     626 				gRx1Step++;
	CALL SUBOPT_0x4
;     627 			else{
	RJMP _0x8F
_0x8E:
;     628 				gRx1Step = 0;
	CALL SUBOPT_0x6
;     629 				F_DOWNLOAD = 0;
;     630 				RUN_LED2_OFF;
;     631 			}
_0x8F:
;     632        	 	break;
	RJMP _0x50
;     633     	case 1203:
_0x8D:
	CPI  R30,LOW(0x4B3)
	LDI  R26,HIGH(0x4B3)
	CPC  R31,R26
	BRNE _0x90
;     634 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x91
;     635 				F_RSV_MOTION = 1;
	SET
	BLD  R3,4
;     636 				if(gRx1Buf[RX1_BUF_SIZE-2] == 0x07)	F_MOTION_STOPPED = 1;
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x7)
	BRNE _0x92
	BLD  R2,3
;     637 				gRx1Step = 0;
_0x92:
	CALL SUBOPT_0x6
;     638 				F_DOWNLOAD = 0;
;     639 				RUN_LED2_OFF;
;     640 				UCSR0B |= 0x40;
	CALL SUBOPT_0x1D
;     641 				EIMSK |= 0x40;
;     642 				F_IR_RECEIVED = 1;
	SET
	BLD  R3,2
;     643 				gIrBuf[0] = eRCodeH[0];
	LDI  R26,LOW(_eRCodeH)
	LDI  R27,HIGH(_eRCodeH)
	CALL __EEPROMRDB
	STS  _gIrBuf,R30
;     644 				gIrBuf[1] = eRCodeM[0];
	LDI  R26,LOW(_eRCodeM)
	LDI  R27,HIGH(_eRCodeM)
	CALL __EEPROMRDB
	__PUTB1MN _gIrBuf,1
;     645 				gIrBuf[2] = eRCodeL[0];
	LDI  R26,LOW(_eRCodeL)
	LDI  R27,HIGH(_eRCodeL)
	CALL __EEPROMRDB
	__PUTB1MN _gIrBuf,2
;     646 				gIrBuf[3] = gRx1Buf[RX1_BUF_SIZE-2];
	__GETB1MN _gRx1Buf,18
	__PUTB1MN _gIrBuf,3
;     647 				return;
	CALL SUBOPT_0x1A
	RETI
;     648 			}
;     649 			gRx1Step = 0;
_0x91:
	RJMP _0x333
;     650 			F_DOWNLOAD = 0;
;     651 			RUN_LED2_OFF;
;     652        	 	break;
;     653     	case 1300:
_0x90:
	CPI  R30,LOW(0x514)
	LDI  R26,HIGH(0x514)
	CPC  R31,R26
	BRNE _0x93
;     654 			U1I_case100();
	CALL _U1I_case100
;     655     	    break;
	RJMP _0x50
;     656     	case 1301:
_0x93:
	CPI  R30,LOW(0x515)
	LDI  R26,HIGH(0x515)
	CPC  R31,R26
	BRNE _0x94
;     657 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     658        	 	break;
	RJMP _0x50
;     659     	case 1302:
_0x94:
	CPI  R30,LOW(0x516)
	LDI  R26,HIGH(0x516)
	CPC  R31,R26
	BRNE _0x95
;     660 			gFileCheckSum ^= gRxData;
	CALL SUBOPT_0x7
;     661 			if(gRxData < 26)
	LDS  R26,_gRxData
	CPI  R26,LOW(0x1A)
	BRSH _0x96
;     662 				gRx1Step++;
	CALL SUBOPT_0x4
;     663 			else{
	RJMP _0x97
_0x96:
;     664 			gRx1Step = 0;
	CALL SUBOPT_0x6
;     665 				F_DOWNLOAD = 0;
;     666 				RUN_LED2_OFF;
;     667 			}
_0x97:
;     668        	 	break;
	RJMP _0x50
;     669     	case 1303:
_0x95:
	CPI  R30,LOW(0x517)
	LDI  R26,HIGH(0x517)
	CPC  R31,R26
	BRNE _0x98
;     670 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x99
;     671 				SendToSoundIC(gRx1Buf[RX1_BUF_SIZE-2]);
	__GETB1MN _gRx1Buf,18
	ST   -Y,R30
	CALL _SendToSoundIC
;     672 				delay_ms(200 + Sound_Length[gRx1Buf[RX1_BUF_SIZE-2]-1]);
	__GETB1MN _gRx1Buf,18
	SUBI R30,LOW(1)
	LDI  R26,LOW(_Sound_Length)
	LDI  R27,HIGH(_Sound_Length)
	CALL SUBOPT_0x24
	SUBI R30,LOW(-200)
	SBCI R31,HIGH(-200)
	CALL SUBOPT_0x25
;     673 				SendToPC(21,1);
	LDI  R30,LOW(21)
	CALL SUBOPT_0x1F
;     674 				gFileCheckSum = 0;
;     675 				sciTx1Data(gRx1Buf[RX1_BUF_SIZE-2]);
	CALL SUBOPT_0x26
;     676 				gFileCheckSum ^= gRx1Buf[RX1_BUF_SIZE-2];
;     677 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     678 			}
;     679 			gRx1Step = 0;
_0x99:
	RJMP _0x333
;     680 			F_DOWNLOAD = 0;
;     681 			RUN_LED2_OFF;
;     682        	 	break;
;     683     	case 1400:
_0x98:
	CPI  R30,LOW(0x578)
	LDI  R26,HIGH(0x578)
	CPC  R31,R26
	BRNE _0x9A
;     684 			U1I_case100();
	CALL _U1I_case100
;     685     	    break;
	RJMP _0x50
;     686     	case 1401:
_0x9A:
	CPI  R30,LOW(0x579)
	LDI  R26,HIGH(0x579)
	CPC  R31,R26
	BRNE _0x9B
;     687 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     688        	 	break;
	RJMP _0x50
;     689     	case 1402:
_0x9B:
	CPI  R30,LOW(0x57A)
	LDI  R26,HIGH(0x57A)
	CPC  R31,R26
	BRNE _0x9C
;     690 			U1I_case302();
	CALL _U1I_case302
;     691        	 	break;
	RJMP _0x50
;     692     	case 1403:
_0x9C:
	CPI  R30,LOW(0x57B)
	LDI  R26,HIGH(0x57B)
	CPC  R31,R26
	BRNE _0x9D
;     693 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x9E
;     694 				F_RSV_PSD_READ = 1;
	SET
	BLD  R3,7
;     695 			}
;     696 			gRx1Step = 0;
_0x9E:
	RJMP _0x333
;     697 			F_DOWNLOAD = 0;
;     698 			RUN_LED2_OFF;
;     699        	 	break;
;     700     	case 1500:
_0x9D:
	CPI  R30,LOW(0x5DC)
	LDI  R26,HIGH(0x5DC)
	CPC  R31,R26
	BRNE _0x9F
;     701 			U1I_case100();
	CALL _U1I_case100
;     702     	    break;
	RJMP _0x50
;     703     	case 1501:
_0x9F:
	CPI  R30,LOW(0x5DD)
	LDI  R26,HIGH(0x5DD)
	CPC  R31,R26
	BRNE _0xA0
;     704 			U1I_case301(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _U1I_case301
;     705        	 	break;
	RJMP _0x50
;     706     	case 1502:
_0xA0:
	CPI  R30,LOW(0x5DE)
	LDI  R26,HIGH(0x5DE)
	CPC  R31,R26
	BRNE _0xA1
;     707 			U1I_case502(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _U1I_case502
;     708        	 	break;
	RJMP _0x50
;     709     	case 1503:
_0xA1:
	CPI  R30,LOW(0x5DF)
	LDI  R26,HIGH(0x5DF)
	CPC  R31,R26
	BRNE _0xA2
;     710 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0xA3
;     711 				gSoundMinTh = gRx1Buf[RX1_BUF_SIZE-2];
	__GETB1MN _gRx1Buf,18
	STS  _gSoundMinTh,R30
;     712 				F_RSV_SOUND_READ = 1;
	SET
	BLD  R3,5
;     713 			}
;     714 			gRx1Step = 0;
_0xA3:
	RJMP _0x333
;     715 			F_DOWNLOAD = 0;
;     716 			RUN_LED2_OFF;
;     717        	 	break;
;     718     	case 1600:
_0xA2:
	CPI  R30,LOW(0x640)
	LDI  R26,HIGH(0x640)
	CPC  R31,R26
	BRNE _0xA4
;     719 			U1I_case100();
	CALL _U1I_case100
;     720     	    break;
	RJMP _0x50
;     721     	case 1601:
_0xA4:
	CPI  R30,LOW(0x641)
	LDI  R26,HIGH(0x641)
	CPC  R31,R26
	BRNE _0xA5
;     722 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     723        	 	break;
	RJMP _0x50
;     724     	case 1602:
_0xA5:
	CPI  R30,LOW(0x642)
	LDI  R26,HIGH(0x642)
	CPC  R31,R26
	BRNE _0xA6
;     725 			U1I_case302();
	CALL _U1I_case302
;     726        	 	break;
	RJMP _0x50
;     727     	case 1603:
_0xA6:
	CPI  R30,LOW(0x643)
	LDI  R26,HIGH(0x643)
	CPC  R31,R26
	BRNE _0xA7
;     728 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0xA8
;     729 				F_RSV_BTN_READ = 1;
	SET
	BLD  R3,6
;     730 			}
;     731 			gRx1Step = 0;
_0xA8:
	RJMP _0x333
;     732 			F_DOWNLOAD = 0;
;     733 			RUN_LED2_OFF;
;     734        	 	break;
;     735     	case 1800:
_0xA7:
	CPI  R30,LOW(0x708)
	LDI  R26,HIGH(0x708)
	CPC  R31,R26
	BRNE _0xA9
;     736 			U1I_case100();
	CALL _U1I_case100
;     737     	    break;
	RJMP _0x50
;     738     	case 1801:
_0xA9:
	CPI  R30,LOW(0x709)
	LDI  R26,HIGH(0x709)
	CPC  R31,R26
	BRNE _0xAA
;     739 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     740        	 	break;
	RJMP _0x50
;     741     	case 1802:
_0xAA:
	CPI  R30,LOW(0x70A)
	LDI  R26,HIGH(0x70A)
	CPC  R31,R26
	BRNE _0xAB
;     742 			U1I_case302();
	CALL _U1I_case302
;     743        	 	break;
	RJMP _0x50
;     744     	case 1803:
_0xAB:
	CPI  R30,LOW(0x70B)
	LDI  R26,HIGH(0x70B)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xAC
;     745 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BREQ PC+3
	JMP _0xAD
;     746 				SendToPC(26,6);
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R30,LOW(6)
	CALL SUBOPT_0x11
;     747 				gFileCheckSum = 0;
;     748 				if(gAccX < 0){
	LDS  R26,_gAccX
	CPI  R26,0
	BRGE _0xAE
;     749 	    			sciTx1Data(gAccX);
	LDS  R30,_gAccX
	CALL SUBOPT_0x27
;     750     				sciTx1Data(0xff);
	RJMP _0x334
;     751         	    }
;     752             	else{
_0xAE:
;     753 	    			sciTx1Data(gAccX);
	LDS  R30,_gAccX
	CALL SUBOPT_0x28
;     754     				sciTx1Data(0);
_0x334:
	ST   -Y,R30
	RCALL _sciTx1Data
;     755         	    }
;     756 				gFileCheckSum ^= gAccX;
	LDS  R30,_gAccX
	CALL SUBOPT_0xA
;     757 				if(gAccY < 0){
	LDS  R26,_gAccY
	CPI  R26,0
	BRGE _0xB0
;     758     				sciTx1Data(gAccY);
	LDS  R30,_gAccY
	CALL SUBOPT_0x27
;     759 	    			sciTx1Data(0xff);
	RJMP _0x335
;     760     	        }
;     761         	    else{
_0xB0:
;     762     				sciTx1Data(gAccY);
	LDS  R30,_gAccY
	CALL SUBOPT_0x28
;     763 	    			sciTx1Data(0);
_0x335:
	ST   -Y,R30
	RCALL _sciTx1Data
;     764     	        }
;     765 				gFileCheckSum ^= gAccY;
	LDS  R30,_gAccY
	CALL SUBOPT_0xA
;     766 				if(gAccZ < 0){
	LDS  R26,_gAccZ
	CPI  R26,0
	BRGE _0xB2
;     767 	    			sciTx1Data(gAccZ);
	LDS  R30,_gAccZ
	CALL SUBOPT_0x27
;     768     				sciTx1Data(0xff);
	RJMP _0x336
;     769         	    }
;     770             	else{
_0xB2:
;     771 	    			sciTx1Data(gAccZ);
	LDS  R30,_gAccZ
	CALL SUBOPT_0x28
;     772     				sciTx1Data(0);
_0x336:
	ST   -Y,R30
	RCALL _sciTx1Data
;     773         	    }
;     774 				gFileCheckSum ^= gAccZ;
	LDS  R30,_gAccZ
	CALL SUBOPT_0xA
;     775 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     776 			}
;     777 			gRx1Step = 0;			// 다운로드 종료
_0xAD:
	RJMP _0x333
;     778 			F_DOWNLOAD = 0;			// 다운로드 중 표시 해제
;     779 			RUN_LED2_OFF;			// 연결 상태 LED 표시 해제
;     780        	 	break;
;     781     	case 2300:
_0xAC:
	CPI  R30,LOW(0x8FC)
	LDI  R26,HIGH(0x8FC)
	CPC  R31,R26
	BRNE _0xB4
;     782 			U1I_case100();
	CALL _U1I_case100
;     783     	    break;
	RJMP _0x50
;     784     	case 2301:
_0xB4:
	CPI  R30,LOW(0x8FD)
	LDI  R26,HIGH(0x8FD)
	CPC  R31,R26
	BRNE _0xB5
;     785 			U1I_case301(1);
	CALL SUBOPT_0x1E
;     786        	 	break;
	RJMP _0x50
;     787     	case 2302:
_0xB5:
	CPI  R30,LOW(0x8FE)
	LDI  R26,HIGH(0x8FE)
	CPC  R31,R26
	BRNE _0xB6
;     788 			gFileCheckSum ^= gRxData;
	CALL SUBOPT_0x7
;     789 			if(gRxData < 4)
	LDS  R26,_gRxData
	CPI  R26,LOW(0x4)
	BRSH _0xB7
;     790 				gRx1Step++;
	CALL SUBOPT_0x4
;     791 			else{
	RJMP _0xB8
_0xB7:
;     792 				gRx1Step = 0;
	CALL SUBOPT_0x6
;     793 				F_DOWNLOAD = 0;
;     794 				RUN_LED2_OFF;
;     795 			}
_0xB8:
;     796        	 	break;
	RJMP _0x50
;     797     	case 2303:
_0xB6:
	CPI  R30,LOW(0x8FF)
	LDI  R26,HIGH(0x8FF)
	CPC  R31,R26
	BRNE _0x50
;     798 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0xBA
;     799 				if(gRx1Buf[RX1_BUF_SIZE-2] == 1){
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x1)
	BRNE _0xBB
;     800 					gDownNumOfM = 0;
	LDI  R30,LOW(0)
	STS  _gDownNumOfM,R30
;     801 					eNumOfM = 0;
	LDI  R26,LOW(_eNumOfM)
	LDI  R27,HIGH(_eNumOfM)
	CALL __EEPROMWRB
;     802 				}
;     803 				else if(gRx1Buf[RX1_BUF_SIZE-2] == 2){
	RJMP _0xBC
_0xBB:
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x2)
	BRNE _0xBD
;     804 					gDownNumOfA = 0;
	LDI  R30,LOW(0)
	STS  _gDownNumOfA,R30
;     805 					eNumOfA = 0;
	LDI  R26,LOW(_eNumOfA)
	LDI  R27,HIGH(_eNumOfA)
	CALL __EEPROMWRB
;     806 				}
;     807 				SendToPC(31,1);
_0xBD:
_0xBC:
	LDI  R30,LOW(31)
	CALL SUBOPT_0x1F
;     808 				gFileCheckSum = 0;
;     809 				sciTx1Data(gRx1Buf[RX1_BUF_SIZE-2]);
	CALL SUBOPT_0x26
;     810 				gFileCheckSum ^= gRx1Buf[RX1_BUF_SIZE-2];
;     811 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     812 			}
;     813 			gRx1Step = 0;
_0xBA:
_0x333:
	LDI  R30,0
	STS  _gRx1Step,R30
	STS  _gRx1Step+1,R30
;     814 			F_DOWNLOAD = 0;
	CLT
	BLD  R2,4
;     815 			RUN_LED2_OFF;
	SBI  0x1B,6
;     816        	 	break;
;     817 	}
_0x50:
;     818 	UCSR0B |= 0x40;
	CALL SUBOPT_0x1D
;     819 	EIMSK |= 0x40;
;     820 }
	CALL SUBOPT_0x1A
	RETI
;     821 
;     822 
;     823 //------------------------------------------------------------------------------
;     824 // 타이머0 오버플로 인터럽트
;     825 //------------------------------------------------------------------------------
;     826 interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     827 	TCNT0 = 111;
	LDI  R30,LOW(111)
	OUT  0x32,R30
;     828 	if(++g10MSEC > 99){
	CALL SUBOPT_0x29
	ADIW R26,1
	STS  _g10MSEC,R26
	STS  _g10MSEC+1,R27
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0xBE
;     829         g10MSEC = 0;
	LDI  R30,0
	STS  _g10MSEC,R30
	STS  _g10MSEC+1,R30
;     830         if(gSEC_DCOUNT > 0)	gSEC_DCOUNT--;
	LDS  R26,_gSEC_DCOUNT
	LDS  R27,_gSEC_DCOUNT+1
	CALL __CPW02
	BRSH _0xBF
	CALL SUBOPT_0x2A
	SBIW R30,1
	CALL SUBOPT_0x2B
;     831         if(++gSEC > 59){
_0xBF:
	LDS  R26,_gSEC
	SUBI R26,-LOW(1)
	STS  _gSEC,R26
	CPI  R26,LOW(0x3C)
	BRLO _0xC0
;     832             gSEC = 0;
	LDI  R30,LOW(0)
	STS  _gSEC,R30
;     833 	        if(gMIN_DCOUNT > 0)	gMIN_DCOUNT--;
	LDS  R26,_gMIN_DCOUNT
	LDS  R27,_gMIN_DCOUNT+1
	CALL __CPW02
	BRSH _0xC1
	CALL SUBOPT_0x2C
	SBIW R30,1
	CALL SUBOPT_0x2D
;     834             if(++gMIN > 59){
_0xC1:
	LDS  R26,_gMIN
	SUBI R26,-LOW(1)
	STS  _gMIN,R26
	CPI  R26,LOW(0x3C)
	BRLO _0xC2
;     835                 gMIN = 0;
	LDI  R30,LOW(0)
	STS  _gMIN,R30
;     836                 if(++gHOUR > 23)
	LDS  R26,_gHOUR
	SUBI R26,-LOW(1)
	STS  _gHOUR,R26
	CPI  R26,LOW(0x18)
	BRLO _0xC3
;     837                     gHOUR = 0;
	STS  _gHOUR,R30
;     838             }
_0xC3:
;     839 		}
_0xC2:
;     840     }
_0xC0:
;     841 }
_0xBE:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
;     842 
;     843 //------------------------------------------------------------------------------
;     844 // 타이머1 오버플로 인터럽트
;     845 //------------------------------------------------------------------------------
;     846 interrupt [TIM1_OVF] void timer1_ovf_isr(void) {
_timer1_ovf_isr:
	CALL SUBOPT_0x18
;     847 	if( gFrameIdx == Scene.NumOfFrame ) {
	CALL SUBOPT_0x2E
	LDS  R26,_gFrameIdx
	LDS  R27,_gFrameIdx+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0xC4
;     848    	    gFrameIdx = 0;
	LDI  R30,0
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R30
;     849     	RUN_LED1_OFF;
	SBI  0x1B,5
;     850 		F_SCENE_PLAYING = 0;
	CLT
	BLD  R2,0
;     851 		TIMSK &= 0xfb;
	IN   R30,0x37
	ANDI R30,0xFB
	OUT  0x37,R30
;     852 		TCCR1B = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
;     853 		return;
	CALL SUBOPT_0x2F
	RETI
;     854 	}
;     855 	TCNT1 = TxInterval;
_0xC4:
	LDS  R30,_TxInterval
	LDS  R31,_TxInterval+1
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;     856 	TIFR |= 0x04;
	CALL SUBOPT_0x30
;     857 	TIMSK |= 0x04;
;     858 	MakeFrame();
	CALL SUBOPT_0x31
;     859 	SendFrame();
;     860 }
	CALL SUBOPT_0x2F
	RETI
;     861 
;     862 
;     863 //------------------------------------------------------------------------------
;     864 // 리모컨 수신용 IR수신 인터럽트
;     865 //------------------------------------------------------------------------------
;     866 interrupt [EXT_INT6] void ext_int6_isr(void) {
_ext_int6_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     867 	BYTE width;
;     868 	WORD i;
;     869 
;     870 	width = TCNT2;
	CALL __SAVELOCR3
;	width -> R16
;	i -> R17,R18
	IN   R16,36
;     871 	TCNT2 = 0;
	LDI  R30,LOW(0)
	OUT  0x24,R30
;     872 
;     873 	if(gIrBitIndex == 0xFF){
	LDS  R26,_gIrBitIndex
	CPI  R26,LOW(0xFF)
	BRNE _0xC5
;     874 		if((width >= IR_HEADER_LT) && (width <= IR_HEADER_UT)){
	CPI  R16,63
	BRLO _0xC7
	CPI  R16,82
	BRLO _0xC8
_0xC7:
	RJMP _0xC6
_0xC8:
;     875 			F_IR_RECEIVED = 0;
	CLT
	BLD  R3,2
;     876 			gIrBitIndex = 0;
	LDI  R30,LOW(0)
	STS  _gIrBitIndex,R30
;     877 			for(i = 0; i < IR_BUFFER_SIZE; i++)
	__GETWRN 17,18,0
_0xCA:
	__CPWRN 17,18,4
	BRSH _0xCB
;     878                 gIrBuf[i] = 0;
	LDI  R26,LOW(_gIrBuf)
	LDI  R27,HIGH(_gIrBuf)
	ADD  R26,R17
	ADC  R27,R18
	LDI  R30,LOW(0)
	ST   X,R30
;     879         }
	__ADDWRN 17,18,1
	RJMP _0xCA
_0xCB:
;     880 	}
_0xC6:
;     881 	else{
	RJMP _0xCC
_0xC5:
;     882         if((width >= IR_LOW_BIT_LT)&&(width <= IR_LOW_BIT_UT))
	CPI  R16,10
	BRLO _0xCE
	CPI  R16,19
	BRLO _0xCF
_0xCE:
	RJMP _0xCD
_0xCF:
;     883             gIrBitIndex++;
	LDS  R30,_gIrBitIndex
	SUBI R30,-LOW(1)
	RJMP _0x337
;     884         else if((width >= IR_HIGH_BIT_LT)&&(width <= IR_HIGH_BIT_UT)){
_0xCD:
	CPI  R16,19
	BRLO _0xD2
	CPI  R16,27
	BRLO _0xD3
_0xD2:
	RJMP _0xD1
_0xD3:
;     885             if(gIrBitIndex != 0)
	LDS  R30,_gIrBitIndex
	CPI  R30,0
	BREQ _0xD4
;     886                 gIrBuf[(BYTE)(gIrBitIndex/8)] |= 0x01<<(gIrBitIndex%8);
	LSR  R30
	LSR  R30
	LSR  R30
	LDI  R31,0
	SUBI R30,LOW(-_gIrBuf)
	SBCI R31,HIGH(-_gIrBuf)
	MOVW R22,R30
	LD   R1,Z
	LDS  R30,_gIrBitIndex
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
;     887             else
	RJMP _0xD5
_0xD4:
;     888                 gIrBuf[0] = 0x01;
	LDI  R30,LOW(1)
	STS  _gIrBuf,R30
;     889             gIrBitIndex++;
_0xD5:
	LDS  R30,_gIrBitIndex
	SUBI R30,-LOW(1)
	RJMP _0x337
;     890         }
;     891         else gIrBitIndex = 0xFF;
_0xD1:
	LDI  R30,LOW(255)
_0x337:
	STS  _gIrBitIndex,R30
;     892       
;     893         if(gIrBitIndex == (IR_BUFFER_SIZE * 8)){
	LDS  R26,_gIrBitIndex
	CPI  R26,LOW(0x20)
	BRNE _0xD7
;     894             F_IR_RECEIVED = 1;
	SET
	BLD  R3,2
;     895             gIrBitIndex = 0xFF;
	LDI  R30,LOW(255)
	STS  _gIrBitIndex,R30
;     896 		}
;     897 	}
_0xD7:
_0xCC:
;     898 }
	CALL __LOADLOCR3
	ADIW R28,3
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;     899 
;     900 
;     901 //------------------------------------------------------------------------------
;     902 // A/D 변환 완료 인터럽트
;     903 //------------------------------------------------------------------------------
;     904 interrupt [ADC_INT] void adc_isr(void) {
_adc_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     905 	WORD i;
;     906 	gAD_val=(signed char)ADCH;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	IN   R11,5
;     907 	switch(gAD_Ch_Index){
	MOV  R30,R4
;     908 		case PSD_CH:
	CPI  R30,0
	BRNE _0xDB
;     909     	    gPSD_val = (BYTE)gAD_val;
	MOV  R9,R11
;     910 			break; 
	RJMP _0xDA
;     911 		case VOLTAGE_CH:
_0xDB:
	CPI  R30,LOW(0x1)
	BRNE _0xDC
;     912 			i = (BYTE)gAD_val;
	MOV  R16,R11
	CLR  R17
;     913 			gVOLTAGE = i*57;
	__MULBNWRU 16,17,57
	__PUTW1R 5,6
;     914 			break; 
	RJMP _0xDA
;     915 		case MIC_CH:
_0xDC:
	CPI  R30,LOW(0xF)
	BRNE _0xDA
;     916 			if((BYTE)gAD_val < 230)
	LDI  R30,LOW(230)
	CP   R11,R30
	BRSH _0xDE
;     917 				gMIC_val = (BYTE)gAD_val;
	MOV  R10,R11
;     918 			else
	RJMP _0xDF
_0xDE:
;     919 				gMIC_val = 0;
	CLR  R10
;     920 			break; 
_0xDF:
;     921 	}  
_0xDA:
;     922 	F_AD_CONVERTING = 0;    
	CLT
	BLD  R2,7
;     923 }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;     924 
;     925 
;     926 void ADC_set(BYTE mode)
;     927 {                                    
_ADC_set:
;     928 	ADMUX=0x20 | gAD_Ch_Index;
;	mode -> Y+0
	MOV  R30,R4
	ORI  R30,0x20
	OUT  0x7,R30
;     929 	ADCSRA=mode;     
	LD   R30,Y
	OUT  0x6,R30
;     930 }		
	ADIW R28,1
	RET
;     931 
;     932 
;     933 //------------------------------------------------------------------------------
;     934 // 전원 검사
;     935 //------------------------------------------------------------------------------
;     936 void DetectPower(void)
;     937 {
_DetectPower:
;     938 	if(F_DOWNLOAD) return;
	SBRC R2,4
	RET
;     939 	if(F_PS_PLUGGED){
	SBRS R2,5
	RJMP _0xE1
;     940 		if(gVOLTAGE >= U_T_OF_POWER)
	LDI  R30,LOW(9650)
	LDI  R31,HIGH(9650)
	CP   R5,R30
	CPC  R6,R31
	BRLO _0xE2
;     941 			gPSunplugCount = 0;
	CALL SUBOPT_0x32
;     942 		else
	RJMP _0xE3
_0xE2:
;     943 			gPSunplugCount++;
	LDS  R30,_gPSunplugCount
	LDS  R31,_gPSunplugCount+1
	ADIW R30,1
	STS  _gPSunplugCount,R30
	STS  _gPSunplugCount+1,R31
;     944 		if(gPSunplugCount > 6){
_0xE3:
	LDS  R26,_gPSunplugCount
	LDS  R27,_gPSunplugCount+1
	SBIW R26,7
	BRLO _0xE4
;     945 			F_PS_PLUGGED = 0;
	CLT
	BLD  R2,5
;     946 			gPSunplugCount = 0;
	CALL SUBOPT_0x32
;     947 		}
;     948 	}
_0xE4:
;     949 	else{
	RJMP _0xE5
_0xE1:
;     950 		if(gVOLTAGE >= U_T_OF_POWER){
	LDI  R30,LOW(9650)
	LDI  R31,HIGH(9650)
	CP   R5,R30
	CPC  R6,R31
	BRLO _0xE6
;     951 			gPSunplugCount = 0;
	CALL SUBOPT_0x32
;     952 			gPSplugCount++;
	LDS  R30,_gPSplugCount
	LDS  R31,_gPSplugCount+1
	ADIW R30,1
	STS  _gPSplugCount,R30
	STS  _gPSplugCount+1,R31
;     953 		}
;     954 		else{
	RJMP _0xE7
_0xE6:
;     955 			gPSplugCount = 0;
	LDI  R30,0
	STS  _gPSplugCount,R30
	STS  _gPSplugCount+1,R30
;     956 		}
_0xE7:
;     957 
;     958 		if(gPSplugCount>2){
	LDS  R26,_gPSplugCount
	LDS  R27,_gPSplugCount+1
	SBIW R26,3
	BRLO _0xE8
;     959 			F_PS_PLUGGED = 1;
	SET
	BLD  R2,5
;     960 			gPSplugCount = 0;
	LDI  R30,0
	STS  _gPSplugCount,R30
	STS  _gPSplugCount+1,R30
;     961 		}
;     962 	}
_0xE8:
_0xE5:
;     963 }
	RET
;     964 
;     965 
;     966 //-----------------------------------------------------------------------------
;     967 // NiMH 배터리 충전
;     968 //-----------------------------------------------------------------------------
;     969 void ChargeNiMH(void)
;     970 {
_ChargeNiMH:
;     971 	F_CHARGING = 1;
	SET
	BLD  R2,6
;     972 	gMIN_DCOUNT = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x2D
;     973 	while(gMIN_DCOUNT){
_0xE9:
	CALL SUBOPT_0x2C
	SBIW R30,0
	BREQ _0xEB
;     974 		PWR_LED2_OFF;
	SBI  0x15,7
;     975 		PWR_LED1_ON;
	CALL SUBOPT_0x33
;     976 		Get_VOLTAGE();	DetectPower();
	CALL SUBOPT_0x34
;     977 		if(F_PS_PLUGGED == 0) break;
	SBRS R2,5
	RJMP _0xEB
;     978 		CHARGE_ENABLE;
	SBI  0x18,4
;     979 		delay_ms(40);
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x25
;     980 		CHARGE_DISABLE;
	CBI  0x18,4
;     981 		delay_ms(500-40);
	LDI  R30,LOW(460)
	LDI  R31,HIGH(460)
	CALL SUBOPT_0x25
;     982 		PWR_LED1_OFF;
	CALL SUBOPT_0x35
;     983 		Get_VOLTAGE();	DetectPower();
	CALL SUBOPT_0x34
;     984 		if(F_PS_PLUGGED == 0) break;
	SBRS R2,5
	RJMP _0xEB
;     985 		delay_ms(500);
	CALL SUBOPT_0x36
;     986 	}
	RJMP _0xE9
_0xEB:
;     987 	gMIN_DCOUNT = 85;
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	CALL SUBOPT_0x2D
;     988 	while(gMIN_DCOUNT){
_0xEE:
	CALL SUBOPT_0x2C
	SBIW R30,0
	BREQ _0xF0
;     989 		PWR_LED2_OFF;
	SBI  0x15,7
;     990 		if(g10MSEC > 50)	PWR_LED1_ON;
	CALL SUBOPT_0x29
	SBIW R26,51
	BRLO _0xF1
	LDS  R30,101
	ANDI R30,0xFB
	RJMP _0x338
;     991 		else			PWR_LED1_OFF;
_0xF1:
	LDS  R30,101
	ORI  R30,4
_0x338:
	STS  101,R30
;     992 		if(g10MSEC == 0 || g10MSEC == 50){
	CALL SUBOPT_0x37
	BREQ _0xF4
	CALL SUBOPT_0x29
	SBIW R26,50
	BRNE _0xF3
_0xF4:
;     993 			Get_VOLTAGE();
	CALL SUBOPT_0x34
;     994 			DetectPower();
;     995 		}
;     996 		if(F_PS_PLUGGED == 0) break;
_0xF3:
	SBRS R2,5
	RJMP _0xF0
;     997 		CHARGE_ENABLE;
	SBI  0x18,4
;     998 	}
	RJMP _0xEE
_0xF0:
;     999 	CHARGE_DISABLE;
	CBI  0x18,4
;    1000 	F_CHARGING = 0;
	CLT
	BLD  R2,6
;    1001 }
	RET
;    1002 
;    1003 
;    1004 //------------------------------------------------------------------------------
;    1005 // 하드웨어 초기화
;    1006 //------------------------------------------------------------------------------
;    1007 void HW_init(void) {
_HW_init:
;    1008 	// Input/Output Ports initialization
;    1009 	// Port A initialization
;    1010 	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
;    1011 	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=P State0=P 
;    1012 	PORTA=0x03;
	LDI  R30,LOW(3)
	OUT  0x1B,R30
;    1013 	DDRA=0xFC;
	LDI  R30,LOW(252)
	OUT  0x1A,R30
;    1014 
;    1015 	// Port B initialization
;    1016 	// Func7=In Func6=Out Func5=Out Func4=Out Func3=In Func2=Out Func1=In Func0=In 
;    1017 	// State7=T State6=0 State5=0 State4=0 State3=T State2=0 State1=T State0=T 
;    1018 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;    1019 	DDRB=0x74;
	LDI  R30,LOW(116)
	OUT  0x17,R30
;    1020 
;    1021 	// Port C initialization
;    1022 	// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;    1023 	// State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;    1024 	PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    1025 	DDRC=0x80;
	LDI  R30,LOW(128)
	OUT  0x14,R30
;    1026 
;    1027 	// Port D initialization
;    1028 	// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;    1029 	// State7=1 State6=T State5=T State4=T State3=T State2=T State1=P State0=P 
;    1030 	PORTD=0x83;
	LDI  R30,LOW(131)
	OUT  0x12,R30
;    1031 	DDRD=0x80;
	LDI  R30,LOW(128)
	OUT  0x11,R30
;    1032 
;    1033 	// Port E initialization
;    1034 	// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In 
;    1035 	// State7=T State6=T State5=P State4=P State3=0 State2=T State1=T State0=T 
;    1036 	PORTE=0x30;
	LDI  R30,LOW(48)
	OUT  0x3,R30
;    1037 	DDRE=0x08;
	LDI  R30,LOW(8)
	OUT  0x2,R30
;    1038 
;    1039     // Port F initialization
;    1040     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;    1041     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;    1042     PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
;    1043     DDRF=0x00;
	STS  97,R30
;    1044 
;    1045 	// Port G initialization
;    1046 	// Func4=In Func3=In Func2=Out Func1=In Func0=In 
;    1047 	// State4=T State3=T State2=0 State1=T State0=T 
;    1048 	PORTG=0x00;
	STS  101,R30
;    1049 	DDRG=0x04;
	LDI  R30,LOW(4)
	STS  100,R30
;    1050 
;    1051     // Timer/Counter 0 initialization
;    1052     // Clock source: System Clock
;    1053     // Clock value: 14.400 kHz
;    1054     // Mode: Normal top=FFh
;    1055     // OC0 output: Disconnected
;    1056     ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1057     TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
;    1058     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;    1059     OCR0=0x00;
	OUT  0x31,R30
;    1060 
;    1061 	// Timer/Counter 1 initialization
;    1062 	// Clock source: System Clock
;    1063 	// Clock value: 14.400 kHz
;    1064 	// Mode: Normal top=FFFFh
;    1065 	// OC1A output: Discon.
;    1066 	// OC1B output: Discon.
;    1067 	// OC1C output: Discon.
;    1068 	// Noise Canceler: Off
;    1069 	// Input Capture on Falling Edge
;    1070 	// Timer 1 Overflow Interrupt: On
;    1071 	// Input Capture Interrupt: Off
;    1072 	// Compare A Match Interrupt: Off
;    1073 	// Compare B Match Interrupt: Off
;    1074 	// Compare C Match Interrupt: Off
;    1075 	TCCR1A=0x00;
	OUT  0x2F,R30
;    1076 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;    1077 	TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;    1078 	TCNT1L=0x00;
	OUT  0x2C,R30
;    1079 	ICR1H=0x00;
	OUT  0x27,R30
;    1080 	ICR1L=0x00;
	OUT  0x26,R30
;    1081 	OCR1AH=0x00;
	OUT  0x2B,R30
;    1082 	OCR1AL=0x00;
	OUT  0x2A,R30
;    1083 	OCR1BH=0x00;
	OUT  0x29,R30
;    1084 	OCR1BL=0x00;
	OUT  0x28,R30
;    1085 	OCR1CH=0x00;
	STS  121,R30
;    1086 	OCR1CL=0x00;
	STS  120,R30
;    1087 
;    1088 	// 타이머 2---------------------------------------------------------------
;    1089     // Timer/Counter 2 initialization
;    1090     // Clock source: System Clock
;    1091     // Clock value: 14.400 kHz
;    1092     // Mode: Normal top=FFh
;    1093     // OC2 output: Disconnected
;    1094     TCCR2=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
;    1095     TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
;    1096     OCR2=0x00;
	OUT  0x23,R30
;    1097 
;    1098 	// 타이머 3---------------------------------------------------------------
;    1099 	// Timer/Counter 3 initialization
;    1100 	// Clock source: System Clock
;    1101 	// Clock value: 230.400 kHz
;    1102 	// Mode: Normal top=FFFFh
;    1103 	// Noise Canceler: Off
;    1104 	// Input Capture on Falling Edge
;    1105 	// OC3A output: Discon.
;    1106 	// OC3B output: Discon.
;    1107 	// OC3C output: Discon.
;    1108 	// Timer 3 Overflow Interrupt: Off
;    1109 	// Input Capture Interrupt: Off
;    1110 	// Compare A Match Interrupt: Off
;    1111 	// Compare B Match Interrupt: Off
;    1112 	// Compare C Match Interrupt: Off
;    1113 	TCCR3A=0x00;
	STS  139,R30
;    1114 	TCCR3B=0x03;
	LDI  R30,LOW(3)
	STS  138,R30
;    1115 	TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
;    1116 	TCNT3L=0x00;
	STS  136,R30
;    1117 	ICR3H=0x00;
	STS  129,R30
;    1118 	ICR3L=0x00;
	STS  128,R30
;    1119 	OCR3AH=0x00;
	STS  135,R30
;    1120 	OCR3AL=0x00;
	STS  134,R30
;    1121 	OCR3BH=0x00;
	STS  133,R30
;    1122 	OCR3BL=0x00;
	STS  132,R30
;    1123 	OCR3CH=0x00;
	STS  131,R30
;    1124 	OCR3CL=0x00;
	STS  130,R30
;    1125 
;    1126 	// External Interrupt(s) initialization
;    1127 	// INT0: Off
;    1128 	// INT1: Off
;    1129 	// INT2: Off
;    1130 	// INT3: Off
;    1131 	// INT4: Off
;    1132 	// INT5: Off
;    1133 	// INT6: On
;    1134 	// INT6 Mode: Falling Edge
;    1135 	// INT7: Off
;    1136 	EICRA=0x00;
	STS  106,R30
;    1137 	EICRB=0x20;
	LDI  R30,LOW(32)
	OUT  0x3A,R30
;    1138 	EIMSK=0x40;
	LDI  R30,LOW(64)
	OUT  0x39,R30
;    1139 	EIFR=0x40;
	OUT  0x38,R30
;    1140 
;    1141     // Timer(s)/Counter(s) Interrupt(s) initialization
;    1142     TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
;    1143     ETIMSK=0x00;
	STS  125,R30
;    1144 
;    1145     // USART0 initialization
;    1146     // Communication Parameters: 8 Data, 1 Stop, No Parity
;    1147     // USART0 Receiver: On
;    1148     // USART0 Transmitter: On
;    1149     // USART0 Mode: Asynchronous
;    1150     // USART0 Baud rate: 115200
;    1151     UCSR0A=0x00;
	OUT  0xB,R30
;    1152 	UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
;    1153     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
;    1154     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;    1155 	UBRR0L=BR115200;
	LDI  R30,LOW(7)
	OUT  0x9,R30
;    1156 
;    1157     // USART1 initialization
;    1158     // Communication Parameters: 8 Data, 1 Stop, No Parity
;    1159     // USART1 Receiver: On
;    1160     // USART1 Transmitter: On
;    1161     // USART1 Mode: Asynchronous
;    1162     // USART1 Baud rate: 115200
;    1163     UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
;    1164     UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
;    1165     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;    1166     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
;    1167 	UBRR1L=BR115200;
	LDI  R30,LOW(7)
	STS  153,R30
;    1168 
;    1169 	// Analog Comparator initialization
;    1170 	// Analog Comparator: Off
;    1171 	// Analog Comparator Input Capture by Timer/Counter 1: Off
;    1172 	// Analog Comparator Output: Off
;    1173 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    1174 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;    1175 
;    1176     //ADC initialization
;    1177     //ADC Clock frequency: 460.800 kHz
;    1178     //ADC Voltage Reference: AREF pin
;    1179     //Only the 8 most significant bits of
;    1180     //the AD conversion result are used
;    1181     ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(32)
	OUT  0x7,R30
;    1182     ADCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x6,R30
;    1183     
;    1184     TWCR = 0;
	STS  116,R30
;    1185 }
	RET
;    1186 
;    1187 
;    1188 //------------------------------------------------------------------------------
;    1189 // 플래그 초기화
;    1190 //------------------------------------------------------------------------------
;    1191 void SW_init(void) {
_SW_init:
;    1192 	PF1_LED1_OFF;
	SBI  0x1B,2
;    1193 	PF1_LED2_OFF;
	SBI  0x1B,3
;    1194 	PF2_LED_OFF;
	SBI  0x1B,4
;    1195 	PWR_LED1_OFF;
	CALL SUBOPT_0x35
;    1196 	PWR_LED2_OFF;
	SBI  0x15,7
;    1197 	RUN_LED1_OFF;
	SBI  0x1B,5
;    1198 	RUN_LED2_OFF;
	SBI  0x1B,6
;    1199 	ERR_LED_OFF;
	SBI  0x1B,7
;    1200 	F_PF = ePF;
	LDI  R26,LOW(_ePF)
	LDI  R27,HIGH(_ePF)
	CALL __EEPROMRDB
	MOV  R12,R30
;    1201 	F_SCENE_PLAYING = 0;
	CLT
	BLD  R2,0
;    1202 	F_ACTION_PLAYING = 0;
	BLD  R2,1
;    1203 	F_MOTION_STOPPED = 0;
	BLD  R2,3
;    1204 	F_DIRECT_C_EN = 0;
	BLD  R2,2
;    1205 	F_CHARGING = 0;
	BLD  R2,6
;    1206 	F_MIC_INPUT = 0;
	BLD  R3,0
;    1207 	F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;    1208 	F_DOWNLOAD = 0;
	BLD  R2,4
;    1209 
;    1210 	gTx0Cnt = 0;
	LDI  R30,LOW(0)
	STS  _gTx0Cnt,R30
;    1211 	gTx0BufIdx = 0;
	STS  _gTx0BufIdx,R30
;    1212 	PSD_OFF;
	CBI  0x18,5
;    1213     g10MSEC=0;
	LDI  R30,0
	STS  _g10MSEC,R30
	STS  _g10MSEC+1,R30
;    1214     gSEC=0;
	LDI  R30,LOW(0)
	STS  _gSEC,R30
;    1215     gMIN=0;
	STS  _gMIN,R30
;    1216     gHOUR=0;
	STS  _gHOUR,R30
;    1217     F_PS_PLUGGED = 0;
	BLD  R2,5
;    1218     F_PF_CHANGED = 0;
	BLD  R3,1
;    1219     F_IR_RECEIVED = 0;
	BLD  R3,2
;    1220     F_EEPROM_BUSY = 0;
	CLR  R14
;    1221 	P_EEP_VCC(1);
	SBI  0x18,2
;    1222 
;    1223 	gDownNumOfM = 0;
	STS  _gDownNumOfM,R30
;    1224 	gDownNumOfA = 0;
	STS  _gDownNumOfA,R30
;    1225 	F_FIRST_M = 1;
	SET
	BLD  R3,3
;    1226 }
	RET
;    1227 
;    1228 
;    1229 void SpecialMode(void)
;    1230 {
_SpecialMode:
;    1231 	int i;
;    1232 
;    1233 	if(F_PF == PF1_HUNO)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xF9
;    1234 		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	__GETWRN 16,17,0
_0xFB:
	__CPWRN 16,17,16
	BRGE _0xFC
	CALL SUBOPT_0x38
;    1235 	else if(F_PF == PF1_DINO)
	__ADDWRN 16,17,1
	RJMP _0xFB
_0xFC:
	RJMP _0xFD
_0xF9:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xFE
;    1236 		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	__GETWRN 16,17,0
_0x100:
	__CPWRN 16,17,16
	BRGE _0x101
	CALL SUBOPT_0x38
;    1237 	else if(F_PF == PF1_DOGY)
	__ADDWRN 16,17,1
	RJMP _0x100
_0x101:
	RJMP _0x102
_0xFE:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x103
;    1238 		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	__GETWRN 16,17,0
_0x105:
	__CPWRN 16,17,16
	BRGE _0x106
	CALL SUBOPT_0x38
;    1239 	else if(F_PF == PF2)
	__ADDWRN 16,17,1
	RJMP _0x105
_0x106:
	RJMP _0x107
_0x103:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x108
;    1240 		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	__GETWRN 16,17,0
_0x10A:
	__CPWRN 16,17,16
	BRGE _0x10B
	CALL SUBOPT_0x38
;    1241 
;    1242 	BreakModeCmdSend();
	__ADDWRN 16,17,1
	RJMP _0x10A
_0x10B:
_0x108:
_0x107:
_0x102:
_0xFD:
	RCALL _BreakModeCmdSend
;    1243 	delay_ms(10);
	CALL SUBOPT_0x39
;    1244 	
;    1245 	if(PINA.0 == 0 && PINA.1 == 1){
	SBIC 0x19,0
	RJMP _0x10D
	SBIC 0x19,1
	RJMP _0x10E
_0x10D:
	RJMP _0x10C
_0x10E:
;    1246 		BasicPose(0, 150, 3000, 4);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CALL SUBOPT_0x3A
;    1247 		delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x25
;    1248 		if(F_ERR_CODE != NO_ERR){
	LDI  R30,LOW(255)
	CP   R30,R13
	BREQ _0x10F
;    1249 			gSEC_DCOUNT = 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x2B
;    1250 			EIMSK &= 0xBF;
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;    1251 			while(gSEC_DCOUNT){
_0x110:
	CALL SUBOPT_0x2A
	SBIW R30,0
	BREQ _0x112
;    1252 				if(g10MSEC < 25)		ERR_LED_ON;
	CALL SUBOPT_0x29
	SBIW R26,25
	BRSH _0x113
	CBI  0x1B,7
;    1253 				else if(g10MSEC < 50)	ERR_LED_OFF;
	RJMP _0x114
_0x113:
	CALL SUBOPT_0x29
	SBIW R26,50
	BRSH _0x115
	RJMP _0x339
;    1254 				else if(g10MSEC < 75)	ERR_LED_ON;
_0x115:
	CALL SUBOPT_0x3B
	BRSH _0x117
	CBI  0x1B,7
;    1255 				else if(g10MSEC < 100)	ERR_LED_OFF;
	RJMP _0x118
_0x117:
	CALL SUBOPT_0x3C
	BRSH _0x119
_0x339:
	SBI  0x1B,7
;    1256 			}
_0x119:
_0x118:
_0x114:
	RJMP _0x110
_0x112:
;    1257 			F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;    1258 			EIMSK |= 0x40;
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    1259 		}
;    1260 		else BasicPose(0, 1, 100, 1);
	RJMP _0x11A
_0x10F:
	CALL SUBOPT_0x3D
;    1261 	}
_0x11A:
;    1262 	else if(PINA.0 == 1 && PINA.1 == 0){
	RJMP _0x11B
_0x10C:
	SBIS 0x19,0
	RJMP _0x11D
	SBIS 0x19,1
	RJMP _0x11E
_0x11D:
	RJMP _0x11C
_0x11E:
;    1263 		delay_ms(10);
	CALL SUBOPT_0x39
;    1264 		if(PINA.0 == 1){
	SBIS 0x19,0
	RJMP _0x11F
;    1265 		    TIMSK &= 0xFE;
	CALL SUBOPT_0x22
;    1266 			EIMSK &= 0xBF;
;    1267 			UCSR0B |= 0x80;
;    1268 			UCSR0B &= 0xBF;
;    1269 			F_DIRECT_C_EN = 1;
;    1270 		}
;    1271 	}
_0x11F:
;    1272 	else if(PINA.0 == 0 && PINA.1 == 0){
	RJMP _0x120
_0x11C:
	SBIC 0x19,0
	RJMP _0x122
	SBIS 0x19,1
	RJMP _0x123
_0x122:
	RJMP _0x121
_0x123:
;    1273 		while(gSEC < 11){
_0x124:
	LDS  R26,_gSEC
	CPI  R26,LOW(0xB)
	BRLO PC+3
	JMP _0x126
;    1274 			if(g10MSEC > 50){	RUN_LED1_OFF;	RUN_LED2_OFF;	}
	CALL SUBOPT_0x29
	SBIW R26,51
	BRLO _0x127
	SBI  0x1B,5
	SBI  0x1B,6
;    1275 			else{				RUN_LED1_ON;	RUN_LED2_ON;	}
	RJMP _0x128
_0x127:
	CBI  0x1B,5
	CBI  0x1B,6
_0x128:
;    1276 			if(F_IR_RECEIVED){
	SBRS R3,2
	RJMP _0x129
;    1277 			    EIMSK &= 0xBF;
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;    1278 				F_IR_RECEIVED = 0;
	CLT
	BLD  R3,2
;    1279 				if(gIrBuf[3] == BTN_C){
	__GETB1MN _gIrBuf,3
	CPI  R30,LOW(0x7)
	BREQ PC+3
	JMP _0x12A
;    1280 					for(i = 1; i < NUM_OF_REMOCON; i++){
	__GETWRN 16,17,1
_0x12C:
	__CPWRN 16,17,5
	BRGE _0x12D
;    1281 						eRCodeH[i-1] = eRCodeH[i];
	MOVW R30,R16
	SBIW R30,1
	SUBI R30,LOW(-_eRCodeH)
	SBCI R31,HIGH(-_eRCodeH)
	MOVW R0,R30
	LDI  R26,LOW(_eRCodeH)
	LDI  R27,HIGH(_eRCodeH)
	CALL SUBOPT_0x3E
;    1282 						eRCodeM[i-1] = eRCodeM[i];
	SUBI R30,LOW(-_eRCodeM)
	SBCI R31,HIGH(-_eRCodeM)
	MOVW R0,R30
	LDI  R26,LOW(_eRCodeM)
	LDI  R27,HIGH(_eRCodeM)
	CALL SUBOPT_0x3E
;    1283 						eRCodeL[i-1] = eRCodeL[i];
	SUBI R30,LOW(-_eRCodeL)
	SBCI R31,HIGH(-_eRCodeL)
	MOVW R0,R30
	LDI  R26,LOW(_eRCodeL)
	LDI  R27,HIGH(_eRCodeL)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
;    1284 					}
	__ADDWRN 16,17,1
	RJMP _0x12C
_0x12D:
;    1285 					eRCodeH[NUM_OF_REMOCON-1] = gIrBuf[0]; 
	__POINTW2MN _eRCodeH,4
	LDS  R30,_gIrBuf
	CALL __EEPROMWRB
;    1286 					eRCodeM[NUM_OF_REMOCON-1] = gIrBuf[1]; 
	__POINTW2MN _eRCodeM,4
	__GETB1MN _gIrBuf,1
	CALL __EEPROMWRB
;    1287 					eRCodeL[NUM_OF_REMOCON-1] = gIrBuf[2];
	__POINTW2MN _eRCodeL,4
	__GETB1MN _gIrBuf,2
	CALL __EEPROMWRB
;    1288 
;    1289 					for(i = 0; i < 3; i++){
	__GETWRN 16,17,0
_0x12F:
	__CPWRN 16,17,3
	BRGE _0x130
;    1290 						PF1_LED1_ON; PF1_LED2_ON; PF2_LED_ON; RUN_LED1_ON; 
	CBI  0x1B,2
	CBI  0x1B,3
	CBI  0x1B,4
	CBI  0x1B,5
;    1291 						RUN_LED2_ON; ERR_LED_ON; PWR_LED1_ON; PWR_LED2_ON;
	CBI  0x1B,6
	CBI  0x1B,7
	CALL SUBOPT_0x33
	CBI  0x15,7
;    1292 						delay_ms(500);
	CALL SUBOPT_0x36
;    1293 						PF1_LED1_OFF; PF1_LED2_OFF; PF2_LED_OFF; RUN_LED1_OFF; 
	SBI  0x1B,2
	SBI  0x1B,3
	SBI  0x1B,4
	SBI  0x1B,5
;    1294 						RUN_LED2_OFF; ERR_LED_OFF; PWR_LED1_OFF; PWR_LED2_ON;
	SBI  0x1B,6
	SBI  0x1B,7
	CALL SUBOPT_0x35
	CBI  0x15,7
;    1295 						delay_ms(500);
	CALL SUBOPT_0x36
;    1296 					}
	__ADDWRN 16,17,1
	RJMP _0x12F
_0x130:
;    1297 
;    1298 					for(i = 0; i < IR_BUFFER_SIZE; i++)	gIrBuf[i]=0;
	__GETWRN 16,17,0
_0x132:
	__CPWRN 16,17,4
	BRGE _0x133
	CALL SUBOPT_0x3F
;    1299 				    EIMSK |= 0x40;
	__ADDWRN 16,17,1
	RJMP _0x132
_0x133:
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    1300 					break;
	RJMP _0x126
;    1301 				}
;    1302 				for(i = 0; i < IR_BUFFER_SIZE; i++)	gIrBuf[i]=0;
_0x12A:
	__GETWRN 16,17,0
_0x135:
	__CPWRN 16,17,4
	BRGE _0x136
	CALL SUBOPT_0x3F
;    1303 			    EIMSK |= 0x40;
	__ADDWRN 16,17,1
	RJMP _0x135
_0x136:
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    1304 			}
;    1305 		}
_0x129:
	RJMP _0x124
_0x126:
;    1306 	}
;    1307 }
_0x121:
_0x120:
_0x11B:
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1308 
;    1309 void ProcComm(void)
;    1310 {
_ProcComm:
;    1311    	BYTE	lbtmp;
;    1312    	
;    1313     if(F_RSV_PSD_READ){
	ST   -Y,R16
;	lbtmp -> R16
	SBRS R3,7
	RJMP _0x137
;    1314 			F_RSV_PSD_READ = 0;
	CLT
	BLD  R3,7
;    1315 			Get_AD_PSD();
	RCALL _Get_AD_PSD
;    1316 			SendToPC(22,2);
	LDI  R30,LOW(22)
	CALL SUBOPT_0x23
;    1317 			gFileCheckSum = 0;
;    1318 			sciTx1Data(gDistance);
	ST   -Y,R7
	CALL SUBOPT_0x40
;    1319 			sciTx1Data(0);
;    1320 			gFileCheckSum ^= gDistance;
	MOV  R30,R7
	CALL SUBOPT_0xA
;    1321 			sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;    1322 		}
;    1323 		if(F_RSV_SOUND_READ){
_0x137:
	SBRS R3,5
	RJMP _0x138
;    1324 			Get_AD_MIC();
	RCALL _Get_AD_MIC
;    1325 			if(gSoundMinTh <= gSoundLevel){
	LDS  R26,_gSoundMinTh
	CP   R8,R26
	BRLO _0x139
;    1326 				SendToPC(23,2);
	LDI  R30,LOW(23)
	CALL SUBOPT_0x23
;    1327 				gFileCheckSum = 0;
;    1328 				sciTx1Data(gSoundLevel);
	ST   -Y,R8
	CALL SUBOPT_0x40
;    1329 				sciTx1Data(0);
;    1330 				gFileCheckSum ^= gSoundLevel;
	MOV  R30,R8
	CALL SUBOPT_0xA
;    1331 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;    1332 			}
;    1333 		}
_0x139:
;    1334 		if(F_RSV_BTN_READ){
_0x138:
	SBRS R3,6
	RJMP _0x13A
;    1335 			lbtmp = PINA & 0x03;
	IN   R30,0x19
	ANDI R30,LOW(0x3)
	MOV  R16,R30
;    1336 			if(lbtmp == 0x02){	
	CPI  R16,2
	BRNE _0x13B
;    1337 				delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x25
;    1338 				if(lbtmp == 0x02){
	CPI  R16,2
	BRNE _0x13C
;    1339 					SendToPC(24,2);
	LDI  R30,LOW(24)
	CALL SUBOPT_0x23
;    1340 					gFileCheckSum = 0;
;    1341 					sciTx1Data(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x40
;    1342 					sciTx1Data(0);
;    1343 					gFileCheckSum ^= 1;
	LDS  R26,_gFileCheckSum
	CALL SUBOPT_0x21
;    1344 					sciTx1Data(gFileCheckSum);
;    1345 					delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x25
;    1346 				}
;    1347 			}
_0x13C:
;    1348 			else if(lbtmp == 0x01){
	RJMP _0x13D
_0x13B:
	CPI  R16,1
	BRNE _0x13E
;    1349 				delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x25
;    1350 				if(lbtmp == 0x01){
	CPI  R16,1
	BRNE _0x13F
;    1351 					SendToPC(24,2);
	LDI  R30,LOW(24)
	CALL SUBOPT_0x23
;    1352 					gFileCheckSum = 0;
;    1353 					sciTx1Data(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL SUBOPT_0x40
;    1354 					sciTx1Data(0);
;    1355 					gFileCheckSum ^= 2;
	LDS  R26,_gFileCheckSum
	LDI  R30,LOW(2)
	EOR  R30,R26
	STS  _gFileCheckSum,R30
;    1356 					sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;    1357 					delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x25
;    1358 				}
;    1359 			}
_0x13F:
;    1360 		}
_0x13E:
_0x13D:
;    1361 }
_0x13A:
	LD   R16,Y+
	RET
;    1362 
;    1363 void Robot_Turn_Left_90(void)
;    1364 {
_Robot_Turn_Left_90:
;    1365     M_Play(BTN_LR);M_Play(BTN_LR);M_Play(BTN_LR);
	CALL SUBOPT_0x41
	CALL SUBOPT_0x41
	CALL SUBOPT_0x41
;    1366 }
	RET
;    1367 
;    1368 void Robot_Turn_Left_180(void)
;    1369 {
_Robot_Turn_Left_180:
;    1370     M_Play(BTN_LR);M_Play(BTN_LR);M_Play(BTN_LR);
	CALL SUBOPT_0x41
	CALL SUBOPT_0x41
	CALL SUBOPT_0x41
;    1371     M_Play(BTN_LR);M_Play(BTN_LR);
	CALL SUBOPT_0x41
	CALL SUBOPT_0x41
;    1372 }
	RET
;    1373 
;    1374 void Robot_Turn_Right_90(void)
;    1375 {
_Robot_Turn_Right_90:
;    1376     M_Play(BTN_RR);M_Play(BTN_RR);M_Play(BTN_RR);M_Play(BTN_LR);
	CALL SUBOPT_0x42
	CALL SUBOPT_0x42
	CALL SUBOPT_0x42
	CALL SUBOPT_0x41
;    1377 }
	RET
;    1378 
;    1379 void Robot_Forward(void)
;    1380 {
_Robot_Forward:
;    1381     M_Play(BTN_U);  M_Play(BTN_U);    M_Play(BTN_RR);
	CALL SUBOPT_0x43
	CALL SUBOPT_0x43
	CALL SUBOPT_0x42
;    1382 }
	RET
;    1383 
;    1384 void Robot_Backward(void)
;    1385 {
_Robot_Backward:
;    1386     M_Play(BTN_D);
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _M_Play
;    1387 }
	RET
;    1388 
;    1389 void User_Func(void)
;    1390 {
_User_Func:
;    1391     while(1){
_0x140:
;    1392         Get_AD_PSD();
	RCALL _Get_AD_PSD
;    1393         if( gDistance <= 12 )   Robot_Backward();
	LDI  R30,LOW(12)
	CP   R30,R7
	BRLO _0x143
	CALL _Robot_Backward
;    1394         else if( gDistance <= 30 ){ 
	RJMP _0x144
_0x143:
	LDI  R30,LOW(30)
	CP   R30,R7
	BRLO _0x145
;    1395             Robot_Turn_Left_90();
	CALL _Robot_Turn_Left_90
;    1396             Get_AD_PSD();
	RCALL _Get_AD_PSD
;    1397             if((gDistance <= 30)){  Robot_Turn_Left_180();
	LDI  R30,LOW(30)
	CP   R30,R7
	BRLO _0x146
	CALL _Robot_Turn_Left_180
;    1398                  Get_AD_PSD();
	RCALL _Get_AD_PSD
;    1399                  if((gDistance <= 30))  Robot_Turn_Right_90();
	LDI  R30,LOW(30)
	CP   R30,R7
	BRLO _0x147
	CALL _Robot_Turn_Right_90
;    1400             }
_0x147:
;    1401         }
_0x146:
;    1402         else{    Robot_Forward();
	RJMP _0x148
_0x145:
	CALL _Robot_Forward
;    1403         }
_0x148:
_0x144:
;    1404     }
	RJMP _0x140
;    1405 
;    1406 }
;    1407 
;    1408 //------------------------------------------------------------------------------
;    1409 // 메인 함수
;    1410 //------------------------------------------------------------------------------
;    1411 void main(void) {
_main:
;    1412 	WORD    l10MSEC;
;    1413 
;    1414 	HW_init();
;	l10MSEC -> R16,R17
	CALL _HW_init
;    1415 	SW_init();
	CALL _SW_init
;    1416 	Acc_init();
	RCALL _Acc_init
;    1417 
;    1418 	#asm("sei");
	sei
;    1419 	TIMSK |= 0x01;
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
;    1420 
;    1421 	SpecialMode();
	CALL _SpecialMode
;    1422 
;    1423 	P_BMC504_RESET(0);
	CBI  0x18,6
;    1424 	delay_ms(20);
	CALL SUBOPT_0x44
;    1425 	P_BMC504_RESET(1);
	SBI  0x18,6
;    1426 
;    1427 	SelfTest1();
	CALL _SelfTest1
;    1428 	while(1){
_0x14D:
;    1429 		ReadButton();
	CALL _ReadButton
;    1430 		ProcButton();
	CALL _ProcButton
;    1431 		IoUpdate();
	CALL _IoUpdate
;    1432 		if(g10MSEC == 0 || g10MSEC == 50){
	CALL SUBOPT_0x37
	BREQ _0x151
	CALL SUBOPT_0x29
	SBIW R26,50
	BRNE _0x150
_0x151:
;    1433 			if(g10MSEC != l10MSEC){
	CALL SUBOPT_0x29
	CP   R16,R26
	CPC  R17,R27
	BREQ _0x153
;    1434 				l10MSEC = g10MSEC;
	__GETWRMN 16,17,0,_g10MSEC
;    1435 				Get_VOLTAGE();
	CALL SUBOPT_0x34
;    1436 				DetectPower();
;    1437 			}
;    1438 		}
_0x153:
;    1439 		ProcIr();
_0x150:
	CALL _ProcIr
;    1440 		AccGetData();
	RCALL _AccGetData
;    1441 		ProcComm();
	CALL _ProcComm
;    1442 	}
	RJMP _0x14D
;    1443 }
_0x154:
	RJMP _0x154
;    1444 #include <mega128.h>
;    1445 #include "Main.h"
;    1446 #include "Macro.h"
;    1447 #include "accel.h"
;    1448 
;    1449 //==============================================================//
;    1450 // Start
;    1451 //==============================================================//
;    1452 void AccStart(void)
;    1453 {
_AccStart:
;    1454 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1455 SCK_SET_OUTPUT;
	SBI  0x2,4
;    1456 	P_ACC_SDI(1);
	SBI  0x3,5
;    1457 	P_ACC_SCK(1);
	SBI  0x3,4
;    1458 	#asm("nop");
	nop
;    1459 	#asm("nop");
	nop
;    1460 	P_ACC_SDI(0);
	CBI  0x3,5
;    1461 	#asm("nop");
	nop
;    1462 	#asm("nop");
	nop
;    1463 	P_ACC_SCK(0);
	CBI  0x3,4
;    1464 	#asm("nop");
	nop
;    1465 	#asm("nop");
	nop
;    1466 }
	RET
;    1467 
;    1468 
;    1469 //==============================================================//
;    1470 // Stop
;    1471 //==============================================================//
;    1472 void AccStop(void)
;    1473 {
_AccStop:
;    1474 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1475 SCK_SET_OUTPUT;
	SBI  0x2,4
;    1476 	P_ACC_SDI(0);
	CBI  0x3,5
;    1477 	P_ACC_SCK(1);
	SBI  0x3,4
;    1478 	#asm("nop");
	nop
;    1479 	#asm("nop");
	nop
;    1480 	P_ACC_SDI(1);
	SBI  0x3,5
;    1481 	#asm("nop");
	nop
;    1482 	#asm("nop");
	nop
;    1483 SDI_SET_INPUT;
	CBI  0x2,5
;    1484 SCK_SET_INPUT;
	CBI  0x2,4
;    1485 }
	RET
;    1486 
;    1487 
;    1488 //==============================================================//
;    1489 //
;    1490 //==============================================================//
;    1491 void AccByteWrite(BYTE bData)
;    1492 {
_AccByteWrite:
;    1493 	BYTE	i;
;    1494 	BYTE	bTmp;
;    1495 
;    1496 SDI_SET_OUTPUT;
	ST   -Y,R17
	ST   -Y,R16
;	bData -> Y+2
;	i -> R16
;	bTmp -> R17
	SBI  0x2,5
;    1497 	for(i=0; i<8; i++){
	LDI  R16,LOW(0)
_0x164:
	CPI  R16,8
	BRSH _0x165
;    1498 		bTmp = CHK_BIT7(bData);
	LDD  R30,Y+2
	ANDI R30,LOW(0x80)
	MOV  R17,R30
;    1499     	if(bTmp){
	CPI  R17,0
	BREQ _0x166
;    1500 			P_ACC_SDI(1);
	SBI  0x3,5
;    1501 		}else{
	RJMP _0x169
_0x166:
;    1502 			P_ACC_SDI(0);
	CBI  0x3,5
;    1503 		}
_0x169:
;    1504 		#asm("nop");
	nop
;    1505 		#asm("nop");
	nop
;    1506 		P_ACC_SCK(1);;
	SBI  0x3,4
;    1507 		#asm("nop");
	nop
;    1508 		#asm("nop");
	nop
;    1509 		#asm("nop");
	nop
;    1510 		#asm("nop");
	nop
;    1511 		P_ACC_SCK(0);
	CBI  0x3,4
;    1512 		#asm("nop");
	nop
;    1513 		#asm("nop");
	nop
;    1514 		bData =	bData << 1;
	LDD  R30,Y+2
	LSL  R30
	STD  Y+2,R30
;    1515 	}
	SUBI R16,-1
	JMP  _0x164
_0x165:
;    1516 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
;    1517 
;    1518 
;    1519 //==============================================================//
;    1520 //
;    1521 //==============================================================//
;    1522 char AccByteRead(void)
;    1523 {
_AccByteRead:
;    1524 	BYTE	i;
;    1525 	char	bTmp = 0;
;    1526 
;    1527 SDI_SET_INPUT;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16
;	bTmp -> R17
	LDI  R17,0
	CBI  0x2,5
;    1528 	for(i = 0; i < 8;	i++){
	LDI  R16,LOW(0)
_0x171:
	CPI  R16,8
	BRSH _0x172
;    1529 		bTmp = bTmp << 1;
	LSL  R17
;    1530 		#asm("nop");
	nop
;    1531 		#asm("nop");
	nop
;    1532 		#asm("nop");
	nop
;    1533 		#asm("nop");
	nop
;    1534 		P_ACC_SCK(1);
	SBI  0x3,4
;    1535 		#asm("nop");
	nop
;    1536 		#asm("nop");
	nop
;    1537 		if(SDI_CHK)	bTmp |= 0x01;
	SBIC 0x1,5
	ORI  R17,LOW(1)
;    1538 		#asm("nop");
	nop
;    1539 		#asm("nop");
	nop
;    1540 		P_ACC_SCK(0);
	CBI  0x3,4
;    1541 	}
	SUBI R16,-1
	JMP  _0x171
_0x172:
;    1542 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1543 
;    1544 	return	bTmp;
	MOV  R30,R17
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1545 }
;    1546 
;    1547 
;    1548 //==============================================================//
;    1549 //
;    1550 //==============================================================//
;    1551 void AccAckRead(void)
;    1552 {
_AccAckRead:
;    1553 SDI_SET_INPUT;
	CBI  0x2,5
;    1554 	#asm("nop");
	nop
;    1555 	#asm("nop");
	nop
;    1556 	P_ACC_SDI(1);
	SBI  0x3,5
;    1557 	#asm("nop");
	nop
;    1558 	#asm("nop");
	nop
;    1559 	P_ACC_SCK(1);
	SBI  0x3,4
;    1560 	#asm("nop");
	nop
;    1561 	#asm("nop");
	nop
;    1562 	P_ACC_SCK(0);
	CBI  0x3,4
;    1563 	#asm("nop");
	nop
;    1564 	#asm("nop");
	nop
;    1565 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1566 	#asm("nop");
	nop
;    1567 	#asm("nop");
	nop
;    1568 }
	RET
;    1569 
;    1570 
;    1571 //==============================================================//
;    1572 //
;    1573 //==============================================================//
;    1574 void AccAckWrite(void)
;    1575 {
_AccAckWrite:
;    1576 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1577 	#asm("nop");
	nop
;    1578 	#asm("nop");
	nop
;    1579 	P_ACC_SDI(0);
	CBI  0x3,5
;    1580 	#asm("nop");
	nop
;    1581 	#asm("nop");
	nop
;    1582 	P_ACC_SCK(1);
	SBI  0x3,4
;    1583 	#asm("nop");
	nop
;    1584 	#asm("nop");
	nop
;    1585 	P_ACC_SCK(0);
	CBI  0x3,4
;    1586 	#asm("nop");
	nop
;    1587 	#asm("nop");
	nop
;    1588 	P_ACC_SDI(1);
	SBI  0x3,5
;    1589 	#asm("nop");
	nop
;    1590 	#asm("nop");
	nop
;    1591 }
	RET
;    1592 
;    1593 
;    1594 //==============================================================//
;    1595 //
;    1596 //==============================================================//
;    1597 void AccNotAckWrite(void)
;    1598 {
_AccNotAckWrite:
;    1599 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1600 	#asm("nop");
	nop
;    1601 	#asm("nop");
	nop
;    1602 	P_ACC_SDI(1);
	SBI  0x3,5
;    1603 	#asm("nop");
	nop
;    1604 	#asm("nop");
	nop
;    1605 	P_ACC_SCK(1);
	SBI  0x3,4
;    1606 	#asm("nop");
	nop
;    1607 	#asm("nop");
	nop
;    1608 	P_ACC_SCK(0);
	CBI  0x3,4
;    1609 	#asm("nop");
	nop
;    1610 	#asm("nop");
	nop
;    1611 }
	RET
;    1612 
;    1613 
;    1614 //==============================================================//
;    1615 //==============================================================//
;    1616 void Acc_init(void)
;    1617 {
_Acc_init:
;    1618 	AccStart();
	CALL SUBOPT_0x45
;    1619 	AccByteWrite(0x70);
;    1620 	AccAckRead();
;    1621 	AccByteWrite(0x14);
	LDI  R30,LOW(20)
	CALL SUBOPT_0x46
;    1622 	AccAckRead();
;    1623 	AccByteWrite(0x03);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x46
;    1624 	AccAckRead();
;    1625 	AccStop();
	CALL _AccStop
;    1626 }
	RET
;    1627 
;    1628 //==============================================================//
;    1629 //==============================================================//
;    1630 void AccGetData(void)
;    1631 {
_AccGetData:
;    1632 	signed char	bTmp = 0;
;    1633 
;    1634 	AccStart();
	ST   -Y,R16
;	bTmp -> R16
	LDI  R16,0
	CALL SUBOPT_0x45
;    1635 	AccByteWrite(0x70);
;    1636 	AccAckRead();
;    1637 	AccByteWrite(0x02);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x46
;    1638 	AccAckRead();
;    1639 	AccStop();
	CALL _AccStop
;    1640 
;    1641 	#asm("nop");
	nop
;    1642 	#asm("nop");
	nop
;    1643 	#asm("nop");
	nop
;    1644 	#asm("nop");
	nop
;    1645 
;    1646 	AccStart();
	CALL _AccStart
;    1647 	AccByteWrite(0x71);
	LDI  R30,LOW(113)
	CALL SUBOPT_0x46
;    1648 	AccAckRead();
;    1649 
;    1650 	bTmp = AccByteRead();
	CALL SUBOPT_0x47
;    1651 	AccAckWrite();
;    1652 
;    1653 	bTmp = AccByteRead();
	CALL SUBOPT_0x47
;    1654 	AccAckWrite();
;    1655 	gAccX = bTmp;
	STS  _gAccX,R16
;    1656 
;    1657 	bTmp = AccByteRead();
	CALL SUBOPT_0x47
;    1658 	AccAckWrite();
;    1659 
;    1660 	bTmp = AccByteRead();
	CALL SUBOPT_0x47
;    1661 	AccAckWrite();
;    1662 	gAccY = bTmp;
	STS  _gAccY,R16
;    1663 
;    1664 	bTmp = AccByteRead();
	CALL SUBOPT_0x47
;    1665 	AccAckWrite();
;    1666 
;    1667 	bTmp = AccByteRead();
	CALL _AccByteRead
	MOV  R16,R30
;    1668 	AccNotAckWrite();
	CALL _AccNotAckWrite
;    1669 	gAccZ = bTmp;
	STS  _gAccZ,R16
;    1670 
;    1671 	AccStop();
	CALL _AccStop
;    1672 }
	LD   R16,Y+
	RET
;    1673 //==============================================================================
;    1674 //						A/D converter 관련 함수들
;    1675 //==============================================================================
;    1676 #include <mega128.h>
;    1677 #include "Main.h"
;    1678 #include "Macro.h"
;    1679 
;    1680 //------------------------------------------------------------------------------
;    1681 // PSD 거리센서 신호 A/D
;    1682 //------------------------------------------------------------------------------
;    1683 void Get_AD_PSD(void)
;    1684 {
_Get_AD_PSD:
;    1685 	float	tmp = 0;
;    1686 	float	dist;
;    1687 	
;    1688 	EIMSK &= 0xBF;
	SBIW R28,8
	LDI  R24,4
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	LDI  R30,LOW(_0x18C*2)
	LDI  R31,HIGH(_0x18C*2)
	CALL __INITLOCB
;	tmp -> Y+4
;	dist -> Y+0
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;    1689 	PSD_ON;
	SBI  0x18,5
;    1690    	delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x25
;    1691 	gAD_Ch_Index = PSD_CH;
	CLR  R4
;    1692    	F_AD_CONVERTING = 1;
	CALL SUBOPT_0x48
;    1693    	ADC_set(ADC_MODE_SINGLE);
;    1694    	while(F_AD_CONVERTING);            
_0x18D:
	SBRC R2,7
	RJMP _0x18D
;    1695    	tmp = tmp + gPSD_val;
	MOV  R30,R9
	__GETD2S 4
	CALL SUBOPT_0x49
	__PUTD1S 4
;    1696 	PSD_OFF;
	CBI  0x18,5
;    1697 	EIMSK |= 0x40;
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    1698 
;    1699 	dist = 1117.2 / (tmp - 6.89);
	__GETD2S 4
	__GETD1N 0x40DC7AE1
	CALL SUBOPT_0x3
	__GETD2N 0x448BA666
	CALL __DIVF21
	CALL SUBOPT_0x0
;    1700 	if(dist < 0) dist = 50;
	CALL SUBOPT_0x2
	CALL __CPD20
	BRGE _0x190
	RJMP _0x33A
;    1701 	else if(dist < 10) dist = 10;
_0x190:
	CALL SUBOPT_0x2
	CALL SUBOPT_0x4A
	CALL __CMPF12
	BRSH _0x192
	CALL SUBOPT_0x4A
	RJMP _0x33B
;    1702 	else if(dist > 50) dist = 50;
_0x192:
	CALL SUBOPT_0x2
	__GETD1N 0x42480000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x194
_0x33A:
	__GETD1N 0x42480000
_0x33B:
	__PUTD1S 0
;    1703 	gDistance = (BYTE)dist;
_0x194:
	CALL SUBOPT_0x4B
	MOV  R7,R30
;    1704 }
	ADIW R28,8
	RET
;    1705 
;    1706 
;    1707 //------------------------------------------------------------------------------
;    1708 // MIC 신호 A/D
;    1709 //------------------------------------------------------------------------------
;    1710 void Get_AD_MIC(void)
;    1711 {
_Get_AD_MIC:
;    1712 	WORD	i;
;    1713 	float	tmp = 0;
;    1714 	
;    1715 	gAD_Ch_Index = MIC_CH;
	SBIW R28,4
	LDI  R24,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x195*2)
	LDI  R31,HIGH(_0x195*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
;	tmp -> Y+2
	LDI  R30,LOW(15)
	MOV  R4,R30
;    1716 	for(i = 0; i < 50; i++){
	__GETWRN 16,17,0
_0x197:
	__CPWRN 16,17,50
	BRSH _0x198
;    1717     	F_AD_CONVERTING = 1;
	CALL SUBOPT_0x48
;    1718 	   	ADC_set(ADC_MODE_SINGLE);
;    1719     	while(F_AD_CONVERTING);            
_0x199:
	SBRC R2,7
	RJMP _0x199
;    1720     	tmp = tmp + gMIC_val;
	MOV  R30,R10
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4D
;    1721     }
	__ADDWRN 16,17,1
	RJMP _0x197
_0x198:
;    1722     tmp = tmp / 50;
	CALL SUBOPT_0x4C
	__GETD1N 0x42480000
	CALL __DIVF21
	CALL SUBOPT_0x4D
;    1723 	gSoundLevel = (BYTE)tmp;
	__GETD1S 2
	CALL __CFD1
	MOV  R8,R30
;    1724 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;    1725 
;    1726 
;    1727 //------------------------------------------------------------------------------
;    1728 // 전원 전압 A/D
;    1729 //------------------------------------------------------------------------------
;    1730 void Get_VOLTAGE(void)
;    1731 {
_Get_VOLTAGE:
;    1732 	if(F_DOWNLOAD) return;
	SBRC R2,4
	RET
;    1733 	gAD_Ch_Index = VOLTAGE_CH;
	LDI  R30,LOW(1)
	MOV  R4,R30
;    1734 	F_AD_CONVERTING = 1;
	CALL SUBOPT_0x48
;    1735    	ADC_set(ADC_MODE_SINGLE);
;    1736 	while(F_AD_CONVERTING);
_0x19D:
	SBRC R2,7
	RJMP _0x19D
;    1737 }
	RET
;    1738 //==============================================================================
;    1739 //						Communication & Command 함수들
;    1740 //==============================================================================
;    1741 
;    1742 #include <mega128.h>
;    1743 #include <string.h>
;    1744 #include "Main.h"
;    1745 #include "Macro.h"
;    1746 #include "Comm.h"
;    1747 #include "HunoBasic_080819.h"
;    1748 #include "DinoBasic_2.h"
;    1749 #include "DogyBasic_2.h"
;    1750 #include "my_demo1.h"	// 사용자 모션 파일
;    1751 
;    1752 
;    1753 BYTE flash fM1_BasicPose[16]={
;    1754 /* ID
;    1755  0 ,1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9  , 10, 11, 12, 13, 14, 15 */
;    1756 125,179,199, 88,108,126, 72, 49,163,141, 51, 47, 49,199,205,205};
;    1757 
;    1758 BYTE flash fM2_BasicPose[16]={
;    1759 /* ID
;    1760  0 ,1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9  , 10, 11, 12, 13, 14, 15 */
;    1761 125,179,199, 88,108,126, 72, 49,163,141, 89,127, 47,159,112,171};
;    1762 
;    1763 BYTE flash fM3_BasicPose[16]={
;    1764 /* ID
;    1765  0 ,1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9  , 10, 11, 12, 13, 14, 15 */
;    1766 159,209,127,127,200, 91, 41,127,127, 52,143, 39, 52,109,210,200};
;    1767 
;    1768 
;    1769 //------------------------------------------------------------------------------
;    1770 // 시리얼 포트로 한 문자를 전송하기 위한 함수
;    1771 //------------------------------------------------------------------------------
;    1772 void sciTx0Data(BYTE td)
;    1773 {
_sciTx0Data:
;    1774 	while(!(UCSR0A & DATA_REGISTER_EMPTY));
;	td -> Y+0
_0x1A0:
	SBIS 0xB,5
	RJMP _0x1A0
;    1775 	UDR0 = td;
	LD   R30,Y
	OUT  0xC,R30
;    1776 }
	RJMP _0x32E
;    1777 
;    1778 void sciTx1Data(BYTE td)
;    1779 {
_sciTx1Data:
;    1780 	while(!(UCSR1A & DATA_REGISTER_EMPTY));
;	td -> Y+0
_0x1A3:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0x1A3
;    1781 	UDR1 = td;
	LD   R30,Y
	STS  156,R30
;    1782 }
_0x32E:
	ADIW R28,1
	RET
;    1783 
;    1784 
;    1785 //------------------------------------------------------------------------------
;    1786 // 시리얼 포트로 한 문자를 받을때까지 대기하기 위한 함수
;    1787 //------------------------------------------------------------------------------
;    1788 BYTE sciRx0Ready(void)
;    1789 {
;    1790 	WORD	startT;
;    1791 
;    1792 	startT = g10MSEC;
;	startT -> R16,R17
;    1793 	while(!(UCSR0A & RX_COMPLETE)){
;    1794         if(g10MSEC < startT){
;    1795             if((100 - startT + g10MSEC) > RX_T_OUT) break;
;    1796         }
;    1797 		else if((g10MSEC-startT) > RX_T_OUT) break;
;    1798 	}
;    1799 	return UDR0;
;    1800 }
;    1801 
;    1802 BYTE sciRx1Ready(void)
;    1803 {
;    1804 	WORD	startT;
;    1805 
;    1806 	startT = g10MSEC;
;	startT -> R16,R17
;    1807 	while(!(UCSR1A & RX_COMPLETE)){
;    1808         if(g10MSEC < startT){
;    1809             if((100 - startT + g10MSEC) > RX_T_OUT) break;
;    1810         }
;    1811 		else if((g10MSEC-startT) > RX_T_OUT) break;
;    1812 	}
;    1813 	return UDR1;
;    1814 }
;    1815 
;    1816 
;    1817 //------------------------------------------------------------------------------
;    1818 // wCK에게 동작 명령 패킷(4바이트)을 보내는 함수                                                                     */
;    1819 //------------------------------------------------------------------------------
;    1820 void SendOperCmd(BYTE Data1,BYTE Data2)
;    1821 {
_SendOperCmd:
;    1822 	BYTE CheckSum; 
;    1823 	CheckSum = (Data1^Data2)&0x7f;
	ST   -Y,R16
;	Data1 -> Y+2
;	Data2 -> Y+1
;	CheckSum -> R16
	LDD  R30,Y+1
	LDD  R26,Y+2
	CALL SUBOPT_0x4E
;    1824 
;    1825 	gTx0Buf[gTx0Cnt] = HEADER;
;    1826 	gTx0Cnt++;
;    1827 
;    1828 	gTx0Buf[gTx0Cnt] = Data1;
	CALL SUBOPT_0x4F
;    1829 	gTx0Cnt++;
;    1830 
;    1831 	gTx0Buf[gTx0Cnt] = Data2;
	CALL SUBOPT_0x50
;    1832 	gTx0Cnt++;
;    1833 
;    1834 	gTx0Buf[gTx0Cnt] = CheckSum;
;    1835 	gTx0Cnt++;
;    1836 
;    1837 }
	ADIW R28,3
	RET
;    1838 
;    1839 
;    1840 //------------------------------------------------------------------------------
;    1841 // wCK의 파라미터를 설정할 때 사용한다
;    1842 //------------------------------------------------------------------------------
;    1843 void SendSetCmd(BYTE ID, BYTE Data1, BYTE Data2, BYTE Data3)
;    1844 {
_SendSetCmd:
;    1845 	BYTE	CheckSum; 
;    1846 
;    1847 	ID = (BYTE)(7<<5)|ID; 
	ST   -Y,R16
;	ID -> Y+4
;	Data1 -> Y+3
;	Data2 -> Y+2
;	Data3 -> Y+1
;	CheckSum -> R16
	LDD  R30,Y+4
	ORI  R30,LOW(0xE0)
	STD  Y+4,R30
;    1848 	CheckSum = (ID^Data1^Data2^Data3)&0x7f;
	LDD  R30,Y+3
	LDD  R26,Y+4
	EOR  R30,R26
	LDD  R26,Y+2
	EOR  R30,R26
	LDD  R26,Y+1
	CALL SUBOPT_0x4E
;    1849 
;    1850 	gTx0Buf[gTx0Cnt] = HEADER;
;    1851 	gTx0Cnt++;
;    1852 
;    1853 	gTx0Buf[gTx0Cnt] = ID;
	LDD  R26,Y+4
	CALL SUBOPT_0x51
;    1854 	gTx0Cnt++;
;    1855 
;    1856 	gTx0Buf[gTx0Cnt] = Data1;
	LDD  R26,Y+3
	CALL SUBOPT_0x51
;    1857 	gTx0Cnt++;
;    1858 
;    1859 	gTx0Buf[gTx0Cnt] = Data2;
	CALL SUBOPT_0x4F
;    1860 	gTx0Cnt++;
;    1861 
;    1862 	gTx0Buf[gTx0Cnt] = Data3;
	CALL SUBOPT_0x50
;    1863 	gTx0Cnt++;
;    1864 
;    1865 	gTx0Buf[gTx0Cnt] = CheckSum;
;    1866 	gTx0Cnt++;
;    1867 }
	ADIW R28,5
	RET
;    1868 
;    1869 
;    1870 //------------------------------------------------------------------------------
;    1871 // 위치 명령(Position Send Command)을 보내는 함수
;    1872 //------------------------------------------------------------------------------
;    1873 void PosSend(BYTE ID, BYTE Position, BYTE SpeedLevel) 
;    1874 {
_PosSend:
;    1875 	BYTE Data1;
;    1876 
;    1877 	Data1 = (SpeedLevel<<5) | ID;
	ST   -Y,R16
;	ID -> Y+3
;	Position -> Y+2
;	SpeedLevel -> Y+1
;	Data1 -> R16
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LDD  R26,Y+3
	OR   R30,R26
	MOV  R16,R30
;    1878 	SendOperCmd(Data1,Position);
	ST   -Y,R16
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _SendOperCmd
;    1879 }
	LDD  R16,Y+0
	RJMP _0x32B
;    1880 
;    1881 
;    1882 //------------------------------------------------------------------------------
;    1883 // 브레이크 모드 명령을 보내는 함수
;    1884 //------------------------------------------------------------------------------
;    1885 void BreakModeCmdSend(void)
;    1886 {
_BreakModeCmdSend:
;    1887 	BYTE	Data1, Data2;
;    1888 	BYTE	CheckSum; 
;    1889 
;    1890 	Data1 = (6<<5) | 31;
	CALL __SAVELOCR3
;	Data1 -> R16
;	Data2 -> R17
;	CheckSum -> R18
	LDI  R16,LOW(223)
;    1891 	Data2 = 0x20;
	LDI  R17,LOW(32)
;    1892 	CheckSum = (Data1^Data2)&0x7f;
	MOV  R30,R17
	EOR  R30,R16
	ANDI R30,0x7F
	CALL SUBOPT_0x52
;    1893 
;    1894 	sciTx0Data(HEADER);
;    1895 	sciTx0Data(Data1);
;    1896 	sciTx0Data(Data2);
;    1897 	sciTx0Data(CheckSum);
	ST   -Y,R18
	CALL _sciTx0Data
;    1898 } 
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;    1899 
;    1900 
;    1901 //------------------------------------------------------------------------------
;    1902 // 이동범위 설정 명령을 보내는 함수
;    1903 //------------------------------------------------------------------------------
;    1904 void BoundSetCmdSend(BYTE ID, BYTE B_L, BYTE B_U)
;    1905 {
_BoundSetCmdSend:
;    1906 	BYTE	Data1, Data2;
;    1907 	BYTE	CheckSum; 
;    1908 
;    1909 	Data1 = (7<<5) | ID;
	CALL __SAVELOCR3
;	ID -> Y+5
;	B_L -> Y+4
;	B_U -> Y+3
;	Data1 -> R16
;	Data2 -> R17
;	CheckSum -> R18
	LDD  R30,Y+5
	ORI  R30,LOW(0xE0)
	MOV  R16,R30
;    1910 	Data2 = 17;
	LDI  R17,LOW(17)
;    1911 	CheckSum = (Data1^Data2^B_U^B_L)&0x7f;
	MOV  R30,R17
	EOR  R30,R16
	LDD  R26,Y+3
	EOR  R30,R26
	LDD  R26,Y+4
	EOR  R26,R30
	LDI  R30,LOW(127)
	AND  R30,R26
	CALL SUBOPT_0x52
;    1912 
;    1913 	sciTx0Data(HEADER);
;    1914 	sciTx0Data(Data1);
;    1915 	sciTx0Data(Data2);
;    1916 	sciTx0Data(B_L);
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _sciTx0Data
;    1917 	sciTx0Data(B_U);
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _sciTx0Data
;    1918 	sciTx0Data(CheckSum);
	ST   -Y,R18
	CALL _sciTx0Data
;    1919 }
	CALL __LOADLOCR3
	ADIW R28,6
	RET
;    1920 
;    1921 //------------------------------------------------------------------------------
;    1922 // 위치 읽기 명령(Position Send Command)을 보내는 함수
;    1923 //------------------------------------------------------------------------------
;    1924 WORD PosRead(BYTE ID) 
;    1925 {
_PosRead:
;    1926 	BYTE	Data1, Data2;
;    1927 	BYTE	CheckSum; 
;    1928 	WORD	startT;
;    1929 
;    1930 	Data1 = (5<<5) | ID;
	CALL __SAVELOCR5
;	ID -> Y+5
;	Data1 -> R16
;	Data2 -> R17
;	CheckSum -> R18
;	startT -> R19,R20
	LDD  R30,Y+5
	ORI  R30,LOW(0xA0)
	MOV  R16,R30
;    1931 	Data2 = 0;
	LDI  R17,LOW(0)
;    1932 	gRx0Cnt = 0;
	LDI  R30,LOW(0)
	STS  _gRx0Cnt,R30
;    1933 	CheckSum = (Data1^Data2)&0x7f;
	MOV  R30,R17
	EOR  R30,R16
	ANDI R30,0x7F
	MOV  R18,R30
;    1934 	RX0_OFF;
	CBI  0xA,4
;    1935 	sciTx0Data(HEADER);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _sciTx0Data
;    1936 	sciTx0Data(Data1);
	ST   -Y,R16
	CALL _sciTx0Data
;    1937 	sciTx0Data(Data2);
	ST   -Y,R17
	CALL _sciTx0Data
;    1938 	sciTx0Data(CheckSum);
	ST   -Y,R18
	CALL _sciTx0Data
;    1939 	RX0_ON;
	SBI  0xA,4
;    1940 	startT = g10MSEC;
	__GETWRMN 19,20,0,_g10MSEC
;    1941 	while(gRx0Cnt < 2){
_0x1B4:
	LDS  R26,_gRx0Cnt
	CPI  R26,LOW(0x2)
	BRSH _0x1B6
;    1942         if(g10MSEC < startT){
	CALL SUBOPT_0x29
	CP   R26,R19
	CPC  R27,R20
	BRSH _0x1B7
;    1943             if((100 - startT + g10MSEC) > RX_T_OUT)
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	SUB  R30,R19
	SBC  R31,R20
	CALL SUBOPT_0x29
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,21
	BRLO _0x1B8
;    1944             	return 444;
	LDI  R30,LOW(444)
	LDI  R31,HIGH(444)
	RJMP _0x32D
;    1945         }
_0x1B8:
;    1946 		else if((g10MSEC - startT) > RX_T_OUT) return 444;
	RJMP _0x1B9
_0x1B7:
	LDS  R30,_g10MSEC
	LDS  R31,_g10MSEC+1
	SUB  R30,R19
	SBC  R31,R20
	SBIW R30,21
	BRLO _0x1BA
	LDI  R30,LOW(444)
	LDI  R31,HIGH(444)
	RJMP _0x32D
;    1947 	}
_0x1BA:
_0x1B9:
	RJMP _0x1B4
_0x1B6:
;    1948 	return (WORD)gRx0Buf[RX0_BUF_SIZE - 1];
	__GETB1MN _gRx0Buf,7
	LDI  R31,0
_0x32D:
	CALL __LOADLOCR5
	ADIW R28,6
	RET
;    1949 } 
;    1950 
;    1951 
;    1952 //------------------------------------------------------------------------------
;    1953 // 사운드 칩에게 명령 보내는 함수
;    1954 //------------------------------------------------------------------------------
;    1955 void SendToSoundIC(BYTE cmd) 
;    1956 {
_SendToSoundIC:
;    1957 	BYTE	CheckSum; 
;    1958 
;    1959 	gRx0Cnt = 0;
	ST   -Y,R16
;	cmd -> Y+1
;	CheckSum -> R16
	LDI  R30,LOW(0)
	STS  _gRx0Cnt,R30
;    1960 	CheckSum = (29^cmd)&0x7f;
	LDD  R30,Y+1
	LDI  R26,LOW(29)
	EOR  R26,R30
	LDI  R30,LOW(127)
	AND  R30,R26
	MOV  R16,R30
;    1961 	sciTx0Data(HEADER);
	LDI  R30,LOW(255)
	CALL SUBOPT_0x53
;    1962 	delay_ms(1);
;    1963 	sciTx0Data(29);
	LDI  R30,LOW(29)
	CALL SUBOPT_0x53
;    1964 	delay_ms(1);
;    1965 	sciTx0Data(cmd);
	LDD  R30,Y+1
	CALL SUBOPT_0x53
;    1966 	delay_ms(1);
;    1967 	sciTx0Data(CheckSum);
	ST   -Y,R16
	CALL _sciTx0Data
;    1968 } 
	LDD  R16,Y+0
	RJMP _0x32C
;    1969 
;    1970 
;    1971 //------------------------------------------------------------------------------
;    1972 // PC와 통신할 때 사용
;    1973 //------------------------------------------------------------------------------
;    1974 void SendToPC(BYTE Cmd, BYTE CSize)
;    1975 {
_SendToPC:
;    1976 	sciTx1Data(0xFF);
;	Cmd -> Y+1
;	CSize -> Y+0
	LDI  R30,LOW(255)
	CALL SUBOPT_0x27
;    1977 	sciTx1Data(0xFF);
	CALL SUBOPT_0x54
;    1978 	sciTx1Data(0xAA);
;    1979 	sciTx1Data(0x55);
	CALL SUBOPT_0x54
;    1980 	sciTx1Data(0xAA);
;    1981 	sciTx1Data(0x55);
	ST   -Y,R30
	CALL _sciTx1Data
;    1982 	sciTx1Data(0x37);
	LDI  R30,LOW(55)
	ST   -Y,R30
	CALL _sciTx1Data
;    1983 	sciTx1Data(0xBA);
	LDI  R30,LOW(186)
	ST   -Y,R30
	CALL _sciTx1Data
;    1984 	sciTx1Data(Cmd);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _sciTx1Data
;    1985 	sciTx1Data(F_PF);
	ST   -Y,R12
	CALL SUBOPT_0x40
;    1986 	sciTx1Data(0);
;    1987 	sciTx1Data(0);
	CALL SUBOPT_0x12
;    1988 	sciTx1Data(0);
	CALL SUBOPT_0x12
;    1989 	sciTx1Data(CSize);
	LD   R30,Y
	ST   -Y,R30
	CALL _sciTx1Data
;    1990 }
_0x32C:
	ADIW R28,2
	RET
;    1991 
;    1992 
;    1993 
;    1994 //------------------------------------------------------------------------------
;    1995 // Flash에서 모션 정보 읽기
;    1996 //------------------------------------------------------------------------------
;    1997 void GetMotionFromFlash(void)
;    1998 {
_GetMotionFromFlash:
;    1999 	WORD	i;
;    2000 
;    2001 	for(i=0;i<MAX_wCK;i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x1BC:
	__CPWRN 16,17,31
	BRSH _0x1BD
;    2002 		Motion.wCK[i].Exist		= 0;
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	CALL SUBOPT_0x57
;    2003 		Motion.wCK[i].RPgain	= 0;
	CALL SUBOPT_0x58
	CALL SUBOPT_0x57
;    2004 		Motion.wCK[i].RDgain	= 0;
	CALL SUBOPT_0x59
	CALL SUBOPT_0x57
;    2005 		Motion.wCK[i].RIgain	= 0;
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x57
;    2006 		Motion.wCK[i].PortEn	= 0;
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x57
;    2007 		Motion.wCK[i].InitPos	= 0;
	CALL SUBOPT_0x5C
	LDI  R30,LOW(0)
	ST   X,R30
;    2008 		gPoseDelta[i] = 0;
	CALL SUBOPT_0x5D
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    2009 	}
	__ADDWRN 16,17,1
	RJMP _0x1BC
_0x1BD:
;    2010 	gLastID = wCK_IDs[Motion.NumOfwCK-1];
	CALL SUBOPT_0x5E
	SBIW R30,1
	SUBI R30,LOW(-_wCK_IDs*2)
	SBCI R31,HIGH(-_wCK_IDs*2)
	LPM  R30,Z
	STS  _gLastID,R30
;    2011 	for(i=0;i<Motion.NumOfwCK;i++){
	__GETWRN 16,17,0
_0x1BF:
	CALL SUBOPT_0x5E
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x1C0
;    2012 		Motion.wCK[wCK_IDs[i]].Exist	= 1;
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x56
	LDI  R30,LOW(1)
	ST   X,R30
;    2013 		Motion.wCK[wCK_IDs[i]].RPgain	= *(gpPg_Table+i);
	CALL SUBOPT_0x5F
	__ADDW1MN _Motion,11
	CALL SUBOPT_0x60
	LDS  R26,_gpPg_Table
	LDS  R27,_gpPg_Table+1
	CALL SUBOPT_0x61
;    2014 		Motion.wCK[wCK_IDs[i]].RDgain	= *(gpDg_Table+i);
	__ADDW1MN _Motion,12
	CALL SUBOPT_0x60
	LDS  R26,_gpDg_Table
	LDS  R27,_gpDg_Table+1
	CALL SUBOPT_0x61
;    2015 		Motion.wCK[wCK_IDs[i]].RIgain	= *(gpIg_Table+i);
	__ADDW1MN _Motion,13
	CALL SUBOPT_0x60
	LDS  R26,_gpIg_Table
	LDS  R27,_gpIg_Table+1
	CALL SUBOPT_0x61
;    2016 		Motion.wCK[wCK_IDs[i]].PortEn	= 1;
	CALL SUBOPT_0x5B
	LDI  R30,LOW(1)
	ST   X,R30
;    2017 		Motion.wCK[wCK_IDs[i]].InitPos	= MotionZeroPos[i];
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5C
	MOVW R30,R16
	SUBI R30,LOW(-_MotionZeroPos*2)
	SBCI R31,HIGH(-_MotionZeroPos*2)
	LPM  R30,Z
	ST   X,R30
;    2018 	}
	__ADDWRN 16,17,1
	RJMP _0x1BF
_0x1C0:
;    2019 	for(i=0;i<Motion.NumOfwCK;i++)
	__GETWRN 16,17,0
_0x1C2:
	CALL SUBOPT_0x5E
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x1C3
;    2020 		gPoseDelta[i] = (int)eM_OriginPose[i] - (int)Motion.wCK[i].InitPos;
	CALL SUBOPT_0x5D
	ADD  R30,R26
	ADC  R31,R27
	MOVW R24,R30
	CALL SUBOPT_0x9
	MOV  R22,R30
	CLR  R23
	CALL SUBOPT_0x55
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x62
	MOVW R26,R24
	ST   X+,R30
	ST   X,R31
;    2021 }
	__ADDWRN 16,17,1
	RJMP _0x1C2
_0x1C3:
	RJMP _0x32A
;    2022 
;    2023 
;    2024 //------------------------------------------------------------------------------
;    2025 // Runtime P,D,I 이득 송신
;    2026 //------------------------------------------------------------------------------
;    2027 void SendTGain(void)
;    2028 {
_SendTGain:
;    2029 	WORD	i;
;    2030 
;    2031 	RX0_INT_OFF;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CBI  0xA,7
;    2032 	TX0_INT_ON;
	SBI  0xA,6
;    2033 
;    2034 	while(gTx0Cnt);
_0x1C4:
	LDS  R30,_gTx0Cnt
	CPI  R30,0
	BRNE _0x1C4
;    2035 	for(i=0;i<MAX_wCK;i++){
	__GETWRN 16,17,0
_0x1C8:
	__CPWRN 16,17,31
	BRSH _0x1C9
;    2036 		if(Motion.wCK[i].Exist)
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	LD   R30,X
	CPI  R30,0
	BREQ _0x1CA
;    2037 			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
	ST   -Y,R16
	LDI  R30,LOW(11)
	ST   -Y,R30
	CALL SUBOPT_0x55
	CALL SUBOPT_0x58
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x55
	CALL SUBOPT_0x59
	CALL SUBOPT_0x63
;    2038 	}
_0x1CA:
	__ADDWRN 16,17,1
	RJMP _0x1C8
_0x1C9:
;    2039 	gTx0BufIdx++;
	CALL SUBOPT_0x15
;    2040 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
	CALL SUBOPT_0x64
	CALL SUBOPT_0x65
;    2041 
;    2042 
;    2043 	while(gTx0Cnt);
_0x1CB:
	LDS  R30,_gTx0Cnt
	CPI  R30,0
	BRNE _0x1CB
;    2044 	for(i=0;i<MAX_wCK;i++){
	__GETWRN 16,17,0
_0x1CF:
	__CPWRN 16,17,31
	BRSH _0x1D0
;    2045 		if(Motion.wCK[i].Exist)
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	LD   R30,X
	CPI  R30,0
	BREQ _0x1D1
;    2046 			SendSetCmd(i, 24, Motion.wCK[i].RIgain, Motion.wCK[i].RIgain);
	ST   -Y,R16
	LDI  R30,LOW(24)
	ST   -Y,R30
	CALL SUBOPT_0x55
	CALL SUBOPT_0x5A
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x55
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x63
;    2047 	}
_0x1D1:
	__ADDWRN 16,17,1
	RJMP _0x1CF
_0x1D0:
;    2048 	gTx0BufIdx++;
	CALL SUBOPT_0x15
;    2049 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
	CALL SUBOPT_0x64
	CALL SUBOPT_0x65
;    2050 	delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x25
;    2051 }
	RJMP _0x32A
;    2052 
;    2053 
;    2054 //------------------------------------------------------------------------------
;    2055 // 확장 포트값 송신
;    2056 //------------------------------------------------------------------------------
;    2057 void SendExPortD(void)
;    2058 {
_SendExPortD:
;    2059 	WORD	i;
;    2060 
;    2061 	UCSR0B &= 0x7F;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CBI  0xA,7
;    2062 	UCSR0B |= 0x40;
	SBI  0xA,6
;    2063 
;    2064 	while(gTx0Cnt);
_0x1D2:
	LDS  R30,_gTx0Cnt
	CPI  R30,0
	BRNE _0x1D2
;    2065 	for(i=0;i<MAX_wCK;i++){
	__GETWRN 16,17,0
_0x1D6:
	__CPWRN 16,17,31
	BRSH _0x1D7
;    2066 		if(Scene.wCK[i].Exist)
	CALL SUBOPT_0x66
	CALL SUBOPT_0x67
	LD   R30,X
	CPI  R30,0
	BREQ _0x1D8
;    2067 			SendSetCmd(i, 100, Scene.wCK[i].ExPortD, Scene.wCK[i].ExPortD);
	ST   -Y,R16
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL SUBOPT_0x66
	CALL SUBOPT_0x68
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x66
	CALL SUBOPT_0x68
	CALL SUBOPT_0x63
;    2068 	}
_0x1D8:
	__ADDWRN 16,17,1
	RJMP _0x1D6
_0x1D7:
;    2069 	gTx0BufIdx++;
	CALL SUBOPT_0x15
;    2070 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
	CALL SUBOPT_0x64
	CALL SUBOPT_0x65
;    2071 }
	RJMP _0x32A
;    2072 
;    2073 
;    2074 //------------------------------------------------------------------------------
;    2075 // Flash에서 씬 정보 읽기
;    2076 //------------------------------------------------------------------------------
;    2077 void GetSceneFromFlash(void)
;    2078 {
_GetSceneFromFlash:
;    2079 	WORD i;
;    2080 	
;    2081 	Scene.NumOfFrame = gpFN_Table[gScIdx];
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CALL SUBOPT_0x69
	LDS  R26,_gpFN_Table
	LDS  R27,_gpFN_Table+1
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
;    2082 	Scene.RTime = gpRT_Table[gScIdx];
	CALL SUBOPT_0x69
	LDS  R26,_gpRT_Table
	LDS  R27,_gpRT_Table+1
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6C
;    2083 	for(i=0; i < MAX_wCK; i++){
_0x1DA:
	__CPWRN 16,17,31
	BRSH _0x1DB
;    2084 		Scene.wCK[i].Exist		= 0;
	CALL SUBOPT_0x66
	CALL SUBOPT_0x67
	CALL SUBOPT_0x6D
;    2085 		Scene.wCK[i].SPos		= 0;
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6D
;    2086 		Scene.wCK[i].DPos		= 0;
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x6D
;    2087 		Scene.wCK[i].Torq		= 0;
	CALL SUBOPT_0x70
	CALL SUBOPT_0x6D
;    2088 		Scene.wCK[i].ExPortD	= 0;
	CALL SUBOPT_0x68
	LDI  R30,LOW(0)
	ST   X,R30
;    2089 	}
	__ADDWRN 16,17,1
	RJMP _0x1DA
_0x1DB:
;    2090 	for(i=0; i < Motion.NumOfwCK; i++){
	__GETWRN 16,17,0
_0x1DD:
	CALL SUBOPT_0x5E
	CP   R16,R30
	CPC  R17,R31
	BRLO PC+3
	JMP _0x1DE
;    2091 		Scene.wCK[wCK_IDs[i]].Exist		= 1;
	CALL SUBOPT_0x71
	CALL SUBOPT_0x67
	LDI  R30,LOW(1)
	ST   X,R30
;    2092 		Scene.wCK[wCK_IDs[i]].SPos		= gpPos_Table[Motion.NumOfwCK*gScIdx+i];
	CALL SUBOPT_0x71
	__ADDW1MN _Scene,7
	CALL SUBOPT_0x72
	CALL SUBOPT_0x73
	CALL SUBOPT_0x74
;    2093 		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[Motion.NumOfwCK*(gScIdx+1)+i];
	__ADDW1MN _Scene,8
	MOVW R22,R30
	__GETW2MN _Motion,8
	CALL SUBOPT_0x69
	ADIW R30,1
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	CALL SUBOPT_0x74
;    2094 		Scene.wCK[wCK_IDs[i]].Torq		= gpT_Table[Motion.NumOfwCK*gScIdx+i];
	__ADDW1MN _Scene,9
	CALL SUBOPT_0x72
	CALL SUBOPT_0x73
	CALL SUBOPT_0x75
	MOVW R26,R22
	ST   X,R30
;    2095 		Scene.wCK[wCK_IDs[i]].ExPortD	= gpE_Table[Motion.NumOfwCK*gScIdx+i];
	CALL SUBOPT_0x71
	__ADDW1MN _Scene,10
	CALL SUBOPT_0x72
	CALL SUBOPT_0x73
	LDS  R26,_gpE_Table
	LDS  R27,_gpE_Table+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
;    2096 	}
	__ADDWRN 16,17,1
	RJMP _0x1DD
_0x1DE:
;    2097 	UCSR0B &= 0x7F;
	CBI  0xA,7
;    2098 	UCSR0B |= 0x40;
	SBI  0xA,6
;    2099 	delay_us(1300);
	__DELAY_USW 4792
;    2100 }
	RJMP _0x32A
;    2101 
;    2102 
;    2103 //------------------------------------------------------------------------------
;    2104 // 프레임 송신 간격 계산
;    2105 //------------------------------------------------------------------------------
;    2106 void CalcFrameInterval(void)
;    2107 {
_CalcFrameInterval:
;    2108 	float	tmp;
;    2109 
;    2110 	if((Scene.RTime / Scene.NumOfFrame) < 20){
	SBIW R28,4
;	tmp -> Y+0
	__GETW2MN _Scene,4
	CALL SUBOPT_0x2E
	CALL __DIVW21U
	SBIW R30,20
	BRSH _0x1DF
;    2111 		F_ERR_CODE = INTERVAL_ERR;
	LDI  R30,LOW(6)
	MOV  R13,R30
;    2112 		return;
	RJMP _0x32B
;    2113 	}
;    2114 	tmp = (float)Scene.RTime * 14.4;
_0x1DF:
	__GETW1MN _Scene,4
	CALL SUBOPT_0x76
	__GETD2N 0x41666666
	CALL __MULF12
	CALL SUBOPT_0x0
;    2115 	tmp = tmp  / (float)Scene.NumOfFrame;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x76
	CALL SUBOPT_0x2
	CALL __DIVF21
	CALL SUBOPT_0x0
;    2116 	TxInterval = 65535 - (WORD)tmp - 5;
	CALL SUBOPT_0x4B
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	SUB  R26,R30
	SBC  R27,R31
	SBIW R26,5
	STS  _TxInterval,R26
	STS  _TxInterval+1,R27
;    2117 
;    2118 	RUN_LED1_ON;
	CBI  0x1B,5
;    2119 	F_SCENE_PLAYING = 1;
	SET
	BLD  R2,0
;    2120 	F_MOTION_STOPPED = 0;
	CLT
	BLD  R2,3
;    2121 	TCCR1B = 0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;    2122 
;    2123 	if(TxInterval <= 65509)	
	CPI  R26,LOW(0xFFE6)
	LDI  R30,HIGH(0xFFE6)
	CPC  R27,R30
	BRSH _0x1E0
;    2124 		TCNT1 = TxInterval+26;
	LDS  R30,_TxInterval
	LDS  R31,_TxInterval+1
	ADIW R30,26
	RJMP _0x33C
;    2125 	else
_0x1E0:
;    2126 		TCNT1 = 65535;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x33C:
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;    2127 
;    2128 	TIFR |= 0x04;
	CALL SUBOPT_0x30
;    2129 	TIMSK |= 0x04;
;    2130 }
_0x32B:
	ADIW R28,4
	RET
;    2131 
;    2132 
;    2133 //------------------------------------------------------------------------------
;    2134 // 프레임당 단위 이동량 계산
;    2135 //------------------------------------------------------------------------------
;    2136 void CalcUnitMove(void)
;    2137 {
_CalcUnitMove:
;    2138 	WORD	i;
;    2139 
;    2140 	for(i=0; i < MAX_wCK; i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x1E3:
	__CPWRN 16,17,31
	BRLO PC+3
	JMP _0x1E4
;    2141 		if(Scene.wCK[i].Exist){
	CALL SUBOPT_0x66
	CALL SUBOPT_0x67
	LD   R30,X
	CPI  R30,0
	BRNE PC+3
	JMP _0x1E5
;    2142 			if(Scene.wCK[i].SPos != Scene.wCK[i].DPos){
	CALL SUBOPT_0x66
	CALL SUBOPT_0x6E
	LD   R22,X
	CALL SUBOPT_0x66
	CALL SUBOPT_0x6F
	LD   R30,X
	CP   R30,R22
	BRNE PC+3
	JMP _0x1E6
;    2143 				gUnitD[i] = (float)((int)Scene.wCK[i].DPos - (int)Scene.wCK[i].SPos);
	CALL SUBOPT_0x77
	MOVW R24,R30
	CALL SUBOPT_0x66
	CALL SUBOPT_0x6F
	LD   R22,X
	CLR  R23
	CALL SUBOPT_0x66
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x62
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R24
	CALL __PUTDP1
;    2144 				gUnitD[i] = (float)(gUnitD[i] / Scene.NumOfFrame);
	CALL SUBOPT_0x77
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x78
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x76
	CALL __DIVF21
	POP  R26
	POP  R27
	CALL __PUTDP1
;    2145 				if(gUnitD[i] > 253)			gUnitD[i] = 254;
	CALL SUBOPT_0x78
	__GETD1N 0x437D0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1E7
	CALL SUBOPT_0x79
	__GETD1N 0x437E0000
	RJMP _0x33D
;    2146 				else if(gUnitD[i] < -253)	gUnitD[i] = -254;
_0x1E7:
	CALL SUBOPT_0x78
	__GETD1N 0xC37D0000
	CALL __CMPF12
	BRSH _0x1E9
	CALL SUBOPT_0x79
	__GETD1N 0xC37E0000
_0x33D:
	CALL __PUTDP1
;    2147 			}
_0x1E9:
;    2148 			else
	RJMP _0x1EA
_0x1E6:
;    2149 				gUnitD[i] = 0;
	CALL SUBOPT_0x79
	__GETD1N 0x0
	CALL __PUTDP1
;    2150 		}
_0x1EA:
;    2151 	}
_0x1E5:
	__ADDWRN 16,17,1
	RJMP _0x1E3
_0x1E4:
;    2152 	gFrameIdx = 0;
	LDI  R30,0
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R30
;    2153 }
_0x32A:
	LD   R16,Y+
	LD   R17,Y+
	RET
;    2154 
;    2155 
;    2156 //------------------------------------------------------------------------------
;    2157 // 한 프레임 송신 준비
;    2158 //------------------------------------------------------------------------------
;    2159 void MakeFrame(void)
;    2160 {
_MakeFrame:
;    2161 	BYTE	i, tmp;
;    2162 	int		wTmp;
;    2163 
;    2164 	while(gTx0Cnt);
	CALL __SAVELOCR4
;	i -> R16
;	tmp -> R17
;	wTmp -> R18,R19
_0x1EB:
	LDS  R30,_gTx0Cnt
	CPI  R30,0
	BRNE _0x1EB
;    2165 	gFrameIdx++;
	LDS  R30,_gFrameIdx
	LDS  R31,_gFrameIdx+1
	ADIW R30,1
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R31
;    2166 
;    2167 	for(i=0; i < MAX_wCK; i++){
	LDI  R16,LOW(0)
_0x1EF:
	CPI  R16,31
	BRLO PC+3
	JMP _0x1F0
;    2168 		if(Scene.wCK[i].Exist){
	LDI  R30,LOW(5)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x67
	LD   R30,X
	CPI  R30,0
	BRNE PC+3
	JMP _0x1F1
;    2169 			if(Scene.wCK[i].Torq < 5){
	LDI  R30,LOW(5)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x70
	LD   R26,X
	CPI  R26,LOW(0x5)
	BRLO PC+3
	JMP _0x1F2
;    2170 				wTmp = (int)Scene.wCK[i].SPos + Round((float)gFrameIdx*gUnitD[i],1 );
	LDI  R30,LOW(5)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x6E
	LD   R30,X
	LDI  R31,0
	PUSH R31
	PUSH R30
	LDS  R30,_gFrameIdx
	LDS  R31,_gFrameIdx+1
	CALL __CWD1
	CALL __CDF1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R16
	LDI  R26,LOW(_gUnitD)
	LDI  R27,HIGH(_gUnitD)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	CALL __PUTPARD1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Round
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
;    2171 				if(Motion.PF != PF2){
	__GETB2MN _Motion,5
	CPI  R26,LOW(0x4)
	BREQ _0x1F3
;    2172 					wTmp = wTmp + gPoseDelta[i];
	MOV  R30,R16
	LDI  R26,LOW(_gPoseDelta)
	LDI  R27,HIGH(_gPoseDelta)
	CALL SUBOPT_0x24
	__ADDWRR 18,19,30,31
;    2173 				}
;    2174 				if(wTmp > 254)		wTmp = 254;
_0x1F3:
	__CPWRN 18,19,255
	BRLT _0x1F4
	__GETWRN 18,19,254
;    2175 				else if(wTmp < 1)	wTmp = 1;
	RJMP _0x1F5
_0x1F4:
	__CPWRN 18,19,1
	BRGE _0x1F6
	__GETWRN 18,19,1
;    2176 				tmp = (BYTE)wTmp;
_0x1F6:
_0x1F5:
	MOV  R17,R18
;    2177 			}
;    2178 			else{
	RJMP _0x1F7
_0x1F2:
;    2179 				tmp = Scene.wCK[i].DPos;
	LDI  R30,LOW(5)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x6F
	LD   R17,X
;    2180 			}
_0x1F7:
;    2181 			PosSend(i,tmp, Scene.wCK[i].Torq);
	ST   -Y,R16
	ST   -Y,R17
	LDI  R30,LOW(5)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x70
	LD   R30,X
	ST   -Y,R30
	CALL _PosSend
;    2182 		}
;    2183 	}
_0x1F1:
	SUBI R16,-1
	RJMP _0x1EF
_0x1F0:
;    2184 }
	RJMP _0x328
;    2185 
;    2186 
;    2187 //------------------------------------------------------------------------------
;    2188 // 한 프레임 송신
;    2189 //------------------------------------------------------------------------------
;    2190 void SendFrame(void)
;    2191 {
_SendFrame:
;    2192 	if(gTx0Cnt == 0)	return;
	LDS  R30,_gTx0Cnt
	CPI  R30,0
	BRNE _0x1F8
	RET
;    2193 
;    2194 	gTx0BufIdx++;
_0x1F8:
	CALL SUBOPT_0x15
;    2195 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
	CALL SUBOPT_0x64
	CALL SUBOPT_0x65
;    2196 }
	RET
;    2197 
;    2198 
;    2199 //------------------------------------------------------------------------------
;    2200 // HUNO의 0점 자세, HUNO, DINO, DOGY 기본 자세 동작
;    2201 //------------------------------------------------------------------------------
;    2202 void BasicPose(BYTE PF, WORD NOF, WORD RT, BYTE TQ)
;    2203 {
_BasicPose:
;    2204 	BYTE	trigger = 0;
;    2205 	WORD	i;
;    2206 
;    2207 	if(F_CHARGING)	return;
	CALL __SAVELOCR3
;	PF -> Y+8
;	NOF -> Y+6
;	RT -> Y+4
;	TQ -> Y+3
;	trigger -> R16
;	i -> R17,R18
	LDI  R16,0
	SBRC R2,6
	RJMP _0x329
;    2208 	if(F_PF == PF2)	return;
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x1FA
	RJMP _0x329
;    2209 	if(F_PF != PF1_HUNO && PF == 0){
_0x1FA:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ _0x1FC
	LDD  R26,Y+8
	CPI  R26,LOW(0x0)
	BREQ _0x1FD
_0x1FC:
	RJMP _0x1FB
_0x1FD:
;    2210 		F_ERR_CODE = PF_MATCH_ERR;
	LDI  R30,LOW(5)
	MOV  R13,R30
;    2211 		return;
	RJMP _0x329
;    2212 	}
;    2213 	
;    2214 	if(NOF != 1){
_0x1FB:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BREQ _0x1FE
;    2215 		if(PF == PF1_HUNO)		SendToSoundIC(1);
	LDD  R26,Y+8
	CPI  R26,LOW(0x1)
	BRNE _0x1FF
	LDI  R30,LOW(1)
	RJMP _0x33E
;    2216 		else if(PF == PF1_DOGY)	SendToSoundIC(9);
_0x1FF:
	LDD  R26,Y+8
	CPI  R26,LOW(0x3)
	BRNE _0x201
	LDI  R30,LOW(9)
_0x33E:
	ST   -Y,R30
	CALL _SendToSoundIC
;    2217 	}
_0x201:
;    2218 
;    2219 	Motion.PF = PF;
_0x1FE:
	LDD  R30,Y+8
	__PUTB1MN _Motion,5
;    2220 	Motion.NumOfScene = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x7A
;    2221 	Motion.NumOfwCK = 16;
;    2222 	gLastID = 15;
	LDI  R30,LOW(15)
	STS  _gLastID,R30
;    2223 
;    2224 	for(i=0; i < Motion.NumOfwCK; i++){
	__GETWRN 17,18,0
_0x203:
	CALL SUBOPT_0x5E
	CP   R17,R30
	CPC  R18,R31
	BRLO PC+3
	JMP _0x204
;    2225 		Motion.wCK[i].Exist		= 1;
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x56
	LDI  R30,LOW(1)
	ST   X,R30
;    2226 		if(i>9){
	__CPWRN 17,18,10
	BRLO _0x205
;    2227 			Motion.wCK[i].RPgain	= 15;
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x58
	LDI  R30,LOW(15)
	ST   X,R30
;    2228 			Motion.wCK[i].RDgain	= 25;
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x59
	LDI  R30,LOW(25)
	RJMP _0x33F
;    2229 		}
;    2230 		else{
_0x205:
;    2231 			Motion.wCK[i].RPgain	= 20;
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x58
	LDI  R30,LOW(20)
	ST   X,R30
;    2232 			Motion.wCK[i].RDgain	= 30;
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x59
	LDI  R30,LOW(30)
_0x33F:
	ST   X,R30
;    2233 		}
;    2234 		Motion.wCK[i].RIgain	= 0;
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x5A
	LDI  R30,LOW(0)
	ST   X,R30
;    2235 		Motion.wCK[i].PortEn	= 1;
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x5B
	LDI  R30,LOW(1)
	ST   X,R30
;    2236 		Motion.wCK[i].InitPos	= (int)MotionZeroPos[i];
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x5C
	__GETW1R 17,18
	SUBI R30,LOW(-_MotionZeroPos*2)
	SBCI R31,HIGH(-_MotionZeroPos*2)
	LPM  R30,Z
	ST   X,R30
;    2237 		gPoseDelta[i] = (int)eM_OriginPose[i] - (int)MotionZeroPos[i];
	__GETW1R 17,18
	LDI  R26,LOW(_gPoseDelta)
	LDI  R27,HIGH(_gPoseDelta)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x7C
	LDI  R31,0
	MOVW R26,R30
	__GETW1R 17,18
	SUBI R30,LOW(-_MotionZeroPos*2)
	SBCI R31,HIGH(-_MotionZeroPos*2)
	LPM  R30,Z
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
;    2238 	}
	__ADDWRN 17,18,1
	RJMP _0x203
_0x204:
;    2239 	SendTGain();
	CALL _SendTGain
;    2240 	F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;    2241 	for(i=0; i < MAX_wCK; i++){					
	__GETWRN 17,18,0
_0x208:
	__CPWRN 17,18,31
	BRSH _0x209
;    2242 		if(Motion.wCK[i].Exist){ Scene.wCK[i].Exist = 1; }
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x56
	LD   R30,X
	CPI  R30,0
	BREQ _0x20A
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x67
	LDI  R30,LOW(1)
	ST   X,R30
;    2243 	}
_0x20A:
	__ADDWRN 17,18,1
	RJMP _0x208
_0x209:
;    2244 	GetPose();
	CALL SUBOPT_0x7E
;    2245 	if(F_ERR_CODE != NO_ERR)	return;
	BREQ _0x20B
	RJMP _0x329
;    2246 	trigger = 0;
_0x20B:
	LDI  R16,LOW(0)
;    2247 	for(i=0; i < Motion.NumOfwCK; i++){
	__GETWRN 17,18,0
_0x20D:
	CALL SUBOPT_0x5E
	CP   R17,R30
	CPC  R18,R31
	BRSH _0x20E
;    2248 		if( abs((float)Scene.wCK[i].DPos - (float)Scene.wCK[i].SPos) > 5 ){
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x7F
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x7F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3
	CALL SUBOPT_0x80
	SBIW R30,6
	BRLO _0x20F
;    2249 			trigger = 1;
	LDI  R16,LOW(1)
;    2250 			break;
	RJMP _0x20E
;    2251 		}
;    2252 	}
_0x20F:
	__ADDWRN 17,18,1
	RJMP _0x20D
_0x20E:
;    2253 	if(trigger){
	CPI  R16,0
	BREQ _0x210
;    2254 		trigger = 0;
	LDI  R16,LOW(0)
;    2255 		Scene.NumOfFrame = NOF;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x6B
;    2256 		Scene.RTime = RT;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x340
;    2257 	}
;    2258 	else{
_0x210:
;    2259 		Scene.NumOfFrame = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x6B
;    2260 		Scene.RTime = 20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
_0x340:
	__PUTW1MN _Scene,4
;    2261 	}
;    2262 
;    2263 	for(i=0; i < Motion.NumOfwCK; i++){
	__GETWRN 17,18,0
_0x213:
	CALL SUBOPT_0x5E
	CP   R17,R30
	CPC  R18,R31
	BRLO PC+3
	JMP _0x214
;    2264 		if(PF == 0){			Scene.wCK[i].DPos = eM_OriginPose[i];}
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x215
	CALL SUBOPT_0x7D
	__ADDW1MN _Scene,8
	MOVW R0,R30
	CALL SUBOPT_0x7C
	MOVW R26,R0
	RJMP _0x341
;    2265 		else if(PF == PF1_HUNO){Scene.wCK[i].DPos = fM1_BasicPose[i];}
_0x215:
	LDD  R26,Y+8
	CPI  R26,LOW(0x1)
	BRNE _0x217
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x6F
	__GETW1R 17,18
	SUBI R30,LOW(-_fM1_BasicPose*2)
	SBCI R31,HIGH(-_fM1_BasicPose*2)
	RJMP _0x342
;    2266 		else if(PF == PF1_DINO){Scene.wCK[i].DPos = fM2_BasicPose[i];}
_0x217:
	LDD  R26,Y+8
	CPI  R26,LOW(0x2)
	BRNE _0x219
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x6F
	__GETW1R 17,18
	SUBI R30,LOW(-_fM2_BasicPose*2)
	SBCI R31,HIGH(-_fM2_BasicPose*2)
	RJMP _0x342
;    2267 		else if(PF == PF1_DOGY){Scene.wCK[i].DPos = fM3_BasicPose[i];}
_0x219:
	LDD  R26,Y+8
	CPI  R26,LOW(0x3)
	BRNE _0x21B
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x6F
	__GETW1R 17,18
	SUBI R30,LOW(-_fM3_BasicPose*2)
	SBCI R31,HIGH(-_fM3_BasicPose*2)
_0x342:
	LPM  R30,Z
_0x341:
	ST   X,R30
;    2268 		Scene.wCK[i].Torq		= TQ;
_0x21B:
	CALL SUBOPT_0x7D
	__ADDW1MN _Scene,9
	LDD  R26,Y+3
	STD  Z+0,R26
;    2269 		Scene.wCK[i].ExPortD	= 1;
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x68
	LDI  R30,LOW(1)
	ST   X,R30
;    2270 	}
	__ADDWRN 17,18,1
	RJMP _0x213
_0x214:
;    2271 	RUN_LED1_ON;
	CBI  0x1B,5
;    2272 	SendExPortD();
	CALL SUBOPT_0x81
;    2273 
;    2274 	CalcFrameInterval();
;    2275 	if(F_ERR_CODE != NO_ERR)	return;
	BREQ _0x21C
	RJMP _0x329
;    2276 	CalcUnitMove();
_0x21C:
	CALL SUBOPT_0x82
;    2277 	MakeFrame();
;    2278 	SendFrame();
;    2279 	while(F_SCENE_PLAYING);
_0x21D:
	SBRC R2,0
	RJMP _0x21D
;    2280 	if(F_MOTION_STOPPED == 1)	return;
	SBRC R2,3
	RJMP _0x329
;    2281 	if(NOF > 1){
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BRLO _0x221
;    2282 		delay_ms(800);
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	CALL SUBOPT_0x25
;    2283 		GetPose();
	CALL SUBOPT_0x7E
;    2284 		if(F_ERR_CODE != NO_ERR)	return;
	BREQ _0x222
	RJMP _0x329
;    2285 		for(i=0; i < Motion.NumOfwCK; i++){
_0x222:
	__GETWRN 17,18,0
_0x224:
	CALL SUBOPT_0x5E
	CP   R17,R30
	CPC  R18,R31
	BRSH _0x225
;    2286 			if( abs((float)Scene.wCK[i].DPos - (float)Scene.wCK[i].SPos) > 10 ){
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x7F
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x7F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3
	CALL SUBOPT_0x80
	SBIW R30,11
	BRLO _0x226
;    2287 				F_ERR_CODE = WCK_POS_ERR;
	LDI  R30,LOW(10)
	MOV  R13,R30
;    2288 				break;
	RJMP _0x225
;    2289 			}
;    2290 		}
_0x226:
	__ADDWRN 17,18,1
	RJMP _0x224
_0x225:
;    2291 	}
;    2292 	RUN_LED1_OFF;
_0x221:
	SBI  0x1B,5
;    2293 }
_0x329:
	CALL __LOADLOCR3
	ADIW R28,9
	RET
;    2294 
;    2295 
;    2296 //------------------------------------------------------------------------------
;    2297 // 현재 자세 읽기
;    2298 //------------------------------------------------------------------------------
;    2299 void GetPose(void)
;    2300 {
_GetPose:
;    2301 	WORD	i, tmp;
;    2302 
;    2303 	UCSR0B |= 0x80;
	CALL __SAVELOCR4
;	i -> R16,R17
;	tmp -> R18,R19
	SBI  0xA,7
;    2304 	UCSR0B &= 0xBF;
	CBI  0xA,6
;    2305 	for(i=0; i < MAX_wCK; i++){
	__GETWRN 16,17,0
_0x228:
	__CPWRN 16,17,31
	BRSH _0x229
;    2306 		if(Motion.wCK[i].Exist){
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	LD   R30,X
	CPI  R30,0
	BREQ _0x22A
;    2307 			tmp = PosRead(i);
	CALL SUBOPT_0x83
;    2308 			if(tmp == 444){
	BRNE _0x22B
;    2309 				tmp = PosRead(i);
	CALL SUBOPT_0x83
;    2310 				if(tmp == 444){
	BRNE _0x22C
;    2311 					tmp = PosRead(i);
	CALL SUBOPT_0x83
;    2312 					if(tmp == 444){
	BRNE _0x22D
;    2313 						F_ERR_CODE = WCK_NO_ACK_ERR;
	LDI  R30,LOW(11)
	MOV  R13,R30
;    2314 						return;
	RJMP _0x328
;    2315 					}
;    2316 				}
_0x22D:
;    2317 			}
_0x22C:
;    2318 			Scene.wCK[i].SPos = (BYTE)tmp;
_0x22B:
	CALL SUBOPT_0x66
	__POINTW2MN _Scene,7
	ADD  R26,R30
	ADC  R27,R31
	ST   X,R18
;    2319 		}
;    2320 	}
_0x22A:
	__ADDWRN 16,17,1
	RJMP _0x228
_0x229:
;    2321 }
_0x328:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;    2322 
;    2323 
;    2324 
;    2325 //------------------------------------------------------------------------------
;    2326 // 모션 트위닝 씬 실행
;    2327 //------------------------------------------------------------------------------
;    2328 void MotionTweenFlash(BYTE GapMax)
;    2329 {
_MotionTweenFlash:
;    2330 	WORD	i;
;    2331 
;    2332 	Scene.NumOfFrame = (WORD)GapMax;
	ST   -Y,R17
	ST   -Y,R16
;	GapMax -> Y+2
;	i -> R16,R17
	LDD  R30,Y+2
	LDI  R31,0
	CALL SUBOPT_0x6B
;    2333 	Scene.RTime = (WORD)GapMax*20;
	LDD  R30,Y+2
	LDI  R26,LOW(20)
	MUL  R30,R26
	MOVW R30,R0
	CALL SUBOPT_0x6C
;    2334 	for(i=0;i<MAX_wCK;i++){
_0x22F:
	__CPWRN 16,17,31
	BRSH _0x230
;    2335 		Scene.wCK[i].Exist		= 0;
	CALL SUBOPT_0x66
	CALL SUBOPT_0x67
	CALL SUBOPT_0x6D
;    2336 		Scene.wCK[i].DPos		= 0;
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x6D
;    2337 		Scene.wCK[i].Torq		= 0;
	CALL SUBOPT_0x70
	CALL SUBOPT_0x6D
;    2338 		Scene.wCK[i].ExPortD	= 0;
	CALL SUBOPT_0x68
	LDI  R30,LOW(0)
	ST   X,R30
;    2339 	}
	__ADDWRN 16,17,1
	RJMP _0x22F
_0x230:
;    2340 	for(i=0;i<Motion.NumOfwCK;i++){
	__GETWRN 16,17,0
_0x232:
	CALL SUBOPT_0x5E
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x233
;    2341 		Scene.wCK[wCK_IDs[i]].Exist		= 1;
	CALL SUBOPT_0x71
	CALL SUBOPT_0x67
	LDI  R30,LOW(1)
	ST   X,R30
;    2342 		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[i];
	CALL SUBOPT_0x71
	__ADDW1MN _Scene,8
	CALL SUBOPT_0x60
	CALL SUBOPT_0x84
	MOVW R26,R0
	ST   X,R30
;    2343 		Scene.wCK[wCK_IDs[i]].Torq		= 3;
	CALL SUBOPT_0x71
	CALL SUBOPT_0x70
	LDI  R30,LOW(3)
	ST   X,R30
;    2344 		Scene.wCK[wCK_IDs[i]].ExPortD	= 0;
	CALL SUBOPT_0x71
	CALL SUBOPT_0x68
	LDI  R30,LOW(0)
	ST   X,R30
;    2345 	}
	__ADDWRN 16,17,1
	RJMP _0x232
_0x233:
;    2346 	UCSR0B &= 0x7F;
	CBI  0xA,7
;    2347 	UCSR0B |= 0x40;
	SBI  0xA,6
;    2348 	SendExPortD();
	CALL SUBOPT_0x81
;    2349 	CalcFrameInterval();
;    2350 	if(F_ERR_CODE != NO_ERR)	return;
	BREQ _0x234
	RJMP _0x327
;    2351 	CalcUnitMove();
_0x234:
	CALL SUBOPT_0x82
;    2352 	MakeFrame();
;    2353 	SendFrame();
;    2354 	while(F_SCENE_PLAYING);
_0x235:
	SBRC R2,0
	RJMP _0x235
;    2355 	if(F_MOTION_STOPPED == 1)	return;
;    2356 }
_0x327:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
;    2357 
;    2358 
;    2359 //------------------------------------------------------------------------------
;    2360 // 모션 플레이(내부 Flash 데이터 이용)
;    2361 //------------------------------------------------------------------------------
;    2362 void M_PlayFlash(void)
;    2363 {
_M_PlayFlash:
;    2364 	float	lGapMax = 0;
;    2365 	WORD	i;
;    2366 
;    2367 	if(F_CHARGING) return;
	SBIW R28,4
	LDI  R24,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x239*2)
	LDI  R31,HIGH(_0x239*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	lGapMax -> Y+2
;	i -> R16,R17
	SBRC R2,6
	RJMP _0x326
;    2368 
;    2369 	GetMotionFromFlash();
	CALL _GetMotionFromFlash
;    2370 	SendTGain();
	CALL _SendTGain
;    2371 
;    2372 	F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;    2373 
;    2374 	GetPose();
	CALL SUBOPT_0x7E
;    2375 	if(F_ERR_CODE != NO_ERR)	return;
	BREQ _0x23B
	RJMP _0x326
;    2376 	for(i=0;i<Motion.NumOfwCK;i++){
_0x23B:
	__GETWRN 16,17,0
_0x23D:
	CALL SUBOPT_0x5E
	CP   R16,R30
	CPC  R17,R31
	BRLO PC+3
	JMP _0x23E
;    2377 		if( abs((float)gpPos_Table[i]-(float)Scene.wCK[i].SPos) > lGapMax )
	MOVW R30,R16
	CALL SUBOPT_0x84
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x66
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x7F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3
	CALL SUBOPT_0x80
	MOVW R26,R30
	__GETD1S 2
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x23F
;    2378 			lGapMax = abs((float)gpPos_Table[i]-(float)Scene.wCK[i].SPos);
	MOVW R30,R16
	CALL SUBOPT_0x84
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x66
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x7F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3
	CALL SUBOPT_0x80
	CALL SUBOPT_0x76
	CALL SUBOPT_0x4D
;    2379 		if(gpT_Table[i] == 6)
_0x23F:
	MOVW R30,R16
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x6)
	BRNE _0x240
;    2380 			lGapMax = 0;
	__CLRD1S 2
;    2381 	}
_0x240:
	__ADDWRN 16,17,1
	RJMP _0x23D
_0x23E:
;    2382 	if(lGapMax > POS_MARGIN)	MotionTweenFlash((BYTE)(lGapMax/3));
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x241
	CALL SUBOPT_0x4C
	__GETD1N 0x40400000
	CALL __DIVF21
	CALL __CFD1
	ST   -Y,R30
	CALL _MotionTweenFlash
;    2383 
;    2384 	for(i=0; i < Motion.NumOfScene; i++){
_0x241:
	__GETWRN 16,17,0
_0x243:
	__GETW1MN _Motion,6
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x244
;    2385 		gScIdx = i;
	__PUTWMRN _gScIdx,0,16,17
;    2386 		GetSceneFromFlash();
	CALL _GetSceneFromFlash
;    2387 		SendExPortD();
	CALL SUBOPT_0x81
;    2388 		CalcFrameInterval();
;    2389 		if(F_ERR_CODE != NO_ERR)	break;
	BRNE _0x244
;    2390 		CalcUnitMove();
	CALL SUBOPT_0x82
;    2391 		MakeFrame();
;    2392 		SendFrame();
;    2393 		while(F_SCENE_PLAYING);
_0x246:
	SBRC R2,0
	RJMP _0x246
;    2394 		if(F_MOTION_STOPPED == 1)	break;
	SBRC R2,3
	RJMP _0x244
;    2395 	}
	__ADDWRN 16,17,1
	RJMP _0x243
_0x244:
;    2396 }
_0x326:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;    2397 
;    2398 
;    2399 //------------------------------------------------------------------------------
;    2400 // 모션 실행
;    2401 //------------------------------------------------------------------------------
;    2402 void M_Play(BYTE BtnCode)
;    2403 {
_M_Play:
;    2404 	if(BtnCode == BTN_C){
;	BtnCode -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x24A
;    2405 		P_BMC504_RESET(0);
	CBI  0x18,6
;    2406 		delay_ms(20);
	CALL SUBOPT_0x44
;    2407 		P_BMC504_RESET(1);
	SBI  0x18,6
;    2408 		delay_ms(20);
	CALL SUBOPT_0x44
;    2409 		BasicPose(F_PF, 50, 1000, 4);
	ST   -Y,R12
	CALL SUBOPT_0x85
;    2410 		if(F_ERR_CODE != NO_ERR){
	LDI  R30,LOW(255)
	CP   R30,R13
	BREQ _0x24F
;    2411 			gSEC_DCOUNT = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x2B
;    2412 			EIMSK &= 0xBF;
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;    2413 			while(gSEC_DCOUNT){
_0x250:
	CALL SUBOPT_0x2A
	SBIW R30,0
	BREQ _0x252
;    2414 				if(g10MSEC == 0 || g10MSEC == 50){
	CALL SUBOPT_0x37
	BREQ _0x254
	CALL SUBOPT_0x29
	SBIW R26,50
	BRNE _0x253
_0x254:
;    2415 					Get_VOLTAGE();
	CALL SUBOPT_0x34
;    2416 					DetectPower();
;    2417 					IoUpdate();
	RCALL _IoUpdate
;    2418 				}
;    2419 				if(g10MSEC < 25)		ERR_LED_ON;
_0x253:
	CALL SUBOPT_0x29
	SBIW R26,25
	BRSH _0x256
	CBI  0x1B,7
;    2420 				else if(g10MSEC < 50)	ERR_LED_OFF;
	RJMP _0x257
_0x256:
	CALL SUBOPT_0x29
	SBIW R26,50
	BRSH _0x258
	RJMP _0x343
;    2421 				else if(g10MSEC < 75)	ERR_LED_ON;
_0x258:
	CALL SUBOPT_0x3B
	BRSH _0x25A
	CBI  0x1B,7
;    2422 				else if(g10MSEC < 100)	ERR_LED_OFF;
	RJMP _0x25B
_0x25A:
	CALL SUBOPT_0x3C
	BRSH _0x25C
_0x343:
	SBI  0x1B,7
;    2423 			}
_0x25C:
_0x25B:
_0x257:
	RJMP _0x250
_0x252:
;    2424 			F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;    2425 			EIMSK |= 0x40;
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    2426 		}
;    2427 		return;
_0x24F:
	ADIW R28,1
	RET
;    2428 	}
;    2429 	if(F_PF == PF1_HUNO){
_0x24A:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ PC+3
	JMP _0x25D
;    2430 		switch(BtnCode){
	LD   R30,Y
;    2431 			case BTN_A:
	CPI  R30,LOW(0x1)
	BRNE _0x261
;    2432 			 	SendToSoundIC(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2433 				gpT_Table	= HUNOBASIC_GETUPFRONT_Torque;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_Torque*2)
	CALL SUBOPT_0x86
;    2434 				gpE_Table	= HUNOBASIC_GETUPFRONT_Port;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_Port*2)
	CALL SUBOPT_0x87
;    2435 				gpPg_Table 	= HUNOBASIC_GETUPFRONT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2436 				gpDg_Table 	= HUNOBASIC_GETUPFRONT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2437 				gpIg_Table 	= HUNOBASIC_GETUPFRONT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2438 				gpFN_Table	= HUNOBASIC_GETUPFRONT_Frames;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_Frames*2)
	CALL SUBOPT_0x8B
;    2439 				gpRT_Table	= HUNOBASIC_GETUPFRONT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_TrTime*2)
	CALL SUBOPT_0x8C
;    2440 				gpPos_Table	= HUNOBASIC_GETUPFRONT_Position;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_Position*2)
	CALL SUBOPT_0x8D
;    2441 				Motion.NumOfScene = HUNOBASIC_GETUPFRONT_NUM_OF_SCENES;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0x7A
;    2442 				Motion.NumOfwCK = HUNOBASIC_GETUPFRONT_NUM_OF_WCKS;
;    2443 				break;
	RJMP _0x260
;    2444 			case BTN_B:
_0x261:
	CPI  R30,LOW(0x2)
	BRNE _0x262
;    2445 			 	SendToSoundIC(8);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2446 				gpT_Table	= HUNOBASIC_GETUPBACK_Torque;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_Torque*2)
	CALL SUBOPT_0x86
;    2447 				gpE_Table	= HUNOBASIC_GETUPBACK_Port;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_Port*2)
	CALL SUBOPT_0x87
;    2448 				gpPg_Table 	= HUNOBASIC_GETUPBACK_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2449 				gpDg_Table 	= HUNOBASIC_GETUPBACK_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2450 				gpIg_Table 	= HUNOBASIC_GETUPBACK_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2451 				gpFN_Table	= HUNOBASIC_GETUPBACK_Frames;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_Frames*2)
	CALL SUBOPT_0x8B
;    2452 				gpRT_Table	= HUNOBASIC_GETUPBACK_TrTime;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_TrTime*2)
	CALL SUBOPT_0x8C
;    2453 				gpPos_Table	= HUNOBASIC_GETUPBACK_Position;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_Position*2)
	CALL SUBOPT_0x8E
;    2454 				Motion.NumOfScene = HUNOBASIC_GETUPBACK_NUM_OF_SCENES;
;    2455 				Motion.NumOfwCK = HUNOBASIC_GETUPBACK_NUM_OF_WCKS;
;    2456 				break;
	RJMP _0x260
;    2457 			case BTN_LR:
_0x262:
	CPI  R30,LOW(0x3)
	BRNE _0x263
;    2458 			 	SendToSoundIC(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2459 				gpT_Table	= HUNOBASIC_TURNLEFT_Torque;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_Torque*2)
	CALL SUBOPT_0x86
;    2460 				gpE_Table	= HUNOBASIC_TURNLEFT_Port;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_Port*2)
	CALL SUBOPT_0x87
;    2461 				gpPg_Table 	= HUNOBASIC_TURNLEFT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2462 				gpDg_Table 	= HUNOBASIC_TURNLEFT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2463 				gpIg_Table 	= HUNOBASIC_TURNLEFT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2464 				gpFN_Table	= HUNOBASIC_TURNLEFT_Frames;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_Frames*2)
	CALL SUBOPT_0x8B
;    2465 				gpRT_Table	= HUNOBASIC_TURNLEFT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_TrTime*2)
	CALL SUBOPT_0x8C
;    2466 				gpPos_Table	= HUNOBASIC_TURNLEFT_Position;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_Position*2)
	CALL SUBOPT_0x8F
;    2467 				Motion.NumOfScene = HUNOBASIC_TURNLEFT_NUM_OF_SCENES;
;    2468 				Motion.NumOfwCK = HUNOBASIC_TURNLEFT_NUM_OF_WCKS;
;    2469 				break;
	RJMP _0x260
;    2470 			case BTN_U:
_0x263:
	CPI  R30,LOW(0x4)
	BRNE _0x264
;    2471 			 	//SendToSoundIC(2);
;    2472 				gpT_Table	= HUNOBASIC_WALKFORWARD_Torque;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_Torque*2)
	CALL SUBOPT_0x86
;    2473 				gpE_Table	= HUNOBASIC_WALKFORWARD_Port;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_Port*2)
	CALL SUBOPT_0x87
;    2474 				gpPg_Table 	= HUNOBASIC_WALKFORWARD_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2475 				gpDg_Table 	= HUNOBASIC_WALKFORWARD_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2476 				gpIg_Table 	= HUNOBASIC_WALKFORWARD_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2477 				gpFN_Table	= HUNOBASIC_WALKFORWARD_Frames;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_Frames*2)
	CALL SUBOPT_0x8B
;    2478 				gpRT_Table	= HUNOBASIC_WALKFORWARD_TrTime;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_TrTime*2)
	CALL SUBOPT_0x8C
;    2479 				gpPos_Table	= HUNOBASIC_WALKFORWARD_Position;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_Position*2)
	CALL SUBOPT_0x8D
;    2480 				Motion.NumOfScene = HUNOBASIC_WALKFORWARD_NUM_OF_SCENES;
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x7A
;    2481 				Motion.NumOfwCK = HUNOBASIC_WALKFORWARD_NUM_OF_WCKS;
;    2482 				break;
	RJMP _0x260
;    2483 			case BTN_RR:
_0x264:
	CPI  R30,LOW(0x5)
	BRNE _0x265
;    2484 			 	SendToSoundIC(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2485 				gpT_Table	= HUNOBASIC_TURNRIGHT_Torque;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_Torque*2)
	CALL SUBOPT_0x86
;    2486 				gpE_Table	= HUNOBASIC_TURNRIGHT_Port;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_Port*2)
	CALL SUBOPT_0x87
;    2487 				gpPg_Table 	= HUNOBASIC_TURNRIGHT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2488 				gpDg_Table 	= HUNOBASIC_TURNRIGHT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2489 				gpIg_Table 	= HUNOBASIC_TURNRIGHT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2490 				gpFN_Table	= HUNOBASIC_TURNRIGHT_Frames;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_Frames*2)
	CALL SUBOPT_0x8B
;    2491 				gpRT_Table	= HUNOBASIC_TURNRIGHT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_TrTime*2)
	CALL SUBOPT_0x8C
;    2492 				gpPos_Table	= HUNOBASIC_TURNRIGHT_Position;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_Position*2)
	CALL SUBOPT_0x8F
;    2493 				Motion.NumOfScene = HUNOBASIC_TURNRIGHT_NUM_OF_SCENES;
;    2494 				Motion.NumOfwCK = HUNOBASIC_TURNRIGHT_NUM_OF_WCKS;
;    2495 				break;
	RJMP _0x260
;    2496 			case BTN_L:
_0x265:
	CPI  R30,LOW(0x6)
	BRNE _0x266
;    2497 			 	SendToSoundIC(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2498 				gpT_Table	= HUNOBASIC_SIDEWALKLEFT_Torque;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_Torque*2)
	CALL SUBOPT_0x86
;    2499 				gpE_Table	= HUNOBASIC_SIDEWALKLEFT_Port;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_Port*2)
	CALL SUBOPT_0x87
;    2500 				gpPg_Table 	= HUNOBASIC_SIDEWALKLEFT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2501 				gpDg_Table 	= HUNOBASIC_SIDEWALKLEFT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2502 				gpIg_Table 	= HUNOBASIC_SIDEWALKLEFT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2503 				gpFN_Table	= HUNOBASIC_SIDEWALKLEFT_Frames;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_Frames*2)
	CALL SUBOPT_0x8B
;    2504 				gpRT_Table	= HUNOBASIC_SIDEWALKLEFT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_TrTime*2)
	CALL SUBOPT_0x8C
;    2505 				gpPos_Table	= HUNOBASIC_SIDEWALKLEFT_Position;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_Position*2)
	CALL SUBOPT_0x8F
;    2506 				Motion.NumOfScene = HUNOBASIC_SIDEWALKLEFT_NUM_OF_SCENES;
;    2507 				Motion.NumOfwCK = HUNOBASIC_SIDEWALKLEFT_NUM_OF_WCKS;
;    2508 				break;
	RJMP _0x260
;    2509 			case BTN_R:
_0x266:
	CPI  R30,LOW(0x8)
	BRNE _0x267
;    2510 			 	SendToSoundIC(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2511 				gpT_Table	= HUNOBASIC_SIDEWALKRIGHT_Torque;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_Torque*2)
	CALL SUBOPT_0x86
;    2512 				gpE_Table	= HUNOBASIC_SIDEWALKRIGHT_Port;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_Port*2)
	CALL SUBOPT_0x87
;    2513 				gpPg_Table 	= HUNOBASIC_SIDEWALKRIGHT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2514 				gpDg_Table 	= HUNOBASIC_SIDEWALKRIGHT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2515 				gpIg_Table 	= HUNOBASIC_SIDEWALKRIGHT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2516 				gpFN_Table	= HUNOBASIC_SIDEWALKRIGHT_Frames;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_Frames*2)
	CALL SUBOPT_0x8B
;    2517 				gpRT_Table	= HUNOBASIC_SIDEWALKRIGHT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_TrTime*2)
	CALL SUBOPT_0x8C
;    2518 				gpPos_Table	= HUNOBASIC_SIDEWALKRIGHT_Position;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_Position*2)
	CALL SUBOPT_0x8F
;    2519 				Motion.NumOfScene = HUNOBASIC_SIDEWALKRIGHT_NUM_OF_SCENES;
;    2520 				Motion.NumOfwCK = HUNOBASIC_SIDEWALKRIGHT_NUM_OF_WCKS;
;    2521 				break;
	RJMP _0x260
;    2522 			case BTN_LA:
_0x267:
	CPI  R30,LOW(0x9)
	BRNE _0x268
;    2523 			 	SendToSoundIC(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2524 				gpT_Table	= HUNOBASIC_PUNCHLEFT_Torque;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_Torque*2)
	CALL SUBOPT_0x86
;    2525 				gpE_Table	= HUNOBASIC_PUNCHLEFT_Port;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_Port*2)
	CALL SUBOPT_0x87
;    2526 				gpPg_Table 	= HUNOBASIC_PUNCHLEFT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2527 				gpDg_Table 	= HUNOBASIC_PUNCHLEFT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2528 				gpIg_Table 	= HUNOBASIC_PUNCHLEFT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2529 				gpFN_Table	= HUNOBASIC_PUNCHLEFT_Frames;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_Frames*2)
	CALL SUBOPT_0x8B
;    2530 				gpRT_Table	= HUNOBASIC_PUNCHLEFT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_TrTime*2)
	CALL SUBOPT_0x8C
;    2531 				gpPos_Table	= HUNOBASIC_PUNCHLEFT_Position;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_Position*2)
	CALL SUBOPT_0x90
;    2532 				Motion.NumOfScene = HUNOBASIC_PUNCHLEFT_NUM_OF_SCENES;
;    2533 				Motion.NumOfwCK = HUNOBASIC_PUNCHLEFT_NUM_OF_WCKS;
;    2534 				break;
	RJMP _0x260
;    2535 			case BTN_D:
_0x268:
	CPI  R30,LOW(0xA)
	BRNE _0x269
;    2536 			 	SendToSoundIC(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2537 				gpT_Table	= HUNOBASIC_WALKBACKWARD_Torque;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_Torque*2)
	CALL SUBOPT_0x86
;    2538 				gpE_Table	= HUNOBASIC_WALKBACKWARD_Port;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_Port*2)
	CALL SUBOPT_0x87
;    2539 				gpPg_Table 	= HUNOBASIC_WALKBACKWARD_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2540 				gpDg_Table 	= HUNOBASIC_WALKBACKWARD_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2541 				gpIg_Table 	= HUNOBASIC_WALKBACKWARD_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2542 				gpFN_Table	= HUNOBASIC_WALKBACKWARD_Frames;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_Frames*2)
	CALL SUBOPT_0x8B
;    2543 				gpRT_Table	= HUNOBASIC_WALKBACKWARD_TrTime;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_TrTime*2)
	CALL SUBOPT_0x8C
;    2544 				gpPos_Table	= HUNOBASIC_WALKBACKWARD_Position;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_Position*2)
	CALL SUBOPT_0x91
;    2545 				Motion.NumOfScene = HUNOBASIC_WALKBACKWARD_NUM_OF_SCENES;
;    2546 				Motion.NumOfwCK = HUNOBASIC_WALKBACKWARD_NUM_OF_WCKS;
;    2547 				break;
	RJMP _0x260
;    2548 			case BTN_RA:
_0x269:
	CPI  R30,LOW(0xB)
	BRNE _0x26A
;    2549 			 	SendToSoundIC(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2550 				gpT_Table	= HUNOBASIC_PUNCHRIGHT_Torque;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_Torque*2)
	CALL SUBOPT_0x86
;    2551 				gpE_Table	= HUNOBASIC_PUNCHRIGHT_Port;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_Port*2)
	CALL SUBOPT_0x87
;    2552 				gpPg_Table 	= HUNOBASIC_PUNCHRIGHT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2553 				gpDg_Table 	= HUNOBASIC_PUNCHRIGHT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2554 				gpIg_Table 	= HUNOBASIC_PUNCHRIGHT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2555 				gpFN_Table	= HUNOBASIC_PUNCHRIGHT_Frames;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_Frames*2)
	CALL SUBOPT_0x8B
;    2556 				gpRT_Table	= HUNOBASIC_PUNCHRIGHT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_TrTime*2)
	CALL SUBOPT_0x8C
;    2557 				gpPos_Table	= HUNOBASIC_PUNCHRIGHT_Position;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_Position*2)
	CALL SUBOPT_0x90
;    2558 				Motion.NumOfScene = HUNOBASIC_PUNCHRIGHT_NUM_OF_SCENES;
;    2559 				Motion.NumOfwCK = HUNOBASIC_PUNCHRIGHT_NUM_OF_WCKS;
;    2560 				break;
	RJMP _0x260
;    2561 			case BTN_0:
_0x26A:
	CPI  R30,LOW(0x15)
	BRNE _0x26C
;    2562 				gpT_Table	= MY_DEMO1_Torque;
	LDI  R30,LOW(_MY_DEMO1_Torque*2)
	LDI  R31,HIGH(_MY_DEMO1_Torque*2)
	CALL SUBOPT_0x86
;    2563 				gpE_Table	= MY_DEMO1_Port;
	LDI  R30,LOW(_MY_DEMO1_Port*2)
	LDI  R31,HIGH(_MY_DEMO1_Port*2)
	CALL SUBOPT_0x87
;    2564 				gpPg_Table 	= MY_DEMO1_RuntimePGain;
	LDI  R30,LOW(_MY_DEMO1_RuntimePGain*2)
	LDI  R31,HIGH(_MY_DEMO1_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2565 				gpDg_Table 	= MY_DEMO1_RuntimeDGain;
	LDI  R30,LOW(_MY_DEMO1_RuntimeDGain*2)
	LDI  R31,HIGH(_MY_DEMO1_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2566 				gpIg_Table 	= MY_DEMO1_RuntimeIGain;
	LDI  R30,LOW(_MY_DEMO1_RuntimeIGain*2)
	LDI  R31,HIGH(_MY_DEMO1_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2567 				gpFN_Table	= MY_DEMO1_Frames;
	LDI  R30,LOW(_MY_DEMO1_Frames*2)
	LDI  R31,HIGH(_MY_DEMO1_Frames*2)
	CALL SUBOPT_0x8B
;    2568 				gpRT_Table	= MY_DEMO1_TrTime;
	LDI  R30,LOW(_MY_DEMO1_TrTime*2)
	LDI  R31,HIGH(_MY_DEMO1_TrTime*2)
	CALL SUBOPT_0x8C
;    2569 				gpPos_Table	= MY_DEMO1_Position;
	LDI  R30,LOW(_MY_DEMO1_Position*2)
	LDI  R31,HIGH(_MY_DEMO1_Position*2)
	CALL SUBOPT_0x90
;    2570 				Motion.NumOfScene = MY_DEMO1_NUM_OF_SCENES;
;    2571 				Motion.NumOfwCK = MY_DEMO1_NUM_OF_WCKS;
;    2572 				break;
	RJMP _0x260
;    2573 			default:
_0x26C:
;    2574 				return;
	RJMP _0x325
;    2575 		}
_0x260:
;    2576 	}
;    2577 	else if(F_PF == PF1_DINO){
	RJMP _0x26D
_0x25D:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0x26E
;    2578 		switch(BtnCode){
	LD   R30,Y
;    2579 			case BTN_A:
	CPI  R30,LOW(0x1)
	BRNE _0x272
;    2580 	 			SendToSoundIC(13);
	CALL SUBOPT_0x92
;    2581 				gpT_Table	= DinoBasic_GetupFront_Torque;
	LDI  R30,LOW(_DinoBasic_GetupFront_Torque*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_Torque*2)
	CALL SUBOPT_0x86
;    2582 				gpE_Table	= DinoBasic_GetupFront_Port;
	LDI  R30,LOW(_DinoBasic_GetupFront_Port*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_Port*2)
	CALL SUBOPT_0x87
;    2583 				gpPg_Table 	= DinoBasic_GetupFront_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_GetupFront_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2584 				gpDg_Table 	= DinoBasic_GetupFront_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_GetupFront_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2585 				gpIg_Table 	= DinoBasic_GetupFront_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_GetupFront_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2586 				gpFN_Table	= DinoBasic_GetupFront_Frames;
	LDI  R30,LOW(_DinoBasic_GetupFront_Frames*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_Frames*2)
	CALL SUBOPT_0x8B
;    2587 				gpRT_Table	= DinoBasic_GetupFront_TrTime;
	LDI  R30,LOW(_DinoBasic_GetupFront_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_TrTime*2)
	CALL SUBOPT_0x8C
;    2588 				gpPos_Table	= DinoBasic_GetupFront_Position;
	LDI  R30,LOW(_DinoBasic_GetupFront_Position*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_Position*2)
	CALL SUBOPT_0x8F
;    2589 				Motion.NumOfScene = DINOBASIC_GETUPFRONT_NUM_OF_SCENES;
;    2590 				Motion.NumOfwCK = DINOBASIC_GETUPFRONT_NUM_OF_WCKS;
;    2591 				break;
	RJMP _0x271
;    2592 			case BTN_B:
_0x272:
	CPI  R30,LOW(0x2)
	BRNE _0x273
;    2593 	 			SendToSoundIC(13);
	CALL SUBOPT_0x92
;    2594 				gpT_Table	= DinoBasic_GetupBack_Torque;
	LDI  R30,LOW(_DinoBasic_GetupBack_Torque*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_Torque*2)
	CALL SUBOPT_0x86
;    2595 				gpE_Table	= DinoBasic_GetupBack_Port;
	LDI  R30,LOW(_DinoBasic_GetupBack_Port*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_Port*2)
	CALL SUBOPT_0x87
;    2596 				gpPg_Table 	= DinoBasic_GetupBack_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_GetupBack_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2597 				gpDg_Table 	= DinoBasic_GetupBack_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_GetupBack_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2598 				gpIg_Table 	= DinoBasic_GetupBack_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_GetupBack_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2599 				gpFN_Table	= DinoBasic_GetupBack_Frames;
	LDI  R30,LOW(_DinoBasic_GetupBack_Frames*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_Frames*2)
	CALL SUBOPT_0x8B
;    2600 				gpRT_Table	= DinoBasic_GetupBack_TrTime;
	LDI  R30,LOW(_DinoBasic_GetupBack_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_TrTime*2)
	CALL SUBOPT_0x8C
;    2601 				gpPos_Table	= DinoBasic_GetupBack_Position;
	LDI  R30,LOW(_DinoBasic_GetupBack_Position*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_Position*2)
	CALL SUBOPT_0x8F
;    2602 				Motion.NumOfScene = DINOBASIC_GETUPBACK_NUM_OF_SCENES;
;    2603 				Motion.NumOfwCK = DINOBASIC_GETUPBACK_NUM_OF_WCKS;
;    2604 				break;
	RJMP _0x271
;    2605 			case BTN_LR:
_0x273:
	CPI  R30,LOW(0x3)
	BRNE _0x274
;    2606 			 	SendToSoundIC(13);
	CALL SUBOPT_0x92
;    2607 				gpT_Table	= DinoBasic_TurnLeft_Torque;
	LDI  R30,LOW(_DinoBasic_TurnLeft_Torque*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_Torque*2)
	CALL SUBOPT_0x86
;    2608 				gpE_Table	= DinoBasic_TurnLeft_Port;
	LDI  R30,LOW(_DinoBasic_TurnLeft_Port*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_Port*2)
	CALL SUBOPT_0x87
;    2609 				gpPg_Table 	= DinoBasic_TurnLeft_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_TurnLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2610 				gpDg_Table 	= DinoBasic_TurnLeft_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_TurnLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2611 				gpIg_Table 	= DinoBasic_TurnLeft_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_TurnLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2612 				gpFN_Table	= DinoBasic_TurnLeft_Frames;
	LDI  R30,LOW(_DinoBasic_TurnLeft_Frames*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_Frames*2)
	CALL SUBOPT_0x8B
;    2613 				gpRT_Table	= DinoBasic_TurnLeft_TrTime;
	LDI  R30,LOW(_DinoBasic_TurnLeft_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_TrTime*2)
	CALL SUBOPT_0x8C
;    2614 				gpPos_Table	= DinoBasic_TurnLeft_Position;
	LDI  R30,LOW(_DinoBasic_TurnLeft_Position*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_Position*2)
	CALL SUBOPT_0x8F
;    2615 				Motion.NumOfScene = DINOBASIC_TURNLEFT_NUM_OF_SCENES;
;    2616 				Motion.NumOfwCK = DINOBASIC_TURNLEFT_NUM_OF_WCKS;
;    2617 				break;
	RJMP _0x271
;    2618 			case BTN_U:
_0x274:
	CPI  R30,LOW(0x4)
	BRNE _0x275
;    2619 			 	SendToSoundIC(14);
	LDI  R30,LOW(14)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2620 				gpT_Table	= DinoBasic_WalkForward_Torque;
	LDI  R30,LOW(_DinoBasic_WalkForward_Torque*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_Torque*2)
	CALL SUBOPT_0x86
;    2621 				gpE_Table	= DinoBasic_WalkForward_Port;
	LDI  R30,LOW(_DinoBasic_WalkForward_Port*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_Port*2)
	CALL SUBOPT_0x87
;    2622 				gpPg_Table 	= DinoBasic_WalkForward_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_WalkForward_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2623 				gpDg_Table 	= DinoBasic_WalkForward_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_WalkForward_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2624 				gpIg_Table 	= DinoBasic_WalkForward_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_WalkForward_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2625 				gpFN_Table	= DinoBasic_WalkForward_Frames;
	LDI  R30,LOW(_DinoBasic_WalkForward_Frames*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_Frames*2)
	CALL SUBOPT_0x8B
;    2626 				gpRT_Table	= DinoBasic_WalkForward_TrTime;
	LDI  R30,LOW(_DinoBasic_WalkForward_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_TrTime*2)
	CALL SUBOPT_0x8C
;    2627 				gpPos_Table	= DinoBasic_WalkForward_Position;
	LDI  R30,LOW(_DinoBasic_WalkForward_Position*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_Position*2)
	CALL SUBOPT_0x91
;    2628 				Motion.NumOfScene = DINOBASIC_WALKFORWARD_NUM_OF_SCENES;
;    2629 				Motion.NumOfwCK = DINOBASIC_WALKFORWARD_NUM_OF_WCKS;
;    2630 				break;
	RJMP _0x271
;    2631 			case BTN_RR:
_0x275:
	CPI  R30,LOW(0x5)
	BRNE _0x276
;    2632 			 	SendToSoundIC(13);
	CALL SUBOPT_0x92
;    2633 				gpT_Table	= DinoBasic_TurnRight_Torque;
	LDI  R30,LOW(_DinoBasic_TurnRight_Torque*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_Torque*2)
	CALL SUBOPT_0x86
;    2634 				gpE_Table	= DinoBasic_TurnRight_Port;
	LDI  R30,LOW(_DinoBasic_TurnRight_Port*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_Port*2)
	CALL SUBOPT_0x87
;    2635 				gpPg_Table 	= DinoBasic_TurnRight_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_TurnRight_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2636 				gpDg_Table 	= DinoBasic_TurnRight_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_TurnRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2637 				gpIg_Table 	= DinoBasic_TurnRight_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_TurnRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2638 				gpFN_Table	= DinoBasic_TurnRight_Frames;
	LDI  R30,LOW(_DinoBasic_TurnRight_Frames*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_Frames*2)
	CALL SUBOPT_0x8B
;    2639 				gpRT_Table	= DinoBasic_TurnRight_TrTime;
	LDI  R30,LOW(_DinoBasic_TurnRight_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_TrTime*2)
	CALL SUBOPT_0x8C
;    2640 				gpPos_Table	= DinoBasic_TurnRight_Position;
	LDI  R30,LOW(_DinoBasic_TurnRight_Position*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_Position*2)
	CALL SUBOPT_0x8D
;    2641 				Motion.NumOfScene = DINOBASIC_TURNRIGHT_NUM_OF_SCENES;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x7A
;    2642 				Motion.NumOfwCK = DINOBASIC_TURNRIGHT_NUM_OF_WCKS;
;    2643 				break;
	RJMP _0x271
;    2644 			case BTN_L:
_0x276:
	CPI  R30,LOW(0x6)
	BRNE _0x277
;    2645 			 	SendToSoundIC(13);
	CALL SUBOPT_0x92
;    2646 				gpT_Table	= DinoBasic_SidewalkLeft_Torque;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_Torque*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_Torque*2)
	CALL SUBOPT_0x86
;    2647 				gpE_Table	= DinoBasic_SidewalkLeft_Port;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_Port*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_Port*2)
	CALL SUBOPT_0x87
;    2648 				gpPg_Table 	= DinoBasic_SidewalkLeft_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2649 				gpDg_Table 	= DinoBasic_SidewalkLeft_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2650 				gpIg_Table 	= DinoBasic_SidewalkLeft_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2651 				gpFN_Table	= DinoBasic_SidewalkLeft_Frames;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_Frames*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_Frames*2)
	CALL SUBOPT_0x8B
;    2652 				gpRT_Table	= DinoBasic_SidewalkLeft_TrTime;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_TrTime*2)
	CALL SUBOPT_0x8C
;    2653 				gpPos_Table	= DinoBasic_SidewalkLeft_Position;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_Position*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_Position*2)
	CALL SUBOPT_0x8F
;    2654 				Motion.NumOfScene = DINOBASIC_SIDEWALKLEFT_NUM_OF_SCENES;
;    2655 				Motion.NumOfwCK = DINOBASIC_SIDEWALKLEFT_NUM_OF_WCKS;
;    2656 				break;
	RJMP _0x271
;    2657 			case BTN_R:
_0x277:
	CPI  R30,LOW(0x8)
	BRNE _0x278
;    2658 			 	SendToSoundIC(13);
	CALL SUBOPT_0x92
;    2659 				gpT_Table	= DinoBasic_SidewalkRight_Torque;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_Torque*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_Torque*2)
	CALL SUBOPT_0x86
;    2660 				gpE_Table	= DinoBasic_SidewalkRight_Port;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_Port*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_Port*2)
	CALL SUBOPT_0x87
;    2661 				gpPg_Table 	= DinoBasic_SidewalkRight_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2662 				gpDg_Table 	= DinoBasic_SidewalkRight_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2663 				gpIg_Table 	= DinoBasic_SidewalkRight_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2664 				gpFN_Table	= DinoBasic_SidewalkRight_Frames;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_Frames*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_Frames*2)
	CALL SUBOPT_0x8B
;    2665 				gpRT_Table	= DinoBasic_SidewalkRight_TrTime;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_TrTime*2)
	CALL SUBOPT_0x8C
;    2666 				gpPos_Table	= DinoBasic_SidewalkRight_Position;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_Position*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_Position*2)
	CALL SUBOPT_0x8F
;    2667 				Motion.NumOfScene = DINOBASIC_SIDEWALKRIGHT_NUM_OF_SCENES;
;    2668 				Motion.NumOfwCK = DINOBASIC_SIDEWALKRIGHT_NUM_OF_WCKS;
;    2669 				break;
	RJMP _0x271
;    2670 			case BTN_LA:
_0x278:
	CPI  R30,LOW(0x9)
	BRNE _0x279
;    2671 			 	SendToSoundIC(13);
	CALL SUBOPT_0x92
;    2672 				gpT_Table	= DinoBasic_PunchLeft_Torque;
	LDI  R30,LOW(_DinoBasic_PunchLeft_Torque*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_Torque*2)
	CALL SUBOPT_0x86
;    2673 				gpE_Table	= DinoBasic_PunchLeft_Port;
	LDI  R30,LOW(_DinoBasic_PunchLeft_Port*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_Port*2)
	CALL SUBOPT_0x87
;    2674 				gpPg_Table 	= DinoBasic_PunchLeft_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_PunchLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2675 				gpDg_Table 	= DinoBasic_PunchLeft_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_PunchLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2676 				gpIg_Table 	= DinoBasic_PunchLeft_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_PunchLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2677 				gpFN_Table	= DinoBasic_PunchLeft_Frames;
	LDI  R30,LOW(_DinoBasic_PunchLeft_Frames*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_Frames*2)
	CALL SUBOPT_0x8B
;    2678 				gpRT_Table	= DinoBasic_PunchLeft_TrTime;
	LDI  R30,LOW(_DinoBasic_PunchLeft_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_TrTime*2)
	CALL SUBOPT_0x8C
;    2679 				gpPos_Table	= DinoBasic_PunchLeft_Position;
	LDI  R30,LOW(_DinoBasic_PunchLeft_Position*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_Position*2)
	CALL SUBOPT_0x93
;    2680 				Motion.NumOfScene = DINOBASIC_PUNCHLEFT_NUM_OF_SCENES;
;    2681 				Motion.NumOfwCK = DINOBASIC_PUNCHLEFT_NUM_OF_WCKS;
;    2682 				break;
	RJMP _0x271
;    2683 			case BTN_D:
_0x279:
	CPI  R30,LOW(0xA)
	BRNE _0x27A
;    2684 			 	SendToSoundIC(13);
	CALL SUBOPT_0x92
;    2685 				gpT_Table	= DinoBasic_WalkBackward_Torque;
	LDI  R30,LOW(_DinoBasic_WalkBackward_Torque*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_Torque*2)
	CALL SUBOPT_0x86
;    2686 				gpE_Table	= DinoBasic_WalkBackward_Port;
	LDI  R30,LOW(_DinoBasic_WalkBackward_Port*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_Port*2)
	CALL SUBOPT_0x87
;    2687 				gpPg_Table 	= DinoBasic_WalkBackward_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_WalkBackward_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2688 				gpDg_Table 	= DinoBasic_WalkBackward_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_WalkBackward_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2689 				gpIg_Table 	= DinoBasic_WalkBackward_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_WalkBackward_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2690 				gpFN_Table	= DinoBasic_WalkBackward_Frames;
	LDI  R30,LOW(_DinoBasic_WalkBackward_Frames*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_Frames*2)
	CALL SUBOPT_0x8B
;    2691 				gpRT_Table	= DinoBasic_WalkBackward_TrTime;
	LDI  R30,LOW(_DinoBasic_WalkBackward_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_TrTime*2)
	CALL SUBOPT_0x8C
;    2692 				gpPos_Table	= DinoBasic_WalkBackward_Position;
	LDI  R30,LOW(_DinoBasic_WalkBackward_Position*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_Position*2)
	CALL SUBOPT_0x91
;    2693 				Motion.NumOfScene = DINOBASIC_WALKBACKWARD_NUM_OF_SCENES;
;    2694 				Motion.NumOfwCK = DINOBASIC_WALKBACKWARD_NUM_OF_WCKS;
;    2695 				break;
	RJMP _0x271
;    2696 			case BTN_RA:
_0x27A:
	CPI  R30,LOW(0xB)
	BRNE _0x27C
;    2697 			 	SendToSoundIC(13);
	CALL SUBOPT_0x92
;    2698 				gpT_Table	= DinoBasic_PunchRight_Torque;
	LDI  R30,LOW(_DinoBasic_PunchRight_Torque*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_Torque*2)
	CALL SUBOPT_0x86
;    2699 				gpE_Table	= DinoBasic_PunchRight_Port;
	LDI  R30,LOW(_DinoBasic_PunchRight_Port*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_Port*2)
	CALL SUBOPT_0x87
;    2700 				gpPg_Table 	= DinoBasic_PunchRight_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_PunchRight_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2701 				gpDg_Table 	= DinoBasic_PunchRight_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_PunchRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2702 				gpIg_Table 	= DinoBasic_PunchRight_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_PunchRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2703 				gpFN_Table	= DinoBasic_PunchRight_Frames;
	LDI  R30,LOW(_DinoBasic_PunchRight_Frames*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_Frames*2)
	CALL SUBOPT_0x8B
;    2704 				gpRT_Table	= DinoBasic_PunchRight_TrTime;
	LDI  R30,LOW(_DinoBasic_PunchRight_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_TrTime*2)
	CALL SUBOPT_0x8C
;    2705 				gpPos_Table	= DinoBasic_PunchRight_Position;
	LDI  R30,LOW(_DinoBasic_PunchRight_Position*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_Position*2)
	CALL SUBOPT_0x93
;    2706 				Motion.NumOfScene = DINOBASIC_PUNCHRIGHT_NUM_OF_SCENES;
;    2707 				Motion.NumOfwCK = DINOBASIC_PUNCHRIGHT_NUM_OF_WCKS;
;    2708 				break;
	RJMP _0x271
;    2709 			default:
_0x27C:
;    2710 				return;
	RJMP _0x325
;    2711 		}
_0x271:
;    2712 	}
;    2713 	else if(F_PF == PF1_DOGY){
	RJMP _0x27D
_0x26E:
	LDI  R30,LOW(3)
	CP   R30,R12
	BREQ PC+3
	JMP _0x27E
;    2714 		switch(BtnCode){
	LD   R30,Y
;    2715 			case BTN_A:
	CPI  R30,LOW(0x1)
	BRNE _0x282
;    2716 	 			SendToSoundIC(12);
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2717 				gpT_Table	= DogyBasic_GetupFront_Torque;
	LDI  R30,LOW(_DogyBasic_GetupFront_Torque*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_Torque*2)
	CALL SUBOPT_0x86
;    2718 				gpE_Table	= DogyBasic_GetupFront_Port;
	LDI  R30,LOW(_DogyBasic_GetupFront_Port*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_Port*2)
	CALL SUBOPT_0x87
;    2719 				gpPg_Table 	= DogyBasic_GetupFront_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_GetupFront_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2720 				gpDg_Table 	= DogyBasic_GetupFront_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_GetupFront_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2721 				gpIg_Table 	= DogyBasic_GetupFront_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_GetupFront_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2722 				gpFN_Table	= DogyBasic_GetupFront_Frames;
	LDI  R30,LOW(_DogyBasic_GetupFront_Frames*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_Frames*2)
	CALL SUBOPT_0x8B
;    2723 				gpRT_Table	= DogyBasic_GetupFront_TrTime;
	LDI  R30,LOW(_DogyBasic_GetupFront_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_TrTime*2)
	CALL SUBOPT_0x8C
;    2724 				gpPos_Table	= DogyBasic_GetupFront_Position;
	LDI  R30,LOW(_DogyBasic_GetupFront_Position*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_Position*2)
	CALL SUBOPT_0x90
;    2725 				Motion.NumOfScene = DOGYBASIC_GETUPFRONT_NUM_OF_SCENES;
;    2726 				Motion.NumOfwCK = DOGYBASIC_GETUPFRONT_NUM_OF_WCKS;
;    2727 				break;
	RJMP _0x281
;    2728 			case BTN_B:
_0x282:
	CPI  R30,LOW(0x2)
	BRNE _0x283
;    2729 	 			SendToSoundIC(12);
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2730 				gpT_Table	= DogyBasic_GetupBack_Torque;
	LDI  R30,LOW(_DogyBasic_GetupBack_Torque*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_Torque*2)
	CALL SUBOPT_0x86
;    2731 				gpE_Table	= DogyBasic_GetupBack_Port;
	LDI  R30,LOW(_DogyBasic_GetupBack_Port*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_Port*2)
	CALL SUBOPT_0x87
;    2732 				gpPg_Table 	= DogyBasic_GetupBack_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_GetupBack_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2733 				gpDg_Table 	= DogyBasic_GetupBack_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_GetupBack_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2734 				gpIg_Table 	= DogyBasic_GetupBack_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_GetupBack_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2735 				gpFN_Table	= DogyBasic_GetupBack_Frames;
	LDI  R30,LOW(_DogyBasic_GetupBack_Frames*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_Frames*2)
	CALL SUBOPT_0x8B
;    2736 				gpRT_Table	= DogyBasic_GetupBack_TrTime;
	LDI  R30,LOW(_DogyBasic_GetupBack_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_TrTime*2)
	CALL SUBOPT_0x8C
;    2737 				gpPos_Table	= DogyBasic_GetupBack_Position;
	LDI  R30,LOW(_DogyBasic_GetupBack_Position*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_Position*2)
	CALL SUBOPT_0x90
;    2738 				Motion.NumOfScene = DOGYBASIC_GETUPBACK_NUM_OF_SCENES;
;    2739 				Motion.NumOfwCK = DOGYBASIC_GETUPBACK_NUM_OF_WCKS;
;    2740 				break;
	RJMP _0x281
;    2741 			case BTN_LR:
_0x283:
	CPI  R30,LOW(0x3)
	BRNE _0x284
;    2742 			 	SendToSoundIC(11);
	CALL SUBOPT_0x94
;    2743 				gpT_Table	= DogyBasic_TurnLeft_Torque;
	LDI  R30,LOW(_DogyBasic_TurnLeft_Torque*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_Torque*2)
	CALL SUBOPT_0x86
;    2744 				gpE_Table	= DogyBasic_TurnLeft_Port;
	LDI  R30,LOW(_DogyBasic_TurnLeft_Port*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_Port*2)
	CALL SUBOPT_0x87
;    2745 				gpPg_Table 	= DogyBasic_TurnLeft_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_TurnLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2746 				gpDg_Table 	= DogyBasic_TurnLeft_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_TurnLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2747 				gpIg_Table 	= DogyBasic_TurnLeft_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_TurnLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2748 				gpFN_Table	= DogyBasic_TurnLeft_Frames;
	LDI  R30,LOW(_DogyBasic_TurnLeft_Frames*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_Frames*2)
	CALL SUBOPT_0x8B
;    2749 				gpRT_Table	= DogyBasic_TurnLeft_TrTime;
	LDI  R30,LOW(_DogyBasic_TurnLeft_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_TrTime*2)
	CALL SUBOPT_0x8C
;    2750 				gpPos_Table	= DogyBasic_TurnLeft_Position;
	LDI  R30,LOW(_DogyBasic_TurnLeft_Position*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_Position*2)
	CALL SUBOPT_0x8E
;    2751 				Motion.NumOfScene = DOGYBASIC_TURNLEFT_NUM_OF_SCENES;
;    2752 				Motion.NumOfwCK = DOGYBASIC_TURNLEFT_NUM_OF_WCKS;
;    2753 				break;
	RJMP _0x281
;    2754 			case BTN_U:
_0x284:
	CPI  R30,LOW(0x4)
	BRNE _0x285
;    2755 			 	SendToSoundIC(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2756 				gpT_Table	= DogyBasic_WalkForward_Torque;
	LDI  R30,LOW(_DogyBasic_WalkForward_Torque*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_Torque*2)
	CALL SUBOPT_0x86
;    2757 				gpE_Table	= DogyBasic_WalkForward_Port;
	LDI  R30,LOW(_DogyBasic_WalkForward_Port*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_Port*2)
	CALL SUBOPT_0x87
;    2758 				gpPg_Table 	= DogyBasic_WalkForward_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_WalkForward_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2759 				gpDg_Table 	= DogyBasic_WalkForward_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_WalkForward_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2760 				gpIg_Table 	= DogyBasic_WalkForward_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_WalkForward_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2761 				gpFN_Table	= DogyBasic_WalkForward_Frames;
	LDI  R30,LOW(_DogyBasic_WalkForward_Frames*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_Frames*2)
	CALL SUBOPT_0x8B
;    2762 				gpRT_Table	= DogyBasic_WalkForward_TrTime;
	LDI  R30,LOW(_DogyBasic_WalkForward_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_TrTime*2)
	CALL SUBOPT_0x8C
;    2763 				gpPos_Table	= DogyBasic_WalkForward_Position;
	LDI  R30,LOW(_DogyBasic_WalkForward_Position*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_Position*2)
	CALL SUBOPT_0x8D
;    2764 				Motion.NumOfScene = DOGYBASIC_WALKFORWARD_NUM_OF_SCENES;
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	CALL SUBOPT_0x7A
;    2765 				Motion.NumOfwCK = DOGYBASIC_WALKFORWARD_NUM_OF_WCKS;
;    2766 				break;
	RJMP _0x281
;    2767 			case BTN_RR:
_0x285:
	CPI  R30,LOW(0x5)
	BRNE _0x286
;    2768 			 	SendToSoundIC(11);
	CALL SUBOPT_0x94
;    2769 				gpT_Table	= DogyBasic_TurnRight_Torque;
	LDI  R30,LOW(_DogyBasic_TurnRight_Torque*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_Torque*2)
	CALL SUBOPT_0x86
;    2770 				gpE_Table	= DogyBasic_TurnRight_Port;
	LDI  R30,LOW(_DogyBasic_TurnRight_Port*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_Port*2)
	CALL SUBOPT_0x87
;    2771 				gpPg_Table 	= DogyBasic_TurnRight_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_TurnRight_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2772 				gpDg_Table 	= DogyBasic_TurnRight_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_TurnRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2773 				gpIg_Table 	= DogyBasic_TurnRight_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_TurnRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2774 				gpFN_Table	= DogyBasic_TurnRight_Frames;
	LDI  R30,LOW(_DogyBasic_TurnRight_Frames*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_Frames*2)
	CALL SUBOPT_0x8B
;    2775 				gpRT_Table	= DogyBasic_TurnRight_TrTime;
	LDI  R30,LOW(_DogyBasic_TurnRight_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_TrTime*2)
	CALL SUBOPT_0x8C
;    2776 				gpPos_Table	= DogyBasic_TurnRight_Position;
	LDI  R30,LOW(_DogyBasic_TurnRight_Position*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_Position*2)
	CALL SUBOPT_0x8E
;    2777 				Motion.NumOfScene = DOGYBASIC_TURNRIGHT_NUM_OF_SCENES;
;    2778 				Motion.NumOfwCK = DOGYBASIC_TURNRIGHT_NUM_OF_WCKS;
;    2779 				break;
	RJMP _0x281
;    2780 			case BTN_L:
_0x286:
	CPI  R30,LOW(0x6)
	BRNE _0x287
;    2781 			 	SendToSoundIC(11);
	CALL SUBOPT_0x94
;    2782 				gpT_Table	= DogyBasic_SidewalkLeft_Torque;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_Torque*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_Torque*2)
	CALL SUBOPT_0x86
;    2783 				gpE_Table	= DogyBasic_SidewalkLeft_Port;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_Port*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_Port*2)
	CALL SUBOPT_0x87
;    2784 				gpPg_Table 	= DogyBasic_SidewalkLeft_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2785 				gpDg_Table 	= DogyBasic_SidewalkLeft_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2786 				gpIg_Table 	= DogyBasic_SidewalkLeft_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2787 				gpFN_Table	= DogyBasic_SidewalkLeft_Frames;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_Frames*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_Frames*2)
	CALL SUBOPT_0x8B
;    2788 				gpRT_Table	= DogyBasic_SidewalkLeft_TrTime;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_TrTime*2)
	CALL SUBOPT_0x8C
;    2789 				gpPos_Table	= DogyBasic_SidewalkLeft_Position;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_Position*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_Position*2)
	CALL SUBOPT_0x95
;    2790 				Motion.NumOfScene = DOGYBASIC_SIDEWALKLEFT_NUM_OF_SCENES;
;    2791 				Motion.NumOfwCK = DOGYBASIC_SIDEWALKLEFT_NUM_OF_WCKS;
;    2792 				break;
	RJMP _0x281
;    2793 			case BTN_R:
_0x287:
	CPI  R30,LOW(0x8)
	BRNE _0x288
;    2794 			 	SendToSoundIC(11);
	CALL SUBOPT_0x94
;    2795 				gpT_Table	= DogyBasic_SidewalkRight_Torque;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_Torque*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_Torque*2)
	CALL SUBOPT_0x86
;    2796 				gpE_Table	= DogyBasic_SidewalkRight_Port;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_Port*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_Port*2)
	CALL SUBOPT_0x87
;    2797 				gpPg_Table 	= DogyBasic_SidewalkRight_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2798 				gpDg_Table 	= DogyBasic_SidewalkRight_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2799 				gpIg_Table 	= DogyBasic_SidewalkRight_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2800 				gpFN_Table	= DogyBasic_SidewalkRight_Frames;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_Frames*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_Frames*2)
	CALL SUBOPT_0x8B
;    2801 				gpRT_Table	= DogyBasic_SidewalkRight_TrTime;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_TrTime*2)
	CALL SUBOPT_0x8C
;    2802 				gpPos_Table	= DogyBasic_SidewalkRight_Position;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_Position*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_Position*2)
	CALL SUBOPT_0x95
;    2803 				Motion.NumOfScene = DOGYBASIC_SIDEWALKRIGHT_NUM_OF_SCENES;
;    2804 				Motion.NumOfwCK = DOGYBASIC_SIDEWALKRIGHT_NUM_OF_WCKS;
;    2805 				break;
	RJMP _0x281
;    2806 			case BTN_LA:
_0x288:
	CPI  R30,LOW(0x9)
	BRNE _0x289
;    2807 			 	SendToSoundIC(11);
	CALL SUBOPT_0x94
;    2808 				gpT_Table	= DogyBasic_PunchLeft_Torque;
	LDI  R30,LOW(_DogyBasic_PunchLeft_Torque*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_Torque*2)
	CALL SUBOPT_0x86
;    2809 				gpE_Table	= DogyBasic_PunchLeft_Port;
	LDI  R30,LOW(_DogyBasic_PunchLeft_Port*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_Port*2)
	CALL SUBOPT_0x87
;    2810 				gpPg_Table 	= DogyBasic_PunchLeft_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_PunchLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2811 				gpDg_Table 	= DogyBasic_PunchLeft_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_PunchLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2812 				gpIg_Table 	= DogyBasic_PunchLeft_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_PunchLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2813 				gpFN_Table	= DogyBasic_PunchLeft_Frames;
	LDI  R30,LOW(_DogyBasic_PunchLeft_Frames*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_Frames*2)
	CALL SUBOPT_0x8B
;    2814 				gpRT_Table	= DogyBasic_PunchLeft_TrTime;
	LDI  R30,LOW(_DogyBasic_PunchLeft_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_TrTime*2)
	CALL SUBOPT_0x8C
;    2815 				gpPos_Table	= DogyBasic_PunchLeft_Position;
	LDI  R30,LOW(_DogyBasic_PunchLeft_Position*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_Position*2)
	CALL SUBOPT_0x93
;    2816 				Motion.NumOfScene = DOGYBASIC_PUNCHLEFT_NUM_OF_SCENES;
;    2817 				Motion.NumOfwCK = DOGYBASIC_PUNCHLEFT_NUM_OF_WCKS;
;    2818 				break;
	RJMP _0x281
;    2819 			case BTN_D:
_0x289:
	CPI  R30,LOW(0xA)
	BRNE _0x28A
;    2820 			 	SendToSoundIC(11);
	CALL SUBOPT_0x94
;    2821 				gpT_Table	= DogyBasic_WalkBackward_Torque;
	LDI  R30,LOW(_DogyBasic_WalkBackward_Torque*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_Torque*2)
	CALL SUBOPT_0x86
;    2822 				gpE_Table	= DogyBasic_WalkBackward_Port;
	LDI  R30,LOW(_DogyBasic_WalkBackward_Port*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_Port*2)
	CALL SUBOPT_0x87
;    2823 				gpPg_Table 	= DogyBasic_WalkBackward_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_WalkBackward_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2824 				gpDg_Table 	= DogyBasic_WalkBackward_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_WalkBackward_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2825 				gpIg_Table 	= DogyBasic_WalkBackward_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_WalkBackward_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2826 				gpFN_Table	= DogyBasic_WalkBackward_Frames;
	LDI  R30,LOW(_DogyBasic_WalkBackward_Frames*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_Frames*2)
	CALL SUBOPT_0x8B
;    2827 				gpRT_Table	= DogyBasic_WalkBackward_TrTime;
	LDI  R30,LOW(_DogyBasic_WalkBackward_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_TrTime*2)
	CALL SUBOPT_0x8C
;    2828 				gpPos_Table	= DogyBasic_WalkBackward_Position;
	LDI  R30,LOW(_DogyBasic_WalkBackward_Position*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_Position*2)
	CALL SUBOPT_0x95
;    2829 				Motion.NumOfScene = DOGYBASIC_WALKBACKWARD_NUM_OF_SCENES;
;    2830 				Motion.NumOfwCK = DOGYBASIC_WALKBACKWARD_NUM_OF_WCKS;
;    2831 				break;
	RJMP _0x281
;    2832 			case BTN_RA:
_0x28A:
	CPI  R30,LOW(0xB)
	BRNE _0x28C
;    2833 			 	SendToSoundIC(11);
	CALL SUBOPT_0x94
;    2834 				gpT_Table	= DogyBasic_PunchRight_Torque;
	LDI  R30,LOW(_DogyBasic_PunchRight_Torque*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_Torque*2)
	CALL SUBOPT_0x86
;    2835 				gpE_Table	= DogyBasic_PunchRight_Port;
	LDI  R30,LOW(_DogyBasic_PunchRight_Port*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_Port*2)
	CALL SUBOPT_0x87
;    2836 				gpPg_Table 	= DogyBasic_PunchRight_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_PunchRight_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_RuntimePGain*2)
	CALL SUBOPT_0x88
;    2837 				gpDg_Table 	= DogyBasic_PunchRight_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_PunchRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_RuntimeDGain*2)
	CALL SUBOPT_0x89
;    2838 				gpIg_Table 	= DogyBasic_PunchRight_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_PunchRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_RuntimeIGain*2)
	CALL SUBOPT_0x8A
;    2839 				gpFN_Table	= DogyBasic_PunchRight_Frames;
	LDI  R30,LOW(_DogyBasic_PunchRight_Frames*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_Frames*2)
	CALL SUBOPT_0x8B
;    2840 				gpRT_Table	= DogyBasic_PunchRight_TrTime;
	LDI  R30,LOW(_DogyBasic_PunchRight_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_TrTime*2)
	CALL SUBOPT_0x8C
;    2841 				gpPos_Table	= DogyBasic_PunchRight_Position;
	LDI  R30,LOW(_DogyBasic_PunchRight_Position*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_Position*2)
	CALL SUBOPT_0x93
;    2842 				Motion.NumOfScene = DOGYBASIC_PUNCHRIGHT_NUM_OF_SCENES;
;    2843 				Motion.NumOfwCK = DOGYBASIC_PUNCHRIGHT_NUM_OF_WCKS;
;    2844 				break;
	RJMP _0x281
;    2845 			default:
_0x28C:
;    2846 				return;
	RJMP _0x325
;    2847 		}
_0x281:
;    2848 	}
;    2849 	else if(F_PF == PF2){
	RJMP _0x28D
_0x27E:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x28E
;    2850 		return;
	RJMP _0x325
;    2851 	}
;    2852 	Motion.PF = F_PF;
_0x28E:
_0x28D:
_0x27D:
_0x26D:
	__PUTBMRN _Motion,5,12
;    2853 	M_PlayFlash();
	CALL _M_PlayFlash
;    2854 }
_0x325:
	ADIW R28,1
	RET
;    2855 //==============================================================================
;    2856 //						Digital Input Output 관련 함수들
;    2857 //==============================================================================
;    2858 
;    2859 #include <mega128.h>
;    2860 #include "Main.h"
;    2861 #include "Macro.h"
;    2862 #include "DIO.h"
;    2863 
;    2864 //------------------------------------------------------------------------------
;    2865 // 버튼 읽기
;    2866 //------------------------------------------------------------------------------
;    2867 void ReadButton(void)
;    2868 {
_ReadButton:
;    2869 	BYTE	lbtmp;
;    2870 
;    2871 	lbtmp = PINA & 0x03;
	ST   -Y,R16
;	lbtmp -> R16
	IN   R30,0x19
	ANDI R30,LOW(0x3)
	MOV  R16,R30
;    2872 
;    2873 	if(F_DOWNLOAD) return;
	SBRC R2,4
	RJMP _0x324
;    2874 
;    2875 	if(lbtmp == 0x02){
	CPI  R16,2
	BRNE _0x290
;    2876 		gPF1BtnCnt++;		gPF2BtnCnt = 0;		gPF12BtnCnt = 0;
	LDS  R30,_gPF1BtnCnt
	LDS  R31,_gPF1BtnCnt+1
	ADIW R30,1
	STS  _gPF1BtnCnt,R30
	STS  _gPF1BtnCnt+1,R31
	CALL SUBOPT_0x96
	CALL SUBOPT_0x97
;    2877        	if(gPF1BtnCnt > 3000){
	CALL SUBOPT_0x98
	CPI  R26,LOW(0xBB9)
	LDI  R30,HIGH(0xBB9)
	CPC  R27,R30
	BRLO _0x291
;    2878 			gBtn_val = PF1_BTN_LONG;
	LDI  R30,LOW(4)
	STS  _gBtn_val,R30
;    2879 			gPF1BtnCnt = 0;
	CALL SUBOPT_0x99
;    2880 		}
;    2881 	}
_0x291:
;    2882 	else if(lbtmp == 0x01){
	RJMP _0x292
_0x290:
	CPI  R16,1
	BRNE _0x293
;    2883 		gPF1BtnCnt = 0;		gPF2BtnCnt++;		gPF12BtnCnt = 0;
	CALL SUBOPT_0x99
	LDS  R30,_gPF2BtnCnt
	LDS  R31,_gPF2BtnCnt+1
	ADIW R30,1
	STS  _gPF2BtnCnt,R30
	STS  _gPF2BtnCnt+1,R31
	CALL SUBOPT_0x97
;    2884        	if(gPF2BtnCnt > 3000){
	CALL SUBOPT_0x9A
	CPI  R26,LOW(0xBB9)
	LDI  R30,HIGH(0xBB9)
	CPC  R27,R30
	BRLO _0x294
;    2885 			gBtn_val = PF2_BTN_LONG;
	LDI  R30,LOW(5)
	STS  _gBtn_val,R30
;    2886 			gPF2BtnCnt = 0;
	CALL SUBOPT_0x96
;    2887 		}
;    2888 	}
_0x294:
;    2889 	else if(lbtmp == 0x00){
	RJMP _0x295
_0x293:
	CPI  R16,0
	BRNE _0x296
;    2890 		gPF1BtnCnt = 0;		gPF2BtnCnt = 0;		gPF12BtnCnt++;
	CALL SUBOPT_0x99
	CALL SUBOPT_0x96
	LDS  R30,_gPF12BtnCnt
	LDS  R31,_gPF12BtnCnt+1
	ADIW R30,1
	STS  _gPF12BtnCnt,R30
	STS  _gPF12BtnCnt+1,R31
;    2891        	if(gPF12BtnCnt > 2000){
	CALL SUBOPT_0x9B
	CPI  R26,LOW(0x7D1)
	LDI  R30,HIGH(0x7D1)
	CPC  R27,R30
	BRLO _0x297
;    2892            	if(F_PF_CHANGED == 0){
	SBRC R3,1
	RJMP _0x298
;    2893 				gBtn_val = PF12_BTN_LONG;
	LDI  R30,LOW(6)
	STS  _gBtn_val,R30
;    2894 	       	    gPF12BtnCnt = 0;
	CALL SUBOPT_0x97
;    2895 			}
;    2896 		}
_0x298:
;    2897 	}
_0x297:
;    2898 	else{
	RJMP _0x299
_0x296:
;    2899 		if(gPF1BtnCnt > 40 && gPF1BtnCnt < 500){
	CALL SUBOPT_0x98
	SBIW R26,41
	BRLO _0x29B
	CALL SUBOPT_0x98
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0x29C
_0x29B:
	RJMP _0x29A
_0x29C:
;    2900 			gBtn_val = PF1_BTN_SHORT;
	LDI  R30,LOW(1)
	RJMP _0x344
;    2901 		}
;    2902 		else if(gPF2BtnCnt > 40 && gPF2BtnCnt < 500){
_0x29A:
	CALL SUBOPT_0x9A
	SBIW R26,41
	BRLO _0x29F
	CALL SUBOPT_0x9A
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0x2A0
_0x29F:
	RJMP _0x29E
_0x2A0:
;    2903 			gBtn_val = PF2_BTN_SHORT;
	LDI  R30,LOW(2)
	RJMP _0x344
;    2904 		}
;    2905 		else if(gPF12BtnCnt > 40 && gPF12BtnCnt < 500){
_0x29E:
	CALL SUBOPT_0x9B
	SBIW R26,41
	BRLO _0x2A3
	CALL SUBOPT_0x9B
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0x2A4
_0x2A3:
	RJMP _0x2A2
_0x2A4:
;    2906 			gBtn_val = PF12_BTN_SHORT;
	LDI  R30,LOW(3)
	RJMP _0x344
;    2907 		}
;    2908 		else
_0x2A2:
;    2909 			gBtn_val = BTN_NOT_PRESSED;
	LDI  R30,LOW(0)
_0x344:
	STS  _gBtn_val,R30
;    2910 		gPF1BtnCnt = 0;
	CALL SUBOPT_0x99
;    2911 		gPF2BtnCnt = 0;
	CALL SUBOPT_0x96
;    2912 		gPF12BtnCnt = 0;
	CALL SUBOPT_0x97
;    2913 		F_PF_CHANGED = 0;
	CLT
	BLD  R3,1
;    2914 	}
_0x299:
_0x295:
_0x292:
;    2915 } 
_0x324:
	LD   R16,Y+
	RET
;    2916 
;    2917 
;    2918 //------------------------------------------------------------------------------
;    2919 // 버튼 처리
;    2920 //------------------------------------------------------------------------------
;    2921 void ProcButton(void)
;    2922 {
_ProcButton:
;    2923 	WORD	i;
;    2924 	if(gBtn_val == PF12_BTN_LONG){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDS  R26,_gBtn_val
	CPI  R26,LOW(0x6)
	BRNE _0x2A6
;    2925 		gBtn_val = 0;
	LDI  R30,LOW(0)
	STS  _gBtn_val,R30
;    2926 		if(F_PS_PLUGGED){
	SBRS R2,5
	RJMP _0x2A7
;    2927 			BreakModeCmdSend();
	CALL _BreakModeCmdSend
;    2928 			ChargeNiMH();
	CALL _ChargeNiMH
;    2929 		}
;    2930 	}
_0x2A7:
;    2931 	else if(gBtn_val == PF1_BTN_LONG){
	RJMP _0x2A8
_0x2A6:
	LDS  R26,_gBtn_val
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x2A9
;    2932 		gBtn_val = 0;
	LDI  R30,LOW(0)
	STS  _gBtn_val,R30
;    2933 		if(F_PF==PF1_HUNO){
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x2AA
;    2934 			F_PF=PF1_DINO;
	LDI  R30,LOW(2)
	MOV  R12,R30
;    2935 			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Dino[i], U_Boundary_Dino[i]);
	__GETWRN 16,17,0
_0x2AC:
	__CPWRN 16,17,16
	BRSH _0x2AD
	ST   -Y,R16
	MOVW R30,R16
	SUBI R30,LOW(-_L_Boundary_Dino*2)
	SBCI R31,HIGH(-_L_Boundary_Dino*2)
	CALL SUBOPT_0x9C
	SUBI R30,LOW(-_U_Boundary_Dino*2)
	SBCI R31,HIGH(-_U_Boundary_Dino*2)
	CALL SUBOPT_0x9D
;    2936 		}
	__ADDWRN 16,17,1
	RJMP _0x2AC
_0x2AD:
;    2937 		else if(F_PF==PF1_DINO){
	RJMP _0x2AE
_0x2AA:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x2AF
;    2938 			F_PF=PF1_DOGY;
	LDI  R30,LOW(3)
	MOV  R12,R30
;    2939 			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Dogy[i], U_Boundary_Dogy[i]);
	__GETWRN 16,17,0
_0x2B1:
	__CPWRN 16,17,16
	BRSH _0x2B2
	ST   -Y,R16
	MOVW R30,R16
	SUBI R30,LOW(-_L_Boundary_Dogy*2)
	SBCI R31,HIGH(-_L_Boundary_Dogy*2)
	CALL SUBOPT_0x9C
	SUBI R30,LOW(-_U_Boundary_Dogy*2)
	SBCI R31,HIGH(-_U_Boundary_Dogy*2)
	CALL SUBOPT_0x9D
;    2940 		}
	__ADDWRN 16,17,1
	RJMP _0x2B1
_0x2B2:
;    2941 		else{
	RJMP _0x2B3
_0x2AF:
;    2942 			F_PF=PF1_HUNO;
	LDI  R30,LOW(1)
	MOV  R12,R30
;    2943 			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Huno[i], U_Boundary_Huno[i]);
	__GETWRN 16,17,0
_0x2B5:
	__CPWRN 16,17,16
	BRSH _0x2B6
	ST   -Y,R16
	MOVW R30,R16
	SUBI R30,LOW(-_L_Boundary_Huno*2)
	SBCI R31,HIGH(-_L_Boundary_Huno*2)
	CALL SUBOPT_0x9C
	SUBI R30,LOW(-_U_Boundary_Huno*2)
	SBCI R31,HIGH(-_U_Boundary_Huno*2)
	CALL SUBOPT_0x9D
;    2944 		}
	__ADDWRN 16,17,1
	RJMP _0x2B5
_0x2B6:
_0x2B3:
_0x2AE:
;    2945 		BreakModeCmdSend();
	RJMP _0x345
;    2946 		delay_ms(10);
;    2947 		F_PF_CHANGED = 1;
;    2948 		ePF = F_PF;
;    2949 	}
;    2950 	else if(gBtn_val == PF2_BTN_LONG){
_0x2A9:
	LDS  R26,_gBtn_val
	CPI  R26,LOW(0x5)
	BRNE _0x2B8
;    2951 		gBtn_val = 0;
	LDI  R30,LOW(0)
	STS  _gBtn_val,R30
;    2952 		F_PF = PF2;
	LDI  R30,LOW(4)
	MOV  R12,R30
;    2953 		BreakModeCmdSend();
_0x345:
	CALL _BreakModeCmdSend
;    2954 		delay_ms(10);
	CALL SUBOPT_0x39
;    2955 		F_PF_CHANGED = 1;
	SET
	BLD  R3,1
;    2956 		ePF = F_PF;
	MOV  R30,R12
	LDI  R26,LOW(_ePF)
	LDI  R27,HIGH(_ePF)
	CALL __EEPROMWRB
;    2957 	}
;    2958 }
_0x2B8:
_0x2A8:
	RJMP _0x323
;    2959 
;    2960 
;    2961 //------------------------------------------------------------------------------
;    2962 // Io 업데이트 처리
;    2963 //------------------------------------------------------------------------------
;    2964 void IoUpdate(void)
;    2965 {
_IoUpdate:
;    2966 	if(F_DOWNLOAD) return;
	SBRC R2,4
	RET
;    2967 	if(F_DIRECT_C_EN){
	SBRS R2,2
	RJMP _0x2BA
;    2968 			PF1_LED1_ON;
	CBI  0x1B,2
;    2969 			PF1_LED2_OFF;
	SBI  0x1B,3
;    2970 			PF2_LED_ON;
	CBI  0x1B,4
;    2971 			return;
	RET
;    2972 	}
;    2973 	switch(F_PF){
_0x2BA:
	MOV  R30,R12
;    2974 		case PF1_HUNO:
	CPI  R30,LOW(0x1)
	BRNE _0x2BE
;    2975 			PF1_LED1_ON;
	CBI  0x1B,2
;    2976 			PF1_LED2_OFF;
	SBI  0x1B,3
;    2977 			PF2_LED_OFF;
	SBI  0x1B,4
;    2978 			break;
	RJMP _0x2BD
;    2979 		case PF1_DINO:
_0x2BE:
	CPI  R30,LOW(0x2)
	BRNE _0x2BF
;    2980 			PF1_LED1_ON;
	CBI  0x1B,2
;    2981 			PF1_LED2_ON;
	CBI  0x1B,3
;    2982 			PF2_LED_OFF;
	SBI  0x1B,4
;    2983 			break;
	RJMP _0x2BD
;    2984 		case PF1_DOGY:
_0x2BF:
	CPI  R30,LOW(0x3)
	BRNE _0x2C0
;    2985 			PF1_LED1_OFF;
	SBI  0x1B,2
;    2986 			PF1_LED2_ON;
	CBI  0x1B,3
;    2987 			PF2_LED_OFF;
	SBI  0x1B,4
;    2988 			break;
	RJMP _0x2BD
;    2989 		case PF2:
_0x2C0:
	CPI  R30,LOW(0x4)
	BRNE _0x2C2
;    2990 			PF1_LED1_OFF;
	SBI  0x1B,2
;    2991 			PF1_LED2_OFF;
	SBI  0x1B,3
;    2992 			PF2_LED_ON;
	CBI  0x1B,4
;    2993 			break;
	RJMP _0x2BD
;    2994 		default:
_0x2C2:
;    2995 			F_PF = PF2;
	LDI  R30,LOW(4)
	MOV  R12,R30
;    2996 	}
_0x2BD:
;    2997 
;    2998 	if(gVOLTAGE>M_T_OF_POWER){
	LDI  R30,LOW(8600)
	LDI  R31,HIGH(8600)
	CP   R30,R5
	CPC  R31,R6
	BRSH _0x2C3
;    2999 		PWR_LED1_ON;
	CALL SUBOPT_0x33
;    3000 		PWR_LED2_OFF;
	SBI  0x15,7
;    3001 		gPwrLowCount = 0;
	CALL SUBOPT_0x9E
;    3002 	}
;    3003 	else if(gVOLTAGE>L_T_OF_POWER){
	RJMP _0x2C4
_0x2C3:
	LDI  R30,LOW(8100)
	LDI  R31,HIGH(8100)
	CP   R30,R5
	CPC  R31,R6
	BRSH _0x2C5
;    3004 		PWR_LED1_OFF;
	CALL SUBOPT_0x35
;    3005 		PWR_LED2_ON;
	CBI  0x15,7
;    3006 		gPwrLowCount++;
	CALL SUBOPT_0x9F
;    3007 		if(gPwrLowCount>5000){
	CPI  R26,LOW(0x1389)
	LDI  R30,HIGH(0x1389)
	CPC  R27,R30
	BRLO _0x2C6
;    3008 			gPwrLowCount = 0;
	CALL SUBOPT_0x9E
;    3009 			BreakModeCmdSend();
	CALL _BreakModeCmdSend
;    3010 		}
;    3011 	}
_0x2C6:
;    3012 	else{
	RJMP _0x2C7
_0x2C5:
;    3013 		PWR_LED1_OFF;
	CALL SUBOPT_0x35
;    3014 		if(g10MSEC<25)			PWR_LED2_ON;
	CALL SUBOPT_0x29
	SBIW R26,25
	BRSH _0x2C8
	CBI  0x15,7
;    3015 		else if(g10MSEC<50)		PWR_LED2_OFF;
	RJMP _0x2C9
_0x2C8:
	CALL SUBOPT_0x29
	SBIW R26,50
	BRSH _0x2CA
	RJMP _0x346
;    3016 		else if(g10MSEC<75)		PWR_LED2_ON;
_0x2CA:
	CALL SUBOPT_0x3B
	BRSH _0x2CC
	CBI  0x15,7
;    3017 		else if(g10MSEC<100)	PWR_LED2_OFF;
	RJMP _0x2CD
_0x2CC:
	CALL SUBOPT_0x3C
	BRSH _0x2CE
_0x346:
	SBI  0x15,7
;    3018 		gPwrLowCount++;
_0x2CE:
_0x2CD:
_0x2C9:
	CALL SUBOPT_0x9F
;    3019 		if(gPwrLowCount>3000){
	CPI  R26,LOW(0xBB9)
	LDI  R30,HIGH(0xBB9)
	CPC  R27,R30
	BRLO _0x2CF
;    3020 			gPwrLowCount=0;
	CALL SUBOPT_0x9E
;    3021 			BreakModeCmdSend();
	CALL _BreakModeCmdSend
;    3022 		}
;    3023 	}
_0x2CF:
_0x2C7:
_0x2C4:
;    3024 	if(F_ERR_CODE == NO_ERR)	ERR_LED_OFF;
	LDI  R30,LOW(255)
	CP   R30,R13
	BRNE _0x2D0
	SBI  0x1B,7
;    3025 	else ERR_LED_ON;
	RJMP _0x2D1
_0x2D0:
	CBI  0x1B,7
;    3026 }
_0x2D1:
	RET
;    3027 
;    3028 
;    3029 //------------------------------------------------------------------------------
;    3030 // 자체 테스트1
;    3031 //------------------------------------------------------------------------------
;    3032 void SelfTest1(void)
;    3033 {
_SelfTest1:
;    3034 	WORD	i;
;    3035 
;    3036 	if(F_DIRECT_C_EN)	return;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	SBRC R2,2
	RJMP _0x323
;    3037 
;    3038 	for(i=0;i<16;i++){
	__GETWRN 16,17,0
_0x2D4:
	__CPWRN 16,17,16
	BRSH _0x2D5
;    3039 		if((StandardZeroPos[i]+15)<eM_OriginPose[i]
;    3040 		 ||(StandardZeroPos[i]-15)>eM_OriginPose[i]){
	CALL SUBOPT_0xD
	MOV  R1,R30
	SUBI R30,-LOW(15)
	MOV  R0,R30
	CALL SUBOPT_0x9
	CP   R0,R30
	BRLO _0x2D7
	MOV  R30,R1
	SUBI R30,LOW(15)
	MOV  R0,R30
	CALL SUBOPT_0x9
	CP   R30,R0
	BRSH _0x2D6
_0x2D7:
;    3041 			F_ERR_CODE = ZERO_DATA_ERR;
	LDI  R30,LOW(8)
	MOV  R13,R30
;    3042 			return;
	RJMP _0x323
;    3043 		}
;    3044 	}
_0x2D6:
	__ADDWRN 16,17,1
	RJMP _0x2D4
_0x2D5:
;    3045 	PWR_LED1_ON;	delay_ms(60);	PWR_LED1_OFF;
	CALL SUBOPT_0x33
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x35
;    3046 	PWR_LED2_ON;	delay_ms(60);	PWR_LED2_OFF;
	CBI  0x15,7
	CALL SUBOPT_0xA0
	SBI  0x15,7
;    3047 	RUN_LED1_ON;	delay_ms(60);	RUN_LED1_OFF;
	CBI  0x1B,5
	CALL SUBOPT_0xA0
	SBI  0x1B,5
;    3048 	RUN_LED2_ON;	delay_ms(60);	RUN_LED2_OFF;
	CBI  0x1B,6
	CALL SUBOPT_0xA0
	SBI  0x1B,6
;    3049 	ERR_LED_ON;		delay_ms(60);	ERR_LED_OFF;
	CBI  0x1B,7
	CALL SUBOPT_0xA0
	SBI  0x1B,7
;    3050 
;    3051 	PF2_LED_ON;		delay_ms(60);	PF2_LED_OFF;
	CBI  0x1B,4
	CALL SUBOPT_0xA0
	SBI  0x1B,4
;    3052 	PF1_LED2_ON;	delay_ms(60);	PF1_LED2_OFF;
	CBI  0x1B,3
	CALL SUBOPT_0xA0
	SBI  0x1B,3
;    3053 	PF1_LED1_ON;	delay_ms(60);	PF1_LED1_OFF;
	CBI  0x1B,2
	CALL SUBOPT_0xA0
	SBI  0x1B,2
;    3054 }
	RJMP _0x323
;    3055 
;    3056 
;    3057 //------------------------------------------------------------------------------
;    3058 // IR 수신 처리
;    3059 //------------------------------------------------------------------------------
;    3060 void ProcIr(void)
;    3061 {
_ProcIr:
;    3062     WORD    i;
;    3063 
;    3064 	if(F_DOWNLOAD) return;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	SBRC R2,4
	RJMP _0x323
;    3065 	if(F_FIRST_M && gIrBuf[3]!=BTN_C && gIrBuf[3]!=BTN_SHARP_A && F_PF!=PF2) return;
	SBRS R3,3
	RJMP _0x2DB
	__GETB1MN _gIrBuf,3
	CPI  R30,LOW(0x7)
	BREQ _0x2DB
	__GETB1MN _gIrBuf,3
	CPI  R30,LOW(0x2B)
	BREQ _0x2DB
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x2DC
_0x2DB:
	RJMP _0x2DA
_0x2DC:
	RJMP _0x323
;    3066 	if(F_IR_RECEIVED){
_0x2DA:
	SBRS R3,2
	RJMP _0x2DD
;    3067 	    EIMSK &= 0xBF;
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;    3068 		F_IR_RECEIVED = 0;
	CLT
	BLD  R3,2
;    3069 		if((gIrBuf[0]==eRCodeH[0] && gIrBuf[1]==eRCodeM[0] && gIrBuf[2]==eRCodeL[0])
;    3070 		 ||(gIrBuf[0]==eRCodeH[1] && gIrBuf[1]==eRCodeM[1] && gIrBuf[2]==eRCodeL[1])
;    3071 		 ||(gIrBuf[0]==eRCodeH[2] && gIrBuf[1]==eRCodeM[2] && gIrBuf[2]==eRCodeL[2])
;    3072 		 ||(gIrBuf[0]==eRCodeH[3] && gIrBuf[1]==eRCodeM[3] && gIrBuf[2]==eRCodeL[3])
;    3073 		 ||(gIrBuf[0]==eRCodeH[4] && gIrBuf[1]==eRCodeM[4] && gIrBuf[2]==eRCodeL[4])){
	LDI  R26,LOW(_eRCodeH)
	LDI  R27,HIGH(_eRCodeH)
	CALL SUBOPT_0xA1
	BRNE _0x2DF
	LDI  R26,LOW(_eRCodeM)
	LDI  R27,HIGH(_eRCodeM)
	CALL SUBOPT_0xA2
	BRNE _0x2DF
	LDI  R26,LOW(_eRCodeL)
	LDI  R27,HIGH(_eRCodeL)
	CALL SUBOPT_0xA3
	BREQ _0x2E1
_0x2DF:
	__POINTW2MN _eRCodeH,1
	CALL SUBOPT_0xA1
	BRNE _0x2E2
	__POINTW2MN _eRCodeM,1
	CALL SUBOPT_0xA2
	BRNE _0x2E2
	__POINTW2MN _eRCodeL,1
	CALL SUBOPT_0xA3
	BREQ _0x2E1
_0x2E2:
	__POINTW2MN _eRCodeH,2
	CALL SUBOPT_0xA1
	BRNE _0x2E4
	__POINTW2MN _eRCodeM,2
	CALL SUBOPT_0xA2
	BRNE _0x2E4
	__POINTW2MN _eRCodeL,2
	CALL SUBOPT_0xA3
	BREQ _0x2E1
_0x2E4:
	__POINTW2MN _eRCodeH,3
	CALL SUBOPT_0xA1
	BRNE _0x2E6
	__POINTW2MN _eRCodeM,3
	CALL SUBOPT_0xA2
	BRNE _0x2E6
	__POINTW2MN _eRCodeL,3
	CALL SUBOPT_0xA3
	BREQ _0x2E1
_0x2E6:
	__POINTW2MN _eRCodeH,4
	CALL SUBOPT_0xA1
	BRNE _0x2E8
	__POINTW2MN _eRCodeM,4
	CALL SUBOPT_0xA2
	BRNE _0x2E8
	__POINTW2MN _eRCodeL,4
	CALL SUBOPT_0xA3
	BREQ _0x2E1
_0x2E8:
	RJMP _0x2DE
_0x2E1:
;    3074 			switch(gIrBuf[3]){
	__GETB1MN _gIrBuf,3
;    3075 				case BTN_A:
	CPI  R30,LOW(0x1)
	BRNE _0x2EE
;    3076 					M_Play(BTN_A);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _M_Play
;    3077 					break;
	RJMP _0x2ED
;    3078 				case BTN_B:
_0x2EE:
	CPI  R30,LOW(0x2)
	BRNE _0x2EF
;    3079 					M_Play(BTN_B);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _M_Play
;    3080 					break;
	RJMP _0x2ED
;    3081 				case BTN_LR:
_0x2EF:
	CPI  R30,LOW(0x3)
	BRNE _0x2F0
;    3082 					M_Play(BTN_LR);
	CALL SUBOPT_0x41
;    3083 					break;
	RJMP _0x2ED
;    3084 				case BTN_U:
_0x2F0:
	CPI  R30,LOW(0x4)
	BRNE _0x2F1
;    3085 					M_Play(BTN_U);
	CALL SUBOPT_0x43
;    3086 					break;
	RJMP _0x2ED
;    3087 				case BTN_RR:
_0x2F1:
	CPI  R30,LOW(0x5)
	BRNE _0x2F2
;    3088 					M_Play(BTN_RR);
	CALL SUBOPT_0x42
;    3089 					break;
	RJMP _0x2ED
;    3090 				case BTN_L:
_0x2F2:
	CPI  R30,LOW(0x6)
	BRNE _0x2F3
;    3091 					M_Play(BTN_L);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _M_Play
;    3092 					break;
	RJMP _0x2ED
;    3093 				case BTN_R:
_0x2F3:
	CPI  R30,LOW(0x8)
	BRNE _0x2F4
;    3094 					M_Play(BTN_R);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _M_Play
;    3095 					break;
	RJMP _0x2ED
;    3096 				case BTN_LA:
_0x2F4:
	CPI  R30,LOW(0x9)
	BRNE _0x2F5
;    3097 					M_Play(BTN_LA);
	LDI  R30,LOW(9)
	ST   -Y,R30
	CALL _M_Play
;    3098 					break;
	RJMP _0x2ED
;    3099 				case BTN_D:
_0x2F5:
	CPI  R30,LOW(0xA)
	BRNE _0x2F6
;    3100 					M_Play(BTN_D);
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _M_Play
;    3101 					break;
	RJMP _0x2ED
;    3102 				case BTN_RA:
_0x2F6:
	CPI  R30,LOW(0xB)
	BRNE _0x2F7
;    3103 					M_Play(BTN_RA);
	LDI  R30,LOW(11)
	ST   -Y,R30
	CALL _M_Play
;    3104 					break;
	RJMP _0x2ED
;    3105 				case BTN_C:
_0x2F7:
	CPI  R30,LOW(0x7)
	BRNE _0x2F8
;    3106 					F_FIRST_M = 0;
	CLT
	BLD  R3,3
;    3107 					M_Play(BTN_C);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _M_Play
;    3108 					break;
	RJMP _0x2ED
;    3109 				case BTN_1:
_0x2F8:
	CPI  R30,LOW(0xC)
	BRNE _0x2F9
;    3110 					break;
	RJMP _0x2ED
;    3111 				case BTN_2:
_0x2F9:
	CPI  R30,LOW(0xD)
	BRNE _0x2FA
;    3112 					break;
	RJMP _0x2ED
;    3113 				case BTN_3:
_0x2FA:
	CPI  R30,LOW(0xE)
	BRNE _0x2FB
;    3114 					break;
	RJMP _0x2ED
;    3115 				case BTN_4:
_0x2FB:
	CPI  R30,LOW(0xF)
	BRNE _0x2FC
;    3116 					break;
	RJMP _0x2ED
;    3117 				case BTN_5:
_0x2FC:
	CPI  R30,LOW(0x10)
	BRNE _0x2FD
;    3118 					break;
	RJMP _0x2ED
;    3119 				case BTN_6:
_0x2FD:
	CPI  R30,LOW(0x11)
	BRNE _0x2FE
;    3120 					break;
	RJMP _0x2ED
;    3121 				case BTN_7:
_0x2FE:
	CPI  R30,LOW(0x12)
	BRNE _0x2FF
;    3122 					break;
	RJMP _0x2ED
;    3123 				case BTN_8:
_0x2FF:
	CPI  R30,LOW(0x13)
	BRNE _0x300
;    3124 					break;
	RJMP _0x2ED
;    3125 				case BTN_9:
_0x300:
	CPI  R30,LOW(0x14)
	BRNE _0x301
;    3126 				    User_Func();
	CALL _User_Func
;    3127 					break;
	RJMP _0x2ED
;    3128 				case BTN_0:
_0x301:
	CPI  R30,LOW(0x15)
	BRNE _0x302
;    3129 					M_Play(BTN_0);
	LDI  R30,LOW(21)
	ST   -Y,R30
	CALL _M_Play
;    3130 					break;
	RJMP _0x2ED
;    3131 				case BTN_STAR_A:
_0x302:
	CPI  R30,LOW(0x16)
	BRNE _0x303
;    3132 					M_Play(BTN_STAR_A);
	LDI  R30,LOW(22)
	ST   -Y,R30
	CALL _M_Play
;    3133 					break;
	RJMP _0x2ED
;    3134 				case BTN_STAR_B:
_0x303:
	CPI  R30,LOW(0x17)
	BRNE _0x304
;    3135 					M_Play(BTN_STAR_B);
	LDI  R30,LOW(23)
	ST   -Y,R30
	CALL _M_Play
;    3136 					break;
	RJMP _0x2ED
;    3137 				case BTN_STAR_C:
_0x304:
	CPI  R30,LOW(0x1C)
	BRNE _0x305
;    3138 					M_Play(BTN_STAR_C);
	LDI  R30,LOW(28)
	ST   -Y,R30
	CALL _M_Play
;    3139 					break;
	RJMP _0x2ED
;    3140 				case BTN_STAR_1:
_0x305:
	CPI  R30,LOW(0x21)
	BREQ _0x2ED
;    3141 					break;
;    3142 				case BTN_STAR_2:
	CPI  R30,LOW(0x22)
	BREQ _0x2ED
;    3143 					break;
;    3144 				case BTN_STAR_3:
	CPI  R30,LOW(0x23)
	BREQ _0x2ED
;    3145 					break;
;    3146 				case BTN_STAR_4:
	CPI  R30,LOW(0x24)
	BREQ _0x2ED
;    3147 					break;
;    3148 				case BTN_STAR_5:
	CPI  R30,LOW(0x25)
	BREQ _0x2ED
;    3149 					break;
;    3150 				case BTN_STAR_6:
	CPI  R30,LOW(0x26)
	BREQ _0x2ED
;    3151 					break;
;    3152 				case BTN_STAR_7:
	CPI  R30,LOW(0x27)
	BREQ _0x2ED
;    3153 					break;
;    3154 				case BTN_STAR_8:
	CPI  R30,LOW(0x28)
	BREQ _0x2ED
;    3155 					break;
;    3156 				case BTN_STAR_9:
	CPI  R30,LOW(0x29)
	BREQ _0x2ED
;    3157 					break;
;    3158 				case BTN_STAR_0:
	CPI  R30,LOW(0x2A)
	BREQ _0x2ED
;    3159 					break;
;    3160 				case BTN_SHARP_1:
	CPI  R30,LOW(0x36)
	BREQ _0x2ED
;    3161 					break;
;    3162 				case BTN_SHARP_2:
	CPI  R30,LOW(0x37)
	BREQ _0x2ED
;    3163 					break;
;    3164 				case BTN_SHARP_3:
	CPI  R30,LOW(0x38)
	BREQ _0x2ED
;    3165 					break;
;    3166 				case BTN_SHARP_4:
	CPI  R30,LOW(0x39)
	BREQ _0x2ED
;    3167 					break;
;    3168 				case BTN_SHARP_5:
	CPI  R30,LOW(0x3A)
	BREQ _0x2ED
;    3169 					break;
;    3170 				case BTN_SHARP_6:
	CPI  R30,LOW(0x3B)
	BREQ _0x2ED
;    3171 					break;
;    3172 				case BTN_SHARP_7:
	CPI  R30,LOW(0x3C)
	BREQ _0x2ED
;    3173 					break;
;    3174 				case BTN_SHARP_8:
	CPI  R30,LOW(0x3D)
	BREQ _0x2ED
;    3175 					break;
;    3176 				case BTN_SHARP_9:
	CPI  R30,LOW(0x3E)
	BREQ _0x2ED
;    3177 					break;
;    3178 				case BTN_SHARP_0:
	CPI  R30,LOW(0x3F)
	BREQ _0x2ED
;    3179 					break;
;    3180 				case BTN_SHARP_A:
	CPI  R30,LOW(0x2B)
	BRNE _0x31A
;    3181 					if(F_PS_PLUGGED){
	SBRS R2,5
	RJMP _0x31B
;    3182 						BreakModeCmdSend();
	CALL _BreakModeCmdSend
;    3183 						ChargeNiMH();
	CALL _ChargeNiMH
;    3184 					}
;    3185 					else{
_0x31B:
;    3186 					}
;    3187 					break;
	RJMP _0x2ED
;    3188 				case BTN_SHARP_B:
_0x31A:
	CPI  R30,LOW(0x2C)
	BREQ _0x2ED
;    3189 					break;
;    3190 				case BTN_SHARP_C:
	CPI  R30,LOW(0x31)
	BRNE _0x2ED
;    3191 					BasicPose(0, 50, 1000, 4);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x85
;    3192 					BasicPose(0, 1, 100, 1);
	CALL SUBOPT_0x3D
;    3193 					break;
;    3194 			}
_0x2ED:
;    3195 		}
;    3196 		if(F_RSV_MOTION){
_0x2DE:
	SBRS R3,4
	RJMP _0x31F
;    3197 			F_RSV_MOTION = 0;
	CLT
	BLD  R3,4
;    3198 			SendToPC(20,1);
	LDI  R30,LOW(20)
	CALL SUBOPT_0x1F
;    3199 			gFileCheckSum = 0;
;    3200 			sciTx1Data(gIrBuf[3]);
	__GETB1MN _gIrBuf,3
	ST   -Y,R30
	CALL _sciTx1Data
;    3201 			gFileCheckSum ^= gIrBuf[3];
	__GETB1MN _gIrBuf,3
	CALL SUBOPT_0xA
;    3202 			sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;    3203 		}
;    3204 		for(i=0;i<IR_BUFFER_SIZE;i++)	gIrBuf[i]=0;
_0x31F:
	__GETWRN 16,17,0
_0x321:
	__CPWRN 16,17,4
	BRSH _0x322
	CALL SUBOPT_0x3F
;    3205 	    EIMSK |= 0x40;
	__ADDWRN 16,17,1
	RJMP _0x321
_0x322:
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    3206 	}
;    3207 }
_0x2DD:
_0x323:
	LD   R16,Y+
	LD   R17,Y+
	RET

_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
_abs:
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	__GETD1S 0
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x4:
	LDS  R30,_gRx1Step
	LDS  R31,_gRx1Step+1
	ADIW R30,1
	STS  _gRx1Step,R30
	STS  _gRx1Step+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDS  R30,_gFieldIdx
	LDS  R31,_gFieldIdx+1
	ADIW R30,1
	STS  _gFieldIdx,R30
	STS  _gFieldIdx+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x6:
	LDI  R30,0
	STS  _gRx1Step,R30
	STS  _gRx1Step+1,R30
	CLT
	BLD  R2,4
	SBI  0x1B,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x7:
	LDS  R30,_gRxData
	LDS  R26,_gFileCheckSum
	EOR  R30,R26
	STS  _gFileCheckSum,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _SendToPC
	LDI  R30,LOW(0)
	STS  _gFileCheckSum,R30
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_eM_OriginPose)
	LDI  R27,HIGH(_eM_OriginPose)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0xA:
	LDS  R26,_gFileCheckSum
	EOR  R30,R26
	STS  _gFileCheckSum,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0xB:
	LDS  R30,_gFileCheckSum
	ST   -Y,R30
	JMP  _sciTx1Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0xC:
	LDS  R30,_gRxData
	LDS  R26,_gFileCheckSum
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	MOVW R30,R16
	SUBI R30,LOW(-_StandardZeroPos*2)
	SBCI R31,HIGH(-_StandardZeroPos*2)
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	MOV  R26,R30
	MOVW R30,R16
	__ADDW1MN _gRx1Buf,3
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xF:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	ANDI R30,LOW(0x3F)
	ANDI R31,HIGH(0x3F)
	MOVW R26,R16
	SUBI R26,LOW(-64)
	SBCI R27,HIGH(-64)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x11:
	ST   -Y,R30
	CALL _SendToPC
	LDI  R30,LOW(0)
	STS  _gFileCheckSum,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _sciTx1Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ST   -Y,R18
	CALL _sciTx1Data
	MOV  R30,R18
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x14:
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LDS  R30,_gTx0BufIdx
	SUBI R30,-LOW(1)
	STS  _gTx0BufIdx,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	CALL __LOADLOCR3
	ADIW R28,3
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x18:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	STS  _gRx1_DStep,R30
	STS  _gRx1_DStep+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:62 WORDS
SUBOPT_0x1A:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	LDI  R30,0
	STS  _gRx1_DStep,R30
	STS  _gRx1_DStep+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1C:
	STS  _gRx1Step,R30
	STS  _gRx1Step+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	SBI  0xA,6
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _U1I_case301

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	ST   -Y,R30
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	ST   -Y,R30
	CALL _sciTx1Data
	LDS  R26,_gFileCheckSum
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _gFileCheckSum,R30
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	IN   R30,0x37
	ANDI R30,0xFE
	OUT  0x37,R30
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
	SBI  0xA,7
	CBI  0xA,6
	SET
	BLD  R2,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	ST   -Y,R30
	LDI  R30,LOW(2)
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x24:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x25:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	__GETB1MN _gRx1Buf,18
	ST   -Y,R30
	CALL _sciTx1Data
	__GETB1MN _gRx1Buf,18
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	CALL _sciTx1Data
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	ST   -Y,R30
	CALL _sciTx1Data
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x29:
	LDS  R26,_g10MSEC
	LDS  R27,_g10MSEC+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDS  R30,_gSEC_DCOUNT
	LDS  R31,_gSEC_DCOUNT+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	STS  _gSEC_DCOUNT,R30
	STS  _gSEC_DCOUNT+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDS  R30,_gMIN_DCOUNT
	LDS  R31,_gMIN_DCOUNT+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	STS  _gMIN_DCOUNT,R30
	STS  _gMIN_DCOUNT+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	__GETW1MN _Scene,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	IN   R30,0x36
	ORI  R30,4
	OUT  0x36,R30
	IN   R30,0x37
	ORI  R30,4
	OUT  0x37,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	CALL _MakeFrame
	JMP  _SendFrame

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	LDI  R30,0
	STS  _gPSunplugCount,R30
	STS  _gPSunplugCount+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x33:
	LDS  R30,101
	ANDI R30,0xFB
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	CALL _Get_VOLTAGE
	JMP  _DetectPower

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x35:
	LDS  R30,101
	ORI  R30,4
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x29
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x38:
	ST   -Y,R16
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(254)
	ST   -Y,R30
	JMP  _BoundSetCmdSend

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _BasicPose

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	RCALL SUBOPT_0x29
	CPI  R26,LOW(0x4B)
	LDI  R30,HIGH(0x4B)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	RCALL SUBOPT_0x29
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _BasicPose

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3E:
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
	MOVW R30,R16
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	LDI  R26,LOW(_gIrBuf)
	LDI  R27,HIGH(_gIrBuf)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	CALL _sciTx1Data
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _M_Play

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(5)
	ST   -Y,R30
	JMP  _M_Play

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _M_Play

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	CALL _AccStart
	LDI  R30,LOW(112)
	ST   -Y,R30
	CALL _AccByteWrite
	JMP  _AccAckRead

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x46:
	ST   -Y,R30
	CALL _AccByteWrite
	JMP  _AccAckRead

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x47:
	CALL _AccByteRead
	MOV  R16,R30
	JMP  _AccAckWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	SET
	BLD  R2,7
	LDI  R30,LOW(220)
	ST   -Y,R30
	JMP  _ADC_set

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x49:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	__GETD1S 0
	CALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4E:
	EOR  R26,R30
	LDI  R30,LOW(127)
	AND  R30,R26
	MOV  R16,R30
	LDS  R26,_gTx0Cnt
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	LDI  R30,LOW(255)
	ST   X,R30
	LDS  R30,_gTx0Cnt
	SUBI R30,-LOW(1)
	STS  _gTx0Cnt,R30
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4F:
	LDD  R26,Y+2
	STD  Z+0,R26
	LDS  R30,_gTx0Cnt
	SUBI R30,-LOW(1)
	STS  _gTx0Cnt,R30
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x50:
	LDD  R26,Y+1
	STD  Z+0,R26
	LDS  R30,_gTx0Cnt
	SUBI R30,-LOW(1)
	STS  _gTx0Cnt,R30
	LDS  R26,_gTx0Cnt
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	ST   X,R16
	SUBI R30,-LOW(1)
	STS  _gTx0Cnt,R30
	LDD  R16,Y+0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	STD  Z+0,R26
	LDS  R30,_gTx0Cnt
	SUBI R30,-LOW(1)
	STS  _gTx0Cnt,R30
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x52:
	MOV  R18,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _sciTx0Data
	ST   -Y,R16
	CALL _sciTx0Data
	ST   -Y,R17
	JMP  _sciTx0Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x53:
	ST   -Y,R30
	CALL _sciTx0Data
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	ST   -Y,R30
	CALL _sciTx1Data
	LDI  R30,LOW(170)
	ST   -Y,R30
	CALL _sciTx1Data
	LDI  R30,LOW(85)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x55:
	__MULBNWRU 16,17,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x56:
	__POINTW2MN _Motion,10
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x57:
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP SUBOPT_0x55

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x58:
	__POINTW2MN _Motion,11
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x59:
	__POINTW2MN _Motion,12
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	__POINTW2MN _Motion,13
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	__POINTW2MN _Motion,14
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5C:
	__POINTW2MN _Motion,15
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	MOVW R30,R16
	LDI  R26,LOW(_gPoseDelta)
	LDI  R27,HIGH(_gPoseDelta)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5E:
	__GETW1MN _Motion,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x5F:
	MOVW R30,R16
	SUBI R30,LOW(-_wCK_IDs*2)
	SBCI R31,HIGH(-_wCK_IDs*2)
	LPM  R30,Z
	LDI  R26,LOW(6)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	MOVW R0,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x61:
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	LD   R26,X
	CLR  R27
	MOVW R30,R22
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	LD   R30,X
	ST   -Y,R30
	JMP  _SendSetCmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x64:
	LDS  R30,_gTx0BufIdx
	SUBI R30,LOW(1)
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x65:
	LD   R30,Z
	ST   -Y,R30
	JMP  _sciTx0Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x66:
	__MULBNWRU 16,17,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x67:
	__POINTW2MN _Scene,6
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x68:
	__POINTW2MN _Scene,10
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	LDS  R30,_gScIdx
	LDS  R31,_gScIdx+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	__PUTW1MN _Scene,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6C:
	__PUTW1MN _Scene,4
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6D:
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP SUBOPT_0x66

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6E:
	__POINTW2MN _Scene,7
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6F:
	__POINTW2MN _Scene,8
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x70:
	__POINTW2MN _Scene,9
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x71:
	MOVW R30,R16
	SUBI R30,LOW(-_wCK_IDs*2)
	SBCI R31,HIGH(-_wCK_IDs*2)
	LPM  R30,Z
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	MOVW R22,R30
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x73:
	LDS  R26,_gScIdx
	LDS  R27,_gScIdx+1
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x74:
	LDS  R26,_gpPos_Table
	LDS  R27,_gpPos_Table+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x75:
	LDS  R26,_gpT_Table
	LDS  R27,_gpT_Table+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x76:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x77:
	MOVW R30,R16
	LDI  R26,LOW(_gUnitD)
	LDI  R27,HIGH(_gUnitD)
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x78:
	MOVW R30,R16
	LDI  R26,LOW(_gUnitD)
	LDI  R27,HIGH(_gUnitD)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x79:
	MOVW R30,R16
	LDI  R26,LOW(_gUnitD)
	LDI  R27,HIGH(_gUnitD)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:245 WORDS
SUBOPT_0x7A:
	__PUTW1MN _Motion,6
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	__PUTW1MN _Motion,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7B:
	__MULBNWRU 17,18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7C:
	LDI  R26,LOW(_eM_OriginPose)
	LDI  R27,HIGH(_eM_OriginPose)
	ADD  R26,R17
	ADC  R27,R18
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x7D:
	__MULBNWRU 17,18,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7E:
	CALL _GetPose
	LDI  R30,LOW(255)
	CP   R30,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x7F:
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x80:
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _abs

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x81:
	CALL _SendExPortD
	CALL _CalcFrameInterval
	LDI  R30,LOW(255)
	CP   R30,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x82:
	CALL _CalcUnitMove
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x83:
	ST   -Y,R16
	CALL _PosRead
	MOVW R18,R30
	LDI  R30,LOW(444)
	LDI  R31,HIGH(444)
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x84:
	LDS  R26,_gpPos_Table
	LDS  R27,_gpPos_Table+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x85:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x86:
	STS  _gpT_Table,R30
	STS  _gpT_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x87:
	STS  _gpE_Table,R30
	STS  _gpE_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x88:
	STS  _gpPg_Table,R30
	STS  _gpPg_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x89:
	STS  _gpDg_Table,R30
	STS  _gpDg_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x8A:
	STS  _gpIg_Table,R30
	STS  _gpIg_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x8B:
	STS  _gpFN_Table,R30
	STS  _gpFN_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x8C:
	STS  _gpRT_Table,R30
	STS  _gpRT_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x8D:
	STS  _gpPos_Table,R30
	STS  _gpPos_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8E:
	RCALL SUBOPT_0x8D
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x8F:
	RCALL SUBOPT_0x8D
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x90:
	RCALL SUBOPT_0x8D
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x91:
	RCALL SUBOPT_0x8D
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x92:
	LDI  R30,LOW(13)
	ST   -Y,R30
	JMP  _SendToSoundIC

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x93:
	RCALL SUBOPT_0x8D
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x94:
	LDI  R30,LOW(11)
	ST   -Y,R30
	JMP  _SendToSoundIC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x95:
	RCALL SUBOPT_0x8D
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x96:
	LDI  R30,0
	STS  _gPF2BtnCnt,R30
	STS  _gPF2BtnCnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x97:
	LDI  R30,0
	STS  _gPF12BtnCnt,R30
	STS  _gPF12BtnCnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x98:
	LDS  R26,_gPF1BtnCnt
	LDS  R27,_gPF1BtnCnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x99:
	LDI  R30,0
	STS  _gPF1BtnCnt,R30
	STS  _gPF1BtnCnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9A:
	LDS  R26,_gPF2BtnCnt
	LDS  R27,_gPF2BtnCnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9B:
	LDS  R26,_gPF12BtnCnt
	LDS  R27,_gPF12BtnCnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9C:
	LPM  R30,Z
	ST   -Y,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9D:
	LPM  R30,Z
	ST   -Y,R30
	JMP  _BoundSetCmdSend

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9E:
	LDI  R30,0
	STS  _gPwrLowCount,R30
	STS  _gPwrLowCount+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9F:
	LDS  R30,_gPwrLowCount
	LDS  R31,_gPwrLowCount+1
	ADIW R30,1
	STS  _gPwrLowCount,R30
	STS  _gPwrLowCount+1,R31
	LDS  R26,_gPwrLowCount
	LDS  R27,_gPwrLowCount+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA0:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA1:
	CALL __EEPROMRDB
	LDS  R26,_gIrBuf
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA2:
	CALL __EEPROMRDB
	__GETB2MN _gIrBuf,1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA3:
	CALL __EEPROMRDB
	__GETB2MN _gIrBuf,2
	CP   R30,R26
	RET

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ftrunc:
	ldd  r23,y+3
	ldd  r22,y+2
	ldd  r31,y+1
	ld   r30,y
	bst  r23,7
	lsl  r23
	sbrc r22,7
	sbr  r23,1
	mov  r25,r23
	subi r25,0x7e
	breq __ftrunc0
	brcs __ftrunc0
	cpi  r25,24
	brsh __ftrunc1
	clr  r26
	clr  r27
	clr  r24
__ftrunc2:
	sec
	ror  r24
	ror  r27
	ror  r26
	dec  r25
	brne __ftrunc2
	and  r30,r26
	and  r31,r27
	and  r22,r24
	rjmp __ftrunc1
__ftrunc0:
	clt
	clr  r23
	clr  r30
	clr  r31
	clr  r22
__ftrunc1:
	cbr  r22,0x80
	lsr  r23
	brcc __ftrunc3
	sbr  r22,0x80
__ftrunc3:
	bld  r23,7
	ld   r26,y+
	ld   r27,y+
	ld   r24,y+
	ld   r25,y+
	cp   r30,r26
	cpc  r31,r27
	cpc  r22,r24
	cpc  r23,r25
	bst  r25,7
	ret

_floor:
	rcall __ftrunc
	brne __floor1
__floor0:
	ret
__floor1:
	brtc __floor0
	ldi  r25,0xbf

	rjmp __addfc

_ceil:
	rcall __ftrunc
	brne __ceil1
__ceil0:
	ret
__ceil1:
	brts __ceil0
	ldi  r25,0x3f

__addfc:
	clr  r26
	clr  r27
	ldi  r24,0x80
	rjmp __addf12

__ANEGD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIC EECR,EEWE
	RJMP __EEPROMWRB
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	MOV  R21,R30
	MOV  R30,R26
	MOV  R26,R21
	MOV  R21,R31
	MOV  R31,R27
	MOV  R27,R21
	MOV  R21,R22
	MOV  R22,R24
	MOV  R24,R21
	MOV  R21,R23
	MOV  R23,R25
	MOV  R25,R21
	MOV  R21,R0
	MOV  R0,R1
	MOV  R1,R21
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF129
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,24
__MULF120:
	LSL  R19
	ROL  R20
	ROL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	BRCC __MULF121
	ADD  R19,R26
	ADC  R20,R27
	ADC  R21,R24
	ADC  R30,R1
	ADC  R31,R1
	ADC  R22,R1
__MULF121:
	DEC  R25
	BRNE __MULF120
	POP  R20
	POP  R19
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __REPACK
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __MAXRES
	RJMP __MINRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	LSR  R22
	ROR  R31
	ROR  R30
	LSR  R24
	ROR  R27
	ROR  R26
	PUSH R20
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R25,24
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R1
	ROL  R20
	ROL  R21
	ROL  R26
	ROL  R27
	ROL  R24
	DEC  R25
	BRNE __DIVF212
	MOV  R30,R1
	MOV  R31,R20
	MOV  R22,R21
	LSR  R26
	ADC  R30,R25
	ADC  R31,R25
	ADC  R22,R25
	POP  R20
	TST  R22
	BRMI __DIVF215
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD20:
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	RET

__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD R26,R28
	ADC R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
