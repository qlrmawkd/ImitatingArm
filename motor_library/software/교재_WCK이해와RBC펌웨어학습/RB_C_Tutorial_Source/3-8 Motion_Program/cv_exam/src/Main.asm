
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
;       4 // ※ 본 소스코드는 Tab Size = 4를 기준으로 편집되었습니다
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
;      18 // 플래그----------------------------------------------------------------------
;      19 bit 	F_PLAYING;				// 모션 실행중 표시
;      20 bit 	F_DIRECT_C_EN;			// wCK 직접제어 가능유무(1:가능, 0:불가)
;      21 
;      22 // 버튼 입력 처리용------------------------------------------------------------
;      23 WORD    gBtnCnt;				// 버튼 눌림 처리용 카운터
;      24 
;      25 // 시간 측정용-----------------------------------------------------------------
;      26 WORD    gMSEC;
;      27 BYTE    gSEC;
;      28 BYTE    gMIN;
;      29 BYTE    gHOUR;
;      30 
;      31 // UART 통신용-----------------------------------------------------------------
;      32 char	gTx0Buf[TX0_BUF_SIZE];		// UART0 송신 버퍼
_gTx0Buf:
	.BYTE 0xBA
;      33 BYTE	gTx0Cnt;					// UART0 송신 대기 바이트 수
;      34 BYTE	gRx0Cnt;					// UART0 수신 바이트 수
;      35 BYTE	gTx0BufIdx;					// UART0 송신 버퍼 인덱스
;      36 char	gRx0Buf[RX0_BUF_SIZE];		// UART0 수신 버퍼
_gRx0Buf:
	.BYTE 0x8
;      37 BYTE	gOldRx1Byte;				// UART1 최근 수신 바이트
;      38 char	gRx1Buf[RX1_BUF_SIZE];		// UART1 수신 버퍼
_gRx1Buf:
	.BYTE 0x14
;      39 BYTE	gRx1Index;					// UART1 수신 버퍼용 인덱스
_gRx1Index:
	.BYTE 0x1
;      40 WORD	gRx1Step;					// UART1 수신 패킷 단계 구분
_gRx1Step:
	.BYTE 0x2
;      41 WORD	gRx1_DStep;					// 직접제어 모드에서 UART1 수신 패킷 단계 구분
_gRx1_DStep:
	.BYTE 0x2
;      42 WORD	gFieldIdx;					// 필드의 바이트 인덱스
_gFieldIdx:
	.BYTE 0x2
;      43 WORD	gFileByteIndex;				// 파일의 바이트 인덱스
_gFileByteIndex:
	.BYTE 0x2
;      44 BYTE	gFileCheckSum;				// 파일내용 CheckSum
_gFileCheckSum:
	.BYTE 0x1
;      45 BYTE	gRxData;					// 수신데이터 저장
_gRxData:
	.BYTE 0x1
;      46 
;      47 // 모션 제어용-----------------------------------------------------------------
;      48 int		gFrameIdx=0;	    // 모션테이블의 프레임 인덱스
_gFrameIdx:
	.BYTE 0x2
;      49 WORD	TxInterval=0;		// 프레임 송신 간격
_TxInterval:
	.BYTE 0x2
;      50 float	gUnitD[MAX_wCK];	// 단위 증가 변위
_gUnitD:
	.BYTE 0x7C
;      51 BYTE flash	*gpT_Table;		// 모션 토크모드 테이블 포인터
_gpT_Table:
	.BYTE 0x2
;      52 BYTE flash	*gpE_Table;		// 모션 확장포트값 테이블 포인터
_gpE_Table:
	.BYTE 0x2
;      53 BYTE flash	*gpPg_Table;	// 모션 Runtime P이득 테이블 포인터
_gpPg_Table:
	.BYTE 0x2
;      54 BYTE flash	*gpDg_Table;	// 모션 Runtime D이득 테이블 포인터
_gpDg_Table:
	.BYTE 0x2
;      55 BYTE flash	*gpIg_Table;	// 모션 Runtime I이득 테이블 포인터
_gpIg_Table:
	.BYTE 0x2
;      56 WORD flash	*gpFN_Table;	// 씬 프레임 수 테이블 포인터
_gpFN_Table:
	.BYTE 0x2
;      57 WORD flash	*gpRT_Table;	// 씬 실행시간 테이블 포인터
_gpRT_Table:
	.BYTE 0x2
;      58 BYTE flash	*gpPos_Table;	// 모션 위치값 테이블 포인터
_gpPos_Table:
	.BYTE 0x2
;      59 
;      60 // 액션 파일의 구성 체계
;      61 //      - 크기 : wCK < Frame < Scene < Motion < Action
;      62 //      - 여러개의 wCK가 모여 Frame을 이루고
;      63 //        여러개의 Frame 이 모여 Scene을 이루며
;      64 //        여러개의 Scene 이 모여 Motion을 이루고
;      65 //        여러개의 Motion 이 모여 Action을 이룬다
;      66 
;      67 struct TwCK_in_Motion{  // 한 개 모션에서 사용하는 wCK 정보
;      68 	BYTE	Exist;			// wCK 유무
;      69 	BYTE	RPgain;			// Runtime P이득
;      70 	BYTE	RDgain;			// Runtime D이득
;      71 	BYTE	RIgain;			// Runtime I이득
;      72 	BYTE	PortEn;			// 확장포트 사용유무(0:사용안함, 1:사용함)
;      73 	BYTE	InitPos;		// 모션파일을 만들 때 사용된 로봇의 영점 위치정보
;      74 };
;      75 
;      76 struct TwCK_in_Scene{	// 한 개 씬에서 사용하는 wCK 정보
;      77 	BYTE	Exist;			// wCK 유무
;      78 	BYTE	SPos;			// 첫 프레임의 wCK 위치
;      79 	BYTE	DPos;			// 끝 프레임의 wCK 위치
;      80 	BYTE	Torq;			// 토크
;      81 	BYTE	ExPortD;		// 확장포트 출력 데이터(1~3)
;      82 };
;      83 
;      84 struct TMotion{			// 한 개 모션에서 사용하는 정보들
;      85 	BYTE	PF;				// 모션에 맞는 플랫폼
;      86 	BYTE	RIdx;			// 모션의 상대 인덱스
;      87 	DWORD	AIdx;			// 모션의 절대 인덱스
;      88 	WORD	NumOfScene;		// 씬 수
;      89 	WORD	NumOfwCK;		// wCK 수
;      90 	struct	TwCK_in_Motion  wCK[MAX_wCK];	// wCK 파라미터
;      91 	WORD	FileSize;		// 파일 크기
;      92 }Motion;
_Motion:
	.BYTE 0xC6
;      93 
;      94 struct TScene{			// 한 개 씬에서 사용하는 정보들
;      95 	WORD	Idx;			// 씬 인덱스(0~65535)
;      96 	WORD	NumOfFrame;		// 프레임 수
;      97 	WORD	RTime;			// 씬 수행 시간[msec]
;      98 	struct	TwCK_in_Scene   wCK[MAX_wCK];	// wCK 데이터
;      99 }Scene;
_Scene:
	.BYTE 0xA1
;     100 
;     101 WORD	gSIdx;			// 씬 인덱스(0~65535)
_gSIdx:
	.BYTE 0x2
;     102 
;     103 //------------------------------------------------------------------------------
;     104 // UART0 송신 인터럽트(패킷 송신용)
;     105 //------------------------------------------------------------------------------
;     106 interrupt [USART0_TXC] void usart0_tx_isr(void) {

	.CSEG
_usart0_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     107 	if(gTx0BufIdx<gTx0Cnt){			// 보낼 데이터가 남아있으면
	CP   R13,R11
	BRSH _0x3
;     108     	while(!(UCSR0A&(1<<UDRE))); 	// 이전 바이트 전송이 완료될때까지 대기
_0x4:
	SBIS 0xB,5
	RJMP _0x4
;     109 		UDR0=gTx0Buf[gTx0BufIdx];		// 1바이트 송신
	MOV  R30,R13
	CALL SUBOPT_0x0
	LD   R30,Z
	OUT  0xC,R30
;     110     	gTx0BufIdx++;      				// 버퍼 인덱스 증가
	INC  R13
;     111 	}
;     112 	else if(gTx0BufIdx==gTx0Cnt){	// 송신 완료
	RJMP _0x7
_0x3:
	CP   R11,R13
	BRNE _0x8
;     113 		gTx0BufIdx = 0;					// 버퍼 인덱스 초기화
	CLR  R13
;     114 		gTx0Cnt = 0;					// 송신 대기 바이트수 초기화
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
;     120 // UART0 수신 인터럽트(wCK, 사운드모듈에서 받은 신호)
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
;     128     // 수신데이터를 FIFO에 저장
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
;     135 // 타이머0 오버플로 인터럽트 (시간 측정용 0.998ms 간격)
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
;     139 	// 1ms 마다 실행
;     140     if(++gMSEC>999){
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRLO _0xC
;     141 		// 1s 마다 실행
;     142         gMSEC=0;
	CLR  R6
	CLR  R7
;     143         if(++gSEC>59){
	INC  R8
	LDI  R30,LOW(59)
	CP   R30,R8
	BRSH _0xD
;     144 			// 1m 마다 실행
;     145             gSEC=0;
	CLR  R8
;     146             if(++gMIN>59){
	INC  R9
	CP   R30,R9
	BRSH _0xE
;     147 				// 1h 마다 실행
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
;     158 // 타이머1 오버플로 인터럽트 (프레임 송신)
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
;     161 	if( gFrameIdx == Scene.NumOfFrame ) {   // 마지막 프레임이었으면
	CALL SUBOPT_0x1
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
;     164 		F_PLAYING=0;		// 모션 실행중 표시해제
	CLT
	BLD  R2,0
;     165 		TIMSK &= 0xfb;  	// Timer1 Overflow Interrupt 해제
	IN   R30,0x37
	ANDI R30,0xFB
	OUT  0x37,R30
;     166 		TCCR1B=0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
;     167 		return;
	CALL SUBOPT_0x2
	RETI
;     168 	}
;     169 	TCNT1=TxInterval;
_0x10:
	LDS  R30,_TxInterval
	LDS  R31,_TxInterval+1
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;     170 	TIFR |= 0x04;		// 타이머 인터럽트 플래그 초기화
	CALL SUBOPT_0x3
;     171 	TIMSK |= 0x04;		// Timer1 Overflow Interrupt 활성화(140쪽)
;     172 	MakeFrame();		// 한 프레임 준비
	RCALL _MakeFrame
;     173 	SendFrame();		// 한 프레임 송신
	RCALL _SendFrame
;     174 }
	CALL SUBOPT_0x2
	RETI
;     175 
;     176 
;     177 //------------------------------------------------------------------------------
;     178 // 하드웨어 초기화
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
;     203 	PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
;     204 	DDRD=0x00;
	LDI  R30,LOW(0)
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
;     224 	// 타이머 0---------------------------------------------------------------
;     225 	// : 범용 시간 측정용으로 사용(ms 단위)
;     226 	// Timer/Counter 0 initialization
;     227 	// Clock source: System Clock
;     228 	// Clock value: 230.400 kHz
;     229 	// Clock 증가 주기 = 1/230400 = 4.34us
;     230 	// Overflow 시간 = 255*1/230400 = 1.107ms
;     231 	// 1ms 주기 overflow를 위한 카운트 시작값 =  255-230 = 25
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
;     239 	// 타이머 1---------------------------------------------------------------
;     240 	// : 모션 플레이시 프레임 송신 간격 조절용으로 사용
;     241 	// Timer/Counter 1 initialization
;     242 	// Clock source: System Clock
;     243 	// Clock value: 14.400 kHz
;     244 	// Clock 증가 주기 = 1/14400 = 69.4us
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
;     269 	// 타이머 2---------------------------------------------------------------
;     270 	// Timer/Counter 2 initialization
;     271 	// Clock source: System Clock
;     272 	// Clock value: 14.400 kHz
;     273 	// Clock 증가 주기 = 1/14400 = 69.4us
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
;     280 	// 타이머 3---------------------------------------------------------------
;     281 	// : 가속도 센서 신호 분석용으로 사용
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
;     331 	UCSR1B=0x18;		// 수신인터럽트 사용안함
	LDI  R30,LOW(24)
	STS  154,R30
;     332 	UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;     333 	UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
;     334 	UBRR1L=BR115200;	// UART1 의 BAUD RATE를 115200로 설정
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
;     341 // 플래그 초기화
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
;     352 	F_PLAYING = 0;          // 동작중 아님
	CLT
	BLD  R2,0
;     353 
;     354 	gTx0Cnt = 0;			// UART0 송신 대기 바이트 수
	CLR  R11
;     355 	gTx0BufIdx = 0;			// TX0 버퍼 인덱스 초기화
	CLR  R13
;     356 	PSD_OFF;                // PSD 거리센서 전원 OFF
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
;     368 	// PF2 버튼이 눌러졌으면 wCK 직접제어 모드로 진입
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
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     371 		if(PINA.0==1){
	SBIS 0x19,0
	RJMP _0x14
;     372 		    TIMSK &= 0xFE;     // Timer0 Overflow Interrupt 미사용
	IN   R30,0x37
	ANDI R30,0xFE
	OUT  0x37,R30
;     373 			EIMSK &= 0xBF;		// EXT6(리모컨 수신) 인터럽트 미사용
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;     374 			UCSR0B |= 0x80;   	// UART0 Rx인터럽트 사용
	SBI  0xA,7
;     375 			UCSR0B &= 0xBF;   	// UART0 Tx인터럽트 미사용
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
;     381 // 메인 함수
;     382 //------------------------------------------------------------------------------
;     383 void main(void) {
_main:
;     384 	WORD    i, lMSEC;
;     385 
;     386 	HW_init();			// 하드웨어 초기화
;	i -> R16,R17
;	lMSEC -> R18,R19
	CALL _HW_init
;     387 	SW_init();			// 변수 초기화
	CALL _SW_init
;     388 
;     389 	#asm("sei");
	sei
;     390 	TIMSK |= 0x01;		// Timer0 Overflow Interrupt 활성화
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
;     391 
;     392 	SpecialMode();
	CALL _SpecialMode
;     393     
;     394 	SendSetCmd(1, ID_SET, 10, 10);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _SendSetCmd
;     395 	
;     396 	while(1){
_0x15:
;     397 		
;     398 		lMSEC = gMSEC;
	MOVW R18,R6
;     399 		ReadButton();	    // 버튼 읽기
	RCALL _ReadButton
;     400 		IoUpdate();		    // IO 상태 UPDATE
	RCALL _IoUpdate
;     401 		while(lMSEC==gMSEC);
_0x18:
	__CPWRR 6,7,18,19
	BREQ _0x18
;     402 		
;     403     }
	RJMP _0x15
;     404 }
_0x1B:
	RJMP _0x1B
;     405 //==============================================================================
;     406 //						Communication & Command 함수들
;     407 //==============================================================================
;     408 
;     409 #include <mega128.h>
;     410 #include <string.h>
;     411 #include "Main.h"
;     412 #include "Macro.h"
;     413 #include "Comm.h"
;     414 #include "p_ex1.h"
;     415 
;     416 //------------------------------------------------------------------------------
;     417 // 시리얼 포트로 한 문자를 전송하기 위한 함수
;     418 //------------------------------------------------------------------------------
;     419 void sciTx0Data(BYTE td)
;     420 {
_sciTx0Data:
;     421 	while(!(UCSR0A&(1<<UDRE))); 	// 이전의 전송이 완료될때까지 대기
;	td -> Y+0
_0x1C:
	SBIS 0xB,5
	RJMP _0x1C
;     422 	UDR0=td;
	LD   R30,Y
	OUT  0xC,R30
;     423 }
	ADIW R28,1
	RET
;     424 
;     425 void sciTx1Data(BYTE td)
;     426 {
;     427 	while(!(UCSR1A&(1<<UDRE))); 	// 이전의 전송이 완료될때까지 대기
;	td -> Y+0
;     428 	UDR1=td;
;     429 }
;     430 
;     431 
;     432 //------------------------------------------------------------------------------
;     433 // 시리얼 포트로 한 문자를 받을때까지 대기하기 위한 함수
;     434 //------------------------------------------------------------------------------
;     435 BYTE sciRx0Ready(void)
;     436 {
;     437 	WORD	startT;
;     438 	startT = gMSEC;
;	startT -> R16,R17
;     439 	while(!(UCSR0A&(1<<RXC)) ){ 	// 한 문자가 수신될때까지 대기
;     440         if(gMSEC<startT){
;     441 			// 타임 아웃시 로컬 탈출
;     442             if((1000 - startT + gMSEC)>RX_T_OUT) break;
;     443         }
;     444 		else if((gMSEC-startT)>RX_T_OUT) break;
;     445 	}
;     446 	return UDR0;
;     447 }
;     448 
;     449 BYTE sciRx1Ready(void)
;     450 {
;     451 	WORD	startT;
;     452 	startT = gMSEC;
;	startT -> R16,R17
;     453 	while(!(UCSR1A&(1<<RXC)) ){ 	// 한 문자가 수신될때까지 대기
;     454         if(gMSEC<startT){
;     455 			// 타임 아웃시 로컬 탈출
;     456             if((1000 - startT + gMSEC)>RX_T_OUT) break;
;     457         }
;     458 		else if((gMSEC-startT)>RX_T_OUT) break;
;     459 	}
;     460 	return UDR1;
;     461 }
;     462 
;     463 
;     464 //------------------------------------------------------------------------------
;     465 // wCK의 파라미터를 설정할 때 사용
;     466 // Input	: Data1, Data2, Data3, Data4
;     467 // Output	: None
;     468 //------------------------------------------------------------------------------
;     469 void SendSetCmd(BYTE ID, BYTE Data1, BYTE Data2, BYTE Data3)
;     470 {
_SendSetCmd:
;     471 	BYTE CheckSum; 
;     472 	ID=(BYTE)(7<<5)|ID; 
	ST   -Y,R16
;	ID -> Y+4
;	Data1 -> Y+3
;	Data2 -> Y+2
;	Data3 -> Y+1
;	CheckSum -> R16
	LDD  R30,Y+4
	ORI  R30,LOW(0xE0)
	STD  Y+4,R30
;     473 	CheckSum = (ID^Data1^Data2^Data3)&0x7f;
	LDD  R30,Y+3
	LDD  R26,Y+4
	EOR  R30,R26
	LDD  R26,Y+2
	EOR  R30,R26
	LDD  R26,Y+1
	EOR  R26,R30
	LDI  R30,LOW(127)
	AND  R30,R26
	MOV  R16,R30
;     474 
;     475 	gTx0Buf[gTx0Cnt]=HEADER;
	CALL SUBOPT_0x4
	LDI  R30,LOW(255)
	ST   X,R30
;     476 	gTx0Cnt++;			// 송신할 바이트수 증가
	CALL SUBOPT_0x5
;     477 
;     478 	gTx0Buf[gTx0Cnt]=ID;
	LDD  R26,Y+4
	STD  Z+0,R26
;     479 	gTx0Cnt++;			// 송신할 바이트수 증가
	CALL SUBOPT_0x5
;     480 
;     481 	gTx0Buf[gTx0Cnt]=Data1;
	LDD  R26,Y+3
	STD  Z+0,R26
;     482 	gTx0Cnt++;			// 송신할 바이트수 증가
	CALL SUBOPT_0x5
;     483 
;     484 	gTx0Buf[gTx0Cnt]=Data2;
	LDD  R26,Y+2
	STD  Z+0,R26
;     485 	gTx0Cnt++;			// 송신할 바이트수 증가
	CALL SUBOPT_0x5
;     486 
;     487 	gTx0Buf[gTx0Cnt]=Data3;
	LDD  R26,Y+1
	STD  Z+0,R26
;     488 	gTx0Cnt++;			// 송신할 바이트수 증가
	INC  R11
;     489 
;     490 	gTx0Buf[gTx0Cnt]=CheckSum;
	CALL SUBOPT_0x4
	ST   X,R16
;     491 	gTx0Cnt++;			// 송신할 바이트수 증가
	INC  R11
;     492 }
	LDD  R16,Y+0
	ADIW R28,5
	RET
;     493 
;     494 
;     495 //------------------------------------------------------------------------------
;     496 // 동기화 위치 명령(Synchronized Position Send Command)을 보내는 함수
;     497 //------------------------------------------------------------------------------
;     498 void SyncPosSend(void) 
;     499 {
_SyncPosSend:
;     500 	int lwtmp;
;     501 	BYTE CheckSum; 
;     502 	BYTE i, tmp, Data;
;     503 
;     504 	Data = (Scene.wCK[0].Torq<<5) | 31;
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
;     505 
;     506 	gTx0Buf[gTx0Cnt]=HEADER;
	CALL SUBOPT_0x4
	LDI  R30,LOW(255)
	ST   X,R30
;     507 	gTx0Cnt++;			// 송신할 바이트수 증가
	INC  R11
;     508 
;     509 	gTx0Buf[gTx0Cnt]=Data;
	CALL SUBOPT_0x4
	ST   X,R21
;     510 	gTx0Cnt++;			// 송신할 바이트수 증가
	INC  R11
;     511 
;     512 	gTx0Buf[gTx0Cnt]=16;
	CALL SUBOPT_0x4
	LDI  R30,LOW(16)
	ST   X,R30
;     513 	gTx0Cnt++;			// 송신할 바이트수 증가
	INC  R11
;     514 
;     515 	CheckSum = 0;
	LDI  R18,LOW(0)
;     516 	for(i=0;i<MAX_wCK;i++){	// 각 wCK 데이터 준비
	LDI  R19,LOW(0)
_0x31:
	CPI  R19,31
	BRLO PC+3
	JMP _0x32
;     517 		if(Scene.wCK[i].Exist){	// 존재하는 ID만 준비
	LDI  R30,LOW(5)
	MUL  R30,R19
	MOVW R30,R0
	CALL SUBOPT_0x6
	BRNE PC+3
	JMP _0x33
;     518 			lwtmp = (int)Scene.wCK[i].SPos + (int)((float)gFrameIdx*gUnitD[i]);
	LDI  R30,LOW(5)
	MUL  R30,R19
	MOVW R30,R0
	CALL SUBOPT_0x7
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
	CALL SUBOPT_0x8
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
;     519 			if(lwtmp>254)		lwtmp = 254;
	__CPWRN 16,17,255
	BRLT _0x34
	__GETWRN 16,17,254
;     520 			else if(lwtmp<1)	lwtmp = 1;
	RJMP _0x35
_0x34:
	__CPWRN 16,17,1
	BRGE _0x36
	__GETWRN 16,17,1
;     521 			tmp = (BYTE)lwtmp;
_0x36:
_0x35:
	MOV  R20,R16
;     522 			gTx0Buf[gTx0Cnt] = tmp;
	CALL SUBOPT_0x4
	ST   X,R20
;     523 			gTx0Cnt++;			// 송신할 바이트수 증가
	INC  R11
;     524 			CheckSum = CheckSum^tmp;
	EOR  R18,R20
;     525 		}
;     526 	}
_0x33:
	SUBI R19,-1
	RJMP _0x31
_0x32:
;     527 	CheckSum = CheckSum & 0x7f;
	ANDI R18,LOW(127)
;     528 
;     529 	gTx0Buf[gTx0Cnt]=CheckSum;
	CALL SUBOPT_0x4
	ST   X,R18
;     530 	gTx0Cnt++;			// 송신할 바이트수 증가
	INC  R11
;     531 } 
	CALL __LOADLOCR6
	ADIW R28,6
	RET
;     532 
;     533 //------------------------------------------------------------------------------
;     534 // 8bit 명령 Position Move를 실행하기 위한 함수
;     535 // Input	: torq ID, Position
;     536 // Output	: None
;     537 //------------------------------------------------------------------------------
;     538 void PositionMove(BYTE torq, BYTE ID, BYTE position)
;     539 {
;     540     BYTE CheckSum;
;     541     ID = (BYTE)(torq << 5) | ID;
;	torq -> Y+3
;	ID -> Y+2
;	position -> Y+1
;	CheckSum -> R16
;     542     CheckSum = (ID ^ position) & 0x7f;
;     543     
;     544     sciTx0Data(0xff);
;     545 	sciTx0Data(ID);
;     546 	sciTx0Data(position);
;     547 	sciTx0Data(CheckSum);
;     548 }                       
;     549 
;     550 //------------------------------------------------------------------------------
;     551 // 확장 명령 I/O Write를 수행하기 위한 함수
;     552 // Input	: ID, IOchannel
;     553 // Output	: None
;     554 //------------------------------------------------------------------------------
;     555 void IOwrite(BYTE ID, BYTE IOchannel)
;     556 {
;     557     BYTE CheckSum; 
;     558 	ID=(BYTE)(7<<5)|ID; 
;	ID -> Y+2
;	IOchannel -> Y+1
;	CheckSum -> R16
;     559 	CheckSum = (ID^100^IOchannel^IOchannel)&0x7f;
;     560 
;     561 	gTx0Buf[gTx0Cnt]=HEADER;    gTx0Cnt++;			// 송신할 바이트수 증가
;     562 	gTx0Buf[gTx0Cnt]=ID;        gTx0Cnt++;			// 송신할 바이트수 증가
;     563 	gTx0Buf[gTx0Cnt]=100;       gTx0Cnt++;			// 송신할 바이트수 증가
;     564 	gTx0Buf[gTx0Cnt]=IOchannel;	gTx0Cnt++;			// 송신할 바이트수 증가
;     565 	gTx0Buf[gTx0Cnt]=IOchannel;	gTx0Cnt++;			// 송신할 바이트수 증가
;     566 	gTx0Buf[gTx0Cnt]=CheckSum; 	gTx0Cnt++;			// 송신할 바이트수 증가   
;     567 	
;     568 	gTx0BufIdx++;
;     569 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작
;     570 	
;     571 }
;     572 
;     573 //------------------------------------------------------------------------------
;     574 // 위치 읽기 명령(Position Send Command)을 보내는 함수
;     575 // Input	: ID, SpeedLevel, Position
;     576 // Output	: Current
;     577 // UART0 RX 인터럽트, Timer0 인터럽트가 활성화 되어 있어야 함
;     578 //------------------------------------------------------------------------------
;     579 WORD PosRead(BYTE ID) 
;     580 {
;     581 	BYTE	Data1, Data2;
;     582 	BYTE	CheckSum, Load, Position; 
;     583 	WORD	startT;
;     584 
;     585 	Data1 = (5<<5) | ID;
;	ID -> Y+7
;	Data1 -> R16
;	Data2 -> R17
;	CheckSum -> R18
;	Load -> R19
;	Position -> R20
;	startT -> Y+5
;     586 	Data2 = 0;
;     587 	gRx0Cnt = 0;			// 수신 바이트 수 초기화
;     588 	CheckSum = (Data1^Data2)&0x7f;
;     589 	sciTx0Data(HEADER);
;     590 	sciTx0Data(Data1);
;     591 	sciTx0Data(Data2);
;     592 	sciTx0Data(CheckSum);
;     593 	startT = gMSEC;
;     594 	while(gRx0Cnt<2){
;     595         if(gMSEC<startT){ 	// 밀리초 카운트가 리셋된 경우
;     596             if((1000 - startT + gMSEC)>RX_T_OUT)
;     597             	return 444;	// 타임아웃시 로컬 탈출
;     598         }
;     599 		else if((gMSEC-startT)>RX_T_OUT) return 444;
;     600 	}
;     601 	return gRx0Buf[RX0_BUF_SIZE-1];
;     602 } 
;     603 
;     604 
;     605 //------------------------------------------------------------------------------
;     606 // Flash에서 모션 정보 읽기
;     607 //	MRIdx : 모션 상대 인덱스
;     608 //------------------------------------------------------------------------------
;     609 void GetMotionFromFlash(void)
;     610 {
_GetMotionFromFlash:
;     611 	WORD i;
;     612 
;     613 	for(i=0;i<MAX_wCK;i++){				// wCK 파라미터 구조체 초기화
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x3F:
	__CPWRN 16,17,31
	BRSH _0x40
;     614 		Motion.wCK[i].Exist		= 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
;     615 		Motion.wCK[i].RPgain	= 0;
	__POINTW2MN _Motion,11
	CALL SUBOPT_0xC
;     616 		Motion.wCK[i].RDgain	= 0;
	__POINTW2MN _Motion,12
	CALL SUBOPT_0xC
;     617 		Motion.wCK[i].RIgain	= 0;
	__POINTW2MN _Motion,13
	CALL SUBOPT_0xC
;     618 		Motion.wCK[i].PortEn	= 0;
	__POINTW2MN _Motion,14
	CALL SUBOPT_0xC
;     619 		Motion.wCK[i].InitPos	= 0;
	__POINTW2MN _Motion,15
	CALL SUBOPT_0xD
;     620 	}
	__ADDWRN 16,17,1
	RJMP _0x3F
_0x40:
;     621 	for(i=0;i<Motion.NumOfwCK;i++){		// 각 wCK 파라미터 불러오기
	__GETWRN 16,17,0
_0x42:
	CALL SUBOPT_0xE
	BRSH _0x43
;     622 		Motion.wCK[wCK_IDs[i]].Exist		= 1;
	CALL SUBOPT_0xF
	CALL SUBOPT_0xA
	LDI  R30,LOW(1)
	ST   X,R30
;     623 		Motion.wCK[wCK_IDs[i]].RPgain	= *(gpPg_Table+i);
	CALL SUBOPT_0xF
	__ADDW1MN _Motion,11
	CALL SUBOPT_0x10
	LDS  R26,_gpPg_Table
	LDS  R27,_gpPg_Table+1
	CALL SUBOPT_0x11
;     624 		Motion.wCK[wCK_IDs[i]].RDgain	= *(gpDg_Table+i);
	__ADDW1MN _Motion,12
	CALL SUBOPT_0x10
	LDS  R26,_gpDg_Table
	LDS  R27,_gpDg_Table+1
	CALL SUBOPT_0x11
;     625 		Motion.wCK[wCK_IDs[i]].RIgain	= *(gpIg_Table+i);
	__ADDW1MN _Motion,13
	CALL SUBOPT_0x10
	LDS  R26,_gpIg_Table
	LDS  R27,_gpIg_Table+1
	CALL SUBOPT_0x11
;     626 		Motion.wCK[wCK_IDs[i]].PortEn	= 1;
	__POINTW2MN _Motion,14
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
;     627 		Motion.wCK[wCK_IDs[i]].InitPos	= MotionZeroPos[i];
	CALL SUBOPT_0xF
	__POINTW2MN _Motion,15
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R16
	SUBI R30,LOW(-_MotionZeroPos*2)
	SBCI R31,HIGH(-_MotionZeroPos*2)
	LPM  R30,Z
	ST   X,R30
;     628 	}
	__ADDWRN 16,17,1
	RJMP _0x42
_0x43:
;     629 }
	RJMP _0x7A
;     630 
;     631 
;     632 //------------------------------------------------------------------------------
;     633 // Runtime P,D,I 이득 송신
;     634 // 		: 모션정보에서 Runtime P,D,I이득을 불러와서 wCK에게 보낸다
;     635 //------------------------------------------------------------------------------
;     636 void SendTGain(void)
;     637 {
_SendTGain:
;     638 	WORD i;
;     639 
;     640 	UCSR0B &= 0x7F;   		// UART0 Rx인터럽트 미사용
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CBI  0xA,7
;     641 	UCSR0B |= 0x40;   		// UART0 Tx인터럽트 사용
	SBI  0xA,6
;     642 
;     643 	while(gTx0Cnt);			// 이전 패킷 송신이 끝날 때까지 대기
_0x44:
	TST  R11
	BRNE _0x44
;     644 	for(i=0;i<MAX_wCK;i++){					// Runtime P,D이득 설정 패킷 준비
	__GETWRN 16,17,0
_0x48:
	__CPWRN 16,17,31
	BRSH _0x49
;     645 		if(Motion.wCK[i].Exist)				// 존재하는 ID만 준비
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	LD   R30,X
	CPI  R30,0
	BREQ _0x4A
;     646 			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
	ST   -Y,R16
	LDI  R30,LOW(11)
	ST   -Y,R30
	CALL SUBOPT_0x9
	__POINTW2MN _Motion,11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x9
	__POINTW2MN _Motion,12
	CALL SUBOPT_0x12
	CALL _SendSetCmd
;     647 	}
_0x4A:
	__ADDWRN 16,17,1
	RJMP _0x48
_0x49:
;     648 	gTx0BufIdx++;
	CALL SUBOPT_0x13
;     649 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작
	CALL SUBOPT_0x14
;     650 
;     651 
;     652 	while(gTx0Cnt);			// 이전 패킷 송신이 끝날 때까지 대기
_0x4B:
	TST  R11
	BRNE _0x4B
;     653 	for(i=0;i<MAX_wCK;i++){					// Runtime I이득 설정 패킷 준비
	__GETWRN 16,17,0
_0x4F:
	__CPWRN 16,17,31
	BRSH _0x50
;     654 		if(Motion.wCK[i].Exist)				// 존재하는 ID만 준비
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	LD   R30,X
	CPI  R30,0
	BREQ _0x51
;     655 			SendSetCmd(i, 24, Motion.wCK[i].RIgain, Motion.wCK[i].RIgain);
	ST   -Y,R16
	LDI  R30,LOW(24)
	ST   -Y,R30
	CALL SUBOPT_0x9
	__POINTW2MN _Motion,13
	CALL SUBOPT_0x12
	CALL SUBOPT_0x9
	__POINTW2MN _Motion,13
	CALL SUBOPT_0x12
	CALL _SendSetCmd
;     656 	}
_0x51:
	__ADDWRN 16,17,1
	RJMP _0x4F
_0x50:
;     657 	gTx0BufIdx++;
	CALL SUBOPT_0x13
;     658 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작
	CALL SUBOPT_0x14
;     659 }
	RJMP _0x7A
;     660 
;     661 
;     662 //------------------------------------------------------------------------------
;     663 // 확장 포트값 송신
;     664 // 		: 씬 정보에서 확장 포트값을 불러와서 wCK에게 보낸다
;     665 //------------------------------------------------------------------------------
;     666 void SendExPortD(void)
;     667 {
_SendExPortD:
;     668 	WORD i;
;     669 
;     670 	UCSR0B &= 0x7F;   		// UART0 Rx인터럽트 미사용
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CBI  0xA,7
;     671 	UCSR0B |= 0x40;   		// UART0 Tx인터럽트 사용
	SBI  0xA,6
;     672 
;     673 	while(gTx0Cnt);			// 이전 패킷 송신이 끝날 때까지 대기
_0x52:
	TST  R11
	BRNE _0x52
;     674 	for(i=0;i<MAX_wCK;i++){					// Runtime P,D이득 설정 패킷 준비
	__GETWRN 16,17,0
_0x56:
	__CPWRN 16,17,31
	BRSH _0x57
;     675 		if(Scene.wCK[i].Exist)				// 존재하는 ID만 준비
	CALL SUBOPT_0x15
	CALL SUBOPT_0x6
	BREQ _0x58
;     676 			SendSetCmd(i, 100, Scene.wCK[i].ExPortD, Scene.wCK[i].ExPortD);
	ST   -Y,R16
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL SUBOPT_0x15
	__POINTW2MN _Scene,10
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	__POINTW2MN _Scene,10
	CALL SUBOPT_0x12
	CALL _SendSetCmd
;     677 	}
_0x58:
	__ADDWRN 16,17,1
	RJMP _0x56
_0x57:
;     678 	gTx0BufIdx++;
	CALL SUBOPT_0x13
;     679 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작
	CALL SUBOPT_0x14
;     680 }
	RJMP _0x7A
;     681 
;     682 
;     683 //------------------------------------------------------------------------------
;     684 // Flash에서 씬 정보 읽기
;     685 //	ScIdx : 씬 인덱스
;     686 //------------------------------------------------------------------------------
;     687 void GetSceneFromFlash(void)
;     688 {
_GetSceneFromFlash:
;     689 	WORD i;
;     690 	
;     691 	Scene.NumOfFrame = gpFN_Table[gSIdx];	// 프레임수
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CALL SUBOPT_0x16
	LDS  R26,_gpFN_Table
	LDS  R27,_gpFN_Table+1
	CALL SUBOPT_0x17
	__PUTW1MN _Scene,2
;     692 	Scene.RTime = gpRT_Table[gSIdx];		// 씬 수행 시간[msec]
	CALL SUBOPT_0x16
	LDS  R26,_gpRT_Table
	LDS  R27,_gpRT_Table+1
	CALL SUBOPT_0x17
	__PUTW1MN _Scene,4
;     693 	for(i=0;i<Motion.NumOfwCK;i++){			// 각 wCK 데이터 초기화
	__GETWRN 16,17,0
_0x5A:
	CALL SUBOPT_0xE
	BRSH _0x5B
;     694 		Scene.wCK[i].Exist		= 0;
	CALL SUBOPT_0x15
	__POINTW2MN _Scene,6
	CALL SUBOPT_0xD
;     695 		Scene.wCK[i].SPos		= 0;
	CALL SUBOPT_0x15
	CALL SUBOPT_0x7
	LDI  R30,LOW(0)
	ST   X,R30
;     696 		Scene.wCK[i].DPos		= 0;
	CALL SUBOPT_0x15
	__POINTW2MN _Scene,8
	CALL SUBOPT_0xD
;     697 		Scene.wCK[i].Torq		= 0;
	CALL SUBOPT_0x15
	__POINTW2MN _Scene,9
	CALL SUBOPT_0xD
;     698 		Scene.wCK[i].ExPortD	= 0;
	CALL SUBOPT_0x15
	__POINTW2MN _Scene,10
	CALL SUBOPT_0xD
;     699 	}
	__ADDWRN 16,17,1
	RJMP _0x5A
_0x5B:
;     700 	for(i=0;i<Motion.NumOfwCK;i++){			// 각 wCK 데이터 저장
	__GETWRN 16,17,0
_0x5D:
	CALL SUBOPT_0xE
	BRSH _0x5E
;     701 		Scene.wCK[wCK_IDs[i]].Exist		= 1;
	CALL SUBOPT_0x18
	__POINTW2MN _Scene,6
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	ST   X,R30
;     702 		Scene.wCK[wCK_IDs[i]].SPos		= gpPos_Table[Motion.NumOfwCK*gSIdx+i];
	CALL SUBOPT_0x18
	__ADDW1MN _Scene,7
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
;     703 		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[Motion.NumOfwCK*(gSIdx+1)+i];
	__ADDW1MN _Scene,8
	MOVW R22,R30
	__GETW2MN _Motion,8
	CALL SUBOPT_0x16
	ADIW R30,1
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	CALL SUBOPT_0x1A
;     704 		Scene.wCK[wCK_IDs[i]].Torq		= gpT_Table[Motion.NumOfwCK*gSIdx+i];
	__ADDW1MN _Scene,9
	CALL SUBOPT_0x19
	LDS  R26,_gpT_Table
	LDS  R27,_gpT_Table+1
	CALL SUBOPT_0x1B
;     705 		Scene.wCK[wCK_IDs[i]].ExPortD	= gpE_Table[Motion.NumOfwCK*gSIdx+i];
	CALL SUBOPT_0x18
	__ADDW1MN _Scene,10
	CALL SUBOPT_0x19
	LDS  R26,_gpE_Table
	LDS  R27,_gpE_Table+1
	CALL SUBOPT_0x1B
;     706 	}
	__ADDWRN 16,17,1
	RJMP _0x5D
_0x5E:
;     707 	UCSR0B &= 0x7F;   		// UART0 Rx인터럽트 미사용
	CBI  0xA,7
;     708 	UCSR0B |= 0x40;   		// UART0 Tx인터럽트 사용
	SBI  0xA,6
;     709 
;     710 	delay_us(1300);
	__DELAY_USW 4792
;     711 }
	RJMP _0x7A
;     712 
;     713 
;     714 //------------------------------------------------------------------------------
;     715 // 프레임 송신 간격 계산
;     716 // 		: 씬 수행 시간을 프레임수로 나눠서 interval을 정한다
;     717 //------------------------------------------------------------------------------
;     718 void CalcFrameInterval(void)
;     719 {
_CalcFrameInterval:
;     720 	float tmp;
;     721 	if((Scene.RTime / Scene.NumOfFrame)<20){
	SBIW R28,4
;	tmp -> Y+0
	__GETW2MN _Scene,4
	CALL SUBOPT_0x1
	CALL __DIVW21U
	SBIW R30,20
	BRSH _0x5F
;     722 		return;
	RJMP _0x7B
;     723 	}
;     724 	tmp = (float)Scene.RTime * 14.4;
_0x5F:
	__GETW1MN _Scene,4
	CALL SUBOPT_0x1C
	__GETD2N 0x41666666
	CALL __MULF12
	__PUTD1S 0
;     725 	tmp = tmp  / (float)Scene.NumOfFrame;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1C
	__GETD2S 0
	CALL __DIVF21
	__PUTD1S 0
;     726 	TxInterval = 65535 - (WORD)tmp - 43;
	CALL __CFD1
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	SUB  R26,R30
	SBC  R27,R31
	SBIW R26,43
	STS  _TxInterval,R26
	STS  _TxInterval+1,R27
;     727 
;     728 	RUN_LED1_ON;
	CBI  0x1B,5
;     729 	F_PLAYING=1;		// 모션 실행중 표시
	SET
	BLD  R2,0
;     730 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;     731 
;     732 	if(TxInterval<=65509)	
	CPI  R26,LOW(0xFFE6)
	LDI  R30,HIGH(0xFFE6)
	CPC  R27,R30
	BRSH _0x60
;     733 		TCNT1=TxInterval+26;
	LDS  R30,_TxInterval
	LDS  R31,_TxInterval+1
	ADIW R30,26
	RJMP _0x7C
;     734 	else
_0x60:
;     735 		TCNT1=65535;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x7C:
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;     736 
;     737 	TIFR |= 0x04;		// 타이머 인터럽트 플래그 초기화
	CALL SUBOPT_0x3
;     738 	TIMSK |= 0x04;		// Timer1 Overflow Interrupt 활성화(140쪽)
;     739 }
_0x7B:
	ADIW R28,4
	RET
;     740 
;     741 
;     742 //------------------------------------------------------------------------------
;     743 // 프레임당 단위 이동량 계산
;     744 //------------------------------------------------------------------------------
;     745 void CalcUnitMove(void)
;     746 {
_CalcUnitMove:
;     747 	WORD i;
;     748 
;     749 	for(i=0;i<MAX_wCK;i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x63:
	__CPWRN 16,17,31
	BRLO PC+3
	JMP _0x64
;     750 		if(Scene.wCK[i].Exist){	// 존재하는 ID만 준비
	CALL SUBOPT_0x15
	CALL SUBOPT_0x6
	BRNE PC+3
	JMP _0x65
;     751 			if(Scene.wCK[i].SPos!=Scene.wCK[i].DPos){
	CALL SUBOPT_0x15
	CALL SUBOPT_0x7
	LD   R22,X
	CALL SUBOPT_0x15
	__POINTW2MN _Scene,8
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CP   R30,R22
	BRNE PC+3
	JMP _0x66
;     752 				// 프레임당 단위 변위 증가량 계산
;     753 				gUnitD[i] = (float)((int)Scene.wCK[i].DPos-(int)Scene.wCK[i].SPos);
	CALL SUBOPT_0x1D
	MOVW R24,R30
	CALL SUBOPT_0x15
	__POINTW2MN _Scene,8
	ADD  R26,R30
	ADC  R27,R31
	LD   R22,X
	CLR  R23
	CALL SUBOPT_0x15
	CALL SUBOPT_0x7
	LD   R26,X
	CLR  R27
	MOVW R30,R22
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R24
	CALL __PUTDP1
;     754 				gUnitD[i] = (float)(gUnitD[i]/Scene.NumOfFrame);
	CALL SUBOPT_0x1D
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1E
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1C
	CALL __DIVF21
	POP  R26
	POP  R27
	CALL __PUTDP1
;     755 				if(gUnitD[i]>253)	gUnitD[i]=254;
	CALL SUBOPT_0x1E
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x437D0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x67
	CALL SUBOPT_0x1F
	__GETD1N 0x437E0000
	RJMP _0x7D
;     756 				else if(gUnitD[i]<-253)	gUnitD[i]=-254;
_0x67:
	CALL SUBOPT_0x1E
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xC37D0000
	CALL __CMPF12
	BRSH _0x69
	CALL SUBOPT_0x1F
	__GETD1N 0xC37E0000
_0x7D:
	CALL __PUTDP1
;     757 			}
_0x69:
;     758 			else
	RJMP _0x6A
_0x66:
;     759 				gUnitD[i] = 0;
	CALL SUBOPT_0x1F
	__GETD1N 0x0
	CALL __PUTDP1
;     760 		}
_0x6A:
;     761 	}
_0x65:
	__ADDWRN 16,17,1
	RJMP _0x63
_0x64:
;     762 	gFrameIdx=0;				// 프레임 인덱스 초기화
	LDI  R30,0
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R30
;     763 }
_0x7A:
	LD   R16,Y+
	LD   R17,Y+
	RET
;     764 
;     765 
;     766 //------------------------------------------------------------------------------
;     767 // 한 프레임 송신 준비
;     768 //------------------------------------------------------------------------------
;     769 void MakeFrame(void)
;     770 {
_MakeFrame:
;     771 	while(gTx0Cnt);			// 이전 프레임 송신이 끝날 때까지 대기
_0x6B:
	TST  R11
	BRNE _0x6B
;     772 	gFrameIdx++;			// 프레임 인덱스 증가
	LDS  R30,_gFrameIdx
	LDS  R31,_gFrameIdx+1
	ADIW R30,1
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R31
;     773 	SyncPosSend();			// 동기화 위치 명령으로 송신
	CALL _SyncPosSend
;     774 }
	RET
;     775 
;     776 
;     777 //------------------------------------------------------------------------------
;     778 // 한 프레임 송신
;     779 //------------------------------------------------------------------------------
;     780 void SendFrame(void)
;     781 {
_SendFrame:
;     782 	if(gTx0Cnt==0)	return;	// 보낼 데이터가 없으면 실행 안함
	TST  R11
	BRNE _0x6E
	RET
;     783 	gTx0BufIdx++;
_0x6E:
	CALL SUBOPT_0x13
;     784 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작
	CALL SUBOPT_0x14
;     785 }
	RET
;     786 
;     787 
;     788 //------------------------------------------------------------------------------
;     789 // 
;     790 //------------------------------------------------------------------------------
;     791 void M_PlayFlash(void)
;     792 {
_M_PlayFlash:
;     793 	float tmp;
;     794 	WORD i;
;     795 
;     796 	GetMotionFromFlash();		// 각 wCK 파라미터 불러오기
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	tmp -> Y+2
;	i -> R16,R17
	CALL _GetMotionFromFlash
;     797 	SendTGain();				// Runtime이득 송신
	CALL _SendTGain
;     798 	for(i=0;i<Motion.NumOfScene;i++){
	__GETWRN 16,17,0
_0x70:
	__GETW1MN _Motion,6
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x71
;     799 		gSIdx = i;
	__PUTWMRN _gSIdx,0,16,17
;     800 		GetSceneFromFlash();	// 한 씬을 불러온다
	CALL _GetSceneFromFlash
;     801 		SendExPortD();			// 확장 포트값 송신
	CALL _SendExPortD
;     802 		CalcFrameInterval();	// 프레임 송신 간격 계산, 타이머1 시작
	CALL _CalcFrameInterval
;     803 		CalcUnitMove();			// 프레임당 단위 이동량 계산
	CALL _CalcUnitMove
;     804 		MakeFrame();			// 한 프레임 준비
	CALL _MakeFrame
;     805 		SendFrame();			// 한 프레임 송신
	CALL _SendFrame
;     806 		while(F_PLAYING);
_0x72:
	SBRC R2,0
	RJMP _0x72
;     807 	}
	__ADDWRN 16,17,1
	RJMP _0x70
_0x71:
;     808 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;     809 
;     810 
;     811 void SampleMotion1(void)	// 샘플 모션 1
;     812 {
_SampleMotion1:
;     813 	gpT_Table			= M_EX1_Torque;
	LDI  R30,LOW(_M_EX1_Torque*2)
	LDI  R31,HIGH(_M_EX1_Torque*2)
	STS  _gpT_Table,R30
	STS  _gpT_Table+1,R31
;     814 	gpE_Table			= M_EX1_Port;
	LDI  R30,LOW(_M_EX1_Port*2)
	LDI  R31,HIGH(_M_EX1_Port*2)
	STS  _gpE_Table,R30
	STS  _gpE_Table+1,R31
;     815 	gpPg_Table 			= M_EX1_RuntimePGain;
	LDI  R30,LOW(_M_EX1_RuntimePGain*2)
	LDI  R31,HIGH(_M_EX1_RuntimePGain*2)
	STS  _gpPg_Table,R30
	STS  _gpPg_Table+1,R31
;     816 	gpDg_Table 			= M_EX1_RuntimeDGain;
	LDI  R30,LOW(_M_EX1_RuntimeDGain*2)
	LDI  R31,HIGH(_M_EX1_RuntimeDGain*2)
	STS  _gpDg_Table,R30
	STS  _gpDg_Table+1,R31
;     817 	gpIg_Table 			= M_EX1_RuntimeIGain;
	LDI  R30,LOW(_M_EX1_RuntimeIGain*2)
	LDI  R31,HIGH(_M_EX1_RuntimeIGain*2)
	STS  _gpIg_Table,R30
	STS  _gpIg_Table+1,R31
;     818 	gpFN_Table			= M_EX1_Frames;
	LDI  R30,LOW(_M_EX1_Frames*2)
	LDI  R31,HIGH(_M_EX1_Frames*2)
	STS  _gpFN_Table,R30
	STS  _gpFN_Table+1,R31
;     819 	gpRT_Table			= M_EX1_TrTime;
	LDI  R30,LOW(_M_EX1_TrTime*2)
	LDI  R31,HIGH(_M_EX1_TrTime*2)
	STS  _gpRT_Table,R30
	STS  _gpRT_Table+1,R31
;     820 	gpPos_Table			= M_EX1_Position;
	LDI  R30,LOW(_M_EX1_Position*2)
	LDI  R31,HIGH(_M_EX1_Position*2)
	STS  _gpPos_Table,R30
	STS  _gpPos_Table+1,R31
;     821 	Motion.NumOfScene 	= M_EX1_NUM_OF_SCENES;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	__PUTW1MN _Motion,6
;     822 	Motion.NumOfwCK 	= M_EX1_NUM_OF_WCKS;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	__PUTW1MN _Motion,8
;     823 	M_PlayFlash();
	CALL _M_PlayFlash
;     824 }
	RET
;     825 //==============================================================================
;     826 //						Digital Input Output 관련 함수들
;     827 //==============================================================================
;     828 
;     829 #include <mega128.h>
;     830 #include "Main.h"
;     831 #include "Macro.h"
;     832 #include "DIO.h"
;     833 
;     834 
;     835 //------------------------------------------------------------------------------
;     836 // 버튼 읽기
;     837 //------------------------------------------------------------------------------
;     838 void ReadButton(void)
;     839 {
_ReadButton:
;     840 	int		i;
;     841 	BYTE	lbtmp;
;     842 
;     843 	lbtmp = PINA & 0x03;
	CALL __SAVELOCR3
;	i -> R16,R17
;	lbtmp -> R18
	IN   R30,0x19
	ANDI R30,LOW(0x3)
	MOV  R18,R30
;     844 	if((lbtmp!=0x03)){
	CPI  R18,3
	BREQ _0x75
;     845 		if(++gBtnCnt>100){   // 눌러서 0.1초 이상 유지되면 입력 인정
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRLO _0x76
;     846 			if(lbtmp==0x02){	// PF1 버튼 눌러졌으면 샘플 모션 실행
	CPI  R18,2
	BRNE _0x77
;     847 				SampleMotion1();
	CALL _SampleMotion1
;     848 			}
;     849 		}
_0x77:
;     850 	}
_0x76:
;     851 	else{
	RJMP _0x78
_0x75:
;     852 	    gBtnCnt=0;
	CLR  R4
	CLR  R5
;     853     }
_0x78:
;     854 } 
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;     855 
;     856 
;     857 //------------------------------------------------------------------------------
;     858 // Io 업데이트 처리
;     859 //------------------------------------------------------------------------------
;     860 void IoUpdate(void)
;     861 {
_IoUpdate:
;     862 	// 모드 표시 LED 처리
;     863 	if(F_DIRECT_C_EN){		// 직접 제어 모드이면
	SBRS R2,1
	RJMP _0x79
;     864 		PF1_LED1_ON;
	CBI  0x1B,2
;     865 		PF1_LED2_OFF;
	SBI  0x1B,3
;     866 		PF2_LED_ON;
	CBI  0x1B,4
;     867 		return;
	RET
;     868 	}
;     869 }
_0x79:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x0:
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	__GETW1MN _Scene,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
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
SUBOPT_0x3:
	IN   R30,0x36
	ORI  R30,4
	OUT  0x36,R30
	IN   R30,0x37
	ORI  R30,4
	OUT  0x37,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	INC  R11
	MOV  R30,R11
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	__POINTW2MN _Scene,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	__POINTW2MN _Scene,7
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x9:
	__MULBNWRU 16,17,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	__POINTW2MN _Motion,10
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	__GETW1MN _Motion,8
	CP   R16,R30
	CPC  R17,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xF:
	MOVW R30,R16
	SUBI R30,LOW(-_wCK_IDs*2)
	SBCI R31,HIGH(-_wCK_IDs*2)
	LPM  R30,Z
	LDI  R26,LOW(6)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	MOVW R0,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	INC  R13
	MOV  R30,R13
	SUBI R30,LOW(1)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LD   R30,Z
	ST   -Y,R30
	JMP  _sciTx0Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x15:
	__MULBNWRU 16,17,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDS  R30,_gSIdx
	LDS  R31,_gSIdx+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x18:
	MOVW R30,R16
	SUBI R30,LOW(-_wCK_IDs*2)
	SBCI R31,HIGH(-_wCK_IDs*2)
	LPM  R30,Z
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x19:
	MOVW R22,R30
	__GETW1MN _Motion,8
	LDS  R26,_gSIdx
	LDS  R27,_gSIdx+1
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	LDS  R26,_gpPos_Table
	LDS  R27,_gpPos_Table+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	MOVW R30,R16
	LDI  R26,LOW(_gUnitD)
	LDI  R27,HIGH(_gUnitD)
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	MOVW R30,R16
	LDI  R26,LOW(_gUnitD)
	LDI  R27,HIGH(_gUnitD)
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	MOVW R30,R16
	LDI  R26,LOW(_gUnitD)
	LDI  R27,HIGH(_gUnitD)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
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
