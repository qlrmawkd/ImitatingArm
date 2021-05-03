
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
;       2 //	 RoboBuilder MainController Sample Program	1.0
;       3 //										2008.04.14	Robobuilder co., ltd.
;       4 // ¡Ø º» ¼Ò½ºÄÚµå´Â Tab Size = 4¸¦ ±âÁØÀ¸·Î ÆíÁýµÇ¾ú½À´Ï´Ù
;       5 //==============================================================================
;       6 #include <mega128.h>
;       7 
;       8 // Standard Input/Output functions
;       9 #include <stdio.h>
;      10 #include <delay.h>
;      11 
;      12 #include "Macro.h"
;      13 #include "Main.h"
;      14 #include "Comm.h"
;      15 #include "Dio.h"
;      16 #include "math.h"
;      17 
;      18 // ÇÃ·¡±×----------------------------------------------------------------------
;      19 bit 	F_PLAYING;				// ¸ð¼Ç ½ÇÇàÁß Ç¥½Ã
;      20 bit 	F_DIRECT_C_EN;			// wCK Á÷Á¢Á¦¾î °¡´ÉÀ¯¹«(1:°¡´É, 0:ºÒ°¡)
;      21 
;      22 // ¹öÆ° ÀÔ·Â Ã³¸®¿ë------------------------------------------------------------
;      23 WORD    gBtnCnt;				// ¹öÆ° ´­¸² Ã³¸®¿ë Ä«¿îÅÍ
;      24 
;      25 // ½Ã°£ ÃøÁ¤¿ë-----------------------------------------------------------------
;      26 WORD    gMSEC;
;      27 BYTE    gSEC;
;      28 BYTE    gMIN;
;      29 BYTE    gHOUR;
;      30 
;      31 // UART Åë½Å¿ë-----------------------------------------------------------------
;      32 char	gTx0Buf[TX0_BUF_SIZE];		// UART0 ¼Û½Å ¹öÆÛ
_gTx0Buf:
	.BYTE 0xBA
;      33 BYTE	gTx0Cnt;					// UART0 ¼Û½Å ´ë±â ¹ÙÀÌÆ® ¼ö
;      34 BYTE	gRx0Cnt;					// UART0 ¼ö½Å ¹ÙÀÌÆ® ¼ö
;      35 BYTE	gTx0BufIdx;					// UART0 ¼Û½Å ¹öÆÛ ÀÎµ¦½º
;      36 char	gRx0Buf[RX0_BUF_SIZE];		// UART0 ¼ö½Å ¹öÆÛ
_gRx0Buf:
	.BYTE 0x8
;      37 BYTE	gOldRx1Byte;				// UART1 ÃÖ±Ù ¼ö½Å ¹ÙÀÌÆ®
;      38 char	gRx1Buf[RX1_BUF_SIZE];		// UART1 ¼ö½Å ¹öÆÛ
_gRx1Buf:
	.BYTE 0x14
;      39 BYTE	gRx1Index;					// UART1 ¼ö½Å ¹öÆÛ¿ë ÀÎµ¦½º
_gRx1Index:
	.BYTE 0x1
;      40 WORD	gRx1Step;					// UART1 ¼ö½Å ÆÐÅ¶ ´Ü°è ±¸ºÐ
_gRx1Step:
	.BYTE 0x2
;      41 WORD	gRx1_DStep;					// Á÷Á¢Á¦¾î ¸ðµå¿¡¼­ UART1 ¼ö½Å ÆÐÅ¶ ´Ü°è ±¸ºÐ
_gRx1_DStep:
	.BYTE 0x2
;      42 WORD	gFieldIdx;					// ÇÊµåÀÇ ¹ÙÀÌÆ® ÀÎµ¦½º
_gFieldIdx:
	.BYTE 0x2
;      43 WORD	gFileByteIndex;				// ÆÄÀÏÀÇ ¹ÙÀÌÆ® ÀÎµ¦½º
_gFileByteIndex:
	.BYTE 0x2
;      44 BYTE	gFileCheckSum;				// ÆÄÀÏ³»¿ë CheckSum
_gFileCheckSum:
	.BYTE 0x1
;      45 BYTE	gRxData;					// ¼ö½Åµ¥ÀÌÅÍ ÀúÀå
_gRxData:
	.BYTE 0x1
;      46 
;      47 // ¸ð¼Ç Á¦¾î¿ë-----------------------------------------------------------------
;      48 int		gFrameIdx=0;	    // ¸ð¼ÇÅ×ÀÌºíÀÇ ÇÁ·¹ÀÓ ÀÎµ¦½º
_gFrameIdx:
	.BYTE 0x2
;      49 WORD	TxInterval=0;		// ÇÁ·¹ÀÓ ¼Û½Å °£°Ý
_TxInterval:
	.BYTE 0x2
;      50 float	gUnitD[MAX_wCK];	// ´ÜÀ§ Áõ°¡ º¯À§
_gUnitD:
	.BYTE 0x7C
;      51 BYTE flash	*gpT_Table;		// ¸ð¼Ç ÅäÅ©¸ðµå Å×ÀÌºí Æ÷ÀÎÅÍ
_gpT_Table:
	.BYTE 0x2
;      52 BYTE flash	*gpE_Table;		// ¸ð¼Ç È®ÀåÆ÷Æ®°ª Å×ÀÌºí Æ÷ÀÎÅÍ
_gpE_Table:
	.BYTE 0x2
;      53 BYTE flash	*gpPg_Table;	// ¸ð¼Ç Runtime PÀÌµæ Å×ÀÌºí Æ÷ÀÎÅÍ
_gpPg_Table:
	.BYTE 0x2
;      54 BYTE flash	*gpDg_Table;	// ¸ð¼Ç Runtime DÀÌµæ Å×ÀÌºí Æ÷ÀÎÅÍ
_gpDg_Table:
	.BYTE 0x2
;      55 BYTE flash	*gpIg_Table;	// ¸ð¼Ç Runtime IÀÌµæ Å×ÀÌºí Æ÷ÀÎÅÍ
_gpIg_Table:
	.BYTE 0x2
;      56 WORD flash	*gpFN_Table;	// ¾À ÇÁ·¹ÀÓ ¼ö Å×ÀÌºí Æ÷ÀÎÅÍ
_gpFN_Table:
	.BYTE 0x2
;      57 WORD flash	*gpRT_Table;	// ¾À ½ÇÇà½Ã°£ Å×ÀÌºí Æ÷ÀÎÅÍ
_gpRT_Table:
	.BYTE 0x2
;      58 BYTE flash	*gpPos_Table;	// ¸ð¼Ç À§Ä¡°ª Å×ÀÌºí Æ÷ÀÎÅÍ
_gpPos_Table:
	.BYTE 0x2
;      59 
;      60 // ¾×¼Ç ÆÄÀÏÀÇ ±¸¼º Ã¼°è
;      61 //      - Å©±â : wCK < Frame < Scene < Motion < Action
;      62 //      - ¿©·¯°³ÀÇ wCK°¡ ¸ð¿© FrameÀ» ÀÌ·ç°í
;      63 //        ¿©·¯°³ÀÇ Frame ÀÌ ¸ð¿© SceneÀ» ÀÌ·ç¸ç
;      64 //        ¿©·¯°³ÀÇ Scene ÀÌ ¸ð¿© MotionÀ» ÀÌ·ç°í
;      65 //        ¿©·¯°³ÀÇ Motion ÀÌ ¸ð¿© ActionÀ» ÀÌ·é´Ù
;      66 
;      67 struct TwCK_in_Motion{  // ÇÑ °³ ¸ð¼Ç¿¡¼­ »ç¿ëÇÏ´Â wCK Á¤º¸
;      68 	BYTE	Exist;			// wCK À¯¹«
;      69 	BYTE	RPgain;			// Runtime PÀÌµæ
;      70 	BYTE	RDgain;			// Runtime DÀÌµæ
;      71 	BYTE	RIgain;			// Runtime IÀÌµæ
;      72 	BYTE	PortEn;			// È®ÀåÆ÷Æ® »ç¿ëÀ¯¹«(0:»ç¿ë¾ÈÇÔ, 1:»ç¿ëÇÔ)
;      73 	BYTE	InitPos;		// ¸ð¼ÇÆÄÀÏÀ» ¸¸µé ¶§ »ç¿ëµÈ ·Îº¿ÀÇ ¿µÁ¡ À§Ä¡Á¤º¸
;      74 };
;      75 
;      76 struct TwCK_in_Scene{	// ÇÑ °³ ¾À¿¡¼­ »ç¿ëÇÏ´Â wCK Á¤º¸
;      77 	BYTE	Exist;			// wCK À¯¹«
;      78 	BYTE	SPos;			// Ã¹ ÇÁ·¹ÀÓÀÇ wCK À§Ä¡
;      79 	BYTE	DPos;			// ³¡ ÇÁ·¹ÀÓÀÇ wCK À§Ä¡
;      80 	BYTE	Torq;			// ÅäÅ©
;      81 	BYTE	ExPortD;		// È®ÀåÆ÷Æ® Ãâ·Â µ¥ÀÌÅÍ(1~3)
;      82 };
;      83 
;      84 struct TMotion{			// ÇÑ °³ ¸ð¼Ç¿¡¼­ »ç¿ëÇÏ´Â Á¤º¸µé
;      85 	BYTE	PF;				// ¸ð¼Ç¿¡ ¸Â´Â ÇÃ·§Æû
;      86 	BYTE	RIdx;			// ¸ð¼ÇÀÇ »ó´ë ÀÎµ¦½º
;      87 	DWORD	AIdx;			// ¸ð¼ÇÀÇ Àý´ë ÀÎµ¦½º
;      88 	WORD	NumOfScene;		// ¾À ¼ö
;      89 	WORD	NumOfwCK;		// wCK ¼ö
;      90 	struct	TwCK_in_Motion  wCK[MAX_wCK];	// wCK ÆÄ¶ó¹ÌÅÍ
;      91 	WORD	FileSize;		// ÆÄÀÏ Å©±â
;      92 }Motion;
_Motion:
	.BYTE 0xC6
;      93 
;      94 struct TScene{			// ÇÑ °³ ¾À¿¡¼­ »ç¿ëÇÏ´Â Á¤º¸µé
;      95 	WORD	Idx;			// ¾À ÀÎµ¦½º(0~65535)
;      96 	WORD	NumOfFrame;		// ÇÁ·¹ÀÓ ¼ö
;      97 	WORD	RTime;			// ¾À ¼öÇà ½Ã°£[msec]
;      98 	struct	TwCK_in_Scene   wCK[MAX_wCK];	// wCK µ¥ÀÌÅÍ
;      99 }Scene;
_Scene:
	.BYTE 0xA1
;     100 
;     101 WORD	gSIdx;			// ¾À ÀÎµ¦½º(0~65535)
_gSIdx:
	.BYTE 0x2
;     102 
;     103 //------------------------------------------------------------------------------
;     104 // UART0 ¼Û½Å ÀÎÅÍ·´Æ®(ÆÐÅ¶ ¼Û½Å¿ë)
;     105 //------------------------------------------------------------------------------
;     106 interrupt [USART0_TXC] void usart0_tx_isr(void) {

	.CSEG
_usart0_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     107 	if(gTx0BufIdx<gTx0Cnt){			// º¸³¾ µ¥ÀÌÅÍ°¡ ³²¾ÆÀÖÀ¸¸é
	CP   R13,R11
	BRSH _0x3
;     108     	while(!(UCSR0A&(1<<UDRE))); 	// ÀÌÀü ¹ÙÀÌÆ® Àü¼ÛÀÌ ¿Ï·áµÉ¶§±îÁö ´ë±â
_0x4:
	SBIS 0xB,5
	RJMP _0x4
;     109 		UDR0=gTx0Buf[gTx0BufIdx];		// 1¹ÙÀÌÆ® ¼Û½Å
	MOV  R30,R13
	CALL SUBOPT_0x0
	OUT  0xC,R30
;     110     	gTx0BufIdx++;      				// ¹öÆÛ ÀÎµ¦½º Áõ°¡
	INC  R13
;     111 	}
;     112 	else if(gTx0BufIdx==gTx0Cnt){	// ¼Û½Å ¿Ï·á
	RJMP _0x7
_0x3:
	CP   R11,R13
	BRNE _0x8
;     113 		gTx0BufIdx = 0;					// ¹öÆÛ ÀÎµ¦½º ÃÊ±âÈ­
	CLR  R13
;     114 		gTx0Cnt = 0;					// ¼Û½Å ´ë±â ¹ÙÀÌÆ®¼ö ÃÊ±âÈ­
	CLR  R11
;     115 	}
;     116 }
_0x8:
_0x7:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     117 
;     118 
;     119 //------------------------------------------------------------------------------
;     120 // UART0 ¼ö½Å ÀÎÅÍ·´Æ®(wCK, »ç¿îµå¸ðµâ¿¡¼­ ¹ÞÀº ½ÅÈ£)
;     121 //------------------------------------------------------------------------------
;     122 interrupt [USART0_RXC] void usart0_rx_isr(void)
;     123 {
_usart0_rx_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     124 	int		i;
;     125     char	data;
;     126 	data=UDR0;
	CALL __SAVELOCR3
;	i -> R16,R17
;	data -> R18
	IN   R18,12
;     127 	gRx0Cnt++;
	INC  R12
;     128     // ¼ö½Åµ¥ÀÌÅÍ¸¦ FIFO¿¡ ÀúÀå
;     129    	for(i=1; i<RX0_BUF_SIZE; i++) gRx0Buf[i-1] = gRx0Buf[i];
	__GETWRN 16,17,1
_0xA:
	__CPWRN 16,17,8
	BRGE _0xB
	MOVW R30,R16
	SBIW R30,1
	SUBI R30,LOW(-_gRx0Buf)
	SBCI R31,HIGH(-_gRx0Buf)
	MOVW R0,R30
	LDI  R26,LOW(_gRx0Buf)
	LDI  R27,HIGH(_gRx0Buf)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
;     130    	gRx0Buf[RX0_BUF_SIZE-1] = data;
	__ADDWRN 16,17,1
	RJMP _0xA
_0xB:
	__PUTBMRN _gRx0Buf,7,18
;     131 }
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
	RETI
;     132 
;     133 
;     134 //------------------------------------------------------------------------------
;     135 // Å¸ÀÌ¸Ó0 ¿À¹öÇÃ·Î ÀÎÅÍ·´Æ® (½Ã°£ ÃøÁ¤¿ë 0.998ms °£°Ý)
;     136 //------------------------------------------------------------------------------
;     137 interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     138 	TCNT0 = 25;
	LDI  R30,LOW(25)
	OUT  0x32,R30
;     139 	// 1ms ¸¶´Ù ½ÇÇà
;     140     if(++gMSEC>999){
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRLO _0xC
;     141 		// 1s ¸¶´Ù ½ÇÇà
;     142         gMSEC=0;
	CLR  R6
	CLR  R7
;     143         if(++gSEC>59){
	INC  R8
	LDI  R30,LOW(59)
	CP   R30,R8
	BRSH _0xD
;     144 			// 1m ¸¶´Ù ½ÇÇà
;     145             gSEC=0;
	CLR  R8
;     146             if(++gMIN>59){
	INC  R9
	CP   R30,R9
	BRSH _0xE
;     147 				// 1h ¸¶´Ù ½ÇÇà
;     148                 gMIN=0;
	CLR  R9
;     149                 if(++gHOUR>23)
	INC  R10
	LDI  R30,LOW(23)
	CP   R30,R10
	BRSH _0xF
;     150                     gHOUR=0;
	CLR  R10
;     151             }
_0xF:
;     152         }
_0xE:
;     153     }
_0xD:
;     154 }
_0xC:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;     155 
;     156 
;     157 //------------------------------------------------------------------------------
;     158 // Å¸ÀÌ¸Ó1 ¿À¹öÇÃ·Î ÀÎÅÍ·´Æ® (ÇÁ·¹ÀÓ ¼Û½Å)
;     159 //------------------------------------------------------------------------------
;     160 interrupt [TIM1_OVF] void timer1_ovf_isr(void) {
_timer1_ovf_isr:
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
;     161 	if( gFrameIdx == Scene.NumOfFrame ) {   // ¸¶Áö¸· ÇÁ·¹ÀÓÀÌ¾úÀ¸¸é
	__GETW1MN _Scene,2
	LDS  R26,_gFrameIdx
	LDS  R27,_gFrameIdx+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x10
;     162    	    gFrameIdx = 0;
	LDI  R30,0
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R30
;     163     	RUN_LED1_OFF;
	SBI  0x1B,5
;     164 		F_PLAYING=0;		// ¸ð¼Ç ½ÇÇàÁß Ç¥½ÃÇØÁ¦
	CLT
	BLD  R2,0
;     165 		TIMSK &= 0xfb;  	// Timer1 Overflow Interrupt ÇØÁ¦
	IN   R30,0x37
	ANDI R30,0xFB
	OUT  0x37,R30
;     166 		TCCR1B=0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
;     167 		return;
	CALL SUBOPT_0x1
	RETI
;     168 	}
;     169 	TCNT1=TxInterval;
_0x10:
	LDS  R30,_TxInterval
	LDS  R31,_TxInterval+1
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;     170 	TIFR |= 0x04;		// Å¸ÀÌ¸Ó ÀÎÅÍ·´Æ® ÇÃ·¡±× ÃÊ±âÈ­
	IN   R30,0x36
	ORI  R30,4
	OUT  0x36,R30
;     171 	TIMSK |= 0x04;		// Timer1 Overflow Interrupt È°¼ºÈ­(140ÂÊ)
	IN   R30,0x37
	ORI  R30,4
	OUT  0x37,R30
;     172 	MakeFrame();		// ÇÑ ÇÁ·¹ÀÓ ÁØºñ
	RCALL _MakeFrame
;     173 	SendFrame();		// ÇÑ ÇÁ·¹ÀÓ ¼Û½Å
	RCALL _SendFrame
;     174 }
	CALL SUBOPT_0x1
	RETI
;     175 
;     176 
;     177 //------------------------------------------------------------------------------
;     178 // ÇÏµå¿þ¾î ÃÊ±âÈ­
;     179 //------------------------------------------------------------------------------
;     180 void HW_init(void) {
_HW_init:
;     181 	// Input/Output Ports initialization
;     182 	// Port A initialization
;     183 	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
;     184 	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=P State0=P 
;     185 	PORTA=0x03;
	LDI  R30,LOW(3)
	OUT  0x1B,R30
;     186 	DDRA=0xFC;
	LDI  R30,LOW(252)
	OUT  0x1A,R30
;     187 
;     188 	// Port B initialization
;     189 	// Func7=In Func6=Out Func5=Out Func4=Out Func3=In Func2=Out Func1=In Func0=In 
;     190 	// State7=T State6=0 State5=0 State4=0 State3=T State2=0 State1=T State0=T 
;     191 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     192 	DDRB=0x74;
	LDI  R30,LOW(116)
	OUT  0x17,R30
;     193 
;     194 	// Port C initialization
;     195 	// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     196 	// State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     197 	PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;     198 	DDRC=0x80;
	LDI  R30,LOW(128)
	OUT  0x14,R30
;     199 
;     200 	// Port D initialization
;     201 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     202 	// State7=T State6=T State5=T State4=T State3=T State2=T State1=P State0=P 
;     203 	PORTD=0x83;
	LDI  R30,LOW(131)
	OUT  0x12,R30
;     204 	DDRD=0x80;
	LDI  R30,LOW(128)
	OUT  0x11,R30
;     205 
;     206 	// Port E initialization
;     207 	// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In 
;     208 	// State7=T State6=P State5=P State4=P State3=0 State2=T State1=T State0=T 
;     209 	PORTE=0x70;
	LDI  R30,LOW(112)
	OUT  0x3,R30
;     210 	DDRE=0x08;
	LDI  R30,LOW(8)
	OUT  0x2,R30
;     211 
;     212 	// Port F initialization
;     213 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     214 	// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     215 	PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
;     216 	DDRF=0x00;
	STS  97,R30
;     217 
;     218 	// Port G initialization
;     219 	// Func4=In Func3=In Func2=Out Func1=In Func0=In 
;     220 	// State4=T State3=T State2=0 State1=T State0=T 
;     221 	PORTG=0x00;
	STS  101,R30
;     222 	DDRG=0x04;
	LDI  R30,LOW(4)
	STS  100,R30
;     223 
;     224 	// Å¸ÀÌ¸Ó 0---------------------------------------------------------------
;     225 	// : ¹ü¿ë ½Ã°£ ÃøÁ¤¿ëÀ¸·Î »ç¿ë(ms ´ÜÀ§)
;     226 	// Timer/Counter 0 initialization
;     227 	// Clock source: System Clock
;     228 	// Clock value: 230.400 kHz
;     229 	// Clock Áõ°¡ ÁÖ±â = 1/230400 = 4.34us
;     230 	// Overflow ½Ã°£ = 255*1/230400 = 1.107ms
;     231 	// 1ms ÁÖ±â overflow¸¦ À§ÇÑ Ä«¿îÆ® ½ÃÀÛ°ª =  255-230 = 25
;     232 	// Mode: Normal top=FFh
;     233 	// OC0 output: Disconnected
;     234 	ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     235 	TCCR0=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
;     236 	TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;     237 	OCR0=0x00;
	OUT  0x31,R30
;     238 
;     239 	// Å¸ÀÌ¸Ó 1---------------------------------------------------------------
;     240 	// : ¸ð¼Ç ÇÃ·¹ÀÌ½Ã ÇÁ·¹ÀÓ ¼Û½Å °£°Ý Á¶Àý¿ëÀ¸·Î »ç¿ë
;     241 	// Timer/Counter 1 initialization
;     242 	// Clock source: System Clock
;     243 	// Clock value: 14.400 kHz
;     244 	// Clock Áõ°¡ ÁÖ±â = 1/14400 = 69.4us
;     245 	// Mode: Normal top=FFFFh
;     246 	// OC1A output: Discon.
;     247 	// OC1B output: Discon.
;     248 	// OC1C output: Discon.
;     249 	// Noise Canceler: Off
;     250 	// Input Capture on Falling Edge
;     251 	// Timer 1 Overflow Interrupt: On
;     252 	// Input Capture Interrupt: Off
;     253 	// Compare A Match Interrupt: Off
;     254 	// Compare B Match Interrupt: Off
;     255 	// Compare C Match Interrupt: Off
;     256 	TCCR1A=0x00;
	OUT  0x2F,R30
;     257 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;     258 	TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;     259 	TCNT1L=0x00;
	OUT  0x2C,R30
;     260 	ICR1H=0x00;
	OUT  0x27,R30
;     261 	ICR1L=0x00;
	OUT  0x26,R30
;     262 	OCR1AH=0x00;
	OUT  0x2B,R30
;     263 	OCR1AL=0x00;
	OUT  0x2A,R30
;     264 	OCR1BH=0x00;
	OUT  0x29,R30
;     265 	OCR1BL=0x00;
	OUT  0x28,R30
;     266 	OCR1CH=0x00;
	STS  121,R30
;     267 	OCR1CL=0x00;
	STS  120,R30
;     268 
;     269 	// Å¸ÀÌ¸Ó 2---------------------------------------------------------------
;     270 	// Timer/Counter 2 initialization
;     271 	// Clock source: System Clock
;     272 	// Clock value: 14.400 kHz
;     273 	// Clock Áõ°¡ ÁÖ±â = 1/14400 = 69.4us
;     274 	// Mode: Normal top=FFh
;     275 	// OC2 output: Disconnected
;     276 	TCCR2=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
;     277 	TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
;     278 	OCR2=0x00;
	OUT  0x23,R30
;     279 
;     280 	// Å¸ÀÌ¸Ó 3---------------------------------------------------------------
;     281 	// : °¡¼Óµµ ¼¾¼­ ½ÅÈ£ ºÐ¼®¿ëÀ¸·Î »ç¿ë
;     282 	TCCR3A=0x00;
	STS  139,R30
;     283 	TCCR3B=0x03;
	LDI  R30,LOW(3)
	STS  138,R30
;     284 	TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
;     285 	TCNT3L=0x00;
	STS  136,R30
;     286 	ICR3H=0x00;
	STS  129,R30
;     287 	ICR3L=0x00;
	STS  128,R30
;     288 	OCR3AH=0x00;
	STS  135,R30
;     289 	OCR3AL=0x00;
	STS  134,R30
;     290 	OCR3BH=0x00;
	STS  133,R30
;     291 	OCR3BL=0x00;
	STS  132,R30
;     292 	OCR3CH=0x00;
	STS  131,R30
;     293 	OCR3CL=0x00;
	STS  130,R30
;     294 
;     295 	// External Interrupt(s) initialization
;     296 	// INT0: Off
;     297 	// INT1: Off
;     298 	// INT2: Off
;     299 	// INT3: Off
;     300 	// INT4: Off
;     301 	// INT5: Off
;     302 	// INT6: Off
;     303 	// INT7: Off
;     304 	EICRA=0x00;
	STS  106,R30
;     305 	EICRB=0x00;
	OUT  0x3A,R30
;     306 	EIMSK=0x00;
	OUT  0x39,R30
;     307 
;     308 	// Timer(s)/Counter(s) Interrupt(s) initialization
;     309 	TIMSK=0x00;
	OUT  0x37,R30
;     310 	ETIMSK=0x00;
	STS  125,R30
;     311 
;     312 	// USART0 initialization
;     313 	// Communication Parameters: 8 Data, 1 Stop, No Parity
;     314 	// USART0 Receiver: Off
;     315 	// USART0 Transmitter: On
;     316 	// USART0 Mode: Asynchronous
;     317 	// USART0 Baud rate: 115200
;     318 	UCSR0A=0x00;
	OUT  0xB,R30
;     319 	UCSR0B=0x48;
	LDI  R30,LOW(72)
	OUT  0xA,R30
;     320 	UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
;     321 	UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;     322 	UBRR0L=0x07;
	LDI  R30,LOW(7)
	OUT  0x9,R30
;     323 
;     324 	// USART1 initialization
;     325 	// Communication Parameters: 8 Data, 1 Stop, No Parity
;     326 	// USART1 Receiver: On
;     327 	// USART1 Transmitter: On
;     328 	// USART1 Mode: Asynchronous
;     329 	// USART1 Baud rate: 115200
;     330 	UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
;     331 	UCSR1B=0x18;		// ¼ö½ÅÀÎÅÍ·´Æ® »ç¿ë¾ÈÇÔ
	LDI  R30,LOW(24)
	STS  154,R30
;     332 	UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;     333 	UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
;     334 	UBRR1L=BR115200;	// UART1 ÀÇ BAUD RATE¸¦ 115200·Î ¼³Á¤
	LDI  R30,LOW(7)
	STS  153,R30
;     335 
;     336 	TWCR = 0;
	LDI  R30,LOW(0)
	STS  116,R30
;     337 }
	RET
;     338 
;     339 
;     340 //------------------------------------------------------------------------------
;     341 // ÇÃ·¡±× ÃÊ±âÈ­
;     342 //------------------------------------------------------------------------------
;     343 void SW_init(void) {
_SW_init:
;     344 	PF1_LED1_OFF;
	SBI  0x1B,2
;     345 	PF1_LED2_OFF;
	SBI  0x1B,3
;     346 	PF2_LED_OFF;
	SBI  0x1B,4
;     347 	PWR_LED1_OFF;
	LDS  R30,101
	ORI  R30,4
	STS  101,R30
;     348 	PWR_LED2_OFF;
	SBI  0x15,7
;     349 	RUN_LED1_OFF;
	SBI  0x1B,5
;     350 	RUN_LED2_OFF;
	SBI  0x1B,6
;     351 	ERR_LED_OFF;
	SBI  0x1B,7
;     352 	F_PLAYING = 0;          // µ¿ÀÛÁß ¾Æ´Ô
	CLT
	BLD  R2,0
;     353 
;     354 	gTx0Cnt = 0;			// UART0 ¼Û½Å ´ë±â ¹ÙÀÌÆ® ¼ö
	CLR  R11
;     355 	gTx0BufIdx = 0;			// TX0 ¹öÆÛ ÀÎµ¦½º ÃÊ±âÈ­
	CLR  R13
;     356 	PSD_OFF;                // PSD °Å¸®¼¾¼­ Àü¿ø OFF
	CBI  0x18,5
;     357 	gMSEC=0;
	CLR  R6
	CLR  R7
;     358 	gSEC=0;
	CLR  R8
;     359 	gMIN=0;
	CLR  R9
;     360 	gHOUR=0;
	CLR  R10
;     361 }
	RET
;     362 
;     363 
;     364 void SpecialMode(void)
;     365 {
_SpecialMode:
;     366 	int i;
;     367 
;     368 	// PF2 ¹öÆ°ÀÌ ´­·¯Á³À¸¸é wCK Á÷Á¢Á¦¾î ¸ðµå·Î ÁøÀÔ
;     369 	if(PINA.0==1 && PINA.1==0){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	SBIS 0x19,0
	RJMP _0x12
	SBIS 0x19,1
	RJMP _0x13
_0x12:
	RJMP _0x11
_0x13:
;     370 		delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x2
;     371 		if(PINA.0==1){
	SBIS 0x19,0
	RJMP _0x14
;     372 		    TIMSK &= 0xFE;     // Timer0 Overflow Interrupt ¹Ì»ç¿ë
	IN   R30,0x37
	ANDI R30,0xFE
	OUT  0x37,R30
;     373 			EIMSK &= 0xBF;		// EXT6(¸®¸ðÄÁ ¼ö½Å) ÀÎÅÍ·´Æ® ¹Ì»ç¿ë
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;     374 			UCSR0B |= 0x80;   	// UART0 RxÀÎÅÍ·´Æ® »ç¿ë
	SBI  0xA,7
;     375 			UCSR0B &= 0xBF;   	// UART0 TxÀÎÅÍ·´Æ® ¹Ì»ç¿ë
	CBI  0xA,6
;     376 		}
;     377 	}
_0x14:
;     378 }
_0x11:
	LD   R16,Y+
	LD   R17,Y+
	RET
;     379 
;     380 //------------------------------------------------------------------------------
;     381 // ¸ÞÀÎ ÇÔ¼ö
;     382 //------------------------------------------------------------------------------
;     383 void main(void) {
_main:
;     384 	WORD    i, lMSEC;
;     385 
;     386 	HW_init();			// ÇÏµå¿þ¾î ÃÊ±âÈ­
;	i -> R16,R17
;	lMSEC -> R18,R19
	CALL _HW_init
;     387 	SW_init();			// º¯¼ö ÃÊ±âÈ­
	CALL _SW_init
;     388 
;     389 	#asm("sei");
	sei
;     390 	TIMSK |= 0x01;		// Timer0 Overflow Interrupt È°¼ºÈ­
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
;     391 
;     392 	SpecialMode();
	CALL _SpecialMode
;     393 
;     394 	while(1){
_0x15:
;     395 		/*
;     396 		lMSEC = gMSEC;
;     397 		ReadButton();	    // ¹öÆ° ÀÐ±â
;     398 		IoUpdate();		    // IO »óÅÂ UPDATE
;     399 		while(lMSEC==gMSEC);
;     400 		*/
;     401 		PositionMove(1,1,200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(200)
	ST   -Y,R30
	RCALL _PositionMove
;     402 		
;     403 		PWR_LED2_ON;    delay_ms(500);
	CBI  0x15,7
	CALL SUBOPT_0x3
;     404 		PWR_LED2_OFF;    delay_ms(500);
	SBI  0x15,7
	CALL SUBOPT_0x3
;     405 		
;     406 		PositionMove(1,1,50);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	RCALL _PositionMove
;     407 		
;     408 		PWR_LED1_ON;    delay_ms(500);
	LDS  R30,101
	ANDI R30,0xFB
	STS  101,R30
	CALL SUBOPT_0x3
;     409 		PWR_LED1_OFF;    delay_ms(500);
	LDS  R30,101
	ORI  R30,4
	STS  101,R30
	CALL SUBOPT_0x3
;     410     }
	RJMP _0x15
;     411 }
_0x18:
	RJMP _0x18
;     412 //==============================================================================
;     413 //						Communication & Command ÇÔ¼öµé
;     414 //==============================================================================
;     415 
;     416 #include <mega128.h>
;     417 #include <string.h>
;     418 #include "Main.h"
;     419 #include "Macro.h"
;     420 #include "Comm.h"
;     421 #include "p_ex1.h"
;     422 
;     423 //------------------------------------------------------------------------------
;     424 // ½Ã¸®¾ó Æ÷Æ®·Î ÇÑ ¹®ÀÚ¸¦ Àü¼ÛÇÏ±â À§ÇÑ ÇÔ¼ö
;     425 //------------------------------------------------------------------------------
;     426 void sciTx0Data(BYTE td)
;     427 {
_sciTx0Data:
;     428 	while(!(UCSR0A&(1<<UDRE))); 	// ÀÌÀüÀÇ Àü¼ÛÀÌ ¿Ï·áµÉ¶§±îÁö ´ë±â
;	td -> Y+0
_0x19:
	SBIS 0xB,5
	RJMP _0x19
;     429 	UDR0=td;
	LD   R30,Y
	OUT  0xC,R30
;     430 }
	ADIW R28,1
	RET
;     431 
;     432 void sciTx1Data(BYTE td)
;     433 {
;     434 	while(!(UCSR1A&(1<<UDRE))); 	// ÀÌÀüÀÇ Àü¼ÛÀÌ ¿Ï·áµÉ¶§±îÁö ´ë±â
;	td -> Y+0
;     435 	UDR1=td;
;     436 }
;     437 
;     438 
;     439 //------------------------------------------------------------------------------
;     440 // ½Ã¸®¾ó Æ÷Æ®·Î ÇÑ ¹®ÀÚ¸¦ ¹ÞÀ»¶§±îÁö ´ë±âÇÏ±â À§ÇÑ ÇÔ¼ö
;     441 //------------------------------------------------------------------------------
;     442 BYTE sciRx0Ready(void)
;     443 {
;     444 	WORD	startT;
;     445 	startT = gMSEC;
;	startT -> R16,R17
;     446 	while(!(UCSR0A&(1<<RXC)) ){ 	// ÇÑ ¹®ÀÚ°¡ ¼ö½ÅµÉ¶§±îÁö ´ë±â
;     447         if(gMSEC<startT){
;     448 			// Å¸ÀÓ ¾Æ¿ô½Ã ·ÎÄÃ Å»Ãâ
;     449             if((1000 - startT + gMSEC)>RX_T_OUT) break;
;     450         }
;     451 		else if((gMSEC-startT)>RX_T_OUT) break;
;     452 	}
;     453 	return UDR0;
;     454 }
;     455 
;     456 BYTE sciRx1Ready(void)
;     457 {
;     458 	WORD	startT;
;     459 	startT = gMSEC;
;	startT -> R16,R17
;     460 	while(!(UCSR1A&(1<<RXC)) ){ 	// ÇÑ ¹®ÀÚ°¡ ¼ö½ÅµÉ¶§±îÁö ´ë±â
;     461         if(gMSEC<startT){
;     462 			// Å¸ÀÓ ¾Æ¿ô½Ã ·ÎÄÃ Å»Ãâ
;     463             if((1000 - startT + gMSEC)>RX_T_OUT) break;
;     464         }
;     465 		else if((gMSEC-startT)>RX_T_OUT) break;
;     466 	}
;     467 	return UDR1;
;     468 }
;     469 
;     470 
;     471 //------------------------------------------------------------------------------
;     472 // wCKÀÇ ÆÄ¶ó¹ÌÅÍ¸¦ ¼³Á¤ÇÒ ¶§ »ç¿ë
;     473 // Input	: Data1, Data2, Data3, Data4
;     474 // Output	: None
;     475 //------------------------------------------------------------------------------
;     476 void SendSetCmd(BYTE ID, BYTE Data1, BYTE Data2, BYTE Data3)
;     477 {
;     478 	BYTE CheckSum; 
;     479 	ID=(BYTE)(7<<5)|ID; 
;	ID -> Y+4
;	Data1 -> Y+3
;	Data2 -> Y+2
;	Data3 -> Y+1
;	CheckSum -> R16
;     480 	CheckSum = (ID^Data1^Data2^Data3)&0x7f;
;     481 
;     482 	gTx0Buf[gTx0Cnt]=HEADER;
;     483 	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
;     484 
;     485 	gTx0Buf[gTx0Cnt]=ID;
;     486 	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
;     487 
;     488 	gTx0Buf[gTx0Cnt]=Data1;
;     489 	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
;     490 
;     491 	gTx0Buf[gTx0Cnt]=Data2;
;     492 	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
;     493 
;     494 	gTx0Buf[gTx0Cnt]=Data3;
;     495 	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
;     496 
;     497 	gTx0Buf[gTx0Cnt]=CheckSum;
;     498 	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
;     499 }
;     500 
;     501 
;     502 //------------------------------------------------------------------------------
;     503 // µ¿±âÈ­ À§Ä¡ ¸í·É(Synchronized Position Send Command)À» º¸³»´Â ÇÔ¼ö
;     504 //------------------------------------------------------------------------------
;     505 void SyncPosSend(void) 
;     506 {
_SyncPosSend:
;     507 	int lwtmp;
;     508 	BYTE CheckSum; 
;     509 	BYTE i, tmp, Data;
;     510 
;     511 	Data = (Scene.wCK[0].Torq<<5) | 31;
	CALL __SAVELOCR6
;	lwtmp -> R16,R17
;	CheckSum -> R18
;	i -> R19
;	tmp -> R20
;	Data -> R21
	__GETB1MN _Scene,9
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	MOV  R21,R30
;     512 
;     513 	gTx0Buf[gTx0Cnt]=HEADER;
	CALL SUBOPT_0x4
	LDI  R30,LOW(255)
	ST   X,R30
;     514 	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
	INC  R11
;     515 
;     516 	gTx0Buf[gTx0Cnt]=Data;
	CALL SUBOPT_0x4
	ST   X,R21
;     517 	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
	INC  R11
;     518 
;     519 	gTx0Buf[gTx0Cnt]=16;
	CALL SUBOPT_0x4
	LDI  R30,LOW(16)
	ST   X,R30
;     520 	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
	INC  R11
;     521 
;     522 	CheckSum = 0;
	LDI  R18,LOW(0)
;     523 	for(i=0;i<MAX_wCK;i++){	// °¢ wCK µ¥ÀÌÅÍ ÁØºñ
	LDI  R19,LOW(0)
_0x2E:
	CPI  R19,31
	BRLO PC+3
	JMP _0x2F
;     524 		if(Scene.wCK[i].Exist){	// Á¸ÀçÇÏ´Â ID¸¸ ÁØºñ
	LDI  R30,LOW(5)
	MUL  R30,R19
	MOVW R30,R0
	__POINTW2MN _Scene,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BRNE PC+3
	JMP _0x30
;     525 			lwtmp = (int)Scene.wCK[i].SPos + (int)((float)gFrameIdx*gUnitD[i]);
	LDI  R30,LOW(5)
	MUL  R30,R19
	MOVW R30,R0
	__POINTW2MN _Scene,7
	ADD  R26,R30
	ADC  R27,R31
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
	MOV  R30,R19
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
	CALL __CFD1
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
;     526 			if(lwtmp>254)		lwtmp = 254;
	__CPWRN 16,17,255
	BRLT _0x31
	__GETWRN 16,17,254
;     527 			else if(lwtmp<1)	lwtmp = 1;
	RJMP _0x32
_0x31:
	__CPWRN 16,17,1
	BRGE _0x33
	__GETWRN 16,17,1
;     528 			tmp = (BYTE)lwtmp;
_0x33:
_0x32:
	MOV  R20,R16
;     529 			gTx0Buf[gTx0Cnt] = tmp;
	CALL SUBOPT_0x4
	ST   X,R20
;     530 			gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
	INC  R11
;     531 			CheckSum = CheckSum^tmp;
	EOR  R18,R20
;     532 		}
;     533 	}
_0x30:
	SUBI R19,-1
	RJMP _0x2E
_0x2F:
;     534 	CheckSum = CheckSum & 0x7f;
	ANDI R18,LOW(127)
;     535 
;     536 	gTx0Buf[gTx0Cnt]=CheckSum;
	CALL SUBOPT_0x4
	ST   X,R18
;     537 	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
	INC  R11
;     538 } 
	CALL __LOADLOCR6
	ADIW R28,6
	RET
;     539 
;     540 //------------------------------------------------------------------------------
;     541 // 8bit Command Position Move Function ö;     542 // Input	: torq ID, Position
;     543 // Output	: None
;     544 //------------------------------------------------------------------------------
;     545 void PositionMove(BYTE torq, BYTE ID, BYTE position)
;     546 {
_PositionMove:
;     547     BYTE CheckSum;
;     548     ID = (BYTE)(torq << 5) | ID;
	ST   -Y,R16
;	torq -> Y+3
;	ID -> Y+2
;	position -> Y+1
;	CheckSum -> R16
	LDD  R30,Y+3
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LDD  R26,Y+2
	OR   R30,R26
	STD  Y+2,R30
;     549     CheckSum = (ID ^ position) & 0x7f;
	LDD  R30,Y+1
	LDD  R26,Y+2
	EOR  R26,R30
	LDI  R30,LOW(127)
	AND  R30,R26
	MOV  R16,R30
;     550     
;     551     sciTx0Data(0xff);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _sciTx0Data
;     552 	sciTx0Data(ID);
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _sciTx0Data
;     553 	sciTx0Data(position);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _sciTx0Data
;     554 	sciTx0Data(CheckSum);
	ST   -Y,R16
	CALL _sciTx0Data
;     555 }                       
	LDD  R16,Y+0
	ADIW R28,4
	RET
;     556 
;     557 //------------------------------------------------------------------------------
;     558 // À§Ä¡ ÀÐ±â ¸í·É(Position Send Command)À» º¸³»´Â ÇÔ¼ö
;     559 // Input	: ID, SpeedLevel, Position
;     560 // Output	: Current
;     561 // UART0 RX ÀÎÅÍ·´Æ®, Timer0 ÀÎÅÍ·´Æ®°¡ È°¼ºÈ­ µÇ¾î ÀÖ¾î¾ß ÇÔ
;     562 //------------------------------------------------------------------------------
;     563 WORD PosRead(BYTE ID) 
;     564 {
;     565 	BYTE	Data1, Data2;
;     566 	BYTE	CheckSum, Load, Position; 
;     567 	WORD	startT;
;     568 
;     569 	Data1 = (5<<5) | ID;
;	ID -> Y+7
;	Data1 -> R16
;	Data2 -> R17
;	CheckSum -> R18
;	Load -> R19
;	Position -> R20
;	startT -> Y+5
;     570 	Data2 = 0;
;     571 	gRx0Cnt = 0;			// ¼ö½Å ¹ÙÀÌÆ® ¼ö ÃÊ±âÈ­
;     572 	CheckSum = (Data1^Data2)&0x7f;
;     573 	sciTx0Data(HEADER);
;     574 	sciTx0Data(Data1);
;     575 	sciTx0Data(Data2);
;     576 	sciTx0Data(CheckSum);
;     577 	startT = gMSEC;
;     578 	while(gRx0Cnt<2){
;     579         if(gMSEC<startT){ 	// ¹Ð¸®ÃÊ Ä«¿îÆ®°¡ ¸®¼ÂµÈ °æ¿ì
;     580             if((1000 - startT + gMSEC)>RX_T_OUT)
;     581             	return 444;	// Å¸ÀÓ¾Æ¿ô½Ã ·ÎÄÃ Å»Ãâ
;     582         }
;     583 		else if((gMSEC-startT)>RX_T_OUT) return 444;
;     584 	}
;     585 	return gRx0Buf[RX0_BUF_SIZE-1];
;     586 } 
;     587 
;     588 
;     589 //------------------------------------------------------------------------------
;     590 // Flash¿¡¼­ ¸ð¼Ç Á¤º¸ ÀÐ±â
;     591 //	MRIdx : ¸ð¼Ç »ó´ë ÀÎµ¦½º
;     592 //------------------------------------------------------------------------------
;     593 void GetMotionFromFlash(void)
;     594 {
;     595 	WORD i;
;     596 
;     597 	for(i=0;i<MAX_wCK;i++){				// wCK ÆÄ¶ó¹ÌÅÍ ±¸Á¶Ã¼ ÃÊ±âÈ­
;	i -> R16,R17
;     598 		Motion.wCK[i].Exist		= 0;
;     599 		Motion.wCK[i].RPgain	= 0;
;     600 		Motion.wCK[i].RDgain	= 0;
;     601 		Motion.wCK[i].RIgain	= 0;
;     602 		Motion.wCK[i].PortEn	= 0;
;     603 		Motion.wCK[i].InitPos	= 0;
;     604 	}
;     605 	for(i=0;i<Motion.NumOfwCK;i++){		// °¢ wCK ÆÄ¶ó¹ÌÅÍ ºÒ·¯¿À±â
;     606 		Motion.wCK[wCK_IDs[i]].Exist		= 1;
;     607 		Motion.wCK[wCK_IDs[i]].RPgain	= *(gpPg_Table+i);
;     608 		Motion.wCK[wCK_IDs[i]].RDgain	= *(gpDg_Table+i);
;     609 		Motion.wCK[wCK_IDs[i]].RIgain	= *(gpIg_Table+i);
;     610 		Motion.wCK[wCK_IDs[i]].PortEn	= 1;
;     611 		Motion.wCK[wCK_IDs[i]].InitPos	= MotionZeroPos[i];
;     612 	}
;     613 }
;     614 
;     615 
;     616 //------------------------------------------------------------------------------
;     617 // Runtime P,D,I ÀÌµæ ¼Û½Å
;     618 // 		: ¸ð¼ÇÁ¤º¸¿¡¼­ Runtime P,D,IÀÌµæÀ» ºÒ·¯¿Í¼­ wCK¿¡°Ô º¸³½´Ù
;     619 //------------------------------------------------------------------------------
;     620 void SendTGain(void)
;     621 {
;     622 	WORD i;
;     623 
;     624 	UCSR0B &= 0x7F;   		// UART0 RxÀÎÅÍ·´Æ® ¹Ì»ç¿ë
;	i -> R16,R17
;     625 	UCSR0B |= 0x40;   		// UART0 TxÀÎÅÍ·´Æ® »ç¿ë
;     626 
;     627 	while(gTx0Cnt);			// ÀÌÀü ÆÐÅ¶ ¼Û½ÅÀÌ ³¡³¯ ¶§±îÁö ´ë±â
;     628 	for(i=0;i<MAX_wCK;i++){					// Runtime P,DÀÌµæ ¼³Á¤ ÆÐÅ¶ ÁØºñ
;     629 		if(Motion.wCK[i].Exist)				// Á¸ÀçÇÏ´Â ID¸¸ ÁØºñ
;     630 			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
;     631 	}
;     632 	gTx0BufIdx++;
;     633 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// Ã¹¹ÙÀÌÆ® ¼Û½Å ½ÃÀÛ
;     634 
;     635 
;     636 	while(gTx0Cnt);			// ÀÌÀü ÆÐÅ¶ ¼Û½ÅÀÌ ³¡³¯ ¶§±îÁö ´ë±â
;     637 	for(i=0;i<MAX_wCK;i++){					// Runtime IÀÌµæ ¼³Á¤ ÆÐÅ¶ ÁØºñ
;     638 		if(Motion.wCK[i].Exist)				// Á¸ÀçÇÏ´Â ID¸¸ ÁØºñ
;     639 			SendSetCmd(i, 24, Motion.wCK[i].RIgain, Motion.wCK[i].RIgain);
;     640 	}
;     641 	gTx0BufIdx++;
;     642 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// Ã¹¹ÙÀÌÆ® ¼Û½Å ½ÃÀÛ
;     643 }
;     644 
;     645 
;     646 //------------------------------------------------------------------------------
;     647 // È®Àå Æ÷Æ®°ª ¼Û½Å
;     648 // 		: ¾À Á¤º¸¿¡¼­ È®Àå Æ÷Æ®°ªÀ» ºÒ·¯¿Í¼­ wCK¿¡°Ô º¸³½´Ù
;     649 //------------------------------------------------------------------------------
;     650 void SendExPortD(void)
;     651 {
;     652 	WORD i;
;     653 
;     654 	UCSR0B &= 0x7F;   		// UART0 RxÀÎÅÍ·´Æ® ¹Ì»ç¿ë
;	i -> R16,R17
;     655 	UCSR0B |= 0x40;   		// UART0 TxÀÎÅÍ·´Æ® »ç¿ë
;     656 
;     657 	while(gTx0Cnt);			// ÀÌÀü ÆÐÅ¶ ¼Û½ÅÀÌ ³¡³¯ ¶§±îÁö ´ë±â
;     658 	for(i=0;i<MAX_wCK;i++){					// Runtime P,DÀÌµæ ¼³Á¤ ÆÐÅ¶ ÁØºñ
;     659 		if(Scene.wCK[i].Exist)				// Á¸ÀçÇÏ´Â ID¸¸ ÁØºñ
;     660 			SendSetCmd(i, 100, Scene.wCK[i].ExPortD, Scene.wCK[i].ExPortD);
;     661 	}
;     662 	gTx0BufIdx++;
;     663 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// Ã¹¹ÙÀÌÆ® ¼Û½Å ½ÃÀÛ
;     664 }
;     665 
;     666 
;     667 //------------------------------------------------------------------------------
;     668 // Flash¿¡¼­ ¾À Á¤º¸ ÀÐ±â
;     669 //	ScIdx : ¾À ÀÎµ¦½º
;     670 //------------------------------------------------------------------------------
;     671 void GetSceneFromFlash(void)
;     672 {
;     673 	WORD i;
;     674 	
;     675 	Scene.NumOfFrame = gpFN_Table[gSIdx];	// ÇÁ·¹ÀÓ¼ö
;	i -> R16,R17
;     676 	Scene.RTime = gpRT_Table[gSIdx];		// ¾À ¼öÇà ½Ã°£[msec]
;     677 	for(i=0;i<Motion.NumOfwCK;i++){			// °¢ wCK µ¥ÀÌÅÍ ÃÊ±âÈ­
;     678 		Scene.wCK[i].Exist		= 0;
;     679 		Scene.wCK[i].SPos		= 0;
;     680 		Scene.wCK[i].DPos		= 0;
;     681 		Scene.wCK[i].Torq		= 0;
;     682 		Scene.wCK[i].ExPortD	= 0;
;     683 	}
;     684 	for(i=0;i<Motion.NumOfwCK;i++){			// °¢ wCK µ¥ÀÌÅÍ ÀúÀå
;     685 		Scene.wCK[wCK_IDs[i]].Exist		= 1;
;     686 		Scene.wCK[wCK_IDs[i]].SPos		= gpPos_Table[Motion.NumOfwCK*gSIdx+i];
;     687 		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[Motion.NumOfwCK*(gSIdx+1)+i];
;     688 		Scene.wCK[wCK_IDs[i]].Torq		= gpT_Table[Motion.NumOfwCK*gSIdx+i];
;     689 		Scene.wCK[wCK_IDs[i]].ExPortD	= gpE_Table[Motion.NumOfwCK*gSIdx+i];
;     690 	}
;     691 	UCSR0B &= 0x7F;   		// UART0 RxÀÎÅÍ·´Æ® ¹Ì»ç¿ë
;     692 	UCSR0B |= 0x40;   		// UART0 TxÀÎÅÍ·´Æ® »ç¿ë
;     693 
;     694 	delay_us(1300);
;     695 }
;     696 
;     697 
;     698 //------------------------------------------------------------------------------
;     699 // ÇÁ·¹ÀÓ ¼Û½Å °£°Ý °è»ê
;     700 // 		: ¾À ¼öÇà ½Ã°£À» ÇÁ·¹ÀÓ¼ö·Î ³ª´²¼­ intervalÀ» Á¤ÇÑ´Ù
;     701 //------------------------------------------------------------------------------
;     702 void CalcFrameInterval(void)
;     703 {
;     704 	float tmp;
;     705 	if((Scene.RTime / Scene.NumOfFrame)<20){
;	tmp -> Y+0
;     706 		return;
;     707 	}
;     708 	tmp = (float)Scene.RTime * 14.4;
;     709 	tmp = tmp  / (float)Scene.NumOfFrame;
;     710 	TxInterval = 65535 - (WORD)tmp - 43;
;     711 
;     712 	RUN_LED1_ON;
;     713 	F_PLAYING=1;		// ¸ð¼Ç ½ÇÇàÁß Ç¥½Ã
;     714 	TCCR1B=0x05;
;     715 
;     716 	if(TxInterval<=65509)	
;     717 		TCNT1=TxInterval+26;
;     718 	else
;     719 		TCNT1=65535;
;     720 
;     721 	TIFR |= 0x04;		// Å¸ÀÌ¸Ó ÀÎÅÍ·´Æ® ÇÃ·¡±× ÃÊ±âÈ­
;     722 	TIMSK |= 0x04;		// Timer1 Overflow Interrupt È°¼ºÈ­(140ÂÊ)
;     723 }
;     724 
;     725 
;     726 //------------------------------------------------------------------------------
;     727 // ÇÁ·¹ÀÓ´ç ´ÜÀ§ ÀÌµ¿·® °è»ê
;     728 //------------------------------------------------------------------------------
;     729 void CalcUnitMove(void)
;     730 {
;     731 	WORD i;
;     732 
;     733 	for(i=0;i<MAX_wCK;i++){
;	i -> R16,R17
;     734 		if(Scene.wCK[i].Exist){	// Á¸ÀçÇÏ´Â ID¸¸ ÁØºñ
;     735 			if(Scene.wCK[i].SPos!=Scene.wCK[i].DPos){
;     736 				// ÇÁ·¹ÀÓ´ç ´ÜÀ§ º¯À§ Áõ°¡·® °è»ê
;     737 				gUnitD[i] = (float)((int)Scene.wCK[i].DPos-(int)Scene.wCK[i].SPos);
;     738 				gUnitD[i] = (float)(gUnitD[i]/Scene.NumOfFrame);
;     739 				if(gUnitD[i]>253)	gUnitD[i]=254;
;     740 				else if(gUnitD[i]<-253)	gUnitD[i]=-254;
;     741 			}
;     742 			else
;     743 				gUnitD[i] = 0;
;     744 		}
;     745 	}
;     746 	gFrameIdx=0;				// ÇÁ·¹ÀÓ ÀÎµ¦½º ÃÊ±âÈ­
;     747 }
;     748 
;     749 
;     750 //------------------------------------------------------------------------------
;     751 // ÇÑ ÇÁ·¹ÀÓ ¼Û½Å ÁØºñ
;     752 //------------------------------------------------------------------------------
;     753 void MakeFrame(void)
;     754 {
_MakeFrame:
;     755 	while(gTx0Cnt);			// ÀÌÀü ÇÁ·¹ÀÓ ¼Û½ÅÀÌ ³¡³¯ ¶§±îÁö ´ë±â
_0x68:
	TST  R11
	BRNE _0x68
;     756 	gFrameIdx++;			// ÇÁ·¹ÀÓ ÀÎµ¦½º Áõ°¡
	LDS  R30,_gFrameIdx
	LDS  R31,_gFrameIdx+1
	ADIW R30,1
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R31
;     757 	SyncPosSend();			// µ¿±âÈ­ À§Ä¡ ¸í·ÉÀ¸·Î ¼Û½Å
	CALL _SyncPosSend
;     758 }
	RET
;     759 
;     760 
;     761 //------------------------------------------------------------------------------
;     762 // ÇÑ ÇÁ·¹ÀÓ ¼Û½Å
;     763 //------------------------------------------------------------------------------
;     764 void SendFrame(void)
;     765 {
_SendFrame:
;     766 	if(gTx0Cnt==0)	return;	// º¸³¾ µ¥ÀÌÅÍ°¡ ¾øÀ¸¸é ½ÇÇà ¾ÈÇÔ
	TST  R11
	BRNE _0x6B
	RET
;     767 	gTx0BufIdx++;
_0x6B:
	INC  R13
;     768 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// Ã¹¹ÙÀÌÆ® ¼Û½Å ½ÃÀÛ
	MOV  R30,R13
	SUBI R30,LOW(1)
	CALL SUBOPT_0x0
	ST   -Y,R30
	CALL _sciTx0Data
;     769 }
	RET
;     770 
;     771 
;     772 //------------------------------------------------------------------------------
;     773 // 
;     774 //------------------------------------------------------------------------------
;     775 void M_PlayFlash(void)
;     776 {
;     777 	float tmp;
;     778 	WORD i;
;     779 
;     780 	GetMotionFromFlash();		// °¢ wCK ÆÄ¶ó¹ÌÅÍ ºÒ·¯¿À±â
;	tmp -> Y+2
;	i -> R16,R17
;     781 	SendTGain();				// RuntimeÀÌµæ ¼Û½Å
;     782 	for(i=0;i<Motion.NumOfScene;i++){
;     783 		gSIdx = i;
;     784 		GetSceneFromFlash();	// ÇÑ ¾ÀÀ» ºÒ·¯¿Â´Ù
;     785 		SendExPortD();			// È®Àå Æ÷Æ®°ª ¼Û½Å
;     786 		CalcFrameInterval();	// ÇÁ·¹ÀÓ ¼Û½Å °£°Ý °è»ê, Å¸ÀÌ¸Ó1 ½ÃÀÛ
;     787 		CalcUnitMove();			// ÇÁ·¹ÀÓ´ç ´ÜÀ§ ÀÌµ¿·® °è»ê
;     788 		MakeFrame();			// ÇÑ ÇÁ·¹ÀÓ ÁØºñ
;     789 		SendFrame();			// ÇÑ ÇÁ·¹ÀÓ ¼Û½Å
;     790 		while(F_PLAYING);
;     791 	}
;     792 }
;     793 
;     794 
;     795 void SampleMotion1(void)	// »ùÇÃ ¸ð¼Ç 1
;     796 {
;     797 	gpT_Table			= M_EX1_Torque;
;     798 	gpE_Table			= M_EX1_Port;
;     799 	gpPg_Table 			= M_EX1_RuntimePGain;
;     800 	gpDg_Table 			= M_EX1_RuntimeDGain;
;     801 	gpIg_Table 			= M_EX1_RuntimeIGain;
;     802 	gpFN_Table			= M_EX1_Frames;
;     803 	gpRT_Table			= M_EX1_TrTime;
;     804 	gpPos_Table			= M_EX1_Position;
;     805 	Motion.NumOfScene 	= M_EX1_NUM_OF_SCENES;
;     806 	Motion.NumOfwCK 	= M_EX1_NUM_OF_WCKS;
;     807 	M_PlayFlash();
;     808 }
;     809 //==============================================================================
;     810 //						Digital Input Output °ü·Ã ÇÔ¼öµé
;     811 //==============================================================================
;     812 
;     813 #include <mega128.h>
;     814 #include "Main.h"
;     815 #include "Macro.h"
;     816 #include "DIO.h"
;     817 
;     818 
;     819 //------------------------------------------------------------------------------
;     820 // ¹öÆ° ÀÐ±â
;     821 //------------------------------------------------------------------------------
;     822 void ReadButton(void)
;     823 {
;     824 	int		i;
;     825 	BYTE	lbtmp;
;     826 
;     827 	lbtmp = PINA & 0x03;
;	i -> R16,R17
;	lbtmp -> R18
;     828 	if((lbtmp!=0x03)){
;     829 		if(++gBtnCnt>100){   // ´­·¯¼­ 0.1ÃÊ ÀÌ»ó À¯ÁöµÇ¸é ÀÔ·Â ÀÎÁ¤
;     830 			if(lbtmp==0x02){	// PF1 ¹öÆ° ´­·¯Á³À¸¸é »ùÇÃ ¸ð¼Ç ½ÇÇà
;     831 				SampleMotion1();
;     832 			}
;     833 		}
;     834 	}
;     835 	else{
;     836 	    gBtnCnt=0;
;     837     }
;     838 } 
;     839 
;     840 
;     841 //------------------------------------------------------------------------------
;     842 // Io ¾÷µ¥ÀÌÆ® Ã³¸®
;     843 //------------------------------------------------------------------------------
;     844 void IoUpdate(void)
;     845 {
;     846 	// ¸ðµå Ç¥½Ã LED Ã³¸®
;     847 	if(F_DIRECT_C_EN){		// Á÷Á¢ Á¦¾î ¸ðµåÀÌ¸é
;     848 		PF1_LED1_ON;
;     849 		PF1_LED2_OFF;
;     850 		PF2_LED_ON;
;     851 		return;
;     852 	}
;     853 }

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
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

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
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

__SAVELOCR6:
	ST   -Y,R21
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

__LOADLOCR6:
	LDD  R21,Y+5
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

;END OF CODE MARKER
__END_OF_CODE:
