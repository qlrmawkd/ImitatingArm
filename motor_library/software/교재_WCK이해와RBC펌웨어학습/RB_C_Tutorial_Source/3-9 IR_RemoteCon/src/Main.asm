
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

	.INCLUDE "Main.vec"
	.INCLUDE "Main.inc"

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
	RJMP _0x31E
;     190 	else return (int)(floor(tempNum));
_0x4:
	CALL SUBOPT_0x1
	CALL _floor
	CALL __CFD1
;     191 }
_0x31E:
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
	RJMP _0x31D
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
	RJMP _0x31C
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
_0x31D:
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
_0x31C:
	LD   R16,Y+
	LD   R17,Y+
	RET
;     290 
;     291 
;     292 void U1I_case703(void)
;     293 {
;     294 	WORD    lwtmp;
;     295 	BYTE	lbtmp;
;     296 
;     297 	if(gFileCheckSum == gRxData){
;	lwtmp -> R16,R17
;	lbtmp -> R18
;     298 		if(gDownNumOfM == 0){
;     299 			if(gRx1Buf[RX1_BUF_SIZE-2] == 1)
;     300 				lwtmp = 0x6000;
;     301 			else if(gRx1Buf[RX1_BUF_SIZE-2] == 2)
;     302 				lwtmp = 0x2000;
;     303 		}
;     304 		else{
;     305 			if(gRx1Buf[RX1_BUF_SIZE-2] == 1){
;     306 				lwtmp = eM_Addr[gDownNumOfM-1] + eM_FSize[gDownNumOfM-1];
;     307 				lwtmp = lwtmp + 64 - (eM_FSize[gDownNumOfM-1]%64);
;     308 				lwtmp = 0x6000 - lwtmp;
;     309 			}
;     310 			else if(gRx1Buf[RX1_BUF_SIZE-2] == 2){
;     311 				lwtmp = eA_Addr[gDownNumOfA-1] + eA_FSize[gDownNumOfA-1];
;     312 				lwtmp = lwtmp + 64 - (eA_FSize[gDownNumOfA-1]%64);
;     313 				lwtmp = 0x8000 - lwtmp;
;     314 			}
;     315 		}
;     316 		SendToPC(15,4);
;     317 		gFileCheckSum = 0;
;     318 		sciTx1Data(0x00);
;     319 		sciTx1Data(0x00);
;     320 		lbtmp = (BYTE)((lwtmp>>8) & 0xFF);
;     321 		sciTx1Data(lbtmp);
;     322 		gFileCheckSum ^= lbtmp;
;     323 		lbtmp = (BYTE)(lwtmp & 0xFF);
;     324 		sciTx1Data(lbtmp);
;     325 		gFileCheckSum ^= lbtmp;
;     326 		sciTx1Data(gFileCheckSum);
;     327 	}
;     328 	gRx1Step = 0;
;     329 	F_DOWNLOAD = 0;
;     330 	RUN_LED2_OFF;
;     331 }
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
	CALL SUBOPT_0xF
	LD   R30,Z
	OUT  0xC,R30
;     342     	gTx0BufIdx++;
	CALL SUBOPT_0x10
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
	CALL SUBOPT_0x11
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
	CALL SUBOPT_0x12
;     366 	gRx0Buf[RX0_BUF_SIZE-1] = data;
	__ADDWRN 16,17,1
	RJMP _0x32
_0x33:
	__PUTBMRN _gRx0Buf,7,18
;     367 }
	CALL SUBOPT_0x11
	RETI
;     368 
;     369 
;     370 //------------------------------------------------------------------------------
;     371 // UART1 수신 인터럽트(RF모듈, PC에서 받은 신호)
;     372 //------------------------------------------------------------------------------
;     373 interrupt [USART1_RXC] void usart1_rx_isr(void)
;     374 {
_usart1_rx_isr:
	CALL SUBOPT_0x13
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
	CALL SUBOPT_0x14
;     383 			gFileCheckSum = 0;
	LDI  R30,LOW(0)
	STS  _gFileCheckSum,R30
;     384 			return;
	CALL SUBOPT_0x15
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
	CALL SUBOPT_0x14
;     389 				else gRx1_DStep = 0;
	RJMP _0x3E
_0x3D:
	CALL SUBOPT_0x16
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
	CALL SUBOPT_0x14
;     394 				else gRx1_DStep = 0;
	RJMP _0x41
_0x40:
	CALL SUBOPT_0x16
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
	CALL SUBOPT_0x14
;     399 				else gRx1_DStep = 0;
	RJMP _0x44
_0x43:
	CALL SUBOPT_0x16
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
	CALL SUBOPT_0x14
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
	CALL SUBOPT_0x16
;     416 				break;
;     417 		}
_0x3B:
;     418 		return;
	CALL SUBOPT_0x15
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
	CALL SUBOPT_0x12
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
	CALL SUBOPT_0x17
;     440 
;     441 		UCSR0B |= 0x40;
	CALL SUBOPT_0x18
;     442 		EIMSK |= 0x40;
;     443 		return;
	CALL SUBOPT_0x15
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
	CALL SUBOPT_0x17
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
	CALL SUBOPT_0x17
;     453     	    }
;     454     	    else if(gRxData == 16){
	RJMP _0x55
_0x54:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x10)
	BRNE _0x56
;     455     	        gRx1Step = 800;
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	CALL SUBOPT_0x17
;     456     	    }
;     457     	    else if(gRxData == 17){
	RJMP _0x57
_0x56:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x11)
	BRNE _0x58
;     458     	        gRx1Step = 900;
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CALL SUBOPT_0x17
;     459     	    }
;     460     	    else if(gRxData == 18){
	RJMP _0x59
_0x58:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x12)
	BRNE _0x5A
;     461     	        gRx1Step = 1000;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x17
;     462     	    }
;     463     	    else if(gRxData == 20){
	RJMP _0x5B
_0x5A:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x14)
	BRNE _0x5C
;     464     	        gRx1Step = 1200;
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	CALL SUBOPT_0x17
;     465     	    }
;     466     	    else if(gRxData == 21){
	RJMP _0x5D
_0x5C:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x15)
	BRNE _0x5E
;     467     	        gRx1Step = 1300;
	LDI  R30,LOW(1300)
	LDI  R31,HIGH(1300)
	CALL SUBOPT_0x17
;     468     	    }
;     469     	    else if(gRxData == 22){
	RJMP _0x5F
_0x5E:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x16)
	BRNE _0x60
;     470     	        gRx1Step = 1400;
	LDI  R30,LOW(1400)
	LDI  R31,HIGH(1400)
	CALL SUBOPT_0x17
;     471     	    }
;     472     	    else if(gRxData == 23){
	RJMP _0x61
_0x60:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x17)
	BRNE _0x62
;     473     	        gRx1Step = 1500;
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	CALL SUBOPT_0x17
;     474     	    }
;     475     	    else if(gRxData == 24){
	RJMP _0x63
_0x62:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x18)
	BRNE _0x64
;     476     	        gRx1Step = 1600;
	LDI  R30,LOW(1600)
	LDI  R31,HIGH(1600)
	CALL SUBOPT_0x17
;     477     	    }
;     478     	    else if(gRxData == 26){
	RJMP _0x65
_0x64:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x1A)
	BRNE _0x66
;     479     	        gRx1Step = 1800;
	LDI  R30,LOW(1800)
	LDI  R31,HIGH(1800)
	CALL SUBOPT_0x17
;     480     	    }
;     481     	    else if(gRxData == 31){
	RJMP _0x67
_0x66:
	LDS  R26,_gRxData
	CPI  R26,LOW(0x1F)
	BRNE _0x68
;     482     	        gRx1Step = 2300;
	LDI  R30,LOW(2300)
	LDI  R31,HIGH(2300)
	CALL SUBOPT_0x17
;     483     	    }
;     484     	    else{
	RJMP _0x69
_0x68:
;     485 				gRx1Step = 0;
	RJMP _0x31F
;     486 				F_DOWNLOAD = 0;
;     487 				RUN_LED2_OFF;
;     488 				break;
;     489 			}    	    	
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
;     490     	    break;
	RJMP _0x50
;     491     	case 300:
_0x51:
	CPI  R30,LOW(0x12C)
	LDI  R26,HIGH(0x12C)
	CPC  R31,R26
	BRNE _0x6A
;     492 			U1I_case100();
	CALL _U1I_case100
;     493     	    break;
	RJMP _0x50
;     494     	case 301:
_0x6A:
	CPI  R30,LOW(0x12D)
	LDI  R26,HIGH(0x12D)
	CPC  R31,R26
	BRNE _0x6B
;     495 			U1I_case301(1);
	CALL SUBOPT_0x19
;     496        	 	break;
	RJMP _0x50
;     497     	case 302:
_0x6B:
	CPI  R30,LOW(0x12E)
	LDI  R26,HIGH(0x12E)
	CPC  R31,R26
	BRNE _0x6C
;     498 			U1I_case302();
	CALL _U1I_case302
;     499        	 	break;
	RJMP _0x50
;     500     	case 303:
_0x6C:
	CPI  R30,LOW(0x12F)
	LDI  R26,HIGH(0x12F)
	CPC  R31,R26
	BRNE _0x6D
;     501     		U1I_case303();
	CALL _U1I_case303
;     502        	 	break;
	RJMP _0x50
;     503     	case 600:
_0x6D:
	CPI  R30,LOW(0x258)
	LDI  R26,HIGH(0x258)
	CPC  R31,R26
	BRNE _0x6E
;     504 			U1I_case100();
	CALL _U1I_case100
;     505     	    break;
	RJMP _0x50
;     506     	case 601:
_0x6E:
	CPI  R30,LOW(0x259)
	LDI  R26,HIGH(0x259)
	CPC  R31,R26
	BRNE _0x6F
;     507 			U1I_case301(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _U1I_case301
;     508        	 	break;
	RJMP _0x50
;     509     	case 602:
_0x6F:
	CPI  R30,LOW(0x25A)
	LDI  R26,HIGH(0x25A)
	CPC  R31,R26
	BRNE _0x70
;     510 			U1I_case502(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _U1I_case502
;     511        	 	break;
	RJMP _0x50
;     512     	case 603:
_0x70:
	CPI  R30,LOW(0x25B)
	LDI  R26,HIGH(0x25B)
	CPC  R31,R26
	BRNE _0x71
;     513     		U1I_case603();
	CALL _U1I_case603
;     514        	 	break;
	RJMP _0x50
;     515     	case 800:
_0x71:
	CPI  R30,LOW(0x320)
	LDI  R26,HIGH(0x320)
	CPC  R31,R26
	BRNE _0x72
;     516 			U1I_case100();
	CALL _U1I_case100
;     517     	    break;
	RJMP _0x50
;     518     	case 801:
_0x72:
	CPI  R30,LOW(0x321)
	LDI  R26,HIGH(0x321)
	CPC  R31,R26
	BRNE _0x73
;     519 			U1I_case301(1);
	CALL SUBOPT_0x19
;     520        	 	break;
	RJMP _0x50
;     521     	case 802:
_0x73:
	CPI  R30,LOW(0x322)
	LDI  R26,HIGH(0x322)
	CPC  R31,R26
	BRNE _0x74
;     522 			U1I_case302();
	CALL _U1I_case302
;     523        	 	break;
	RJMP _0x50
;     524     	case 803:
_0x74:
	CPI  R30,LOW(0x323)
	LDI  R26,HIGH(0x323)
	CPC  R31,R26
	BRNE _0x75
;     525 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x76
;     526 				SendToPC(16,1);
	LDI  R30,LOW(16)
	CALL SUBOPT_0x1A
;     527 				gFileCheckSum = 0;
;     528 				sciTx1Data(0x01);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1B
;     529 				gFileCheckSum ^= 0x01;
	CALL SUBOPT_0x1C
;     530 				sciTx1Data(gFileCheckSum);
;     531 				gRx1Step = 0;
	CALL SUBOPT_0x6
;     532 				F_DOWNLOAD = 0;
;     533 				RUN_LED2_OFF;
;     534 			    TIMSK &= 0xFE;
	CALL SUBOPT_0x1D
;     535 				EIMSK &= 0xBF;
;     536 				UCSR0B |= 0x80;
;     537 				UCSR0B &= 0xBF;
;     538 				F_DIRECT_C_EN = 1;
;     539 				PF1_LED1_ON;
	CBI  0x1B,2
;     540 				PF1_LED2_OFF;
	SBI  0x1B,3
;     541 				PF2_LED_ON;
	CBI  0x1B,4
;     542 				return;
	CALL SUBOPT_0x15
	RETI
;     543 			}
;     544 			gRx1Step = 0;
_0x76:
	RJMP _0x31F
;     545 			F_DOWNLOAD = 0;
;     546 			RUN_LED2_OFF;
;     547        	 	break;
;     548     	case 900:
_0x75:
	CPI  R30,LOW(0x384)
	LDI  R26,HIGH(0x384)
	CPC  R31,R26
	BRNE _0x77
;     549 			U1I_case100();
	CALL _U1I_case100
;     550     	    break;
	RJMP _0x50
;     551     	case 901:
_0x77:
	CPI  R30,LOW(0x385)
	LDI  R26,HIGH(0x385)
	CPC  R31,R26
	BRNE _0x78
;     552 			U1I_case301(1);
	CALL SUBOPT_0x19
;     553        	 	break;
	RJMP _0x50
;     554     	case 902:
_0x78:
	CPI  R30,LOW(0x386)
	LDI  R26,HIGH(0x386)
	CPC  R31,R26
	BRNE _0x79
;     555 			U1I_case302();
	CALL _U1I_case302
;     556        	 	break;
	RJMP _0x50
;     557     	case 903:
_0x79:
	CPI  R30,LOW(0x387)
	LDI  R26,HIGH(0x387)
	CPC  R31,R26
	BRNE _0x7A
;     558 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x7B
;     559 				SendToPC(17,2);
	LDI  R30,LOW(17)
	CALL SUBOPT_0x1E
;     560 				gFileCheckSum = 0;
;     561 				sciTx1Data(F_ERR_CODE);
	ST   -Y,R13
	RCALL _sciTx1Data
;     562 				gFileCheckSum ^= F_ERR_CODE;
	MOV  R30,R13
	CALL SUBOPT_0xA
;     563 				sciTx1Data(F_PF);
	ST   -Y,R12
	RCALL _sciTx1Data
;     564 				gFileCheckSum ^= F_PF;
	MOV  R30,R12
	CALL SUBOPT_0xA
;     565 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     566 			}
;     567 			gRx1Step = 0;
_0x7B:
	RJMP _0x31F
;     568 			F_DOWNLOAD = 0;
;     569 			RUN_LED2_OFF;
;     570        	 	break;
;     571     	case 1000:
_0x7A:
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0x7C
;     572 			U1I_case100();
	CALL _U1I_case100
;     573     	    break;
	RJMP _0x50
;     574     	case 1001:
_0x7C:
	CPI  R30,LOW(0x3E9)
	LDI  R26,HIGH(0x3E9)
	CPC  R31,R26
	BRNE _0x7D
;     575 			U1I_case301(1);
	CALL SUBOPT_0x19
;     576        	 	break;
	RJMP _0x50
;     577     	case 1002:
_0x7D:
	CPI  R30,LOW(0x3EA)
	LDI  R26,HIGH(0x3EA)
	CPC  R31,R26
	BRNE _0x7E
;     578 			U1I_case302();
	CALL _U1I_case302
;     579        	 	break;
	RJMP _0x50
;     580     	case 1003:
_0x7E:
	CPI  R30,LOW(0x3EB)
	LDI  R26,HIGH(0x3EB)
	CPC  R31,R26
	BRNE _0x7F
;     581 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x80
;     582 				SendToPC(18,2);
	LDI  R30,LOW(18)
	CALL SUBOPT_0x1E
;     583 				gFileCheckSum = 0;
;     584 				sciTx1Data(9);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x1B
;     585 				gFileCheckSum ^= 9;
	LDI  R30,LOW(9)
	EOR  R30,R26
	STS  _gFileCheckSum,R30
;     586 				sciTx1Data(99);
	LDI  R30,LOW(99)
	CALL SUBOPT_0x1B
;     587 				gFileCheckSum ^= 99;
	LDI  R30,LOW(99)
	EOR  R30,R26
	STS  _gFileCheckSum,R30
;     588 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     589 			}
;     590 			gRx1Step = 0;
_0x80:
	RJMP _0x31F
;     591 			F_DOWNLOAD = 0;
;     592 			RUN_LED2_OFF;
;     593        	 	break;
;     594     	case 1200:
_0x7F:
	CPI  R30,LOW(0x4B0)
	LDI  R26,HIGH(0x4B0)
	CPC  R31,R26
	BRNE _0x81
;     595 			U1I_case100();
	CALL _U1I_case100
;     596     	    break;
	RJMP _0x50
;     597     	case 1201:
_0x81:
	CPI  R30,LOW(0x4B1)
	LDI  R26,HIGH(0x4B1)
	CPC  R31,R26
	BRNE _0x82
;     598 			U1I_case301(1);
	CALL SUBOPT_0x19
;     599        	 	break;
	RJMP _0x50
;     600     	case 1202:
_0x82:
	CPI  R30,LOW(0x4B2)
	LDI  R26,HIGH(0x4B2)
	CPC  R31,R26
	BRNE _0x83
;     601 			gFileCheckSum ^= gRxData;
	CALL SUBOPT_0x7
;     602 			if(gRxData < 64)
	LDS  R26,_gRxData
	CPI  R26,LOW(0x40)
	BRSH _0x84
;     603 				gRx1Step++;
	CALL SUBOPT_0x4
;     604 			else{
	RJMP _0x85
_0x84:
;     605 				gRx1Step = 0;
	CALL SUBOPT_0x6
;     606 				F_DOWNLOAD = 0;
;     607 				RUN_LED2_OFF;
;     608 			}
_0x85:
;     609        	 	break;
	RJMP _0x50
;     610     	case 1203:
_0x83:
	CPI  R30,LOW(0x4B3)
	LDI  R26,HIGH(0x4B3)
	CPC  R31,R26
	BRNE _0x86
;     611 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x87
;     612 				F_RSV_MOTION = 1;
	SET
	BLD  R3,4
;     613 				if(gRx1Buf[RX1_BUF_SIZE-2] == 0x07)	F_MOTION_STOPPED = 1;
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x7)
	BRNE _0x88
	BLD  R2,3
;     614 				gRx1Step = 0;
_0x88:
	CALL SUBOPT_0x6
;     615 				F_DOWNLOAD = 0;
;     616 				RUN_LED2_OFF;
;     617 				UCSR0B |= 0x40;
	CALL SUBOPT_0x18
;     618 				EIMSK |= 0x40;
;     619 				F_IR_RECEIVED = 1;
	SET
	BLD  R3,2
;     620 				gIrBuf[0] = eRCodeH[0];
	LDI  R26,LOW(_eRCodeH)
	LDI  R27,HIGH(_eRCodeH)
	CALL __EEPROMRDB
	STS  _gIrBuf,R30
;     621 				gIrBuf[1] = eRCodeM[0];
	LDI  R26,LOW(_eRCodeM)
	LDI  R27,HIGH(_eRCodeM)
	CALL __EEPROMRDB
	__PUTB1MN _gIrBuf,1
;     622 				gIrBuf[2] = eRCodeL[0];
	LDI  R26,LOW(_eRCodeL)
	LDI  R27,HIGH(_eRCodeL)
	CALL __EEPROMRDB
	__PUTB1MN _gIrBuf,2
;     623 				gIrBuf[3] = gRx1Buf[RX1_BUF_SIZE-2];
	__GETB1MN _gRx1Buf,18
	__PUTB1MN _gIrBuf,3
;     624 				return;
	CALL SUBOPT_0x15
	RETI
;     625 			}
;     626 			gRx1Step = 0;
_0x87:
	RJMP _0x31F
;     627 			F_DOWNLOAD = 0;
;     628 			RUN_LED2_OFF;
;     629        	 	break;
;     630     	case 1300:
_0x86:
	CPI  R30,LOW(0x514)
	LDI  R26,HIGH(0x514)
	CPC  R31,R26
	BRNE _0x89
;     631 			U1I_case100();
	CALL _U1I_case100
;     632     	    break;
	RJMP _0x50
;     633     	case 1301:
_0x89:
	CPI  R30,LOW(0x515)
	LDI  R26,HIGH(0x515)
	CPC  R31,R26
	BRNE _0x8A
;     634 			U1I_case301(1);
	CALL SUBOPT_0x19
;     635        	 	break;
	RJMP _0x50
;     636     	case 1302:
_0x8A:
	CPI  R30,LOW(0x516)
	LDI  R26,HIGH(0x516)
	CPC  R31,R26
	BRNE _0x8B
;     637 			gFileCheckSum ^= gRxData;
	CALL SUBOPT_0x7
;     638 			if(gRxData < 26)
	LDS  R26,_gRxData
	CPI  R26,LOW(0x1A)
	BRSH _0x8C
;     639 				gRx1Step++;
	CALL SUBOPT_0x4
;     640 			else{
	RJMP _0x8D
_0x8C:
;     641 			gRx1Step = 0;
	CALL SUBOPT_0x6
;     642 				F_DOWNLOAD = 0;
;     643 				RUN_LED2_OFF;
;     644 			}
_0x8D:
;     645        	 	break;
	RJMP _0x50
;     646     	case 1303:
_0x8B:
	CPI  R30,LOW(0x517)
	LDI  R26,HIGH(0x517)
	CPC  R31,R26
	BRNE _0x8E
;     647 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x8F
;     648 				SendToSoundIC(gRx1Buf[RX1_BUF_SIZE-2]);
	__GETB1MN _gRx1Buf,18
	ST   -Y,R30
	RCALL _SendToSoundIC
;     649 				delay_ms(200 + Sound_Length[gRx1Buf[RX1_BUF_SIZE-2]-1]);
	__GETB1MN _gRx1Buf,18
	SUBI R30,LOW(1)
	LDI  R26,LOW(_Sound_Length)
	LDI  R27,HIGH(_Sound_Length)
	CALL SUBOPT_0x1F
	SUBI R30,LOW(-200)
	SBCI R31,HIGH(-200)
	CALL SUBOPT_0x20
;     650 				SendToPC(21,1);
	LDI  R30,LOW(21)
	CALL SUBOPT_0x1A
;     651 				gFileCheckSum = 0;
;     652 				sciTx1Data(gRx1Buf[RX1_BUF_SIZE-2]);
	CALL SUBOPT_0x21
;     653 				gFileCheckSum ^= gRx1Buf[RX1_BUF_SIZE-2];
;     654 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     655 			}
;     656 			gRx1Step = 0;
_0x8F:
	RJMP _0x31F
;     657 			F_DOWNLOAD = 0;
;     658 			RUN_LED2_OFF;
;     659        	 	break;
;     660     	case 1400:
_0x8E:
	CPI  R30,LOW(0x578)
	LDI  R26,HIGH(0x578)
	CPC  R31,R26
	BRNE _0x90
;     661 			U1I_case100();
	CALL _U1I_case100
;     662     	    break;
	RJMP _0x50
;     663     	case 1401:
_0x90:
	CPI  R30,LOW(0x579)
	LDI  R26,HIGH(0x579)
	CPC  R31,R26
	BRNE _0x91
;     664 			U1I_case301(1);
	CALL SUBOPT_0x19
;     665        	 	break;
	RJMP _0x50
;     666     	case 1402:
_0x91:
	CPI  R30,LOW(0x57A)
	LDI  R26,HIGH(0x57A)
	CPC  R31,R26
	BRNE _0x92
;     667 			U1I_case302();
	CALL _U1I_case302
;     668        	 	break;
	RJMP _0x50
;     669     	case 1403:
_0x92:
	CPI  R30,LOW(0x57B)
	LDI  R26,HIGH(0x57B)
	CPC  R31,R26
	BRNE _0x93
;     670 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x94
;     671 				F_RSV_PSD_READ = 1;
	SET
	BLD  R3,7
;     672 			}
;     673 			gRx1Step = 0;
_0x94:
	RJMP _0x31F
;     674 			F_DOWNLOAD = 0;
;     675 			RUN_LED2_OFF;
;     676        	 	break;
;     677     	case 1500:
_0x93:
	CPI  R30,LOW(0x5DC)
	LDI  R26,HIGH(0x5DC)
	CPC  R31,R26
	BRNE _0x95
;     678 			U1I_case100();
	CALL _U1I_case100
;     679     	    break;
	RJMP _0x50
;     680     	case 1501:
_0x95:
	CPI  R30,LOW(0x5DD)
	LDI  R26,HIGH(0x5DD)
	CPC  R31,R26
	BRNE _0x96
;     681 			U1I_case301(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _U1I_case301
;     682        	 	break;
	RJMP _0x50
;     683     	case 1502:
_0x96:
	CPI  R30,LOW(0x5DE)
	LDI  R26,HIGH(0x5DE)
	CPC  R31,R26
	BRNE _0x97
;     684 			U1I_case502(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _U1I_case502
;     685        	 	break;
	RJMP _0x50
;     686     	case 1503:
_0x97:
	CPI  R30,LOW(0x5DF)
	LDI  R26,HIGH(0x5DF)
	CPC  R31,R26
	BRNE _0x98
;     687 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x99
;     688 				gSoundMinTh = gRx1Buf[RX1_BUF_SIZE-2];
	__GETB1MN _gRx1Buf,18
	STS  _gSoundMinTh,R30
;     689 				F_RSV_SOUND_READ = 1;
	SET
	BLD  R3,5
;     690 			}
;     691 			gRx1Step = 0;
_0x99:
	RJMP _0x31F
;     692 			F_DOWNLOAD = 0;
;     693 			RUN_LED2_OFF;
;     694        	 	break;
;     695     	case 1600:
_0x98:
	CPI  R30,LOW(0x640)
	LDI  R26,HIGH(0x640)
	CPC  R31,R26
	BRNE _0x9A
;     696 			U1I_case100();
	CALL _U1I_case100
;     697     	    break;
	RJMP _0x50
;     698     	case 1601:
_0x9A:
	CPI  R30,LOW(0x641)
	LDI  R26,HIGH(0x641)
	CPC  R31,R26
	BRNE _0x9B
;     699 			U1I_case301(1);
	CALL SUBOPT_0x19
;     700        	 	break;
	RJMP _0x50
;     701     	case 1602:
_0x9B:
	CPI  R30,LOW(0x642)
	LDI  R26,HIGH(0x642)
	CPC  R31,R26
	BRNE _0x9C
;     702 			U1I_case302();
	CALL _U1I_case302
;     703        	 	break;
	RJMP _0x50
;     704     	case 1603:
_0x9C:
	CPI  R30,LOW(0x643)
	LDI  R26,HIGH(0x643)
	CPC  R31,R26
	BRNE _0x9D
;     705 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0x9E
;     706 				F_RSV_BTN_READ = 1;
	SET
	BLD  R3,6
;     707 			}
;     708 			gRx1Step = 0;
_0x9E:
	RJMP _0x31F
;     709 			F_DOWNLOAD = 0;
;     710 			RUN_LED2_OFF;
;     711        	 	break;
;     712     	case 1800:
_0x9D:
	CPI  R30,LOW(0x708)
	LDI  R26,HIGH(0x708)
	CPC  R31,R26
	BRNE _0x9F
;     713 			U1I_case100();
	CALL _U1I_case100
;     714     	    break;
	RJMP _0x50
;     715     	case 1801:
_0x9F:
	CPI  R30,LOW(0x709)
	LDI  R26,HIGH(0x709)
	CPC  R31,R26
	BRNE _0xA0
;     716 			U1I_case301(1);
	CALL SUBOPT_0x19
;     717        	 	break;
	RJMP _0x50
;     718     	case 1802:
_0xA0:
	CPI  R30,LOW(0x70A)
	LDI  R26,HIGH(0x70A)
	CPC  R31,R26
	BRNE _0xA1
;     719 			U1I_case302();
	CALL _U1I_case302
;     720        	 	break;
	RJMP _0x50
;     721     	case 1803:
_0xA1:
	CPI  R30,LOW(0x70B)
	LDI  R26,HIGH(0x70B)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xA2
;     722 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BREQ PC+3
	JMP _0xA3
;     723 				SendToPC(26,6);
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _SendToPC
;     724 				gFileCheckSum = 0;
	LDI  R30,LOW(0)
	STS  _gFileCheckSum,R30
;     725 				if(gAccX < 0){
	LDS  R26,_gAccX
	CPI  R26,0
	BRGE _0xA4
;     726 	    			sciTx1Data(gAccX);
	LDS  R30,_gAccX
	CALL SUBOPT_0x22
;     727     				sciTx1Data(0xff);
	RJMP _0x320
;     728         	    }
;     729             	else{
_0xA4:
;     730 	    			sciTx1Data(gAccX);
	LDS  R30,_gAccX
	CALL SUBOPT_0x23
;     731     				sciTx1Data(0);
_0x320:
	ST   -Y,R30
	RCALL _sciTx1Data
;     732         	    }
;     733 				gFileCheckSum ^= gAccX;
	LDS  R30,_gAccX
	CALL SUBOPT_0xA
;     734 				if(gAccY < 0){
	LDS  R26,_gAccY
	CPI  R26,0
	BRGE _0xA6
;     735     				sciTx1Data(gAccY);
	LDS  R30,_gAccY
	CALL SUBOPT_0x22
;     736 	    			sciTx1Data(0xff);
	RJMP _0x321
;     737     	        }
;     738         	    else{
_0xA6:
;     739     				sciTx1Data(gAccY);
	LDS  R30,_gAccY
	CALL SUBOPT_0x23
;     740 	    			sciTx1Data(0);
_0x321:
	ST   -Y,R30
	RCALL _sciTx1Data
;     741     	        }
;     742 				gFileCheckSum ^= gAccY;
	LDS  R30,_gAccY
	CALL SUBOPT_0xA
;     743 				if(gAccZ < 0){
	LDS  R26,_gAccZ
	CPI  R26,0
	BRGE _0xA8
;     744 	    			sciTx1Data(gAccZ);
	LDS  R30,_gAccZ
	CALL SUBOPT_0x22
;     745     				sciTx1Data(0xff);
	RJMP _0x322
;     746         	    }
;     747             	else{
_0xA8:
;     748 	    			sciTx1Data(gAccZ);
	LDS  R30,_gAccZ
	CALL SUBOPT_0x23
;     749     				sciTx1Data(0);
_0x322:
	ST   -Y,R30
	RCALL _sciTx1Data
;     750         	    }
;     751 				gFileCheckSum ^= gAccZ;
	LDS  R30,_gAccZ
	CALL SUBOPT_0xA
;     752 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     753 			}
;     754 			gRx1Step = 0;			// 다운로드 종료
_0xA3:
	RJMP _0x31F
;     755 			F_DOWNLOAD = 0;			// 다운로드 중 표시 해제
;     756 			RUN_LED2_OFF;			// 연결 상태 LED 표시 해제
;     757        	 	break;
;     758     	case 2300:
_0xA2:
	CPI  R30,LOW(0x8FC)
	LDI  R26,HIGH(0x8FC)
	CPC  R31,R26
	BRNE _0xAA
;     759 			U1I_case100();
	CALL _U1I_case100
;     760     	    break;
	RJMP _0x50
;     761     	case 2301:
_0xAA:
	CPI  R30,LOW(0x8FD)
	LDI  R26,HIGH(0x8FD)
	CPC  R31,R26
	BRNE _0xAB
;     762 			U1I_case301(1);
	CALL SUBOPT_0x19
;     763        	 	break;
	RJMP _0x50
;     764     	case 2302:
_0xAB:
	CPI  R30,LOW(0x8FE)
	LDI  R26,HIGH(0x8FE)
	CPC  R31,R26
	BRNE _0xAC
;     765 			gFileCheckSum ^= gRxData;
	CALL SUBOPT_0x7
;     766 			if(gRxData < 4)
	LDS  R26,_gRxData
	CPI  R26,LOW(0x4)
	BRSH _0xAD
;     767 				gRx1Step++;
	CALL SUBOPT_0x4
;     768 			else{
	RJMP _0xAE
_0xAD:
;     769 				gRx1Step = 0;
	CALL SUBOPT_0x6
;     770 				F_DOWNLOAD = 0;
;     771 				RUN_LED2_OFF;
;     772 			}
_0xAE:
;     773        	 	break;
	RJMP _0x50
;     774     	case 2303:
_0xAC:
	CPI  R30,LOW(0x8FF)
	LDI  R26,HIGH(0x8FF)
	CPC  R31,R26
	BRNE _0x50
;     775 			if(gFileCheckSum == gRxData){
	CALL SUBOPT_0xC
	BRNE _0xB0
;     776 				if(gRx1Buf[RX1_BUF_SIZE-2] == 1){
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x1)
	BRNE _0xB1
;     777 					gDownNumOfM = 0;
	LDI  R30,LOW(0)
	STS  _gDownNumOfM,R30
;     778 					eNumOfM = 0;
	LDI  R26,LOW(_eNumOfM)
	LDI  R27,HIGH(_eNumOfM)
	CALL __EEPROMWRB
;     779 				}
;     780 				else if(gRx1Buf[RX1_BUF_SIZE-2] == 2){
	RJMP _0xB2
_0xB1:
	__GETB1MN _gRx1Buf,18
	CPI  R30,LOW(0x2)
	BRNE _0xB3
;     781 					gDownNumOfA = 0;
	LDI  R30,LOW(0)
	STS  _gDownNumOfA,R30
;     782 					eNumOfA = 0;
	LDI  R26,LOW(_eNumOfA)
	LDI  R27,HIGH(_eNumOfA)
	CALL __EEPROMWRB
;     783 				}
;     784 				SendToPC(31,1);
_0xB3:
_0xB2:
	LDI  R30,LOW(31)
	CALL SUBOPT_0x1A
;     785 				gFileCheckSum = 0;
;     786 				sciTx1Data(gRx1Buf[RX1_BUF_SIZE-2]);
	CALL SUBOPT_0x21
;     787 				gFileCheckSum ^= gRx1Buf[RX1_BUF_SIZE-2];
;     788 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;     789 			}
;     790 			gRx1Step = 0;
_0xB0:
_0x31F:
	LDI  R30,0
	STS  _gRx1Step,R30
	STS  _gRx1Step+1,R30
;     791 			F_DOWNLOAD = 0;
	CLT
	BLD  R2,4
;     792 			RUN_LED2_OFF;
	SBI  0x1B,6
;     793        	 	break;
;     794 	}
_0x50:
;     795 	UCSR0B |= 0x40;
	CALL SUBOPT_0x18
;     796 	EIMSK |= 0x40;
;     797 }
	CALL SUBOPT_0x15
	RETI
;     798 
;     799 
;     800 //------------------------------------------------------------------------------
;     801 // 타이머0 오버플로 인터럽트
;     802 //------------------------------------------------------------------------------
;     803 interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     804 	TCNT0 = 111;
	LDI  R30,LOW(111)
	OUT  0x32,R30
;     805 	if(++g10MSEC > 99){
	CALL SUBOPT_0x24
	ADIW R26,1
	STS  _g10MSEC,R26
	STS  _g10MSEC+1,R27
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0xB4
;     806         g10MSEC = 0;
	LDI  R30,0
	STS  _g10MSEC,R30
	STS  _g10MSEC+1,R30
;     807         if(gSEC_DCOUNT > 0)	gSEC_DCOUNT--;
	LDS  R26,_gSEC_DCOUNT
	LDS  R27,_gSEC_DCOUNT+1
	CALL __CPW02
	BRSH _0xB5
	CALL SUBOPT_0x25
	SBIW R30,1
	CALL SUBOPT_0x26
;     808         if(++gSEC > 59){
_0xB5:
	LDS  R26,_gSEC
	SUBI R26,-LOW(1)
	STS  _gSEC,R26
	CPI  R26,LOW(0x3C)
	BRLO _0xB6
;     809             gSEC = 0;
	LDI  R30,LOW(0)
	STS  _gSEC,R30
;     810 	        if(gMIN_DCOUNT > 0)	gMIN_DCOUNT--;
	LDS  R26,_gMIN_DCOUNT
	LDS  R27,_gMIN_DCOUNT+1
	CALL __CPW02
	BRSH _0xB7
	CALL SUBOPT_0x27
	SBIW R30,1
	CALL SUBOPT_0x28
;     811             if(++gMIN > 59){
_0xB7:
	LDS  R26,_gMIN
	SUBI R26,-LOW(1)
	STS  _gMIN,R26
	CPI  R26,LOW(0x3C)
	BRLO _0xB8
;     812                 gMIN = 0;
	LDI  R30,LOW(0)
	STS  _gMIN,R30
;     813                 if(++gHOUR > 23)
	LDS  R26,_gHOUR
	SUBI R26,-LOW(1)
	STS  _gHOUR,R26
	CPI  R26,LOW(0x18)
	BRLO _0xB9
;     814                     gHOUR = 0;
	STS  _gHOUR,R30
;     815             }
_0xB9:
;     816 		}
_0xB8:
;     817     }
_0xB6:
;     818 }
_0xB4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
;     819 
;     820 //------------------------------------------------------------------------------
;     821 // 타이머1 오버플로 인터럽트
;     822 //------------------------------------------------------------------------------
;     823 interrupt [TIM1_OVF] void timer1_ovf_isr(void) {
_timer1_ovf_isr:
	CALL SUBOPT_0x13
;     824 	if( gFrameIdx == Scene.NumOfFrame ) {
	CALL SUBOPT_0x29
	LDS  R26,_gFrameIdx
	LDS  R27,_gFrameIdx+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0xBA
;     825    	    gFrameIdx = 0;
	LDI  R30,0
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R30
;     826     	RUN_LED1_OFF;
	SBI  0x1B,5
;     827 		F_SCENE_PLAYING = 0;
	CLT
	BLD  R2,0
;     828 		TIMSK &= 0xfb;
	IN   R30,0x37
	ANDI R30,0xFB
	OUT  0x37,R30
;     829 		TCCR1B = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
;     830 		return;
	CALL SUBOPT_0x2A
	RETI
;     831 	}
;     832 	TCNT1 = TxInterval;
_0xBA:
	LDS  R30,_TxInterval
	LDS  R31,_TxInterval+1
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;     833 	TIFR |= 0x04;
	CALL SUBOPT_0x2B
;     834 	TIMSK |= 0x04;
;     835 	MakeFrame();
	CALL SUBOPT_0x2C
;     836 	SendFrame();
;     837 }
	CALL SUBOPT_0x2A
	RETI
;     838 
;     839 
;     840 //------------------------------------------------------------------------------
;     841 // 리모컨 수신용 IR수신 인터럽트
;     842 //------------------------------------------------------------------------------
;     843 interrupt [EXT_INT6] void ext_int6_isr(void) {
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
;     844 	BYTE width;
;     845 	WORD i;
;     846 
;     847 	width = TCNT2;
	CALL __SAVELOCR3
;	width -> R16
;	i -> R17,R18
	IN   R16,36
;     848 	TCNT2 = 0;
	LDI  R30,LOW(0)
	OUT  0x24,R30
;     849 
;     850 	if(gIrBitIndex == 0xFF){
	LDS  R26,_gIrBitIndex
	CPI  R26,LOW(0xFF)
	BRNE _0xBB
;     851 		if((width >= IR_HEADER_LT) && (width <= IR_HEADER_UT)){
	CPI  R16,63
	BRLO _0xBD
	CPI  R16,82
	BRLO _0xBE
_0xBD:
	RJMP _0xBC
_0xBE:
;     852 			F_IR_RECEIVED = 0;
	CLT
	BLD  R3,2
;     853 			gIrBitIndex = 0;
	LDI  R30,LOW(0)
	STS  _gIrBitIndex,R30
;     854 			for(i = 0; i < IR_BUFFER_SIZE; i++)
	__GETWRN 17,18,0
_0xC0:
	__CPWRN 17,18,4
	BRSH _0xC1
;     855                 gIrBuf[i] = 0;
	LDI  R26,LOW(_gIrBuf)
	LDI  R27,HIGH(_gIrBuf)
	ADD  R26,R17
	ADC  R27,R18
	LDI  R30,LOW(0)
	ST   X,R30
;     856         }
	__ADDWRN 17,18,1
	RJMP _0xC0
_0xC1:
;     857 	}
_0xBC:
;     858 	else{
	RJMP _0xC2
_0xBB:
;     859         if((width >= IR_LOW_BIT_LT)&&(width <= IR_LOW_BIT_UT))
	CPI  R16,10
	BRLO _0xC4
	CPI  R16,19
	BRLO _0xC5
_0xC4:
	RJMP _0xC3
_0xC5:
;     860             gIrBitIndex++;
	LDS  R30,_gIrBitIndex
	SUBI R30,-LOW(1)
	RJMP _0x323
;     861         else if((width >= IR_HIGH_BIT_LT)&&(width <= IR_HIGH_BIT_UT)){
_0xC3:
	CPI  R16,19
	BRLO _0xC8
	CPI  R16,27
	BRLO _0xC9
_0xC8:
	RJMP _0xC7
_0xC9:
;     862             if(gIrBitIndex != 0)
	LDS  R30,_gIrBitIndex
	CPI  R30,0
	BREQ _0xCA
;     863                 gIrBuf[(BYTE)(gIrBitIndex/8)] |= 0x01<<(gIrBitIndex%8);
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
;     864             else
	RJMP _0xCB
_0xCA:
;     865                 gIrBuf[0] = 0x01;
	LDI  R30,LOW(1)
	STS  _gIrBuf,R30
;     866             gIrBitIndex++;
_0xCB:
	LDS  R30,_gIrBitIndex
	SUBI R30,-LOW(1)
	RJMP _0x323
;     867         }
;     868         else gIrBitIndex = 0xFF;
_0xC7:
	LDI  R30,LOW(255)
_0x323:
	STS  _gIrBitIndex,R30
;     869       
;     870         if(gIrBitIndex == (IR_BUFFER_SIZE * 8)){
	LDS  R26,_gIrBitIndex
	CPI  R26,LOW(0x20)
	BRNE _0xCD
;     871             F_IR_RECEIVED = 1;
	SET
	BLD  R3,2
;     872             gIrBitIndex = 0xFF;
	LDI  R30,LOW(255)
	STS  _gIrBitIndex,R30
;     873 		}
;     874 	}
_0xCD:
_0xC2:
;     875 }
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
;     876 
;     877 
;     878 //------------------------------------------------------------------------------
;     879 // A/D 변환 완료 인터럽트
;     880 //------------------------------------------------------------------------------
;     881 interrupt [ADC_INT] void adc_isr(void) {
_adc_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     882 	WORD i;
;     883 	gAD_val=(signed char)ADCH;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	IN   R11,5
;     884 	switch(gAD_Ch_Index){
	MOV  R30,R4
;     885 		case PSD_CH:
	CPI  R30,0
	BRNE _0xD1
;     886     	    gPSD_val = (BYTE)gAD_val;
	MOV  R9,R11
;     887 			break; 
	RJMP _0xD0
;     888 		case VOLTAGE_CH:
_0xD1:
	CPI  R30,LOW(0x1)
	BRNE _0xD2
;     889 			i = (BYTE)gAD_val;
	MOV  R16,R11
	CLR  R17
;     890 			gVOLTAGE = i*57;
	__MULBNWRU 16,17,57
	__PUTW1R 5,6
;     891 			break; 
	RJMP _0xD0
;     892 		case MIC_CH:
_0xD2:
	CPI  R30,LOW(0xF)
	BRNE _0xD0
;     893 			if((BYTE)gAD_val < 230)
	LDI  R30,LOW(230)
	CP   R11,R30
	BRSH _0xD4
;     894 				gMIC_val = (BYTE)gAD_val;
	MOV  R10,R11
;     895 			else
	RJMP _0xD5
_0xD4:
;     896 				gMIC_val = 0;
	CLR  R10
;     897 			break; 
_0xD5:
;     898 	}  
_0xD0:
;     899 	F_AD_CONVERTING = 0;    
	CLT
	BLD  R2,7
;     900 }
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
;     901 
;     902 
;     903 void ADC_set(BYTE mode)
;     904 {                                    
_ADC_set:
;     905 	ADMUX=0x20 | gAD_Ch_Index;
;	mode -> Y+0
	MOV  R30,R4
	ORI  R30,0x20
	OUT  0x7,R30
;     906 	ADCSRA=mode;     
	LD   R30,Y
	OUT  0x6,R30
;     907 }		
	ADIW R28,1
	RET
;     908 
;     909 
;     910 //------------------------------------------------------------------------------
;     911 // 전원 검사
;     912 //------------------------------------------------------------------------------
;     913 void DetectPower(void)
;     914 {
_DetectPower:
;     915 	if(F_DOWNLOAD) return;
	SBRC R2,4
	RET
;     916 	if(F_PS_PLUGGED){
	SBRS R2,5
	RJMP _0xD7
;     917 		if(gVOLTAGE >= U_T_OF_POWER)
	LDI  R30,LOW(9650)
	LDI  R31,HIGH(9650)
	CP   R5,R30
	CPC  R6,R31
	BRLO _0xD8
;     918 			gPSunplugCount = 0;
	CALL SUBOPT_0x2D
;     919 		else
	RJMP _0xD9
_0xD8:
;     920 			gPSunplugCount++;
	LDS  R30,_gPSunplugCount
	LDS  R31,_gPSunplugCount+1
	ADIW R30,1
	STS  _gPSunplugCount,R30
	STS  _gPSunplugCount+1,R31
;     921 		if(gPSunplugCount > 6){
_0xD9:
	LDS  R26,_gPSunplugCount
	LDS  R27,_gPSunplugCount+1
	SBIW R26,7
	BRLO _0xDA
;     922 			F_PS_PLUGGED = 0;
	CLT
	BLD  R2,5
;     923 			gPSunplugCount = 0;
	CALL SUBOPT_0x2D
;     924 		}
;     925 	}
_0xDA:
;     926 	else{
	RJMP _0xDB
_0xD7:
;     927 		if(gVOLTAGE >= U_T_OF_POWER){
	LDI  R30,LOW(9650)
	LDI  R31,HIGH(9650)
	CP   R5,R30
	CPC  R6,R31
	BRLO _0xDC
;     928 			gPSunplugCount = 0;
	CALL SUBOPT_0x2D
;     929 			gPSplugCount++;
	LDS  R30,_gPSplugCount
	LDS  R31,_gPSplugCount+1
	ADIW R30,1
	STS  _gPSplugCount,R30
	STS  _gPSplugCount+1,R31
;     930 		}
;     931 		else{
	RJMP _0xDD
_0xDC:
;     932 			gPSplugCount = 0;
	LDI  R30,0
	STS  _gPSplugCount,R30
	STS  _gPSplugCount+1,R30
;     933 		}
_0xDD:
;     934 
;     935 		if(gPSplugCount>2){
	LDS  R26,_gPSplugCount
	LDS  R27,_gPSplugCount+1
	SBIW R26,3
	BRLO _0xDE
;     936 			F_PS_PLUGGED = 1;
	SET
	BLD  R2,5
;     937 			gPSplugCount = 0;
	LDI  R30,0
	STS  _gPSplugCount,R30
	STS  _gPSplugCount+1,R30
;     938 		}
;     939 	}
_0xDE:
_0xDB:
;     940 }
	RET
;     941 
;     942 
;     943 //-----------------------------------------------------------------------------
;     944 // NiMH 배터리 충전
;     945 //-----------------------------------------------------------------------------
;     946 void ChargeNiMH(void)
;     947 {
_ChargeNiMH:
;     948 	F_CHARGING = 1;
	SET
	BLD  R2,6
;     949 	gMIN_DCOUNT = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x28
;     950 	while(gMIN_DCOUNT){
_0xDF:
	CALL SUBOPT_0x27
	SBIW R30,0
	BREQ _0xE1
;     951 		PWR_LED2_OFF;
	SBI  0x15,7
;     952 		PWR_LED1_ON;
	CALL SUBOPT_0x2E
;     953 		Get_VOLTAGE();	DetectPower();
	CALL SUBOPT_0x2F
;     954 		if(F_PS_PLUGGED == 0) break;
	SBRS R2,5
	RJMP _0xE1
;     955 		CHARGE_ENABLE;
	SBI  0x18,4
;     956 		delay_ms(40);
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x20
;     957 		CHARGE_DISABLE;
	CBI  0x18,4
;     958 		delay_ms(500-40);
	LDI  R30,LOW(460)
	LDI  R31,HIGH(460)
	CALL SUBOPT_0x20
;     959 		PWR_LED1_OFF;
	CALL SUBOPT_0x30
;     960 		Get_VOLTAGE();	DetectPower();
	CALL SUBOPT_0x2F
;     961 		if(F_PS_PLUGGED == 0) break;
	SBRS R2,5
	RJMP _0xE1
;     962 		delay_ms(500);
	CALL SUBOPT_0x31
;     963 	}
	RJMP _0xDF
_0xE1:
;     964 	gMIN_DCOUNT = 85;
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	CALL SUBOPT_0x28
;     965 	while(gMIN_DCOUNT){
_0xE4:
	CALL SUBOPT_0x27
	SBIW R30,0
	BREQ _0xE6
;     966 		PWR_LED2_OFF;
	SBI  0x15,7
;     967 		if(g10MSEC > 50)	PWR_LED1_ON;
	CALL SUBOPT_0x24
	SBIW R26,51
	BRLO _0xE7
	LDS  R30,101
	ANDI R30,0xFB
	RJMP _0x324
;     968 		else			PWR_LED1_OFF;
_0xE7:
	LDS  R30,101
	ORI  R30,4
_0x324:
	STS  101,R30
;     969 		if(g10MSEC == 0 || g10MSEC == 50){
	CALL SUBOPT_0x32
	BREQ _0xEA
	CALL SUBOPT_0x24
	SBIW R26,50
	BRNE _0xE9
_0xEA:
;     970 			Get_VOLTAGE();
	CALL SUBOPT_0x2F
;     971 			DetectPower();
;     972 		}
;     973 		if(F_PS_PLUGGED == 0) break;
_0xE9:
	SBRS R2,5
	RJMP _0xE6
;     974 		CHARGE_ENABLE;
	SBI  0x18,4
;     975 	}
	RJMP _0xE4
_0xE6:
;     976 	CHARGE_DISABLE;
	CBI  0x18,4
;     977 	F_CHARGING = 0;
	CLT
	BLD  R2,6
;     978 }
	RET
;     979 
;     980 
;     981 //------------------------------------------------------------------------------
;     982 // 하드웨어 초기화
;     983 //------------------------------------------------------------------------------
;     984 void HW_init(void) {
_HW_init:
;     985 	// Input/Output Ports initialization
;     986 	// Port A initialization
;     987 	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
;     988 	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=P State0=P 
;     989 	PORTA=0x03;
	LDI  R30,LOW(3)
	OUT  0x1B,R30
;     990 	DDRA=0xFC;
	LDI  R30,LOW(252)
	OUT  0x1A,R30
;     991 
;     992 	// Port B initialization
;     993 	// Func7=In Func6=Out Func5=Out Func4=Out Func3=In Func2=Out Func1=In Func0=In 
;     994 	// State7=T State6=0 State5=0 State4=0 State3=T State2=0 State1=T State0=T 
;     995 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     996 	DDRB=0x74;
	LDI  R30,LOW(116)
	OUT  0x17,R30
;     997 
;     998 	// Port C initialization
;     999 	// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;    1000 	// State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;    1001 	PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    1002 	DDRC=0x80;
	LDI  R30,LOW(128)
	OUT  0x14,R30
;    1003 
;    1004 	// Port D initialization
;    1005 	// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;    1006 	// State7=1 State6=T State5=T State4=T State3=T State2=T State1=P State0=P 
;    1007 	PORTD=0x83;
	LDI  R30,LOW(131)
	OUT  0x12,R30
;    1008 	DDRD=0x80;
	LDI  R30,LOW(128)
	OUT  0x11,R30
;    1009 
;    1010 	// Port E initialization
;    1011 	// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In 
;    1012 	// State7=T State6=T State5=P State4=P State3=0 State2=T State1=T State0=T 
;    1013 	PORTE=0x30;
	LDI  R30,LOW(48)
	OUT  0x3,R30
;    1014 	DDRE=0x08;
	LDI  R30,LOW(8)
	OUT  0x2,R30
;    1015 
;    1016     // Port F initialization
;    1017     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;    1018     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;    1019     PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
;    1020     DDRF=0x00;
	STS  97,R30
;    1021 
;    1022 	// Port G initialization
;    1023 	// Func4=In Func3=In Func2=Out Func1=In Func0=In 
;    1024 	// State4=T State3=T State2=0 State1=T State0=T 
;    1025 	PORTG=0x00;
	STS  101,R30
;    1026 	DDRG=0x04;
	LDI  R30,LOW(4)
	STS  100,R30
;    1027 
;    1028     // Timer/Counter 0 initialization
;    1029     // Clock source: System Clock
;    1030     // Clock value: 14.400 kHz
;    1031     // Mode: Normal top=FFh
;    1032     // OC0 output: Disconnected
;    1033     ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1034     TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
;    1035     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;    1036     OCR0=0x00;
	OUT  0x31,R30
;    1037 
;    1038 	// Timer/Counter 1 initialization
;    1039 	// Clock source: System Clock
;    1040 	// Clock value: 14.400 kHz
;    1041 	// Mode: Normal top=FFFFh
;    1042 	// OC1A output: Discon.
;    1043 	// OC1B output: Discon.
;    1044 	// OC1C output: Discon.
;    1045 	// Noise Canceler: Off
;    1046 	// Input Capture on Falling Edge
;    1047 	// Timer 1 Overflow Interrupt: On
;    1048 	// Input Capture Interrupt: Off
;    1049 	// Compare A Match Interrupt: Off
;    1050 	// Compare B Match Interrupt: Off
;    1051 	// Compare C Match Interrupt: Off
;    1052 	TCCR1A=0x00;
	OUT  0x2F,R30
;    1053 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;    1054 	TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;    1055 	TCNT1L=0x00;
	OUT  0x2C,R30
;    1056 	ICR1H=0x00;
	OUT  0x27,R30
;    1057 	ICR1L=0x00;
	OUT  0x26,R30
;    1058 	OCR1AH=0x00;
	OUT  0x2B,R30
;    1059 	OCR1AL=0x00;
	OUT  0x2A,R30
;    1060 	OCR1BH=0x00;
	OUT  0x29,R30
;    1061 	OCR1BL=0x00;
	OUT  0x28,R30
;    1062 	OCR1CH=0x00;
	STS  121,R30
;    1063 	OCR1CL=0x00;
	STS  120,R30
;    1064 
;    1065 	// 타이머 2---------------------------------------------------------------
;    1066     // Timer/Counter 2 initialization
;    1067     // Clock source: System Clock
;    1068     // Clock value: 14.400 kHz
;    1069     // Mode: Normal top=FFh
;    1070     // OC2 output: Disconnected
;    1071     TCCR2=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
;    1072     TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
;    1073     OCR2=0x00;
	OUT  0x23,R30
;    1074 
;    1075 	// 타이머 3---------------------------------------------------------------
;    1076 	// Timer/Counter 3 initialization
;    1077 	// Clock source: System Clock
;    1078 	// Clock value: 230.400 kHz
;    1079 	// Mode: Normal top=FFFFh
;    1080 	// Noise Canceler: Off
;    1081 	// Input Capture on Falling Edge
;    1082 	// OC3A output: Discon.
;    1083 	// OC3B output: Discon.
;    1084 	// OC3C output: Discon.
;    1085 	// Timer 3 Overflow Interrupt: Off
;    1086 	// Input Capture Interrupt: Off
;    1087 	// Compare A Match Interrupt: Off
;    1088 	// Compare B Match Interrupt: Off
;    1089 	// Compare C Match Interrupt: Off
;    1090 	TCCR3A=0x00;
	STS  139,R30
;    1091 	TCCR3B=0x03;
	LDI  R30,LOW(3)
	STS  138,R30
;    1092 	TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
;    1093 	TCNT3L=0x00;
	STS  136,R30
;    1094 	ICR3H=0x00;
	STS  129,R30
;    1095 	ICR3L=0x00;
	STS  128,R30
;    1096 	OCR3AH=0x00;
	STS  135,R30
;    1097 	OCR3AL=0x00;
	STS  134,R30
;    1098 	OCR3BH=0x00;
	STS  133,R30
;    1099 	OCR3BL=0x00;
	STS  132,R30
;    1100 	OCR3CH=0x00;
	STS  131,R30
;    1101 	OCR3CL=0x00;
	STS  130,R30
;    1102 
;    1103 	// External Interrupt(s) initialization
;    1104 	// INT0: Off
;    1105 	// INT1: Off
;    1106 	// INT2: Off
;    1107 	// INT3: Off
;    1108 	// INT4: Off
;    1109 	// INT5: Off
;    1110 	// INT6: On
;    1111 	// INT6 Mode: Falling Edge
;    1112 	// INT7: Off
;    1113 	EICRA=0x00;
	STS  106,R30
;    1114 	EICRB=0x20;
	LDI  R30,LOW(32)
	OUT  0x3A,R30
;    1115 	EIMSK=0x40;
	LDI  R30,LOW(64)
	OUT  0x39,R30
;    1116 	EIFR=0x40;
	OUT  0x38,R30
;    1117 
;    1118     // Timer(s)/Counter(s) Interrupt(s) initialization
;    1119     TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
;    1120     ETIMSK=0x00;
	STS  125,R30
;    1121 
;    1122     // USART0 initialization
;    1123     // Communication Parameters: 8 Data, 1 Stop, No Parity
;    1124     // USART0 Receiver: On
;    1125     // USART0 Transmitter: On
;    1126     // USART0 Mode: Asynchronous
;    1127     // USART0 Baud rate: 115200
;    1128     UCSR0A=0x00;
	OUT  0xB,R30
;    1129 	UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
;    1130     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
;    1131     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;    1132 	UBRR0L=BR115200;
	LDI  R30,LOW(7)
	OUT  0x9,R30
;    1133 
;    1134     // USART1 initialization
;    1135     // Communication Parameters: 8 Data, 1 Stop, No Parity
;    1136     // USART1 Receiver: On
;    1137     // USART1 Transmitter: On
;    1138     // USART1 Mode: Asynchronous
;    1139     // USART1 Baud rate: 115200
;    1140     UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
;    1141     UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
;    1142     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;    1143     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
;    1144 	UBRR1L=BR115200;
	LDI  R30,LOW(7)
	STS  153,R30
;    1145 
;    1146 	// Analog Comparator initialization
;    1147 	// Analog Comparator: Off
;    1148 	// Analog Comparator Input Capture by Timer/Counter 1: Off
;    1149 	// Analog Comparator Output: Off
;    1150 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    1151 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;    1152 
;    1153     //ADC initialization
;    1154     //ADC Clock frequency: 460.800 kHz
;    1155     //ADC Voltage Reference: AREF pin
;    1156     //Only the 8 most significant bits of
;    1157     //the AD conversion result are used
;    1158     ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(32)
	OUT  0x7,R30
;    1159     ADCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x6,R30
;    1160     
;    1161     TWCR = 0;
	STS  116,R30
;    1162 }
	RET
;    1163 
;    1164 
;    1165 //------------------------------------------------------------------------------
;    1166 // 플래그 초기화
;    1167 //------------------------------------------------------------------------------
;    1168 void SW_init(void) {
_SW_init:
;    1169 	PF1_LED1_OFF;
	SBI  0x1B,2
;    1170 	PF1_LED2_OFF;
	SBI  0x1B,3
;    1171 	PF2_LED_OFF;
	SBI  0x1B,4
;    1172 	PWR_LED1_OFF;
	CALL SUBOPT_0x30
;    1173 	PWR_LED2_OFF;
	SBI  0x15,7
;    1174 	RUN_LED1_OFF;
	SBI  0x1B,5
;    1175 	RUN_LED2_OFF;
	SBI  0x1B,6
;    1176 	ERR_LED_OFF;
	SBI  0x1B,7
;    1177 	F_PF = ePF;
	LDI  R26,LOW(_ePF)
	LDI  R27,HIGH(_ePF)
	CALL __EEPROMRDB
	MOV  R12,R30
;    1178 	F_SCENE_PLAYING = 0;
	CLT
	BLD  R2,0
;    1179 	F_ACTION_PLAYING = 0;
	BLD  R2,1
;    1180 	F_MOTION_STOPPED = 0;
	BLD  R2,3
;    1181 	F_DIRECT_C_EN = 0;
	BLD  R2,2
;    1182 	F_CHARGING = 0;
	BLD  R2,6
;    1183 	F_MIC_INPUT = 0;
	BLD  R3,0
;    1184 	F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;    1185 	F_DOWNLOAD = 0;
	BLD  R2,4
;    1186 
;    1187 	gTx0Cnt = 0;
	LDI  R30,LOW(0)
	STS  _gTx0Cnt,R30
;    1188 	gTx0BufIdx = 0;
	STS  _gTx0BufIdx,R30
;    1189 	PSD_OFF;
	CBI  0x18,5
;    1190     g10MSEC=0;
	LDI  R30,0
	STS  _g10MSEC,R30
	STS  _g10MSEC+1,R30
;    1191     gSEC=0;
	LDI  R30,LOW(0)
	STS  _gSEC,R30
;    1192     gMIN=0;
	STS  _gMIN,R30
;    1193     gHOUR=0;
	STS  _gHOUR,R30
;    1194     F_PS_PLUGGED = 0;
	BLD  R2,5
;    1195     F_PF_CHANGED = 0;
	BLD  R3,1
;    1196     F_IR_RECEIVED = 0;
	BLD  R3,2
;    1197     F_EEPROM_BUSY = 0;
	CLR  R14
;    1198 	P_EEP_VCC(1);
	SBI  0x18,2
;    1199 
;    1200 	gDownNumOfM = 0;
	STS  _gDownNumOfM,R30
;    1201 	gDownNumOfA = 0;
	STS  _gDownNumOfA,R30
;    1202 	F_FIRST_M = 1;
	SET
	BLD  R3,3
;    1203 }
	RET
;    1204 
;    1205 
;    1206 void SpecialMode(void)
;    1207 {
_SpecialMode:
;    1208 	int i;
;    1209 
;    1210 	if(F_PF == PF1_HUNO)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xEF
;    1211 		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	__GETWRN 16,17,0
_0xF1:
	__CPWRN 16,17,16
	BRGE _0xF2
	CALL SUBOPT_0x33
;    1212 	else if(F_PF == PF1_DINO)
	__ADDWRN 16,17,1
	RJMP _0xF1
_0xF2:
	RJMP _0xF3
_0xEF:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xF4
;    1213 		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	__GETWRN 16,17,0
_0xF6:
	__CPWRN 16,17,16
	BRGE _0xF7
	CALL SUBOPT_0x33
;    1214 	else if(F_PF == PF1_DOGY)
	__ADDWRN 16,17,1
	RJMP _0xF6
_0xF7:
	RJMP _0xF8
_0xF4:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0xF9
;    1215 		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	__GETWRN 16,17,0
_0xFB:
	__CPWRN 16,17,16
	BRGE _0xFC
	CALL SUBOPT_0x33
;    1216 	else if(F_PF == PF2)
	__ADDWRN 16,17,1
	RJMP _0xFB
_0xFC:
	RJMP _0xFD
_0xF9:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0xFE
;    1217 		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	__GETWRN 16,17,0
_0x100:
	__CPWRN 16,17,16
	BRGE _0x101
	CALL SUBOPT_0x33
;    1218 
;    1219 	BreakModeCmdSend();
	__ADDWRN 16,17,1
	RJMP _0x100
_0x101:
_0xFE:
_0xFD:
_0xF8:
_0xF3:
	RCALL _BreakModeCmdSend
;    1220 	delay_ms(10);
	CALL SUBOPT_0x34
;    1221 	
;    1222 	if(PINA.0 == 0 && PINA.1 == 1){
	SBIC 0x19,0
	RJMP _0x103
	SBIC 0x19,1
	RJMP _0x104
_0x103:
	RJMP _0x102
_0x104:
;    1223 		BasicPose(0, 150, 3000, 4);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CALL SUBOPT_0x35
;    1224 		delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x20
;    1225 		if(F_ERR_CODE != NO_ERR){
	LDI  R30,LOW(255)
	CP   R30,R13
	BREQ _0x105
;    1226 			gSEC_DCOUNT = 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x26
;    1227 			EIMSK &= 0xBF;
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;    1228 			while(gSEC_DCOUNT){
_0x106:
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0x108
;    1229 				if(g10MSEC < 25)		ERR_LED_ON;
	CALL SUBOPT_0x24
	SBIW R26,25
	BRSH _0x109
	CBI  0x1B,7
;    1230 				else if(g10MSEC < 50)	ERR_LED_OFF;
	RJMP _0x10A
_0x109:
	CALL SUBOPT_0x24
	SBIW R26,50
	BRSH _0x10B
	RJMP _0x325
;    1231 				else if(g10MSEC < 75)	ERR_LED_ON;
_0x10B:
	CALL SUBOPT_0x36
	BRSH _0x10D
	CBI  0x1B,7
;    1232 				else if(g10MSEC < 100)	ERR_LED_OFF;
	RJMP _0x10E
_0x10D:
	CALL SUBOPT_0x37
	BRSH _0x10F
_0x325:
	SBI  0x1B,7
;    1233 			}
_0x10F:
_0x10E:
_0x10A:
	RJMP _0x106
_0x108:
;    1234 			F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;    1235 			EIMSK |= 0x40;
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    1236 		}
;    1237 		else BasicPose(0, 1, 100, 1);
	RJMP _0x110
_0x105:
	CALL SUBOPT_0x38
;    1238 	}
_0x110:
;    1239 	else if(PINA.0 == 1 && PINA.1 == 0){
	RJMP _0x111
_0x102:
	SBIS 0x19,0
	RJMP _0x113
	SBIS 0x19,1
	RJMP _0x114
_0x113:
	RJMP _0x112
_0x114:
;    1240 		delay_ms(10);
	CALL SUBOPT_0x34
;    1241 		if(PINA.0 == 1){
	SBIS 0x19,0
	RJMP _0x115
;    1242 		    TIMSK &= 0xFE;
	CALL SUBOPT_0x1D
;    1243 			EIMSK &= 0xBF;
;    1244 			UCSR0B |= 0x80;
;    1245 			UCSR0B &= 0xBF;
;    1246 			F_DIRECT_C_EN = 1;
;    1247 		}
;    1248 	}
_0x115:
;    1249 	else if(PINA.0 == 0 && PINA.1 == 0){
	RJMP _0x116
_0x112:
	SBIC 0x19,0
	RJMP _0x118
	SBIS 0x19,1
	RJMP _0x119
_0x118:
	RJMP _0x117
_0x119:
;    1250 		while(gSEC < 11){
_0x11A:
	LDS  R26,_gSEC
	CPI  R26,LOW(0xB)
	BRLO PC+3
	JMP _0x11C
;    1251 			if(g10MSEC > 50){	RUN_LED1_OFF;	RUN_LED2_OFF;	}
	CALL SUBOPT_0x24
	SBIW R26,51
	BRLO _0x11D
	SBI  0x1B,5
	SBI  0x1B,6
;    1252 			else{				RUN_LED1_ON;	RUN_LED2_ON;	}
	RJMP _0x11E
_0x11D:
	CBI  0x1B,5
	CBI  0x1B,6
_0x11E:
;    1253 			if(F_IR_RECEIVED){
	SBRS R3,2
	RJMP _0x11F
;    1254 			    EIMSK &= 0xBF;
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;    1255 				F_IR_RECEIVED = 0;
	CLT
	BLD  R3,2
;    1256 				if(gIrBuf[3] == BTN_C){
	__GETB1MN _gIrBuf,3
	CPI  R30,LOW(0x7)
	BREQ PC+3
	JMP _0x120
;    1257 					for(i = 1; i < NUM_OF_REMOCON; i++){
	__GETWRN 16,17,1
_0x122:
	__CPWRN 16,17,5
	BRGE _0x123
;    1258 						eRCodeH[i-1] = eRCodeH[i];
	MOVW R30,R16
	SBIW R30,1
	SUBI R30,LOW(-_eRCodeH)
	SBCI R31,HIGH(-_eRCodeH)
	MOVW R0,R30
	LDI  R26,LOW(_eRCodeH)
	LDI  R27,HIGH(_eRCodeH)
	CALL SUBOPT_0x39
;    1259 						eRCodeM[i-1] = eRCodeM[i];
	SUBI R30,LOW(-_eRCodeM)
	SBCI R31,HIGH(-_eRCodeM)
	MOVW R0,R30
	LDI  R26,LOW(_eRCodeM)
	LDI  R27,HIGH(_eRCodeM)
	CALL SUBOPT_0x39
;    1260 						eRCodeL[i-1] = eRCodeL[i];
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
;    1261 					}
	__ADDWRN 16,17,1
	RJMP _0x122
_0x123:
;    1262 					eRCodeH[NUM_OF_REMOCON-1] = gIrBuf[0]; 
	__POINTW2MN _eRCodeH,4
	LDS  R30,_gIrBuf
	CALL __EEPROMWRB
;    1263 					eRCodeM[NUM_OF_REMOCON-1] = gIrBuf[1]; 
	__POINTW2MN _eRCodeM,4
	__GETB1MN _gIrBuf,1
	CALL __EEPROMWRB
;    1264 					eRCodeL[NUM_OF_REMOCON-1] = gIrBuf[2];
	__POINTW2MN _eRCodeL,4
	__GETB1MN _gIrBuf,2
	CALL __EEPROMWRB
;    1265 
;    1266 					for(i = 0; i < 3; i++){
	__GETWRN 16,17,0
_0x125:
	__CPWRN 16,17,3
	BRGE _0x126
;    1267 						PF1_LED1_ON; PF1_LED2_ON; PF2_LED_ON; RUN_LED1_ON; 
	CBI  0x1B,2
	CBI  0x1B,3
	CBI  0x1B,4
	CBI  0x1B,5
;    1268 						RUN_LED2_ON; ERR_LED_ON; PWR_LED1_ON; PWR_LED2_ON;
	CBI  0x1B,6
	CBI  0x1B,7
	CALL SUBOPT_0x2E
	CBI  0x15,7
;    1269 						delay_ms(500);
	CALL SUBOPT_0x31
;    1270 						PF1_LED1_OFF; PF1_LED2_OFF; PF2_LED_OFF; RUN_LED1_OFF; 
	SBI  0x1B,2
	SBI  0x1B,3
	SBI  0x1B,4
	SBI  0x1B,5
;    1271 						RUN_LED2_OFF; ERR_LED_OFF; PWR_LED1_OFF; PWR_LED2_ON;
	SBI  0x1B,6
	SBI  0x1B,7
	CALL SUBOPT_0x30
	CBI  0x15,7
;    1272 						delay_ms(500);
	CALL SUBOPT_0x31
;    1273 					}
	__ADDWRN 16,17,1
	RJMP _0x125
_0x126:
;    1274 
;    1275 					for(i = 0; i < IR_BUFFER_SIZE; i++)	gIrBuf[i]=0;
	__GETWRN 16,17,0
_0x128:
	__CPWRN 16,17,4
	BRGE _0x129
	CALL SUBOPT_0x3A
;    1276 				    EIMSK |= 0x40;
	__ADDWRN 16,17,1
	RJMP _0x128
_0x129:
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    1277 					break;
	RJMP _0x11C
;    1278 				}
;    1279 				for(i = 0; i < IR_BUFFER_SIZE; i++)	gIrBuf[i]=0;
_0x120:
	__GETWRN 16,17,0
_0x12B:
	__CPWRN 16,17,4
	BRGE _0x12C
	CALL SUBOPT_0x3A
;    1280 			    EIMSK |= 0x40;
	__ADDWRN 16,17,1
	RJMP _0x12B
_0x12C:
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    1281 			}
;    1282 		}
_0x11F:
	RJMP _0x11A
_0x11C:
;    1283 	}
;    1284 }
_0x117:
_0x116:
_0x111:
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1285 
;    1286 
;    1287 void ProcComm(void)
;    1288 {
_ProcComm:
;    1289 	BYTE	lbtmp;
;    1290 
;    1291 	if(F_RSV_PSD_READ){
	ST   -Y,R16
;	lbtmp -> R16
	SBRS R3,7
	RJMP _0x12D
;    1292 		F_RSV_PSD_READ = 0;
	CLT
	BLD  R3,7
;    1293 		Get_AD_PSD();
	RCALL _Get_AD_PSD
;    1294 		SendToPC(22,2);
	LDI  R30,LOW(22)
	CALL SUBOPT_0x1E
;    1295 		gFileCheckSum = 0;
;    1296 		sciTx1Data(gDistance);
	ST   -Y,R7
	CALL SUBOPT_0x3B
;    1297 		sciTx1Data(0);
;    1298 		gFileCheckSum ^= gDistance;
	MOV  R30,R7
	CALL SUBOPT_0xA
;    1299 		sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;    1300 	}
;    1301 	if(F_RSV_SOUND_READ){
_0x12D:
	SBRS R3,5
	RJMP _0x12E
;    1302 		Get_AD_MIC();
	RCALL _Get_AD_MIC
;    1303 		if(gSoundMinTh <= gSoundLevel){
	LDS  R26,_gSoundMinTh
	CP   R8,R26
	BRLO _0x12F
;    1304 			SendToPC(23,2);
	LDI  R30,LOW(23)
	CALL SUBOPT_0x1E
;    1305 			gFileCheckSum = 0;
;    1306 			sciTx1Data(gSoundLevel);
	ST   -Y,R8
	CALL SUBOPT_0x3B
;    1307 			sciTx1Data(0);
;    1308 			gFileCheckSum ^= gSoundLevel;
	MOV  R30,R8
	CALL SUBOPT_0xA
;    1309 			sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;    1310 		}
;    1311 	}
_0x12F:
;    1312 	if(F_RSV_BTN_READ){
_0x12E:
	SBRS R3,6
	RJMP _0x130
;    1313 		lbtmp = PINA & 0x03;
	IN   R30,0x19
	ANDI R30,LOW(0x3)
	MOV  R16,R30
;    1314 		if(lbtmp == 0x02){	
	CPI  R16,2
	BRNE _0x131
;    1315 			delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x20
;    1316 			if(lbtmp == 0x02){
	CPI  R16,2
	BRNE _0x132
;    1317 				SendToPC(24,2);
	LDI  R30,LOW(24)
	CALL SUBOPT_0x1E
;    1318 				gFileCheckSum = 0;
;    1319 				sciTx1Data(1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x23
;    1320 				sciTx1Data(0);
	CALL SUBOPT_0x1B
;    1321 				gFileCheckSum ^= 1;
	CALL SUBOPT_0x1C
;    1322 				sciTx1Data(gFileCheckSum);
;    1323 				delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x20
;    1324 			}
;    1325 		}
_0x132:
;    1326 		else if(lbtmp == 0x01){
	RJMP _0x133
_0x131:
	CPI  R16,1
	BRNE _0x134
;    1327 			delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x20
;    1328 			if(lbtmp == 0x01){
	CPI  R16,1
	BRNE _0x135
;    1329 				SendToPC(24,2);
	LDI  R30,LOW(24)
	CALL SUBOPT_0x1E
;    1330 				gFileCheckSum = 0;
;    1331 				sciTx1Data(2);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x23
;    1332 				sciTx1Data(0);
	CALL SUBOPT_0x1B
;    1333 				gFileCheckSum ^= 2;
	LDI  R30,LOW(2)
	EOR  R30,R26
	STS  _gFileCheckSum,R30
;    1334 				sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;    1335 				delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x20
;    1336 			}
;    1337 		}
_0x135:
;    1338 	}
_0x134:
_0x133:
;    1339 }
_0x130:
	LD   R16,Y+
	RET
;    1340 
;    1341 
;    1342 //------------------------------------------------------------------------------
;    1343 // 메인 함수
;    1344 //------------------------------------------------------------------------------
;    1345 void main(void) {
_main:
;    1346 	WORD    l10MSEC;
;    1347 
;    1348 	HW_init();
;	l10MSEC -> R16,R17
	CALL _HW_init
;    1349 	SW_init();
	CALL _SW_init
;    1350 	Acc_init();
	RCALL _Acc_init
;    1351 
;    1352 	#asm("sei");
	sei
;    1353 	TIMSK |= 0x01;
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
;    1354 
;    1355 	SpecialMode();
	CALL _SpecialMode
;    1356 
;    1357 	P_BMC504_RESET(0);
	CBI  0x18,6
;    1358 	delay_ms(20);
	CALL SUBOPT_0x3C
;    1359 	P_BMC504_RESET(1);
	SBI  0x18,6
;    1360 
;    1361 	SelfTest1();
	CALL _SelfTest1
;    1362 	while(1){
_0x13A:
;    1363 		ReadButton();
	CALL _ReadButton
;    1364 		ProcButton();
	CALL _ProcButton
;    1365 		IoUpdate();
	CALL _IoUpdate
;    1366 		if(g10MSEC == 0 || g10MSEC == 50){
	CALL SUBOPT_0x32
	BREQ _0x13E
	CALL SUBOPT_0x24
	SBIW R26,50
	BRNE _0x13D
_0x13E:
;    1367 			if(g10MSEC != l10MSEC){
	CALL SUBOPT_0x24
	CP   R16,R26
	CPC  R17,R27
	BREQ _0x140
;    1368 				l10MSEC = g10MSEC;
	__GETWRMN 16,17,0,_g10MSEC
;    1369 				Get_VOLTAGE();
	CALL SUBOPT_0x2F
;    1370 				DetectPower();
;    1371 			}
;    1372 		}
_0x140:
;    1373 		ProcIr();
_0x13D:
	CALL _ProcIr
;    1374 		AccGetData();
	RCALL _AccGetData
;    1375 		ProcComm();
	CALL _ProcComm
;    1376 	}
	RJMP _0x13A
;    1377 }
_0x141:
	RJMP _0x141
;    1378 #include <mega128.h>
;    1379 #include "Main.h"
;    1380 #include "Macro.h"
;    1381 #include "accel.h"
;    1382 
;    1383 //==============================================================//
;    1384 // Start
;    1385 //==============================================================//
;    1386 void AccStart(void)
;    1387 {
_AccStart:
;    1388 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1389 SCK_SET_OUTPUT;
	SBI  0x2,4
;    1390 	P_ACC_SDI(1);
	SBI  0x3,5
;    1391 	P_ACC_SCK(1);
	SBI  0x3,4
;    1392 	#asm("nop");
	nop
;    1393 	#asm("nop");
	nop
;    1394 	P_ACC_SDI(0);
	CBI  0x3,5
;    1395 	#asm("nop");
	nop
;    1396 	#asm("nop");
	nop
;    1397 	P_ACC_SCK(0);
	CBI  0x3,4
;    1398 	#asm("nop");
	nop
;    1399 	#asm("nop");
	nop
;    1400 }
	RET
;    1401 
;    1402 
;    1403 //==============================================================//
;    1404 // Stop
;    1405 //==============================================================//
;    1406 void AccStop(void)
;    1407 {
_AccStop:
;    1408 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1409 SCK_SET_OUTPUT;
	SBI  0x2,4
;    1410 	P_ACC_SDI(0);
	CBI  0x3,5
;    1411 	P_ACC_SCK(1);
	SBI  0x3,4
;    1412 	#asm("nop");
	nop
;    1413 	#asm("nop");
	nop
;    1414 	P_ACC_SDI(1);
	SBI  0x3,5
;    1415 	#asm("nop");
	nop
;    1416 	#asm("nop");
	nop
;    1417 SDI_SET_INPUT;
	CBI  0x2,5
;    1418 SCK_SET_INPUT;
	CBI  0x2,4
;    1419 }
	RET
;    1420 
;    1421 
;    1422 //==============================================================//
;    1423 //
;    1424 //==============================================================//
;    1425 void AccByteWrite(BYTE bData)
;    1426 {
_AccByteWrite:
;    1427 	BYTE	i;
;    1428 	BYTE	bTmp;
;    1429 
;    1430 SDI_SET_OUTPUT;
	ST   -Y,R17
	ST   -Y,R16
;	bData -> Y+2
;	i -> R16
;	bTmp -> R17
	SBI  0x2,5
;    1431 	for(i=0; i<8; i++){
	LDI  R16,LOW(0)
_0x151:
	CPI  R16,8
	BRSH _0x152
;    1432 		bTmp = CHK_BIT7(bData);
	LDD  R30,Y+2
	ANDI R30,LOW(0x80)
	MOV  R17,R30
;    1433     	if(bTmp){
	CPI  R17,0
	BREQ _0x153
;    1434 			P_ACC_SDI(1);
	SBI  0x3,5
;    1435 		}else{
	RJMP _0x156
_0x153:
;    1436 			P_ACC_SDI(0);
	CBI  0x3,5
;    1437 		}
_0x156:
;    1438 		#asm("nop");
	nop
;    1439 		#asm("nop");
	nop
;    1440 		P_ACC_SCK(1);;
	SBI  0x3,4
;    1441 		#asm("nop");
	nop
;    1442 		#asm("nop");
	nop
;    1443 		#asm("nop");
	nop
;    1444 		#asm("nop");
	nop
;    1445 		P_ACC_SCK(0);
	CBI  0x3,4
;    1446 		#asm("nop");
	nop
;    1447 		#asm("nop");
	nop
;    1448 		bData =	bData << 1;
	LDD  R30,Y+2
	LSL  R30
	STD  Y+2,R30
;    1449 	}
	SUBI R16,-1
	JMP  _0x151
_0x152:
;    1450 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
;    1451 
;    1452 
;    1453 //==============================================================//
;    1454 //
;    1455 //==============================================================//
;    1456 char AccByteRead(void)
;    1457 {
_AccByteRead:
;    1458 	BYTE	i;
;    1459 	char	bTmp = 0;
;    1460 
;    1461 SDI_SET_INPUT;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16
;	bTmp -> R17
	LDI  R17,0
	CBI  0x2,5
;    1462 	for(i = 0; i < 8;	i++){
	LDI  R16,LOW(0)
_0x15E:
	CPI  R16,8
	BRSH _0x15F
;    1463 		bTmp = bTmp << 1;
	LSL  R17
;    1464 		#asm("nop");
	nop
;    1465 		#asm("nop");
	nop
;    1466 		#asm("nop");
	nop
;    1467 		#asm("nop");
	nop
;    1468 		P_ACC_SCK(1);
	SBI  0x3,4
;    1469 		#asm("nop");
	nop
;    1470 		#asm("nop");
	nop
;    1471 		if(SDI_CHK)	bTmp |= 0x01;
	SBIC 0x1,5
	ORI  R17,LOW(1)
;    1472 		#asm("nop");
	nop
;    1473 		#asm("nop");
	nop
;    1474 		P_ACC_SCK(0);
	CBI  0x3,4
;    1475 	}
	SUBI R16,-1
	JMP  _0x15E
_0x15F:
;    1476 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1477 
;    1478 	return	bTmp;
	MOV  R30,R17
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1479 }
;    1480 
;    1481 
;    1482 //==============================================================//
;    1483 //
;    1484 //==============================================================//
;    1485 void AccAckRead(void)
;    1486 {
_AccAckRead:
;    1487 SDI_SET_INPUT;
	CBI  0x2,5
;    1488 	#asm("nop");
	nop
;    1489 	#asm("nop");
	nop
;    1490 	P_ACC_SDI(1);
	SBI  0x3,5
;    1491 	#asm("nop");
	nop
;    1492 	#asm("nop");
	nop
;    1493 	P_ACC_SCK(1);
	SBI  0x3,4
;    1494 	#asm("nop");
	nop
;    1495 	#asm("nop");
	nop
;    1496 	P_ACC_SCK(0);
	CBI  0x3,4
;    1497 	#asm("nop");
	nop
;    1498 	#asm("nop");
	nop
;    1499 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1500 	#asm("nop");
	nop
;    1501 	#asm("nop");
	nop
;    1502 }
	RET
;    1503 
;    1504 
;    1505 //==============================================================//
;    1506 //
;    1507 //==============================================================//
;    1508 void AccAckWrite(void)
;    1509 {
_AccAckWrite:
;    1510 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1511 	#asm("nop");
	nop
;    1512 	#asm("nop");
	nop
;    1513 	P_ACC_SDI(0);
	CBI  0x3,5
;    1514 	#asm("nop");
	nop
;    1515 	#asm("nop");
	nop
;    1516 	P_ACC_SCK(1);
	SBI  0x3,4
;    1517 	#asm("nop");
	nop
;    1518 	#asm("nop");
	nop
;    1519 	P_ACC_SCK(0);
	CBI  0x3,4
;    1520 	#asm("nop");
	nop
;    1521 	#asm("nop");
	nop
;    1522 	P_ACC_SDI(1);
	SBI  0x3,5
;    1523 	#asm("nop");
	nop
;    1524 	#asm("nop");
	nop
;    1525 }
	RET
;    1526 
;    1527 
;    1528 //==============================================================//
;    1529 //
;    1530 //==============================================================//
;    1531 void AccNotAckWrite(void)
;    1532 {
_AccNotAckWrite:
;    1533 SDI_SET_OUTPUT;
	SBI  0x2,5
;    1534 	#asm("nop");
	nop
;    1535 	#asm("nop");
	nop
;    1536 	P_ACC_SDI(1);
	SBI  0x3,5
;    1537 	#asm("nop");
	nop
;    1538 	#asm("nop");
	nop
;    1539 	P_ACC_SCK(1);
	SBI  0x3,4
;    1540 	#asm("nop");
	nop
;    1541 	#asm("nop");
	nop
;    1542 	P_ACC_SCK(0);
	CBI  0x3,4
;    1543 	#asm("nop");
	nop
;    1544 	#asm("nop");
	nop
;    1545 }
	RET
;    1546 
;    1547 
;    1548 //==============================================================//
;    1549 //==============================================================//
;    1550 void Acc_init(void)
;    1551 {
_Acc_init:
;    1552 	AccStart();
	CALL SUBOPT_0x3D
;    1553 	AccByteWrite(0x70);
;    1554 	AccAckRead();
;    1555 	AccByteWrite(0x14);
	LDI  R30,LOW(20)
	CALL SUBOPT_0x3E
;    1556 	AccAckRead();
;    1557 	AccByteWrite(0x03);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x3E
;    1558 	AccAckRead();
;    1559 	AccStop();
	CALL _AccStop
;    1560 }
	RET
;    1561 
;    1562 //==============================================================//
;    1563 //==============================================================//
;    1564 void AccGetData(void)
;    1565 {
_AccGetData:
;    1566 	signed char	bTmp = 0;
;    1567 
;    1568 	AccStart();
	ST   -Y,R16
;	bTmp -> R16
	LDI  R16,0
	CALL SUBOPT_0x3D
;    1569 	AccByteWrite(0x70);
;    1570 	AccAckRead();
;    1571 	AccByteWrite(0x02);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x3E
;    1572 	AccAckRead();
;    1573 	AccStop();
	CALL _AccStop
;    1574 
;    1575 	#asm("nop");
	nop
;    1576 	#asm("nop");
	nop
;    1577 	#asm("nop");
	nop
;    1578 	#asm("nop");
	nop
;    1579 
;    1580 	AccStart();
	CALL _AccStart
;    1581 	AccByteWrite(0x71);
	LDI  R30,LOW(113)
	CALL SUBOPT_0x3E
;    1582 	AccAckRead();
;    1583 
;    1584 	bTmp = AccByteRead();
	CALL SUBOPT_0x3F
;    1585 	AccAckWrite();
;    1586 
;    1587 	bTmp = AccByteRead();
	CALL SUBOPT_0x3F
;    1588 	AccAckWrite();
;    1589 	gAccX = bTmp;
	STS  _gAccX,R16
;    1590 
;    1591 	bTmp = AccByteRead();
	CALL SUBOPT_0x3F
;    1592 	AccAckWrite();
;    1593 
;    1594 	bTmp = AccByteRead();
	CALL SUBOPT_0x3F
;    1595 	AccAckWrite();
;    1596 	gAccY = bTmp;
	STS  _gAccY,R16
;    1597 
;    1598 	bTmp = AccByteRead();
	CALL SUBOPT_0x3F
;    1599 	AccAckWrite();
;    1600 
;    1601 	bTmp = AccByteRead();
	CALL _AccByteRead
	MOV  R16,R30
;    1602 	AccNotAckWrite();
	CALL _AccNotAckWrite
;    1603 	gAccZ = bTmp;
	STS  _gAccZ,R16
;    1604 
;    1605 	AccStop();
	CALL _AccStop
;    1606 }
	LD   R16,Y+
	RET
;    1607 //==============================================================================
;    1608 //						A/D converter 관련 함수들
;    1609 //==============================================================================
;    1610 #include <mega128.h>
;    1611 #include "Main.h"
;    1612 #include "Macro.h"
;    1613 
;    1614 //------------------------------------------------------------------------------
;    1615 // PSD 거리센서 신호 A/D
;    1616 //------------------------------------------------------------------------------
;    1617 void Get_AD_PSD(void)
;    1618 {
_Get_AD_PSD:
;    1619 	float	tmp = 0;
;    1620 	float	dist;
;    1621 	
;    1622 	EIMSK &= 0xBF;
	SBIW R28,8
	LDI  R24,4
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	LDI  R30,LOW(_0x179*2)
	LDI  R31,HIGH(_0x179*2)
	CALL __INITLOCB
;	tmp -> Y+4
;	dist -> Y+0
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;    1623 	PSD_ON;
	SBI  0x18,5
;    1624    	delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x20
;    1625 	gAD_Ch_Index = PSD_CH;
	CLR  R4
;    1626    	F_AD_CONVERTING = 1;
	CALL SUBOPT_0x40
;    1627    	ADC_set(ADC_MODE_SINGLE);
;    1628    	while(F_AD_CONVERTING);            
_0x17A:
	SBRC R2,7
	RJMP _0x17A
;    1629    	tmp = tmp + gPSD_val;
	MOV  R30,R9
	__GETD2S 4
	CALL SUBOPT_0x41
	__PUTD1S 4
;    1630 	PSD_OFF;
	CBI  0x18,5
;    1631 	EIMSK |= 0x40;
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    1632 
;    1633 	dist = 1117.2 / (tmp - 6.89);
	__GETD2S 4
	__GETD1N 0x40DC7AE1
	CALL SUBOPT_0x3
	__GETD2N 0x448BA666
	CALL __DIVF21
	CALL SUBOPT_0x0
;    1634 	//dist = 27.5 / (5.0*(float)(gAD_val&0x03ff)/1024.0);
;    1635 	if(dist < 0) dist = 50;
	CALL SUBOPT_0x2
	CALL __CPD20
	BRGE _0x17D
	RJMP _0x326
;    1636 	else if(dist < 10) dist = 10;
_0x17D:
	CALL SUBOPT_0x2
	CALL SUBOPT_0x42
	CALL __CMPF12
	BRSH _0x17F
	CALL SUBOPT_0x42
	RJMP _0x327
;    1637 	else if(dist > 50) dist = 50;
_0x17F:
	CALL SUBOPT_0x2
	__GETD1N 0x42480000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x181
_0x326:
	__GETD1N 0x42480000
_0x327:
	__PUTD1S 0
;    1638 	gDistance = (BYTE)dist;
_0x181:
	CALL SUBOPT_0x43
	MOV  R7,R30
;    1639 }
	ADIW R28,8
	RET
;    1640 
;    1641 
;    1642 //------------------------------------------------------------------------------
;    1643 // MIC 신호 A/D
;    1644 //------------------------------------------------------------------------------
;    1645 void Get_AD_MIC(void)
;    1646 {
_Get_AD_MIC:
;    1647 	WORD	i;
;    1648 	float	tmp = 0;
;    1649 	
;    1650 	gAD_Ch_Index = MIC_CH;
	SBIW R28,4
	LDI  R24,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x182*2)
	LDI  R31,HIGH(_0x182*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
;	tmp -> Y+2
	LDI  R30,LOW(15)
	MOV  R4,R30
;    1651 	for(i = 0; i < 50; i++){
	__GETWRN 16,17,0
_0x184:
	__CPWRN 16,17,50
	BRSH _0x185
;    1652     	F_AD_CONVERTING = 1;
	CALL SUBOPT_0x40
;    1653 	   	ADC_set(ADC_MODE_SINGLE);
;    1654     	while(F_AD_CONVERTING);            
_0x186:
	SBRC R2,7
	RJMP _0x186
;    1655     	tmp = tmp + gMIC_val;
	MOV  R30,R10
	CALL SUBOPT_0x44
	CALL SUBOPT_0x41
	CALL SUBOPT_0x45
;    1656     }
	__ADDWRN 16,17,1
	RJMP _0x184
_0x185:
;    1657     tmp = tmp / 50;
	CALL SUBOPT_0x44
	__GETD1N 0x42480000
	CALL __DIVF21
	CALL SUBOPT_0x45
;    1658 	gSoundLevel = (BYTE)tmp;
	__GETD1S 2
	CALL __CFD1
	MOV  R8,R30
;    1659 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;    1660 
;    1661 
;    1662 //------------------------------------------------------------------------------
;    1663 // 전원 전압 A/D
;    1664 //------------------------------------------------------------------------------
;    1665 void Get_VOLTAGE(void)
;    1666 {
_Get_VOLTAGE:
;    1667 	if(F_DOWNLOAD) return;
	SBRC R2,4
	RET
;    1668 	gAD_Ch_Index = VOLTAGE_CH;
	LDI  R30,LOW(1)
	MOV  R4,R30
;    1669 	F_AD_CONVERTING = 1;
	CALL SUBOPT_0x40
;    1670    	ADC_set(ADC_MODE_SINGLE);
;    1671 	while(F_AD_CONVERTING);
_0x18A:
	SBRC R2,7
	RJMP _0x18A
;    1672 }
	RET
;    1673 //==============================================================================
;    1674 //						Communication & Command 함수들
;    1675 //==============================================================================
;    1676 
;    1677 #include <mega128.h>
;    1678 #include <string.h>
;    1679 #include "Main.h"
;    1680 #include "Macro.h"
;    1681 #include "Comm.h"
;    1682 #include "HunoBasic_080819.h"
;    1683 #include "DinoBasic_2.h"
;    1684 #include "DogyBasic_2.h"
;    1685 #include "my_demo1.h"	// 사용자 모션 파일
;    1686 
;    1687 
;    1688 BYTE flash fM1_BasicPose[16]={
;    1689 /* ID
;    1690  0 ,1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9  , 10, 11, 12, 13, 14, 15 */
;    1691 125,179,199, 88,108,126, 72, 49,163,141, 51, 47, 49,199,205,205};
;    1692 
;    1693 BYTE flash fM2_BasicPose[16]={
;    1694 /* ID
;    1695  0 ,1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9  , 10, 11, 12, 13, 14, 15 */
;    1696 125,179,199, 88,108,126, 72, 49,163,141, 89,127, 47,159,112,171};
;    1697 
;    1698 BYTE flash fM3_BasicPose[16]={
;    1699 /* ID
;    1700  0 ,1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9  , 10, 11, 12, 13, 14, 15 */
;    1701 159,209,127,127,200, 91, 41,127,127, 52,143, 39, 52,109,210,200};
;    1702 
;    1703 
;    1704 //------------------------------------------------------------------------------
;    1705 // 시리얼 포트로 한 문자를 전송하기 위한 함수
;    1706 //------------------------------------------------------------------------------
;    1707 void sciTx0Data(BYTE td)
;    1708 {
_sciTx0Data:
;    1709 	while(!(UCSR0A & DATA_REGISTER_EMPTY));
;	td -> Y+0
_0x18D:
	SBIS 0xB,5
	RJMP _0x18D
;    1710 	UDR0 = td;
	LD   R30,Y
	OUT  0xC,R30
;    1711 }
	RJMP _0x31B
;    1712 
;    1713 void sciTx1Data(BYTE td)
;    1714 {
_sciTx1Data:
;    1715 	while(!(UCSR1A & DATA_REGISTER_EMPTY));
;	td -> Y+0
_0x190:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0x190
;    1716 	UDR1 = td;
	LD   R30,Y
	STS  156,R30
;    1717 }
_0x31B:
	ADIW R28,1
	RET
;    1718 
;    1719 
;    1720 //------------------------------------------------------------------------------
;    1721 // 시리얼 포트로 한 문자를 받을때까지 대기하기 위한 함수
;    1722 //------------------------------------------------------------------------------
;    1723 BYTE sciRx0Ready(void)
;    1724 {
;    1725 	WORD	startT;
;    1726 
;    1727 	startT = g10MSEC;
;	startT -> R16,R17
;    1728 	while(!(UCSR0A & RX_COMPLETE)){
;    1729         if(g10MSEC < startT){
;    1730             if((100 - startT + g10MSEC) > RX_T_OUT) break;
;    1731         }
;    1732 		else if((g10MSEC-startT) > RX_T_OUT) break;
;    1733 	}
;    1734 	return UDR0;
;    1735 }
;    1736 
;    1737 BYTE sciRx1Ready(void)
;    1738 {
;    1739 	WORD	startT;
;    1740 
;    1741 	startT = g10MSEC;
;	startT -> R16,R17
;    1742 	while(!(UCSR1A & RX_COMPLETE)){
;    1743         if(g10MSEC < startT){
;    1744             if((100 - startT + g10MSEC) > RX_T_OUT) break;
;    1745         }
;    1746 		else if((g10MSEC-startT) > RX_T_OUT) break;
;    1747 	}
;    1748 	return UDR1;
;    1749 }
;    1750 
;    1751 
;    1752 //------------------------------------------------------------------------------
;    1753 // wCK에게 동작 명령 패킷(4바이트)을 보내는 함수                                                                     */
;    1754 //------------------------------------------------------------------------------
;    1755 void SendOperCmd(BYTE Data1,BYTE Data2)
;    1756 {
_SendOperCmd:
;    1757 	BYTE CheckSum; 
;    1758 	CheckSum = (Data1^Data2)&0x7f;
	ST   -Y,R16
;	Data1 -> Y+2
;	Data2 -> Y+1
;	CheckSum -> R16
	LDD  R30,Y+1
	LDD  R26,Y+2
	CALL SUBOPT_0x46
;    1759 
;    1760 	gTx0Buf[gTx0Cnt] = HEADER;
;    1761 	gTx0Cnt++;
;    1762 
;    1763 	gTx0Buf[gTx0Cnt] = Data1;
	CALL SUBOPT_0x47
;    1764 	gTx0Cnt++;
;    1765 
;    1766 	gTx0Buf[gTx0Cnt] = Data2;
	CALL SUBOPT_0x48
;    1767 	gTx0Cnt++;
;    1768 
;    1769 	gTx0Buf[gTx0Cnt] = CheckSum;
;    1770 	gTx0Cnt++;
;    1771 
;    1772 }
	ADIW R28,3
	RET
;    1773 
;    1774 
;    1775 //------------------------------------------------------------------------------
;    1776 // wCK의 파라미터를 설정할 때 사용한다
;    1777 //------------------------------------------------------------------------------
;    1778 void SendSetCmd(BYTE ID, BYTE Data1, BYTE Data2, BYTE Data3)
;    1779 {
_SendSetCmd:
;    1780 	BYTE	CheckSum; 
;    1781 
;    1782 	ID = (BYTE)(7<<5)|ID; 
	ST   -Y,R16
;	ID -> Y+4
;	Data1 -> Y+3
;	Data2 -> Y+2
;	Data3 -> Y+1
;	CheckSum -> R16
	LDD  R30,Y+4
	ORI  R30,LOW(0xE0)
	STD  Y+4,R30
;    1783 	CheckSum = (ID^Data1^Data2^Data3)&0x7f;
	LDD  R30,Y+3
	LDD  R26,Y+4
	EOR  R30,R26
	LDD  R26,Y+2
	EOR  R30,R26
	LDD  R26,Y+1
	CALL SUBOPT_0x46
;    1784 
;    1785 	gTx0Buf[gTx0Cnt] = HEADER;
;    1786 	gTx0Cnt++;
;    1787 
;    1788 	gTx0Buf[gTx0Cnt] = ID;
	LDD  R26,Y+4
	CALL SUBOPT_0x49
;    1789 	gTx0Cnt++;
;    1790 
;    1791 	gTx0Buf[gTx0Cnt] = Data1;
	LDD  R26,Y+3
	CALL SUBOPT_0x49
;    1792 	gTx0Cnt++;
;    1793 
;    1794 	gTx0Buf[gTx0Cnt] = Data2;
	CALL SUBOPT_0x47
;    1795 	gTx0Cnt++;
;    1796 
;    1797 	gTx0Buf[gTx0Cnt] = Data3;
	CALL SUBOPT_0x48
;    1798 	gTx0Cnt++;
;    1799 
;    1800 	gTx0Buf[gTx0Cnt] = CheckSum;
;    1801 	gTx0Cnt++;
;    1802 }
	ADIW R28,5
	RET
;    1803 
;    1804 
;    1805 //------------------------------------------------------------------------------
;    1806 // 위치 명령(Position Send Command)을 보내는 함수
;    1807 //------------------------------------------------------------------------------
;    1808 void PosSend(BYTE ID, BYTE Position, BYTE SpeedLevel) 
;    1809 {
_PosSend:
;    1810 	BYTE Data1;
;    1811 
;    1812 	Data1 = (SpeedLevel<<5) | ID;
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
;    1813 	SendOperCmd(Data1,Position);
	ST   -Y,R16
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _SendOperCmd
;    1814 }
	LDD  R16,Y+0
	RJMP _0x318
;    1815 
;    1816 
;    1817 //------------------------------------------------------------------------------
;    1818 // 브레이크 모드 명령을 보내는 함수
;    1819 //------------------------------------------------------------------------------
;    1820 void BreakModeCmdSend(void)
;    1821 {
_BreakModeCmdSend:
;    1822 	BYTE	Data1, Data2;
;    1823 	BYTE	CheckSum; 
;    1824 
;    1825 	Data1 = (6<<5) | 31;
	CALL __SAVELOCR3
;	Data1 -> R16
;	Data2 -> R17
;	CheckSum -> R18
	LDI  R16,LOW(223)
;    1826 	Data2 = 0x20;
	LDI  R17,LOW(32)
;    1827 	CheckSum = (Data1^Data2)&0x7f;
	MOV  R30,R17
	EOR  R30,R16
	ANDI R30,0x7F
	CALL SUBOPT_0x4A
;    1828 
;    1829 	sciTx0Data(HEADER);
;    1830 	sciTx0Data(Data1);
;    1831 	sciTx0Data(Data2);
;    1832 	sciTx0Data(CheckSum);
	ST   -Y,R18
	CALL _sciTx0Data
;    1833 } 
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;    1834 
;    1835 
;    1836 //------------------------------------------------------------------------------
;    1837 // 이동범위 설정 명령을 보내는 함수
;    1838 //------------------------------------------------------------------------------
;    1839 void BoundSetCmdSend(BYTE ID, BYTE B_L, BYTE B_U)
;    1840 {
_BoundSetCmdSend:
;    1841 	BYTE	Data1, Data2;
;    1842 	BYTE	CheckSum; 
;    1843 
;    1844 	Data1 = (7<<5) | ID;
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
;    1845 	Data2 = 17;
	LDI  R17,LOW(17)
;    1846 	CheckSum = (Data1^Data2^B_U^B_L)&0x7f;
	MOV  R30,R17
	EOR  R30,R16
	LDD  R26,Y+3
	EOR  R30,R26
	LDD  R26,Y+4
	EOR  R26,R30
	LDI  R30,LOW(127)
	AND  R30,R26
	CALL SUBOPT_0x4A
;    1847 
;    1848 	sciTx0Data(HEADER);
;    1849 	sciTx0Data(Data1);
;    1850 	sciTx0Data(Data2);
;    1851 	sciTx0Data(B_L);
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _sciTx0Data
;    1852 	sciTx0Data(B_U);
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _sciTx0Data
;    1853 	sciTx0Data(CheckSum);
	ST   -Y,R18
	CALL _sciTx0Data
;    1854 }
	CALL __LOADLOCR3
	ADIW R28,6
	RET
;    1855 
;    1856 //------------------------------------------------------------------------------
;    1857 // 위치 읽기 명령(Position Send Command)을 보내는 함수
;    1858 //------------------------------------------------------------------------------
;    1859 WORD PosRead(BYTE ID) 
;    1860 {
_PosRead:
;    1861 	BYTE	Data1, Data2;
;    1862 	BYTE	CheckSum; 
;    1863 	WORD	startT;
;    1864 
;    1865 	Data1 = (5<<5) | ID;
	CALL __SAVELOCR5
;	ID -> Y+5
;	Data1 -> R16
;	Data2 -> R17
;	CheckSum -> R18
;	startT -> R19,R20
	LDD  R30,Y+5
	ORI  R30,LOW(0xA0)
	MOV  R16,R30
;    1866 	Data2 = 0;
	LDI  R17,LOW(0)
;    1867 	gRx0Cnt = 0;
	LDI  R30,LOW(0)
	STS  _gRx0Cnt,R30
;    1868 	CheckSum = (Data1^Data2)&0x7f;
	MOV  R30,R17
	EOR  R30,R16
	ANDI R30,0x7F
	MOV  R18,R30
;    1869 	RX0_OFF;
	CBI  0xA,4
;    1870 	sciTx0Data(HEADER);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _sciTx0Data
;    1871 	sciTx0Data(Data1);
	ST   -Y,R16
	CALL _sciTx0Data
;    1872 	sciTx0Data(Data2);
	ST   -Y,R17
	CALL _sciTx0Data
;    1873 	sciTx0Data(CheckSum);
	ST   -Y,R18
	CALL _sciTx0Data
;    1874 	RX0_ON;
	SBI  0xA,4
;    1875 	startT = g10MSEC;
	__GETWRMN 19,20,0,_g10MSEC
;    1876 	while(gRx0Cnt < 2){
_0x1A1:
	LDS  R26,_gRx0Cnt
	CPI  R26,LOW(0x2)
	BRSH _0x1A3
;    1877         if(g10MSEC < startT){
	CALL SUBOPT_0x24
	CP   R26,R19
	CPC  R27,R20
	BRSH _0x1A4
;    1878             if((100 - startT + g10MSEC) > RX_T_OUT)
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	SUB  R30,R19
	SBC  R31,R20
	CALL SUBOPT_0x24
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,21
	BRLO _0x1A5
;    1879             	return 444;
	LDI  R30,LOW(444)
	LDI  R31,HIGH(444)
	RJMP _0x31A
;    1880         }
_0x1A5:
;    1881 		else if((g10MSEC - startT) > RX_T_OUT) return 444;
	RJMP _0x1A6
_0x1A4:
	LDS  R30,_g10MSEC
	LDS  R31,_g10MSEC+1
	SUB  R30,R19
	SBC  R31,R20
	SBIW R30,21
	BRLO _0x1A7
	LDI  R30,LOW(444)
	LDI  R31,HIGH(444)
	RJMP _0x31A
;    1882 	}
_0x1A7:
_0x1A6:
	RJMP _0x1A1
_0x1A3:
;    1883 	return (WORD)gRx0Buf[RX0_BUF_SIZE - 1];
	__GETB1MN _gRx0Buf,7
	LDI  R31,0
_0x31A:
	CALL __LOADLOCR5
	ADIW R28,6
	RET
;    1884 } 
;    1885 
;    1886 
;    1887 //------------------------------------------------------------------------------
;    1888 // 사운드 칩에게 명령 보내는 함수
;    1889 //------------------------------------------------------------------------------
;    1890 void SendToSoundIC(BYTE cmd) 
;    1891 {
_SendToSoundIC:
;    1892 	BYTE	CheckSum; 
;    1893 
;    1894 	gRx0Cnt = 0;
	ST   -Y,R16
;	cmd -> Y+1
;	CheckSum -> R16
	LDI  R30,LOW(0)
	STS  _gRx0Cnt,R30
;    1895 	CheckSum = (29^cmd)&0x7f;
	LDD  R30,Y+1
	LDI  R26,LOW(29)
	EOR  R26,R30
	LDI  R30,LOW(127)
	AND  R30,R26
	MOV  R16,R30
;    1896 	sciTx0Data(HEADER);
	LDI  R30,LOW(255)
	CALL SUBOPT_0x4B
;    1897 	delay_ms(1);
;    1898 	sciTx0Data(29);
	LDI  R30,LOW(29)
	CALL SUBOPT_0x4B
;    1899 	delay_ms(1);
;    1900 	sciTx0Data(cmd);
	LDD  R30,Y+1
	CALL SUBOPT_0x4B
;    1901 	delay_ms(1);
;    1902 	sciTx0Data(CheckSum);
	ST   -Y,R16
	CALL _sciTx0Data
;    1903 } 
	LDD  R16,Y+0
	RJMP _0x319
;    1904 
;    1905 
;    1906 //------------------------------------------------------------------------------
;    1907 // PC와 통신할 때 사용
;    1908 //------------------------------------------------------------------------------
;    1909 void SendToPC(BYTE Cmd, BYTE CSize)
;    1910 {
_SendToPC:
;    1911 	sciTx1Data(0xFF);
;	Cmd -> Y+1
;	CSize -> Y+0
	LDI  R30,LOW(255)
	CALL SUBOPT_0x22
;    1912 	sciTx1Data(0xFF);
	CALL SUBOPT_0x4C
;    1913 	sciTx1Data(0xAA);
;    1914 	sciTx1Data(0x55);
	CALL SUBOPT_0x4C
;    1915 	sciTx1Data(0xAA);
;    1916 	sciTx1Data(0x55);
	ST   -Y,R30
	CALL _sciTx1Data
;    1917 	sciTx1Data(0x37);
	LDI  R30,LOW(55)
	ST   -Y,R30
	CALL _sciTx1Data
;    1918 	sciTx1Data(0xBA);
	LDI  R30,LOW(186)
	ST   -Y,R30
	CALL _sciTx1Data
;    1919 	sciTx1Data(Cmd);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _sciTx1Data
;    1920 	sciTx1Data(F_PF);
	ST   -Y,R12
	CALL _sciTx1Data
;    1921 	sciTx1Data(0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x23
;    1922 	sciTx1Data(0);
	CALL SUBOPT_0x23
;    1923 	sciTx1Data(0);
	ST   -Y,R30
	CALL _sciTx1Data
;    1924 	sciTx1Data(CSize);
	LD   R30,Y
	ST   -Y,R30
	CALL _sciTx1Data
;    1925 }
_0x319:
	ADIW R28,2
	RET
;    1926 
;    1927 
;    1928 
;    1929 //------------------------------------------------------------------------------
;    1930 // Flash에서 모션 정보 읽기
;    1931 //------------------------------------------------------------------------------
;    1932 void GetMotionFromFlash(void)
;    1933 {
_GetMotionFromFlash:
;    1934 	WORD	i;
;    1935 
;    1936 	for(i=0;i<MAX_wCK;i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x1A9:
	__CPWRN 16,17,31
	BRSH _0x1AA
;    1937 		Motion.wCK[i].Exist		= 0;
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
;    1938 		Motion.wCK[i].RPgain	= 0;
	CALL SUBOPT_0x50
	CALL SUBOPT_0x4F
;    1939 		Motion.wCK[i].RDgain	= 0;
	CALL SUBOPT_0x51
	CALL SUBOPT_0x4F
;    1940 		Motion.wCK[i].RIgain	= 0;
	CALL SUBOPT_0x52
	CALL SUBOPT_0x4F
;    1941 		Motion.wCK[i].PortEn	= 0;
	CALL SUBOPT_0x53
	CALL SUBOPT_0x4F
;    1942 		Motion.wCK[i].InitPos	= 0;
	CALL SUBOPT_0x54
	LDI  R30,LOW(0)
	ST   X,R30
;    1943 		gPoseDelta[i] = 0;
	CALL SUBOPT_0x55
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    1944 	}
	__ADDWRN 16,17,1
	RJMP _0x1A9
_0x1AA:
;    1945 	gLastID = wCK_IDs[Motion.NumOfwCK-1];
	CALL SUBOPT_0x56
	SBIW R30,1
	SUBI R30,LOW(-_wCK_IDs*2)
	SBCI R31,HIGH(-_wCK_IDs*2)
	LPM  R30,Z
	STS  _gLastID,R30
;    1946 	for(i=0;i<Motion.NumOfwCK;i++){
	__GETWRN 16,17,0
_0x1AC:
	CALL SUBOPT_0x56
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x1AD
;    1947 		Motion.wCK[wCK_IDs[i]].Exist	= 1;
	CALL SUBOPT_0x57
	CALL SUBOPT_0x4E
	LDI  R30,LOW(1)
	ST   X,R30
;    1948 		Motion.wCK[wCK_IDs[i]].RPgain	= *(gpPg_Table+i);
	CALL SUBOPT_0x57
	__ADDW1MN _Motion,11
	CALL SUBOPT_0x58
	LDS  R26,_gpPg_Table
	LDS  R27,_gpPg_Table+1
	CALL SUBOPT_0x59
;    1949 		Motion.wCK[wCK_IDs[i]].RDgain	= *(gpDg_Table+i);
	__ADDW1MN _Motion,12
	CALL SUBOPT_0x58
	LDS  R26,_gpDg_Table
	LDS  R27,_gpDg_Table+1
	CALL SUBOPT_0x59
;    1950 		Motion.wCK[wCK_IDs[i]].RIgain	= *(gpIg_Table+i);
	__ADDW1MN _Motion,13
	CALL SUBOPT_0x58
	LDS  R26,_gpIg_Table
	LDS  R27,_gpIg_Table+1
	CALL SUBOPT_0x59
;    1951 		Motion.wCK[wCK_IDs[i]].PortEn	= 1;
	CALL SUBOPT_0x53
	LDI  R30,LOW(1)
	ST   X,R30
;    1952 		Motion.wCK[wCK_IDs[i]].InitPos	= MotionZeroPos[i];
	CALL SUBOPT_0x57
	CALL SUBOPT_0x54
	MOVW R30,R16
	SUBI R30,LOW(-_MotionZeroPos*2)
	SBCI R31,HIGH(-_MotionZeroPos*2)
	LPM  R30,Z
	ST   X,R30
;    1953 	}
	__ADDWRN 16,17,1
	RJMP _0x1AC
_0x1AD:
;    1954 	for(i=0;i<Motion.NumOfwCK;i++)
	__GETWRN 16,17,0
_0x1AF:
	CALL SUBOPT_0x56
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x1B0
;    1955 		gPoseDelta[i] = (int)eM_OriginPose[i] - (int)Motion.wCK[i].InitPos;
	CALL SUBOPT_0x55
	ADD  R30,R26
	ADC  R31,R27
	MOVW R24,R30
	CALL SUBOPT_0x9
	MOV  R22,R30
	CLR  R23
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x54
	CALL SUBOPT_0x5A
	MOVW R26,R24
	ST   X+,R30
	ST   X,R31
;    1956 }
	__ADDWRN 16,17,1
	RJMP _0x1AF
_0x1B0:
	RJMP _0x317
;    1957 
;    1958 
;    1959 //------------------------------------------------------------------------------
;    1960 // Runtime P,D,I 이득 송신
;    1961 //------------------------------------------------------------------------------
;    1962 void SendTGain(void)
;    1963 {
_SendTGain:
;    1964 	WORD	i;
;    1965 
;    1966 	RX0_INT_OFF;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CBI  0xA,7
;    1967 	TX0_INT_ON;
	SBI  0xA,6
;    1968 
;    1969 	while(gTx0Cnt);
_0x1B1:
	LDS  R30,_gTx0Cnt
	CPI  R30,0
	BRNE _0x1B1
;    1970 	for(i=0;i<MAX_wCK;i++){
	__GETWRN 16,17,0
_0x1B5:
	__CPWRN 16,17,31
	BRSH _0x1B6
;    1971 		if(Motion.wCK[i].Exist)
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
	LD   R30,X
	CPI  R30,0
	BREQ _0x1B7
;    1972 			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
	ST   -Y,R16
	LDI  R30,LOW(11)
	ST   -Y,R30
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x50
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x51
	CALL SUBOPT_0x5B
;    1973 	}
_0x1B7:
	__ADDWRN 16,17,1
	RJMP _0x1B5
_0x1B6:
;    1974 	gTx0BufIdx++;
	CALL SUBOPT_0x10
;    1975 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
;    1976 
;    1977 
;    1978 	while(gTx0Cnt);
_0x1B8:
	LDS  R30,_gTx0Cnt
	CPI  R30,0
	BRNE _0x1B8
;    1979 	for(i=0;i<MAX_wCK;i++){
	__GETWRN 16,17,0
_0x1BC:
	__CPWRN 16,17,31
	BRSH _0x1BD
;    1980 		if(Motion.wCK[i].Exist)
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
	LD   R30,X
	CPI  R30,0
	BREQ _0x1BE
;    1981 			SendSetCmd(i, 24, Motion.wCK[i].RIgain, Motion.wCK[i].RIgain);
	ST   -Y,R16
	LDI  R30,LOW(24)
	ST   -Y,R30
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x52
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x52
	CALL SUBOPT_0x5B
;    1982 	}
_0x1BE:
	__ADDWRN 16,17,1
	RJMP _0x1BC
_0x1BD:
;    1983 	gTx0BufIdx++;
	CALL SUBOPT_0x10
;    1984 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
;    1985 	delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x20
;    1986 }
	RJMP _0x317
;    1987 
;    1988 
;    1989 //------------------------------------------------------------------------------
;    1990 // 확장 포트값 송신
;    1991 //------------------------------------------------------------------------------
;    1992 void SendExPortD(void)
;    1993 {
_SendExPortD:
;    1994 	WORD	i;
;    1995 
;    1996 	UCSR0B &= 0x7F;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CBI  0xA,7
;    1997 	UCSR0B |= 0x40;
	SBI  0xA,6
;    1998 
;    1999 	while(gTx0Cnt);
_0x1BF:
	LDS  R30,_gTx0Cnt
	CPI  R30,0
	BRNE _0x1BF
;    2000 	for(i=0;i<MAX_wCK;i++){
	__GETWRN 16,17,0
_0x1C3:
	__CPWRN 16,17,31
	BRSH _0x1C4
;    2001 		if(Scene.wCK[i].Exist)
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
	LD   R30,X
	CPI  R30,0
	BREQ _0x1C5
;    2002 			SendSetCmd(i, 100, Scene.wCK[i].ExPortD, Scene.wCK[i].ExPortD);
	ST   -Y,R16
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x60
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x60
	CALL SUBOPT_0x5B
;    2003 	}
_0x1C5:
	__ADDWRN 16,17,1
	RJMP _0x1C3
_0x1C4:
;    2004 	gTx0BufIdx++;
	CALL SUBOPT_0x10
;    2005 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
;    2006 }
	RJMP _0x317
;    2007 
;    2008 
;    2009 //------------------------------------------------------------------------------
;    2010 // Flash에서 씬 정보 읽기
;    2011 //------------------------------------------------------------------------------
;    2012 void GetSceneFromFlash(void)
;    2013 {
_GetSceneFromFlash:
;    2014 	WORD i;
;    2015 	
;    2016 	Scene.NumOfFrame = gpFN_Table[gScIdx];
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CALL SUBOPT_0x61
	LDS  R26,_gpFN_Table
	LDS  R27,_gpFN_Table+1
	CALL SUBOPT_0x62
	CALL SUBOPT_0x63
;    2017 	Scene.RTime = gpRT_Table[gScIdx];
	CALL SUBOPT_0x61
	LDS  R26,_gpRT_Table
	LDS  R27,_gpRT_Table+1
	CALL SUBOPT_0x62
	CALL SUBOPT_0x64
;    2018 	for(i=0; i < MAX_wCK; i++){
_0x1C7:
	__CPWRN 16,17,31
	BRSH _0x1C8
;    2019 		Scene.wCK[i].Exist		= 0;
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x65
;    2020 		Scene.wCK[i].SPos		= 0;
	CALL SUBOPT_0x66
	CALL SUBOPT_0x65
;    2021 		Scene.wCK[i].DPos		= 0;
	CALL SUBOPT_0x67
	CALL SUBOPT_0x65
;    2022 		Scene.wCK[i].Torq		= 0;
	CALL SUBOPT_0x68
	CALL SUBOPT_0x65
;    2023 		Scene.wCK[i].ExPortD	= 0;
	CALL SUBOPT_0x60
	LDI  R30,LOW(0)
	ST   X,R30
;    2024 	}
	__ADDWRN 16,17,1
	RJMP _0x1C7
_0x1C8:
;    2025 	for(i=0; i < Motion.NumOfwCK; i++){
	__GETWRN 16,17,0
_0x1CA:
	CALL SUBOPT_0x56
	CP   R16,R30
	CPC  R17,R31
	BRLO PC+3
	JMP _0x1CB
;    2026 		Scene.wCK[wCK_IDs[i]].Exist		= 1;
	CALL SUBOPT_0x69
	CALL SUBOPT_0x5F
	LDI  R30,LOW(1)
	ST   X,R30
;    2027 		Scene.wCK[wCK_IDs[i]].SPos		= gpPos_Table[Motion.NumOfwCK*gScIdx+i];
	CALL SUBOPT_0x69
	__ADDW1MN _Scene,7
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6C
;    2028 		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[Motion.NumOfwCK*(gScIdx+1)+i];
	__ADDW1MN _Scene,8
	MOVW R22,R30
	__GETW2MN _Motion,8
	CALL SUBOPT_0x61
	ADIW R30,1
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	CALL SUBOPT_0x6C
;    2029 		Scene.wCK[wCK_IDs[i]].Torq		= gpT_Table[Motion.NumOfwCK*gScIdx+i];
	__ADDW1MN _Scene,9
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6D
	MOVW R26,R22
	ST   X,R30
;    2030 		Scene.wCK[wCK_IDs[i]].ExPortD	= gpE_Table[Motion.NumOfwCK*gScIdx+i];
	CALL SUBOPT_0x69
	__ADDW1MN _Scene,10
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
	LDS  R26,_gpE_Table
	LDS  R27,_gpE_Table+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
;    2031 	}
	__ADDWRN 16,17,1
	RJMP _0x1CA
_0x1CB:
;    2032 	UCSR0B &= 0x7F;
	CBI  0xA,7
;    2033 	UCSR0B |= 0x40;
	SBI  0xA,6
;    2034 	delay_us(1300);
	__DELAY_USW 4792
;    2035 }
	RJMP _0x317
;    2036 
;    2037 
;    2038 //------------------------------------------------------------------------------
;    2039 // 프레임 송신 간격 계산
;    2040 //------------------------------------------------------------------------------
;    2041 void CalcFrameInterval(void)
;    2042 {
_CalcFrameInterval:
;    2043 	float	tmp;
;    2044 
;    2045 	if((Scene.RTime / Scene.NumOfFrame) < 20){
	SBIW R28,4
;	tmp -> Y+0
	__GETW2MN _Scene,4
	CALL SUBOPT_0x29
	CALL __DIVW21U
	SBIW R30,20
	BRSH _0x1CC
;    2046 		F_ERR_CODE = INTERVAL_ERR;
	LDI  R30,LOW(6)
	MOV  R13,R30
;    2047 		return;
	RJMP _0x318
;    2048 	}
;    2049 	tmp = (float)Scene.RTime * 14.4;
_0x1CC:
	__GETW1MN _Scene,4
	CALL SUBOPT_0x6E
	__GETD2N 0x41666666
	CALL __MULF12
	CALL SUBOPT_0x0
;    2050 	tmp = tmp  / (float)Scene.NumOfFrame;
	CALL SUBOPT_0x29
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x2
	CALL __DIVF21
	CALL SUBOPT_0x0
;    2051 	TxInterval = 65535 - (WORD)tmp - 5;
	CALL SUBOPT_0x43
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	SUB  R26,R30
	SBC  R27,R31
	SBIW R26,5
	STS  _TxInterval,R26
	STS  _TxInterval+1,R27
;    2052 
;    2053 	RUN_LED1_ON;
	CBI  0x1B,5
;    2054 	F_SCENE_PLAYING = 1;
	SET
	BLD  R2,0
;    2055 	F_MOTION_STOPPED = 0;
	CLT
	BLD  R2,3
;    2056 	TCCR1B = 0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;    2057 
;    2058 	if(TxInterval <= 65509)	
	CPI  R26,LOW(0xFFE6)
	LDI  R30,HIGH(0xFFE6)
	CPC  R27,R30
	BRSH _0x1CD
;    2059 		TCNT1 = TxInterval+26;
	LDS  R30,_TxInterval
	LDS  R31,_TxInterval+1
	ADIW R30,26
	RJMP _0x328
;    2060 	else
_0x1CD:
;    2061 		TCNT1 = 65535;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x328:
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;    2062 
;    2063 	TIFR |= 0x04;
	CALL SUBOPT_0x2B
;    2064 	TIMSK |= 0x04;
;    2065 }
_0x318:
	ADIW R28,4
	RET
;    2066 
;    2067 
;    2068 //------------------------------------------------------------------------------
;    2069 // 프레임당 단위 이동량 계산
;    2070 //------------------------------------------------------------------------------
;    2071 void CalcUnitMove(void)
;    2072 {
_CalcUnitMove:
;    2073 	WORD	i;
;    2074 
;    2075 	for(i=0; i < MAX_wCK; i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x1D0:
	__CPWRN 16,17,31
	BRLO PC+3
	JMP _0x1D1
;    2076 		if(Scene.wCK[i].Exist){
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
	LD   R30,X
	CPI  R30,0
	BRNE PC+3
	JMP _0x1D2
;    2077 			if(Scene.wCK[i].SPos != Scene.wCK[i].DPos){
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x66
	LD   R22,X
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x67
	LD   R30,X
	CP   R30,R22
	BRNE PC+3
	JMP _0x1D3
;    2078 				gUnitD[i] = (float)((int)Scene.wCK[i].DPos - (int)Scene.wCK[i].SPos);
	CALL SUBOPT_0x6F
	MOVW R24,R30
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x67
	LD   R22,X
	CLR  R23
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x66
	CALL SUBOPT_0x5A
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R24
	CALL __PUTDP1
;    2079 				gUnitD[i] = (float)(gUnitD[i] / Scene.NumOfFrame);
	CALL SUBOPT_0x6F
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x70
	CALL SUBOPT_0x29
	CALL SUBOPT_0x6E
	CALL __DIVF21
	POP  R26
	POP  R27
	CALL __PUTDP1
;    2080 				if(gUnitD[i] > 253)			gUnitD[i] = 254;
	CALL SUBOPT_0x70
	__GETD1N 0x437D0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1D4
	CALL SUBOPT_0x71
	__GETD1N 0x437E0000
	RJMP _0x329
;    2081 				else if(gUnitD[i] < -253)	gUnitD[i] = -254;
_0x1D4:
	CALL SUBOPT_0x70
	__GETD1N 0xC37D0000
	CALL __CMPF12
	BRSH _0x1D6
	CALL SUBOPT_0x71
	__GETD1N 0xC37E0000
_0x329:
	CALL __PUTDP1
;    2082 			}
_0x1D6:
;    2083 			else
	RJMP _0x1D7
_0x1D3:
;    2084 				gUnitD[i] = 0;
	CALL SUBOPT_0x71
	__GETD1N 0x0
	CALL __PUTDP1
;    2085 		}
_0x1D7:
;    2086 	}
_0x1D2:
	__ADDWRN 16,17,1
	RJMP _0x1D0
_0x1D1:
;    2087 	gFrameIdx = 0;
	LDI  R30,0
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R30
;    2088 }
_0x317:
	LD   R16,Y+
	LD   R17,Y+
	RET
;    2089 
;    2090 
;    2091 //------------------------------------------------------------------------------
;    2092 // 한 프레임 송신 준비
;    2093 //------------------------------------------------------------------------------
;    2094 void MakeFrame(void)
;    2095 {
_MakeFrame:
;    2096 	BYTE	i, tmp;
;    2097 	int		wTmp;
;    2098 
;    2099 	while(gTx0Cnt);
	CALL __SAVELOCR4
;	i -> R16
;	tmp -> R17
;	wTmp -> R18,R19
_0x1D8:
	LDS  R30,_gTx0Cnt
	CPI  R30,0
	BRNE _0x1D8
;    2100 	gFrameIdx++;
	LDS  R30,_gFrameIdx
	LDS  R31,_gFrameIdx+1
	ADIW R30,1
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R31
;    2101 
;    2102 	for(i=0; i < MAX_wCK; i++){
	LDI  R16,LOW(0)
_0x1DC:
	CPI  R16,31
	BRLO PC+3
	JMP _0x1DD
;    2103 		if(Scene.wCK[i].Exist){
	LDI  R30,LOW(5)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x5F
	LD   R30,X
	CPI  R30,0
	BRNE PC+3
	JMP _0x1DE
;    2104 			if(Scene.wCK[i].Torq < 5){
	LDI  R30,LOW(5)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x68
	LD   R26,X
	CPI  R26,LOW(0x5)
	BRLO PC+3
	JMP _0x1DF
;    2105 				wTmp = (int)Scene.wCK[i].SPos + Round((float)gFrameIdx*gUnitD[i],1 );
	LDI  R30,LOW(5)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x66
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
;    2106 				if(Motion.PF != PF2){
	__GETB2MN _Motion,5
	CPI  R26,LOW(0x4)
	BREQ _0x1E0
;    2107 					wTmp = wTmp + gPoseDelta[i];
	MOV  R30,R16
	LDI  R26,LOW(_gPoseDelta)
	LDI  R27,HIGH(_gPoseDelta)
	CALL SUBOPT_0x1F
	__ADDWRR 18,19,30,31
;    2108 				}
;    2109 				if(wTmp > 254)		wTmp = 254;
_0x1E0:
	__CPWRN 18,19,255
	BRLT _0x1E1
	__GETWRN 18,19,254
;    2110 				else if(wTmp < 1)	wTmp = 1;
	RJMP _0x1E2
_0x1E1:
	__CPWRN 18,19,1
	BRGE _0x1E3
	__GETWRN 18,19,1
;    2111 				tmp = (BYTE)wTmp;
_0x1E3:
_0x1E2:
	MOV  R17,R18
;    2112 			}
;    2113 			else{
	RJMP _0x1E4
_0x1DF:
;    2114 				tmp = Scene.wCK[i].DPos;
	LDI  R30,LOW(5)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x67
	LD   R17,X
;    2115 			}
_0x1E4:
;    2116 			PosSend(i,tmp, Scene.wCK[i].Torq);
	ST   -Y,R16
	ST   -Y,R17
	LDI  R30,LOW(5)
	MUL  R30,R16
	MOVW R30,R0
	CALL SUBOPT_0x68
	LD   R30,X
	ST   -Y,R30
	CALL _PosSend
;    2117 		}
;    2118 	}
_0x1DE:
	SUBI R16,-1
	RJMP _0x1DC
_0x1DD:
;    2119 }
	RJMP _0x315
;    2120 
;    2121 
;    2122 //------------------------------------------------------------------------------
;    2123 // 한 프레임 송신
;    2124 //------------------------------------------------------------------------------
;    2125 void SendFrame(void)
;    2126 {
_SendFrame:
;    2127 	if(gTx0Cnt == 0)	return;
	LDS  R30,_gTx0Cnt
	CPI  R30,0
	BRNE _0x1E5
	RET
;    2128 
;    2129 	gTx0BufIdx++;
_0x1E5:
	CALL SUBOPT_0x10
;    2130 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
;    2131 }
	RET
;    2132 
;    2133 
;    2134 //------------------------------------------------------------------------------
;    2135 // HUNO의 0점 자세, HUNO, DINO, DOGY 기본 자세 동작
;    2136 //------------------------------------------------------------------------------
;    2137 void BasicPose(BYTE PF, WORD NOF, WORD RT, BYTE TQ)
;    2138 {
_BasicPose:
;    2139 	BYTE	trigger = 0;
;    2140 	WORD	i;
;    2141 
;    2142 	if(F_CHARGING)	return;
	CALL __SAVELOCR3
;	PF -> Y+8
;	NOF -> Y+6
;	RT -> Y+4
;	TQ -> Y+3
;	trigger -> R16
;	i -> R17,R18
	LDI  R16,0
	SBRC R2,6
	RJMP _0x316
;    2143 	if(F_PF == PF2)	return;
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x1E7
	RJMP _0x316
;    2144 	if(F_PF != PF1_HUNO && PF == 0){
_0x1E7:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ _0x1E9
	LDD  R26,Y+8
	CPI  R26,LOW(0x0)
	BREQ _0x1EA
_0x1E9:
	RJMP _0x1E8
_0x1EA:
;    2145 		F_ERR_CODE = PF_MATCH_ERR;
	LDI  R30,LOW(5)
	MOV  R13,R30
;    2146 		return;
	RJMP _0x316
;    2147 	}
;    2148 	
;    2149 	if(NOF != 1){
_0x1E8:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BREQ _0x1EB
;    2150 		if(PF == PF1_HUNO)		SendToSoundIC(1);
	LDD  R26,Y+8
	CPI  R26,LOW(0x1)
	BRNE _0x1EC
	LDI  R30,LOW(1)
	RJMP _0x32A
;    2151 		else if(PF == PF1_DOGY)	SendToSoundIC(9);
_0x1EC:
	LDD  R26,Y+8
	CPI  R26,LOW(0x3)
	BRNE _0x1EE
	LDI  R30,LOW(9)
_0x32A:
	ST   -Y,R30
	CALL _SendToSoundIC
;    2152 	}
_0x1EE:
;    2153 
;    2154 	Motion.PF = PF;
_0x1EB:
	LDD  R30,Y+8
	__PUTB1MN _Motion,5
;    2155 	Motion.NumOfScene = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x72
;    2156 	Motion.NumOfwCK = 16;
;    2157 	gLastID = 15;
	LDI  R30,LOW(15)
	STS  _gLastID,R30
;    2158 
;    2159 	for(i=0; i < Motion.NumOfwCK; i++){
	__GETWRN 17,18,0
_0x1F0:
	CALL SUBOPT_0x56
	CP   R17,R30
	CPC  R18,R31
	BRLO PC+3
	JMP _0x1F1
;    2160 		Motion.wCK[i].Exist		= 1;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x4E
	LDI  R30,LOW(1)
	ST   X,R30
;    2161 		if(i>9){
	__CPWRN 17,18,10
	BRLO _0x1F2
;    2162 			Motion.wCK[i].RPgain	= 15;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x50
	LDI  R30,LOW(15)
	ST   X,R30
;    2163 			Motion.wCK[i].RDgain	= 25;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x51
	LDI  R30,LOW(25)
	RJMP _0x32B
;    2164 		}
;    2165 		else{
_0x1F2:
;    2166 			Motion.wCK[i].RPgain	= 20;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x50
	LDI  R30,LOW(20)
	ST   X,R30
;    2167 			Motion.wCK[i].RDgain	= 30;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x51
	LDI  R30,LOW(30)
_0x32B:
	ST   X,R30
;    2168 		}
;    2169 		Motion.wCK[i].RIgain	= 0;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x52
	LDI  R30,LOW(0)
	ST   X,R30
;    2170 		Motion.wCK[i].PortEn	= 1;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x53
	LDI  R30,LOW(1)
	ST   X,R30
;    2171 		Motion.wCK[i].InitPos	= (int)MotionZeroPos[i];
	CALL SUBOPT_0x73
	CALL SUBOPT_0x54
	__GETW1R 17,18
	SUBI R30,LOW(-_MotionZeroPos*2)
	SBCI R31,HIGH(-_MotionZeroPos*2)
	LPM  R30,Z
	ST   X,R30
;    2172 		gPoseDelta[i] = (int)eM_OriginPose[i] - (int)MotionZeroPos[i];
	__GETW1R 17,18
	LDI  R26,LOW(_gPoseDelta)
	LDI  R27,HIGH(_gPoseDelta)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x74
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
;    2173 	}
	__ADDWRN 17,18,1
	RJMP _0x1F0
_0x1F1:
;    2174 	SendTGain();
	CALL _SendTGain
;    2175 	F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;    2176 	for(i=0; i < MAX_wCK; i++){					
	__GETWRN 17,18,0
_0x1F5:
	__CPWRN 17,18,31
	BRSH _0x1F6
;    2177 		if(Motion.wCK[i].Exist){ Scene.wCK[i].Exist = 1; }
	CALL SUBOPT_0x73
	CALL SUBOPT_0x4E
	LD   R30,X
	CPI  R30,0
	BREQ _0x1F7
	CALL SUBOPT_0x75
	CALL SUBOPT_0x5F
	LDI  R30,LOW(1)
	ST   X,R30
;    2178 	}
_0x1F7:
	__ADDWRN 17,18,1
	RJMP _0x1F5
_0x1F6:
;    2179 	GetPose();
	CALL SUBOPT_0x76
;    2180 	if(F_ERR_CODE != NO_ERR)	return;
	BREQ _0x1F8
	RJMP _0x316
;    2181 	trigger = 0;
_0x1F8:
	LDI  R16,LOW(0)
;    2182 	for(i=0; i < Motion.NumOfwCK; i++){
	__GETWRN 17,18,0
_0x1FA:
	CALL SUBOPT_0x56
	CP   R17,R30
	CPC  R18,R31
	BRSH _0x1FB
;    2183 		if( abs((float)Scene.wCK[i].DPos - (float)Scene.wCK[i].SPos) > 5 ){
	CALL SUBOPT_0x75
	CALL SUBOPT_0x67
	CALL SUBOPT_0x77
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x75
	CALL SUBOPT_0x66
	CALL SUBOPT_0x77
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3
	CALL SUBOPT_0x78
	SBIW R30,6
	BRLO _0x1FC
;    2184 			trigger = 1;
	LDI  R16,LOW(1)
;    2185 			break;
	RJMP _0x1FB
;    2186 		}
;    2187 	}
_0x1FC:
	__ADDWRN 17,18,1
	RJMP _0x1FA
_0x1FB:
;    2188 	if(trigger){
	CPI  R16,0
	BREQ _0x1FD
;    2189 		trigger = 0;
	LDI  R16,LOW(0)
;    2190 		Scene.NumOfFrame = NOF;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x63
;    2191 		Scene.RTime = RT;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x32C
;    2192 	}
;    2193 	else{
_0x1FD:
;    2194 		Scene.NumOfFrame = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x63
;    2195 		Scene.RTime = 20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
_0x32C:
	__PUTW1MN _Scene,4
;    2196 	}
;    2197 
;    2198 	for(i=0; i < Motion.NumOfwCK; i++){
	__GETWRN 17,18,0
_0x200:
	CALL SUBOPT_0x56
	CP   R17,R30
	CPC  R18,R31
	BRLO PC+3
	JMP _0x201
;    2199 		if(PF == 0){			Scene.wCK[i].DPos = eM_OriginPose[i];}
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x202
	CALL SUBOPT_0x75
	__ADDW1MN _Scene,8
	MOVW R0,R30
	CALL SUBOPT_0x74
	MOVW R26,R0
	RJMP _0x32D
;    2200 		else if(PF == PF1_HUNO){Scene.wCK[i].DPos = fM1_BasicPose[i];}
_0x202:
	LDD  R26,Y+8
	CPI  R26,LOW(0x1)
	BRNE _0x204
	CALL SUBOPT_0x75
	CALL SUBOPT_0x67
	__GETW1R 17,18
	SUBI R30,LOW(-_fM1_BasicPose*2)
	SBCI R31,HIGH(-_fM1_BasicPose*2)
	RJMP _0x32E
;    2201 		else if(PF == PF1_DINO){Scene.wCK[i].DPos = fM2_BasicPose[i];}
_0x204:
	LDD  R26,Y+8
	CPI  R26,LOW(0x2)
	BRNE _0x206
	CALL SUBOPT_0x75
	CALL SUBOPT_0x67
	__GETW1R 17,18
	SUBI R30,LOW(-_fM2_BasicPose*2)
	SBCI R31,HIGH(-_fM2_BasicPose*2)
	RJMP _0x32E
;    2202 		else if(PF == PF1_DOGY){Scene.wCK[i].DPos = fM3_BasicPose[i];}
_0x206:
	LDD  R26,Y+8
	CPI  R26,LOW(0x3)
	BRNE _0x208
	CALL SUBOPT_0x75
	CALL SUBOPT_0x67
	__GETW1R 17,18
	SUBI R30,LOW(-_fM3_BasicPose*2)
	SBCI R31,HIGH(-_fM3_BasicPose*2)
_0x32E:
	LPM  R30,Z
_0x32D:
	ST   X,R30
;    2203 		Scene.wCK[i].Torq		= TQ;
_0x208:
	CALL SUBOPT_0x75
	__ADDW1MN _Scene,9
	LDD  R26,Y+3
	STD  Z+0,R26
;    2204 		Scene.wCK[i].ExPortD	= 1;
	CALL SUBOPT_0x75
	CALL SUBOPT_0x60
	LDI  R30,LOW(1)
	ST   X,R30
;    2205 	}
	__ADDWRN 17,18,1
	RJMP _0x200
_0x201:
;    2206 	RUN_LED1_ON;
	CBI  0x1B,5
;    2207 	SendExPortD();
	CALL SUBOPT_0x79
;    2208 
;    2209 	CalcFrameInterval();
;    2210 	if(F_ERR_CODE != NO_ERR)	return;
	BREQ _0x209
	RJMP _0x316
;    2211 	CalcUnitMove();
_0x209:
	CALL SUBOPT_0x7A
;    2212 	MakeFrame();
;    2213 	SendFrame();
;    2214 	while(F_SCENE_PLAYING);
_0x20A:
	SBRC R2,0
	RJMP _0x20A
;    2215 	if(F_MOTION_STOPPED == 1)	return;
	SBRC R2,3
	RJMP _0x316
;    2216 	if(NOF > 1){
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BRLO _0x20E
;    2217 		delay_ms(800);
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	CALL SUBOPT_0x20
;    2218 		GetPose();
	CALL SUBOPT_0x76
;    2219 		if(F_ERR_CODE != NO_ERR)	return;
	BREQ _0x20F
	RJMP _0x316
;    2220 		for(i=0; i < Motion.NumOfwCK; i++){
_0x20F:
	__GETWRN 17,18,0
_0x211:
	CALL SUBOPT_0x56
	CP   R17,R30
	CPC  R18,R31
	BRSH _0x212
;    2221 			if( abs((float)Scene.wCK[i].DPos - (float)Scene.wCK[i].SPos) > 10 ){
	CALL SUBOPT_0x75
	CALL SUBOPT_0x67
	CALL SUBOPT_0x77
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x75
	CALL SUBOPT_0x66
	CALL SUBOPT_0x77
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3
	CALL SUBOPT_0x78
	SBIW R30,11
	BRLO _0x213
;    2222 				F_ERR_CODE = WCK_POS_ERR;
	LDI  R30,LOW(10)
	MOV  R13,R30
;    2223 				break;
	RJMP _0x212
;    2224 			}
;    2225 		}
_0x213:
	__ADDWRN 17,18,1
	RJMP _0x211
_0x212:
;    2226 	}
;    2227 	RUN_LED1_OFF;
_0x20E:
	SBI  0x1B,5
;    2228 }
_0x316:
	CALL __LOADLOCR3
	ADIW R28,9
	RET
;    2229 
;    2230 
;    2231 //------------------------------------------------------------------------------
;    2232 // 현재 자세 읽기
;    2233 //------------------------------------------------------------------------------
;    2234 void GetPose(void)
;    2235 {
_GetPose:
;    2236 	WORD	i, tmp;
;    2237 
;    2238 	UCSR0B |= 0x80;
	CALL __SAVELOCR4
;	i -> R16,R17
;	tmp -> R18,R19
	SBI  0xA,7
;    2239 	UCSR0B &= 0xBF;
	CBI  0xA,6
;    2240 	for(i=0; i < MAX_wCK; i++){
	__GETWRN 16,17,0
_0x215:
	__CPWRN 16,17,31
	BRSH _0x216
;    2241 		if(Motion.wCK[i].Exist){
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
	LD   R30,X
	CPI  R30,0
	BREQ _0x217
;    2242 			tmp = PosRead(i);
	CALL SUBOPT_0x7B
;    2243 			if(tmp == 444){
	BRNE _0x218
;    2244 				tmp = PosRead(i);
	CALL SUBOPT_0x7B
;    2245 				if(tmp == 444){
	BRNE _0x219
;    2246 					tmp = PosRead(i);
	CALL SUBOPT_0x7B
;    2247 					if(tmp == 444){
	BRNE _0x21A
;    2248 						F_ERR_CODE = WCK_NO_ACK_ERR;
	LDI  R30,LOW(11)
	MOV  R13,R30
;    2249 						return;
	RJMP _0x315
;    2250 					}
;    2251 				}
_0x21A:
;    2252 			}
_0x219:
;    2253 			Scene.wCK[i].SPos = (BYTE)tmp;
_0x218:
	CALL SUBOPT_0x5E
	__POINTW2MN _Scene,7
	ADD  R26,R30
	ADC  R27,R31
	ST   X,R18
;    2254 		}
;    2255 	}
_0x217:
	__ADDWRN 16,17,1
	RJMP _0x215
_0x216:
;    2256 }
_0x315:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;    2257 
;    2258 
;    2259 
;    2260 //------------------------------------------------------------------------------
;    2261 // 모션 트위닝 씬 실행
;    2262 //------------------------------------------------------------------------------
;    2263 void MotionTweenFlash(BYTE GapMax)
;    2264 {
_MotionTweenFlash:
;    2265 	WORD	i;
;    2266 
;    2267 	Scene.NumOfFrame = (WORD)GapMax;
	ST   -Y,R17
	ST   -Y,R16
;	GapMax -> Y+2
;	i -> R16,R17
	LDD  R30,Y+2
	LDI  R31,0
	CALL SUBOPT_0x63
;    2268 	Scene.RTime = (WORD)GapMax*20;
	LDD  R30,Y+2
	LDI  R26,LOW(20)
	MUL  R30,R26
	MOVW R30,R0
	CALL SUBOPT_0x64
;    2269 	for(i=0;i<MAX_wCK;i++){
_0x21C:
	__CPWRN 16,17,31
	BRSH _0x21D
;    2270 		Scene.wCK[i].Exist		= 0;
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x65
;    2271 		Scene.wCK[i].DPos		= 0;
	CALL SUBOPT_0x67
	CALL SUBOPT_0x65
;    2272 		Scene.wCK[i].Torq		= 0;
	CALL SUBOPT_0x68
	CALL SUBOPT_0x65
;    2273 		Scene.wCK[i].ExPortD	= 0;
	CALL SUBOPT_0x60
	LDI  R30,LOW(0)
	ST   X,R30
;    2274 	}
	__ADDWRN 16,17,1
	RJMP _0x21C
_0x21D:
;    2275 	for(i=0;i<Motion.NumOfwCK;i++){
	__GETWRN 16,17,0
_0x21F:
	CALL SUBOPT_0x56
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x220
;    2276 		Scene.wCK[wCK_IDs[i]].Exist		= 1;
	CALL SUBOPT_0x69
	CALL SUBOPT_0x5F
	LDI  R30,LOW(1)
	ST   X,R30
;    2277 		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[i];
	CALL SUBOPT_0x69
	__ADDW1MN _Scene,8
	CALL SUBOPT_0x58
	CALL SUBOPT_0x7C
	MOVW R26,R0
	ST   X,R30
;    2278 		Scene.wCK[wCK_IDs[i]].Torq		= 3;
	CALL SUBOPT_0x69
	CALL SUBOPT_0x68
	LDI  R30,LOW(3)
	ST   X,R30
;    2279 		Scene.wCK[wCK_IDs[i]].ExPortD	= 0;
	CALL SUBOPT_0x69
	CALL SUBOPT_0x60
	LDI  R30,LOW(0)
	ST   X,R30
;    2280 	}
	__ADDWRN 16,17,1
	RJMP _0x21F
_0x220:
;    2281 	UCSR0B &= 0x7F;
	CBI  0xA,7
;    2282 	UCSR0B |= 0x40;
	SBI  0xA,6
;    2283 	SendExPortD();
	CALL SUBOPT_0x79
;    2284 	CalcFrameInterval();
;    2285 	if(F_ERR_CODE != NO_ERR)	return;
	BREQ _0x221
	RJMP _0x314
;    2286 	CalcUnitMove();
_0x221:
	CALL SUBOPT_0x7A
;    2287 	MakeFrame();
;    2288 	SendFrame();
;    2289 	while(F_SCENE_PLAYING);
_0x222:
	SBRC R2,0
	RJMP _0x222
;    2290 	if(F_MOTION_STOPPED == 1)	return;
;    2291 }
_0x314:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
;    2292 
;    2293 
;    2294 //------------------------------------------------------------------------------
;    2295 // 모션 플레이(내부 Flash 데이터 이용)
;    2296 //------------------------------------------------------------------------------
;    2297 void M_PlayFlash(void)
;    2298 {
_M_PlayFlash:
;    2299 	float	lGapMax = 0;
;    2300 	WORD	i;
;    2301 
;    2302 	if(F_CHARGING) return;
	SBIW R28,4
	LDI  R24,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x226*2)
	LDI  R31,HIGH(_0x226*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	lGapMax -> Y+2
;	i -> R16,R17
	SBRC R2,6
	RJMP _0x313
;    2303 
;    2304 	GetMotionFromFlash();
	CALL _GetMotionFromFlash
;    2305 	SendTGain();
	CALL _SendTGain
;    2306 
;    2307 	F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;    2308 
;    2309 	GetPose();
	CALL SUBOPT_0x76
;    2310 	if(F_ERR_CODE != NO_ERR)	return;
	BREQ _0x228
	RJMP _0x313
;    2311 	for(i=0;i<Motion.NumOfwCK;i++){
_0x228:
	__GETWRN 16,17,0
_0x22A:
	CALL SUBOPT_0x56
	CP   R16,R30
	CPC  R17,R31
	BRLO PC+3
	JMP _0x22B
;    2312 		if( abs((float)gpPos_Table[i]-(float)Scene.wCK[i].SPos) > lGapMax )
	MOVW R30,R16
	CALL SUBOPT_0x7C
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x66
	CALL SUBOPT_0x77
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3
	CALL SUBOPT_0x78
	MOVW R26,R30
	__GETD1S 2
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x22C
;    2313 			lGapMax = abs((float)gpPos_Table[i]-(float)Scene.wCK[i].SPos);
	MOVW R30,R16
	CALL SUBOPT_0x7C
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x66
	CALL SUBOPT_0x77
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3
	CALL SUBOPT_0x78
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x45
;    2314 		if(gpT_Table[i] == 6)
_0x22C:
	MOVW R30,R16
	CALL SUBOPT_0x6D
	CPI  R30,LOW(0x6)
	BRNE _0x22D
;    2315 			lGapMax = 0;
	__CLRD1S 2
;    2316 	}
_0x22D:
	__ADDWRN 16,17,1
	RJMP _0x22A
_0x22B:
;    2317 	if(lGapMax > POS_MARGIN)	MotionTweenFlash((BYTE)(lGapMax/3));
	CALL SUBOPT_0x44
	CALL SUBOPT_0x42
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x22E
	CALL SUBOPT_0x44
	__GETD1N 0x40400000
	CALL __DIVF21
	CALL __CFD1
	ST   -Y,R30
	CALL _MotionTweenFlash
;    2318 
;    2319 	for(i=0; i < Motion.NumOfScene; i++){
_0x22E:
	__GETWRN 16,17,0
_0x230:
	__GETW1MN _Motion,6
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x231
;    2320 		gScIdx = i;
	__PUTWMRN _gScIdx,0,16,17
;    2321 		GetSceneFromFlash();
	CALL _GetSceneFromFlash
;    2322 		SendExPortD();
	CALL SUBOPT_0x79
;    2323 		CalcFrameInterval();
;    2324 		if(F_ERR_CODE != NO_ERR)	break;
	BRNE _0x231
;    2325 		CalcUnitMove();
	CALL SUBOPT_0x7A
;    2326 		MakeFrame();
;    2327 		SendFrame();
;    2328 		while(F_SCENE_PLAYING);
_0x233:
	SBRC R2,0
	RJMP _0x233
;    2329 		if(F_MOTION_STOPPED == 1)	break;
	SBRC R2,3
	RJMP _0x231
;    2330 	}
	__ADDWRN 16,17,1
	RJMP _0x230
_0x231:
;    2331 }
_0x313:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;    2332 
;    2333 
;    2334 //------------------------------------------------------------------------------
;    2335 // 모션 실행
;    2336 //------------------------------------------------------------------------------
;    2337 void M_Play(BYTE BtnCode)
;    2338 {
_M_Play:
;    2339 	if(BtnCode == BTN_C){
;	BtnCode -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x237
;    2340 		P_BMC504_RESET(0);
	CBI  0x18,6
;    2341 		delay_ms(20);
	CALL SUBOPT_0x3C
;    2342 		P_BMC504_RESET(1);
	SBI  0x18,6
;    2343 		delay_ms(20);
	CALL SUBOPT_0x3C
;    2344 		BasicPose(F_PF, 50, 1000, 4);
	ST   -Y,R12
	CALL SUBOPT_0x7D
;    2345 		if(F_ERR_CODE != NO_ERR){
	LDI  R30,LOW(255)
	CP   R30,R13
	BREQ _0x23C
;    2346 			gSEC_DCOUNT = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x26
;    2347 			EIMSK &= 0xBF;
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;    2348 			while(gSEC_DCOUNT){
_0x23D:
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0x23F
;    2349 				if(g10MSEC == 0 || g10MSEC == 50){
	CALL SUBOPT_0x32
	BREQ _0x241
	CALL SUBOPT_0x24
	SBIW R26,50
	BRNE _0x240
_0x241:
;    2350 					Get_VOLTAGE();
	CALL SUBOPT_0x2F
;    2351 					DetectPower();
;    2352 					IoUpdate();
	RCALL _IoUpdate
;    2353 				}
;    2354 				if(g10MSEC < 25)		ERR_LED_ON;
_0x240:
	CALL SUBOPT_0x24
	SBIW R26,25
	BRSH _0x243
	CBI  0x1B,7
;    2355 				else if(g10MSEC < 50)	ERR_LED_OFF;
	RJMP _0x244
_0x243:
	CALL SUBOPT_0x24
	SBIW R26,50
	BRSH _0x245
	RJMP _0x32F
;    2356 				else if(g10MSEC < 75)	ERR_LED_ON;
_0x245:
	CALL SUBOPT_0x36
	BRSH _0x247
	CBI  0x1B,7
;    2357 				else if(g10MSEC < 100)	ERR_LED_OFF;
	RJMP _0x248
_0x247:
	CALL SUBOPT_0x37
	BRSH _0x249
_0x32F:
	SBI  0x1B,7
;    2358 			}
_0x249:
_0x248:
_0x244:
	RJMP _0x23D
_0x23F:
;    2359 			F_ERR_CODE = NO_ERR;
	LDI  R30,LOW(255)
	MOV  R13,R30
;    2360 			EIMSK |= 0x40;
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    2361 		}
;    2362 		return;
_0x23C:
	ADIW R28,1
	RET
;    2363 	}
;    2364 	if(F_PF == PF1_HUNO){
_0x237:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ PC+3
	JMP _0x24A
;    2365 		switch(BtnCode){
	LD   R30,Y
;    2366 			case BTN_A:
	CPI  R30,LOW(0x1)
	BRNE _0x24E
;    2367 			 	SendToSoundIC(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2368 				gpT_Table	= HUNOBASIC_GETUPFRONT_Torque;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_Torque*2)
	CALL SUBOPT_0x7E
;    2369 				gpE_Table	= HUNOBASIC_GETUPFRONT_Port;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_Port*2)
	CALL SUBOPT_0x7F
;    2370 				gpPg_Table 	= HUNOBASIC_GETUPFRONT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2371 				gpDg_Table 	= HUNOBASIC_GETUPFRONT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2372 				gpIg_Table 	= HUNOBASIC_GETUPFRONT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2373 				gpFN_Table	= HUNOBASIC_GETUPFRONT_Frames;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_Frames*2)
	CALL SUBOPT_0x83
;    2374 				gpRT_Table	= HUNOBASIC_GETUPFRONT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_TrTime*2)
	CALL SUBOPT_0x84
;    2375 				gpPos_Table	= HUNOBASIC_GETUPFRONT_Position;
	LDI  R30,LOW(_HUNOBASIC_GETUPFRONT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPFRONT_Position*2)
	CALL SUBOPT_0x85
;    2376 				Motion.NumOfScene = HUNOBASIC_GETUPFRONT_NUM_OF_SCENES;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0x72
;    2377 				Motion.NumOfwCK = HUNOBASIC_GETUPFRONT_NUM_OF_WCKS;
;    2378 				break;
	RJMP _0x24D
;    2379 			case BTN_B:
_0x24E:
	CPI  R30,LOW(0x2)
	BRNE _0x24F
;    2380 			 	SendToSoundIC(8);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2381 				gpT_Table	= HUNOBASIC_GETUPBACK_Torque;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_Torque*2)
	CALL SUBOPT_0x7E
;    2382 				gpE_Table	= HUNOBASIC_GETUPBACK_Port;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_Port*2)
	CALL SUBOPT_0x7F
;    2383 				gpPg_Table 	= HUNOBASIC_GETUPBACK_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2384 				gpDg_Table 	= HUNOBASIC_GETUPBACK_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2385 				gpIg_Table 	= HUNOBASIC_GETUPBACK_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2386 				gpFN_Table	= HUNOBASIC_GETUPBACK_Frames;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_Frames*2)
	CALL SUBOPT_0x83
;    2387 				gpRT_Table	= HUNOBASIC_GETUPBACK_TrTime;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_TrTime*2)
	CALL SUBOPT_0x84
;    2388 				gpPos_Table	= HUNOBASIC_GETUPBACK_Position;
	LDI  R30,LOW(_HUNOBASIC_GETUPBACK_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_GETUPBACK_Position*2)
	CALL SUBOPT_0x86
;    2389 				Motion.NumOfScene = HUNOBASIC_GETUPBACK_NUM_OF_SCENES;
;    2390 				Motion.NumOfwCK = HUNOBASIC_GETUPBACK_NUM_OF_WCKS;
;    2391 				break;
	RJMP _0x24D
;    2392 			case BTN_LR:
_0x24F:
	CPI  R30,LOW(0x3)
	BRNE _0x250
;    2393 			 	SendToSoundIC(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2394 				gpT_Table	= HUNOBASIC_TURNLEFT_Torque;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_Torque*2)
	CALL SUBOPT_0x7E
;    2395 				gpE_Table	= HUNOBASIC_TURNLEFT_Port;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_Port*2)
	CALL SUBOPT_0x7F
;    2396 				gpPg_Table 	= HUNOBASIC_TURNLEFT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2397 				gpDg_Table 	= HUNOBASIC_TURNLEFT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2398 				gpIg_Table 	= HUNOBASIC_TURNLEFT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2399 				gpFN_Table	= HUNOBASIC_TURNLEFT_Frames;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_Frames*2)
	CALL SUBOPT_0x83
;    2400 				gpRT_Table	= HUNOBASIC_TURNLEFT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_TrTime*2)
	CALL SUBOPT_0x84
;    2401 				gpPos_Table	= HUNOBASIC_TURNLEFT_Position;
	LDI  R30,LOW(_HUNOBASIC_TURNLEFT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNLEFT_Position*2)
	CALL SUBOPT_0x87
;    2402 				Motion.NumOfScene = HUNOBASIC_TURNLEFT_NUM_OF_SCENES;
;    2403 				Motion.NumOfwCK = HUNOBASIC_TURNLEFT_NUM_OF_WCKS;
;    2404 				break;
	RJMP _0x24D
;    2405 			case BTN_U:
_0x250:
	CPI  R30,LOW(0x4)
	BRNE _0x251
;    2406 			 	SendToSoundIC(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2407 				gpT_Table	= HUNOBASIC_WALKFORWARD_Torque;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_Torque*2)
	CALL SUBOPT_0x7E
;    2408 				gpE_Table	= HUNOBASIC_WALKFORWARD_Port;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_Port*2)
	CALL SUBOPT_0x7F
;    2409 				gpPg_Table 	= HUNOBASIC_WALKFORWARD_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2410 				gpDg_Table 	= HUNOBASIC_WALKFORWARD_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2411 				gpIg_Table 	= HUNOBASIC_WALKFORWARD_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2412 				gpFN_Table	= HUNOBASIC_WALKFORWARD_Frames;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_Frames*2)
	CALL SUBOPT_0x83
;    2413 				gpRT_Table	= HUNOBASIC_WALKFORWARD_TrTime;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_TrTime*2)
	CALL SUBOPT_0x84
;    2414 				gpPos_Table	= HUNOBASIC_WALKFORWARD_Position;
	LDI  R30,LOW(_HUNOBASIC_WALKFORWARD_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKFORWARD_Position*2)
	CALL SUBOPT_0x85
;    2415 				Motion.NumOfScene = HUNOBASIC_WALKFORWARD_NUM_OF_SCENES;
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x72
;    2416 				Motion.NumOfwCK = HUNOBASIC_WALKFORWARD_NUM_OF_WCKS;
;    2417 				break;
	RJMP _0x24D
;    2418 			case BTN_RR:
_0x251:
	CPI  R30,LOW(0x5)
	BRNE _0x252
;    2419 			 	SendToSoundIC(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2420 				gpT_Table	= HUNOBASIC_TURNRIGHT_Torque;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_Torque*2)
	CALL SUBOPT_0x7E
;    2421 				gpE_Table	= HUNOBASIC_TURNRIGHT_Port;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_Port*2)
	CALL SUBOPT_0x7F
;    2422 				gpPg_Table 	= HUNOBASIC_TURNRIGHT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2423 				gpDg_Table 	= HUNOBASIC_TURNRIGHT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2424 				gpIg_Table 	= HUNOBASIC_TURNRIGHT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2425 				gpFN_Table	= HUNOBASIC_TURNRIGHT_Frames;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_Frames*2)
	CALL SUBOPT_0x83
;    2426 				gpRT_Table	= HUNOBASIC_TURNRIGHT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_TrTime*2)
	CALL SUBOPT_0x84
;    2427 				gpPos_Table	= HUNOBASIC_TURNRIGHT_Position;
	LDI  R30,LOW(_HUNOBASIC_TURNRIGHT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_TURNRIGHT_Position*2)
	CALL SUBOPT_0x87
;    2428 				Motion.NumOfScene = HUNOBASIC_TURNRIGHT_NUM_OF_SCENES;
;    2429 				Motion.NumOfwCK = HUNOBASIC_TURNRIGHT_NUM_OF_WCKS;
;    2430 				break;
	RJMP _0x24D
;    2431 			case BTN_L:
_0x252:
	CPI  R30,LOW(0x6)
	BRNE _0x253
;    2432 			 	SendToSoundIC(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2433 				gpT_Table	= HUNOBASIC_SIDEWALKLEFT_Torque;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_Torque*2)
	CALL SUBOPT_0x7E
;    2434 				gpE_Table	= HUNOBASIC_SIDEWALKLEFT_Port;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_Port*2)
	CALL SUBOPT_0x7F
;    2435 				gpPg_Table 	= HUNOBASIC_SIDEWALKLEFT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2436 				gpDg_Table 	= HUNOBASIC_SIDEWALKLEFT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2437 				gpIg_Table 	= HUNOBASIC_SIDEWALKLEFT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2438 				gpFN_Table	= HUNOBASIC_SIDEWALKLEFT_Frames;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_Frames*2)
	CALL SUBOPT_0x83
;    2439 				gpRT_Table	= HUNOBASIC_SIDEWALKLEFT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_TrTime*2)
	CALL SUBOPT_0x84
;    2440 				gpPos_Table	= HUNOBASIC_SIDEWALKLEFT_Position;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKLEFT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKLEFT_Position*2)
	CALL SUBOPT_0x87
;    2441 				Motion.NumOfScene = HUNOBASIC_SIDEWALKLEFT_NUM_OF_SCENES;
;    2442 				Motion.NumOfwCK = HUNOBASIC_SIDEWALKLEFT_NUM_OF_WCKS;
;    2443 				break;
	RJMP _0x24D
;    2444 			case BTN_R:
_0x253:
	CPI  R30,LOW(0x8)
	BRNE _0x254
;    2445 			 	SendToSoundIC(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2446 				gpT_Table	= HUNOBASIC_SIDEWALKRIGHT_Torque;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_Torque*2)
	CALL SUBOPT_0x7E
;    2447 				gpE_Table	= HUNOBASIC_SIDEWALKRIGHT_Port;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_Port*2)
	CALL SUBOPT_0x7F
;    2448 				gpPg_Table 	= HUNOBASIC_SIDEWALKRIGHT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2449 				gpDg_Table 	= HUNOBASIC_SIDEWALKRIGHT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2450 				gpIg_Table 	= HUNOBASIC_SIDEWALKRIGHT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2451 				gpFN_Table	= HUNOBASIC_SIDEWALKRIGHT_Frames;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_Frames*2)
	CALL SUBOPT_0x83
;    2452 				gpRT_Table	= HUNOBASIC_SIDEWALKRIGHT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_TrTime*2)
	CALL SUBOPT_0x84
;    2453 				gpPos_Table	= HUNOBASIC_SIDEWALKRIGHT_Position;
	LDI  R30,LOW(_HUNOBASIC_SIDEWALKRIGHT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_SIDEWALKRIGHT_Position*2)
	CALL SUBOPT_0x87
;    2454 				Motion.NumOfScene = HUNOBASIC_SIDEWALKRIGHT_NUM_OF_SCENES;
;    2455 				Motion.NumOfwCK = HUNOBASIC_SIDEWALKRIGHT_NUM_OF_WCKS;
;    2456 				break;
	RJMP _0x24D
;    2457 			case BTN_LA:
_0x254:
	CPI  R30,LOW(0x9)
	BRNE _0x255
;    2458 			 	SendToSoundIC(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2459 				gpT_Table	= HUNOBASIC_PUNCHLEFT_Torque;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_Torque*2)
	CALL SUBOPT_0x7E
;    2460 				gpE_Table	= HUNOBASIC_PUNCHLEFT_Port;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_Port*2)
	CALL SUBOPT_0x7F
;    2461 				gpPg_Table 	= HUNOBASIC_PUNCHLEFT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2462 				gpDg_Table 	= HUNOBASIC_PUNCHLEFT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2463 				gpIg_Table 	= HUNOBASIC_PUNCHLEFT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2464 				gpFN_Table	= HUNOBASIC_PUNCHLEFT_Frames;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_Frames*2)
	CALL SUBOPT_0x83
;    2465 				gpRT_Table	= HUNOBASIC_PUNCHLEFT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_TrTime*2)
	CALL SUBOPT_0x84
;    2466 				gpPos_Table	= HUNOBASIC_PUNCHLEFT_Position;
	LDI  R30,LOW(_HUNOBASIC_PUNCHLEFT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHLEFT_Position*2)
	CALL SUBOPT_0x88
;    2467 				Motion.NumOfScene = HUNOBASIC_PUNCHLEFT_NUM_OF_SCENES;
;    2468 				Motion.NumOfwCK = HUNOBASIC_PUNCHLEFT_NUM_OF_WCKS;
;    2469 				break;
	RJMP _0x24D
;    2470 			case BTN_D:
_0x255:
	CPI  R30,LOW(0xA)
	BRNE _0x256
;    2471 			 	SendToSoundIC(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2472 				gpT_Table	= HUNOBASIC_WALKBACKWARD_Torque;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_Torque*2)
	CALL SUBOPT_0x7E
;    2473 				gpE_Table	= HUNOBASIC_WALKBACKWARD_Port;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_Port*2)
	CALL SUBOPT_0x7F
;    2474 				gpPg_Table 	= HUNOBASIC_WALKBACKWARD_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2475 				gpDg_Table 	= HUNOBASIC_WALKBACKWARD_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2476 				gpIg_Table 	= HUNOBASIC_WALKBACKWARD_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2477 				gpFN_Table	= HUNOBASIC_WALKBACKWARD_Frames;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_Frames*2)
	CALL SUBOPT_0x83
;    2478 				gpRT_Table	= HUNOBASIC_WALKBACKWARD_TrTime;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_TrTime*2)
	CALL SUBOPT_0x84
;    2479 				gpPos_Table	= HUNOBASIC_WALKBACKWARD_Position;
	LDI  R30,LOW(_HUNOBASIC_WALKBACKWARD_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_WALKBACKWARD_Position*2)
	CALL SUBOPT_0x89
;    2480 				Motion.NumOfScene = HUNOBASIC_WALKBACKWARD_NUM_OF_SCENES;
;    2481 				Motion.NumOfwCK = HUNOBASIC_WALKBACKWARD_NUM_OF_WCKS;
;    2482 				break;
	RJMP _0x24D
;    2483 			case BTN_RA:
_0x256:
	CPI  R30,LOW(0xB)
	BRNE _0x257
;    2484 			 	SendToSoundIC(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2485 				gpT_Table	= HUNOBASIC_PUNCHRIGHT_Torque;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_Torque*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_Torque*2)
	CALL SUBOPT_0x7E
;    2486 				gpE_Table	= HUNOBASIC_PUNCHRIGHT_Port;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_Port*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_Port*2)
	CALL SUBOPT_0x7F
;    2487 				gpPg_Table 	= HUNOBASIC_PUNCHRIGHT_RuntimePGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_RuntimePGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2488 				gpDg_Table 	= HUNOBASIC_PUNCHRIGHT_RuntimeDGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_RuntimeDGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2489 				gpIg_Table 	= HUNOBASIC_PUNCHRIGHT_RuntimeIGain;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_RuntimeIGain*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2490 				gpFN_Table	= HUNOBASIC_PUNCHRIGHT_Frames;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_Frames*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_Frames*2)
	CALL SUBOPT_0x83
;    2491 				gpRT_Table	= HUNOBASIC_PUNCHRIGHT_TrTime;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_TrTime*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_TrTime*2)
	CALL SUBOPT_0x84
;    2492 				gpPos_Table	= HUNOBASIC_PUNCHRIGHT_Position;
	LDI  R30,LOW(_HUNOBASIC_PUNCHRIGHT_Position*2)
	LDI  R31,HIGH(_HUNOBASIC_PUNCHRIGHT_Position*2)
	CALL SUBOPT_0x88
;    2493 				Motion.NumOfScene = HUNOBASIC_PUNCHRIGHT_NUM_OF_SCENES;
;    2494 				Motion.NumOfwCK = HUNOBASIC_PUNCHRIGHT_NUM_OF_WCKS;
;    2495 				break;
	RJMP _0x24D
;    2496 			case BTN_0:
_0x257:
	CPI  R30,LOW(0x15)
	BRNE _0x259
;    2497 				gpT_Table	= MY_DEMO1_Torque;
	LDI  R30,LOW(_MY_DEMO1_Torque*2)
	LDI  R31,HIGH(_MY_DEMO1_Torque*2)
	CALL SUBOPT_0x7E
;    2498 				gpE_Table	= MY_DEMO1_Port;
	LDI  R30,LOW(_MY_DEMO1_Port*2)
	LDI  R31,HIGH(_MY_DEMO1_Port*2)
	CALL SUBOPT_0x7F
;    2499 				gpPg_Table 	= MY_DEMO1_RuntimePGain;
	LDI  R30,LOW(_MY_DEMO1_RuntimePGain*2)
	LDI  R31,HIGH(_MY_DEMO1_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2500 				gpDg_Table 	= MY_DEMO1_RuntimeDGain;
	LDI  R30,LOW(_MY_DEMO1_RuntimeDGain*2)
	LDI  R31,HIGH(_MY_DEMO1_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2501 				gpIg_Table 	= MY_DEMO1_RuntimeIGain;
	LDI  R30,LOW(_MY_DEMO1_RuntimeIGain*2)
	LDI  R31,HIGH(_MY_DEMO1_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2502 				gpFN_Table	= MY_DEMO1_Frames;
	LDI  R30,LOW(_MY_DEMO1_Frames*2)
	LDI  R31,HIGH(_MY_DEMO1_Frames*2)
	CALL SUBOPT_0x83
;    2503 				gpRT_Table	= MY_DEMO1_TrTime;
	LDI  R30,LOW(_MY_DEMO1_TrTime*2)
	LDI  R31,HIGH(_MY_DEMO1_TrTime*2)
	CALL SUBOPT_0x84
;    2504 				gpPos_Table	= MY_DEMO1_Position;
	LDI  R30,LOW(_MY_DEMO1_Position*2)
	LDI  R31,HIGH(_MY_DEMO1_Position*2)
	CALL SUBOPT_0x88
;    2505 				Motion.NumOfScene = MY_DEMO1_NUM_OF_SCENES;
;    2506 				Motion.NumOfwCK = MY_DEMO1_NUM_OF_WCKS;
;    2507 				break;
	RJMP _0x24D
;    2508 			default:
_0x259:
;    2509 				return;
	RJMP _0x312
;    2510 		}
_0x24D:
;    2511 	}
;    2512 	else if(F_PF == PF1_DINO){
	RJMP _0x25A
_0x24A:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0x25B
;    2513 		switch(BtnCode){
	LD   R30,Y
;    2514 			case BTN_A:
	CPI  R30,LOW(0x1)
	BRNE _0x25F
;    2515 	 			SendToSoundIC(13);
	CALL SUBOPT_0x8A
;    2516 				gpT_Table	= DinoBasic_GetupFront_Torque;
	LDI  R30,LOW(_DinoBasic_GetupFront_Torque*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_Torque*2)
	CALL SUBOPT_0x7E
;    2517 				gpE_Table	= DinoBasic_GetupFront_Port;
	LDI  R30,LOW(_DinoBasic_GetupFront_Port*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_Port*2)
	CALL SUBOPT_0x7F
;    2518 				gpPg_Table 	= DinoBasic_GetupFront_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_GetupFront_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2519 				gpDg_Table 	= DinoBasic_GetupFront_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_GetupFront_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2520 				gpIg_Table 	= DinoBasic_GetupFront_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_GetupFront_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2521 				gpFN_Table	= DinoBasic_GetupFront_Frames;
	LDI  R30,LOW(_DinoBasic_GetupFront_Frames*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_Frames*2)
	CALL SUBOPT_0x83
;    2522 				gpRT_Table	= DinoBasic_GetupFront_TrTime;
	LDI  R30,LOW(_DinoBasic_GetupFront_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_TrTime*2)
	CALL SUBOPT_0x84
;    2523 				gpPos_Table	= DinoBasic_GetupFront_Position;
	LDI  R30,LOW(_DinoBasic_GetupFront_Position*2)
	LDI  R31,HIGH(_DinoBasic_GetupFront_Position*2)
	CALL SUBOPT_0x87
;    2524 				Motion.NumOfScene = DINOBASIC_GETUPFRONT_NUM_OF_SCENES;
;    2525 				Motion.NumOfwCK = DINOBASIC_GETUPFRONT_NUM_OF_WCKS;
;    2526 				break;
	RJMP _0x25E
;    2527 			case BTN_B:
_0x25F:
	CPI  R30,LOW(0x2)
	BRNE _0x260
;    2528 	 			SendToSoundIC(13);
	CALL SUBOPT_0x8A
;    2529 				gpT_Table	= DinoBasic_GetupBack_Torque;
	LDI  R30,LOW(_DinoBasic_GetupBack_Torque*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_Torque*2)
	CALL SUBOPT_0x7E
;    2530 				gpE_Table	= DinoBasic_GetupBack_Port;
	LDI  R30,LOW(_DinoBasic_GetupBack_Port*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_Port*2)
	CALL SUBOPT_0x7F
;    2531 				gpPg_Table 	= DinoBasic_GetupBack_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_GetupBack_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2532 				gpDg_Table 	= DinoBasic_GetupBack_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_GetupBack_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2533 				gpIg_Table 	= DinoBasic_GetupBack_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_GetupBack_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2534 				gpFN_Table	= DinoBasic_GetupBack_Frames;
	LDI  R30,LOW(_DinoBasic_GetupBack_Frames*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_Frames*2)
	CALL SUBOPT_0x83
;    2535 				gpRT_Table	= DinoBasic_GetupBack_TrTime;
	LDI  R30,LOW(_DinoBasic_GetupBack_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_TrTime*2)
	CALL SUBOPT_0x84
;    2536 				gpPos_Table	= DinoBasic_GetupBack_Position;
	LDI  R30,LOW(_DinoBasic_GetupBack_Position*2)
	LDI  R31,HIGH(_DinoBasic_GetupBack_Position*2)
	CALL SUBOPT_0x87
;    2537 				Motion.NumOfScene = DINOBASIC_GETUPBACK_NUM_OF_SCENES;
;    2538 				Motion.NumOfwCK = DINOBASIC_GETUPBACK_NUM_OF_WCKS;
;    2539 				break;
	RJMP _0x25E
;    2540 			case BTN_LR:
_0x260:
	CPI  R30,LOW(0x3)
	BRNE _0x261
;    2541 			 	SendToSoundIC(13);
	CALL SUBOPT_0x8A
;    2542 				gpT_Table	= DinoBasic_TurnLeft_Torque;
	LDI  R30,LOW(_DinoBasic_TurnLeft_Torque*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_Torque*2)
	CALL SUBOPT_0x7E
;    2543 				gpE_Table	= DinoBasic_TurnLeft_Port;
	LDI  R30,LOW(_DinoBasic_TurnLeft_Port*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_Port*2)
	CALL SUBOPT_0x7F
;    2544 				gpPg_Table 	= DinoBasic_TurnLeft_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_TurnLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2545 				gpDg_Table 	= DinoBasic_TurnLeft_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_TurnLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2546 				gpIg_Table 	= DinoBasic_TurnLeft_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_TurnLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2547 				gpFN_Table	= DinoBasic_TurnLeft_Frames;
	LDI  R30,LOW(_DinoBasic_TurnLeft_Frames*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_Frames*2)
	CALL SUBOPT_0x83
;    2548 				gpRT_Table	= DinoBasic_TurnLeft_TrTime;
	LDI  R30,LOW(_DinoBasic_TurnLeft_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_TrTime*2)
	CALL SUBOPT_0x84
;    2549 				gpPos_Table	= DinoBasic_TurnLeft_Position;
	LDI  R30,LOW(_DinoBasic_TurnLeft_Position*2)
	LDI  R31,HIGH(_DinoBasic_TurnLeft_Position*2)
	CALL SUBOPT_0x87
;    2550 				Motion.NumOfScene = DINOBASIC_TURNLEFT_NUM_OF_SCENES;
;    2551 				Motion.NumOfwCK = DINOBASIC_TURNLEFT_NUM_OF_WCKS;
;    2552 				break;
	RJMP _0x25E
;    2553 			case BTN_U:
_0x261:
	CPI  R30,LOW(0x4)
	BRNE _0x262
;    2554 			 	SendToSoundIC(14);
	LDI  R30,LOW(14)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2555 				gpT_Table	= DinoBasic_WalkForward_Torque;
	LDI  R30,LOW(_DinoBasic_WalkForward_Torque*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_Torque*2)
	CALL SUBOPT_0x7E
;    2556 				gpE_Table	= DinoBasic_WalkForward_Port;
	LDI  R30,LOW(_DinoBasic_WalkForward_Port*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_Port*2)
	CALL SUBOPT_0x7F
;    2557 				gpPg_Table 	= DinoBasic_WalkForward_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_WalkForward_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2558 				gpDg_Table 	= DinoBasic_WalkForward_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_WalkForward_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2559 				gpIg_Table 	= DinoBasic_WalkForward_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_WalkForward_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2560 				gpFN_Table	= DinoBasic_WalkForward_Frames;
	LDI  R30,LOW(_DinoBasic_WalkForward_Frames*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_Frames*2)
	CALL SUBOPT_0x83
;    2561 				gpRT_Table	= DinoBasic_WalkForward_TrTime;
	LDI  R30,LOW(_DinoBasic_WalkForward_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_TrTime*2)
	CALL SUBOPT_0x84
;    2562 				gpPos_Table	= DinoBasic_WalkForward_Position;
	LDI  R30,LOW(_DinoBasic_WalkForward_Position*2)
	LDI  R31,HIGH(_DinoBasic_WalkForward_Position*2)
	CALL SUBOPT_0x89
;    2563 				Motion.NumOfScene = DINOBASIC_WALKFORWARD_NUM_OF_SCENES;
;    2564 				Motion.NumOfwCK = DINOBASIC_WALKFORWARD_NUM_OF_WCKS;
;    2565 				break;
	RJMP _0x25E
;    2566 			case BTN_RR:
_0x262:
	CPI  R30,LOW(0x5)
	BRNE _0x263
;    2567 			 	SendToSoundIC(13);
	CALL SUBOPT_0x8A
;    2568 				gpT_Table	= DinoBasic_TurnRight_Torque;
	LDI  R30,LOW(_DinoBasic_TurnRight_Torque*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_Torque*2)
	CALL SUBOPT_0x7E
;    2569 				gpE_Table	= DinoBasic_TurnRight_Port;
	LDI  R30,LOW(_DinoBasic_TurnRight_Port*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_Port*2)
	CALL SUBOPT_0x7F
;    2570 				gpPg_Table 	= DinoBasic_TurnRight_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_TurnRight_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2571 				gpDg_Table 	= DinoBasic_TurnRight_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_TurnRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2572 				gpIg_Table 	= DinoBasic_TurnRight_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_TurnRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2573 				gpFN_Table	= DinoBasic_TurnRight_Frames;
	LDI  R30,LOW(_DinoBasic_TurnRight_Frames*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_Frames*2)
	CALL SUBOPT_0x83
;    2574 				gpRT_Table	= DinoBasic_TurnRight_TrTime;
	LDI  R30,LOW(_DinoBasic_TurnRight_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_TrTime*2)
	CALL SUBOPT_0x84
;    2575 				gpPos_Table	= DinoBasic_TurnRight_Position;
	LDI  R30,LOW(_DinoBasic_TurnRight_Position*2)
	LDI  R31,HIGH(_DinoBasic_TurnRight_Position*2)
	CALL SUBOPT_0x85
;    2576 				Motion.NumOfScene = DINOBASIC_TURNRIGHT_NUM_OF_SCENES;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x72
;    2577 				Motion.NumOfwCK = DINOBASIC_TURNRIGHT_NUM_OF_WCKS;
;    2578 				break;
	RJMP _0x25E
;    2579 			case BTN_L:
_0x263:
	CPI  R30,LOW(0x6)
	BRNE _0x264
;    2580 			 	SendToSoundIC(13);
	CALL SUBOPT_0x8A
;    2581 				gpT_Table	= DinoBasic_SidewalkLeft_Torque;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_Torque*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_Torque*2)
	CALL SUBOPT_0x7E
;    2582 				gpE_Table	= DinoBasic_SidewalkLeft_Port;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_Port*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_Port*2)
	CALL SUBOPT_0x7F
;    2583 				gpPg_Table 	= DinoBasic_SidewalkLeft_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2584 				gpDg_Table 	= DinoBasic_SidewalkLeft_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2585 				gpIg_Table 	= DinoBasic_SidewalkLeft_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2586 				gpFN_Table	= DinoBasic_SidewalkLeft_Frames;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_Frames*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_Frames*2)
	CALL SUBOPT_0x83
;    2587 				gpRT_Table	= DinoBasic_SidewalkLeft_TrTime;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_TrTime*2)
	CALL SUBOPT_0x84
;    2588 				gpPos_Table	= DinoBasic_SidewalkLeft_Position;
	LDI  R30,LOW(_DinoBasic_SidewalkLeft_Position*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkLeft_Position*2)
	CALL SUBOPT_0x87
;    2589 				Motion.NumOfScene = DINOBASIC_SIDEWALKLEFT_NUM_OF_SCENES;
;    2590 				Motion.NumOfwCK = DINOBASIC_SIDEWALKLEFT_NUM_OF_WCKS;
;    2591 				break;
	RJMP _0x25E
;    2592 			case BTN_R:
_0x264:
	CPI  R30,LOW(0x8)
	BRNE _0x265
;    2593 			 	SendToSoundIC(13);
	CALL SUBOPT_0x8A
;    2594 				gpT_Table	= DinoBasic_SidewalkRight_Torque;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_Torque*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_Torque*2)
	CALL SUBOPT_0x7E
;    2595 				gpE_Table	= DinoBasic_SidewalkRight_Port;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_Port*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_Port*2)
	CALL SUBOPT_0x7F
;    2596 				gpPg_Table 	= DinoBasic_SidewalkRight_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2597 				gpDg_Table 	= DinoBasic_SidewalkRight_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2598 				gpIg_Table 	= DinoBasic_SidewalkRight_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2599 				gpFN_Table	= DinoBasic_SidewalkRight_Frames;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_Frames*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_Frames*2)
	CALL SUBOPT_0x83
;    2600 				gpRT_Table	= DinoBasic_SidewalkRight_TrTime;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_TrTime*2)
	CALL SUBOPT_0x84
;    2601 				gpPos_Table	= DinoBasic_SidewalkRight_Position;
	LDI  R30,LOW(_DinoBasic_SidewalkRight_Position*2)
	LDI  R31,HIGH(_DinoBasic_SidewalkRight_Position*2)
	CALL SUBOPT_0x87
;    2602 				Motion.NumOfScene = DINOBASIC_SIDEWALKRIGHT_NUM_OF_SCENES;
;    2603 				Motion.NumOfwCK = DINOBASIC_SIDEWALKRIGHT_NUM_OF_WCKS;
;    2604 				break;
	RJMP _0x25E
;    2605 			case BTN_LA:
_0x265:
	CPI  R30,LOW(0x9)
	BRNE _0x266
;    2606 			 	SendToSoundIC(13);
	CALL SUBOPT_0x8A
;    2607 				gpT_Table	= DinoBasic_PunchLeft_Torque;
	LDI  R30,LOW(_DinoBasic_PunchLeft_Torque*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_Torque*2)
	CALL SUBOPT_0x7E
;    2608 				gpE_Table	= DinoBasic_PunchLeft_Port;
	LDI  R30,LOW(_DinoBasic_PunchLeft_Port*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_Port*2)
	CALL SUBOPT_0x7F
;    2609 				gpPg_Table 	= DinoBasic_PunchLeft_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_PunchLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2610 				gpDg_Table 	= DinoBasic_PunchLeft_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_PunchLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2611 				gpIg_Table 	= DinoBasic_PunchLeft_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_PunchLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2612 				gpFN_Table	= DinoBasic_PunchLeft_Frames;
	LDI  R30,LOW(_DinoBasic_PunchLeft_Frames*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_Frames*2)
	CALL SUBOPT_0x83
;    2613 				gpRT_Table	= DinoBasic_PunchLeft_TrTime;
	LDI  R30,LOW(_DinoBasic_PunchLeft_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_TrTime*2)
	CALL SUBOPT_0x84
;    2614 				gpPos_Table	= DinoBasic_PunchLeft_Position;
	LDI  R30,LOW(_DinoBasic_PunchLeft_Position*2)
	LDI  R31,HIGH(_DinoBasic_PunchLeft_Position*2)
	CALL SUBOPT_0x8B
;    2615 				Motion.NumOfScene = DINOBASIC_PUNCHLEFT_NUM_OF_SCENES;
;    2616 				Motion.NumOfwCK = DINOBASIC_PUNCHLEFT_NUM_OF_WCKS;
;    2617 				break;
	RJMP _0x25E
;    2618 			case BTN_D:
_0x266:
	CPI  R30,LOW(0xA)
	BRNE _0x267
;    2619 			 	SendToSoundIC(13);
	CALL SUBOPT_0x8A
;    2620 				gpT_Table	= DinoBasic_WalkBackward_Torque;
	LDI  R30,LOW(_DinoBasic_WalkBackward_Torque*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_Torque*2)
	CALL SUBOPT_0x7E
;    2621 				gpE_Table	= DinoBasic_WalkBackward_Port;
	LDI  R30,LOW(_DinoBasic_WalkBackward_Port*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_Port*2)
	CALL SUBOPT_0x7F
;    2622 				gpPg_Table 	= DinoBasic_WalkBackward_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_WalkBackward_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2623 				gpDg_Table 	= DinoBasic_WalkBackward_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_WalkBackward_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2624 				gpIg_Table 	= DinoBasic_WalkBackward_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_WalkBackward_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2625 				gpFN_Table	= DinoBasic_WalkBackward_Frames;
	LDI  R30,LOW(_DinoBasic_WalkBackward_Frames*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_Frames*2)
	CALL SUBOPT_0x83
;    2626 				gpRT_Table	= DinoBasic_WalkBackward_TrTime;
	LDI  R30,LOW(_DinoBasic_WalkBackward_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_TrTime*2)
	CALL SUBOPT_0x84
;    2627 				gpPos_Table	= DinoBasic_WalkBackward_Position;
	LDI  R30,LOW(_DinoBasic_WalkBackward_Position*2)
	LDI  R31,HIGH(_DinoBasic_WalkBackward_Position*2)
	CALL SUBOPT_0x89
;    2628 				Motion.NumOfScene = DINOBASIC_WALKBACKWARD_NUM_OF_SCENES;
;    2629 				Motion.NumOfwCK = DINOBASIC_WALKBACKWARD_NUM_OF_WCKS;
;    2630 				break;
	RJMP _0x25E
;    2631 			case BTN_RA:
_0x267:
	CPI  R30,LOW(0xB)
	BRNE _0x269
;    2632 			 	SendToSoundIC(13);
	CALL SUBOPT_0x8A
;    2633 				gpT_Table	= DinoBasic_PunchRight_Torque;
	LDI  R30,LOW(_DinoBasic_PunchRight_Torque*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_Torque*2)
	CALL SUBOPT_0x7E
;    2634 				gpE_Table	= DinoBasic_PunchRight_Port;
	LDI  R30,LOW(_DinoBasic_PunchRight_Port*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_Port*2)
	CALL SUBOPT_0x7F
;    2635 				gpPg_Table 	= DinoBasic_PunchRight_RuntimePGain;
	LDI  R30,LOW(_DinoBasic_PunchRight_RuntimePGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2636 				gpDg_Table 	= DinoBasic_PunchRight_RuntimeDGain;
	LDI  R30,LOW(_DinoBasic_PunchRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2637 				gpIg_Table 	= DinoBasic_PunchRight_RuntimeIGain;
	LDI  R30,LOW(_DinoBasic_PunchRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2638 				gpFN_Table	= DinoBasic_PunchRight_Frames;
	LDI  R30,LOW(_DinoBasic_PunchRight_Frames*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_Frames*2)
	CALL SUBOPT_0x83
;    2639 				gpRT_Table	= DinoBasic_PunchRight_TrTime;
	LDI  R30,LOW(_DinoBasic_PunchRight_TrTime*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_TrTime*2)
	CALL SUBOPT_0x84
;    2640 				gpPos_Table	= DinoBasic_PunchRight_Position;
	LDI  R30,LOW(_DinoBasic_PunchRight_Position*2)
	LDI  R31,HIGH(_DinoBasic_PunchRight_Position*2)
	CALL SUBOPT_0x8B
;    2641 				Motion.NumOfScene = DINOBASIC_PUNCHRIGHT_NUM_OF_SCENES;
;    2642 				Motion.NumOfwCK = DINOBASIC_PUNCHRIGHT_NUM_OF_WCKS;
;    2643 				break;
	RJMP _0x25E
;    2644 			default:
_0x269:
;    2645 				return;
	RJMP _0x312
;    2646 		}
_0x25E:
;    2647 	}
;    2648 	else if(F_PF == PF1_DOGY){
	RJMP _0x26A
_0x25B:
	LDI  R30,LOW(3)
	CP   R30,R12
	BREQ PC+3
	JMP _0x26B
;    2649 		switch(BtnCode){
	LD   R30,Y
;    2650 			case BTN_A:
	CPI  R30,LOW(0x1)
	BRNE _0x26F
;    2651 	 			SendToSoundIC(12);
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2652 				gpT_Table	= DogyBasic_GetupFront_Torque;
	LDI  R30,LOW(_DogyBasic_GetupFront_Torque*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_Torque*2)
	CALL SUBOPT_0x7E
;    2653 				gpE_Table	= DogyBasic_GetupFront_Port;
	LDI  R30,LOW(_DogyBasic_GetupFront_Port*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_Port*2)
	CALL SUBOPT_0x7F
;    2654 				gpPg_Table 	= DogyBasic_GetupFront_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_GetupFront_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2655 				gpDg_Table 	= DogyBasic_GetupFront_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_GetupFront_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2656 				gpIg_Table 	= DogyBasic_GetupFront_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_GetupFront_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2657 				gpFN_Table	= DogyBasic_GetupFront_Frames;
	LDI  R30,LOW(_DogyBasic_GetupFront_Frames*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_Frames*2)
	CALL SUBOPT_0x83
;    2658 				gpRT_Table	= DogyBasic_GetupFront_TrTime;
	LDI  R30,LOW(_DogyBasic_GetupFront_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_TrTime*2)
	CALL SUBOPT_0x84
;    2659 				gpPos_Table	= DogyBasic_GetupFront_Position;
	LDI  R30,LOW(_DogyBasic_GetupFront_Position*2)
	LDI  R31,HIGH(_DogyBasic_GetupFront_Position*2)
	CALL SUBOPT_0x88
;    2660 				Motion.NumOfScene = DOGYBASIC_GETUPFRONT_NUM_OF_SCENES;
;    2661 				Motion.NumOfwCK = DOGYBASIC_GETUPFRONT_NUM_OF_WCKS;
;    2662 				break;
	RJMP _0x26E
;    2663 			case BTN_B:
_0x26F:
	CPI  R30,LOW(0x2)
	BRNE _0x270
;    2664 	 			SendToSoundIC(12);
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2665 				gpT_Table	= DogyBasic_GetupBack_Torque;
	LDI  R30,LOW(_DogyBasic_GetupBack_Torque*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_Torque*2)
	CALL SUBOPT_0x7E
;    2666 				gpE_Table	= DogyBasic_GetupBack_Port;
	LDI  R30,LOW(_DogyBasic_GetupBack_Port*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_Port*2)
	CALL SUBOPT_0x7F
;    2667 				gpPg_Table 	= DogyBasic_GetupBack_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_GetupBack_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2668 				gpDg_Table 	= DogyBasic_GetupBack_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_GetupBack_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2669 				gpIg_Table 	= DogyBasic_GetupBack_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_GetupBack_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2670 				gpFN_Table	= DogyBasic_GetupBack_Frames;
	LDI  R30,LOW(_DogyBasic_GetupBack_Frames*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_Frames*2)
	CALL SUBOPT_0x83
;    2671 				gpRT_Table	= DogyBasic_GetupBack_TrTime;
	LDI  R30,LOW(_DogyBasic_GetupBack_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_TrTime*2)
	CALL SUBOPT_0x84
;    2672 				gpPos_Table	= DogyBasic_GetupBack_Position;
	LDI  R30,LOW(_DogyBasic_GetupBack_Position*2)
	LDI  R31,HIGH(_DogyBasic_GetupBack_Position*2)
	CALL SUBOPT_0x88
;    2673 				Motion.NumOfScene = DOGYBASIC_GETUPBACK_NUM_OF_SCENES;
;    2674 				Motion.NumOfwCK = DOGYBASIC_GETUPBACK_NUM_OF_WCKS;
;    2675 				break;
	RJMP _0x26E
;    2676 			case BTN_LR:
_0x270:
	CPI  R30,LOW(0x3)
	BRNE _0x271
;    2677 			 	SendToSoundIC(11);
	CALL SUBOPT_0x8C
;    2678 				gpT_Table	= DogyBasic_TurnLeft_Torque;
	LDI  R30,LOW(_DogyBasic_TurnLeft_Torque*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_Torque*2)
	CALL SUBOPT_0x7E
;    2679 				gpE_Table	= DogyBasic_TurnLeft_Port;
	LDI  R30,LOW(_DogyBasic_TurnLeft_Port*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_Port*2)
	CALL SUBOPT_0x7F
;    2680 				gpPg_Table 	= DogyBasic_TurnLeft_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_TurnLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2681 				gpDg_Table 	= DogyBasic_TurnLeft_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_TurnLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2682 				gpIg_Table 	= DogyBasic_TurnLeft_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_TurnLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2683 				gpFN_Table	= DogyBasic_TurnLeft_Frames;
	LDI  R30,LOW(_DogyBasic_TurnLeft_Frames*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_Frames*2)
	CALL SUBOPT_0x83
;    2684 				gpRT_Table	= DogyBasic_TurnLeft_TrTime;
	LDI  R30,LOW(_DogyBasic_TurnLeft_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_TrTime*2)
	CALL SUBOPT_0x84
;    2685 				gpPos_Table	= DogyBasic_TurnLeft_Position;
	LDI  R30,LOW(_DogyBasic_TurnLeft_Position*2)
	LDI  R31,HIGH(_DogyBasic_TurnLeft_Position*2)
	CALL SUBOPT_0x86
;    2686 				Motion.NumOfScene = DOGYBASIC_TURNLEFT_NUM_OF_SCENES;
;    2687 				Motion.NumOfwCK = DOGYBASIC_TURNLEFT_NUM_OF_WCKS;
;    2688 				break;
	RJMP _0x26E
;    2689 			case BTN_U:
_0x271:
	CPI  R30,LOW(0x4)
	BRNE _0x272
;    2690 			 	SendToSoundIC(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _SendToSoundIC
;    2691 				gpT_Table	= DogyBasic_WalkForward_Torque;
	LDI  R30,LOW(_DogyBasic_WalkForward_Torque*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_Torque*2)
	CALL SUBOPT_0x7E
;    2692 				gpE_Table	= DogyBasic_WalkForward_Port;
	LDI  R30,LOW(_DogyBasic_WalkForward_Port*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_Port*2)
	CALL SUBOPT_0x7F
;    2693 				gpPg_Table 	= DogyBasic_WalkForward_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_WalkForward_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2694 				gpDg_Table 	= DogyBasic_WalkForward_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_WalkForward_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2695 				gpIg_Table 	= DogyBasic_WalkForward_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_WalkForward_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2696 				gpFN_Table	= DogyBasic_WalkForward_Frames;
	LDI  R30,LOW(_DogyBasic_WalkForward_Frames*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_Frames*2)
	CALL SUBOPT_0x83
;    2697 				gpRT_Table	= DogyBasic_WalkForward_TrTime;
	LDI  R30,LOW(_DogyBasic_WalkForward_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_TrTime*2)
	CALL SUBOPT_0x84
;    2698 				gpPos_Table	= DogyBasic_WalkForward_Position;
	LDI  R30,LOW(_DogyBasic_WalkForward_Position*2)
	LDI  R31,HIGH(_DogyBasic_WalkForward_Position*2)
	CALL SUBOPT_0x85
;    2699 				Motion.NumOfScene = DOGYBASIC_WALKFORWARD_NUM_OF_SCENES;
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	CALL SUBOPT_0x72
;    2700 				Motion.NumOfwCK = DOGYBASIC_WALKFORWARD_NUM_OF_WCKS;
;    2701 				break;
	RJMP _0x26E
;    2702 			case BTN_RR:
_0x272:
	CPI  R30,LOW(0x5)
	BRNE _0x273
;    2703 			 	SendToSoundIC(11);
	CALL SUBOPT_0x8C
;    2704 				gpT_Table	= DogyBasic_TurnRight_Torque;
	LDI  R30,LOW(_DogyBasic_TurnRight_Torque*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_Torque*2)
	CALL SUBOPT_0x7E
;    2705 				gpE_Table	= DogyBasic_TurnRight_Port;
	LDI  R30,LOW(_DogyBasic_TurnRight_Port*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_Port*2)
	CALL SUBOPT_0x7F
;    2706 				gpPg_Table 	= DogyBasic_TurnRight_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_TurnRight_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2707 				gpDg_Table 	= DogyBasic_TurnRight_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_TurnRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2708 				gpIg_Table 	= DogyBasic_TurnRight_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_TurnRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2709 				gpFN_Table	= DogyBasic_TurnRight_Frames;
	LDI  R30,LOW(_DogyBasic_TurnRight_Frames*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_Frames*2)
	CALL SUBOPT_0x83
;    2710 				gpRT_Table	= DogyBasic_TurnRight_TrTime;
	LDI  R30,LOW(_DogyBasic_TurnRight_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_TrTime*2)
	CALL SUBOPT_0x84
;    2711 				gpPos_Table	= DogyBasic_TurnRight_Position;
	LDI  R30,LOW(_DogyBasic_TurnRight_Position*2)
	LDI  R31,HIGH(_DogyBasic_TurnRight_Position*2)
	CALL SUBOPT_0x86
;    2712 				Motion.NumOfScene = DOGYBASIC_TURNRIGHT_NUM_OF_SCENES;
;    2713 				Motion.NumOfwCK = DOGYBASIC_TURNRIGHT_NUM_OF_WCKS;
;    2714 				break;
	RJMP _0x26E
;    2715 			case BTN_L:
_0x273:
	CPI  R30,LOW(0x6)
	BRNE _0x274
;    2716 			 	SendToSoundIC(11);
	CALL SUBOPT_0x8C
;    2717 				gpT_Table	= DogyBasic_SidewalkLeft_Torque;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_Torque*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_Torque*2)
	CALL SUBOPT_0x7E
;    2718 				gpE_Table	= DogyBasic_SidewalkLeft_Port;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_Port*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_Port*2)
	CALL SUBOPT_0x7F
;    2719 				gpPg_Table 	= DogyBasic_SidewalkLeft_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2720 				gpDg_Table 	= DogyBasic_SidewalkLeft_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2721 				gpIg_Table 	= DogyBasic_SidewalkLeft_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2722 				gpFN_Table	= DogyBasic_SidewalkLeft_Frames;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_Frames*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_Frames*2)
	CALL SUBOPT_0x83
;    2723 				gpRT_Table	= DogyBasic_SidewalkLeft_TrTime;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_TrTime*2)
	CALL SUBOPT_0x84
;    2724 				gpPos_Table	= DogyBasic_SidewalkLeft_Position;
	LDI  R30,LOW(_DogyBasic_SidewalkLeft_Position*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkLeft_Position*2)
	CALL SUBOPT_0x8D
;    2725 				Motion.NumOfScene = DOGYBASIC_SIDEWALKLEFT_NUM_OF_SCENES;
;    2726 				Motion.NumOfwCK = DOGYBASIC_SIDEWALKLEFT_NUM_OF_WCKS;
;    2727 				break;
	RJMP _0x26E
;    2728 			case BTN_R:
_0x274:
	CPI  R30,LOW(0x8)
	BRNE _0x275
;    2729 			 	SendToSoundIC(11);
	CALL SUBOPT_0x8C
;    2730 				gpT_Table	= DogyBasic_SidewalkRight_Torque;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_Torque*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_Torque*2)
	CALL SUBOPT_0x7E
;    2731 				gpE_Table	= DogyBasic_SidewalkRight_Port;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_Port*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_Port*2)
	CALL SUBOPT_0x7F
;    2732 				gpPg_Table 	= DogyBasic_SidewalkRight_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2733 				gpDg_Table 	= DogyBasic_SidewalkRight_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2734 				gpIg_Table 	= DogyBasic_SidewalkRight_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2735 				gpFN_Table	= DogyBasic_SidewalkRight_Frames;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_Frames*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_Frames*2)
	CALL SUBOPT_0x83
;    2736 				gpRT_Table	= DogyBasic_SidewalkRight_TrTime;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_TrTime*2)
	CALL SUBOPT_0x84
;    2737 				gpPos_Table	= DogyBasic_SidewalkRight_Position;
	LDI  R30,LOW(_DogyBasic_SidewalkRight_Position*2)
	LDI  R31,HIGH(_DogyBasic_SidewalkRight_Position*2)
	CALL SUBOPT_0x8D
;    2738 				Motion.NumOfScene = DOGYBASIC_SIDEWALKRIGHT_NUM_OF_SCENES;
;    2739 				Motion.NumOfwCK = DOGYBASIC_SIDEWALKRIGHT_NUM_OF_WCKS;
;    2740 				break;
	RJMP _0x26E
;    2741 			case BTN_LA:
_0x275:
	CPI  R30,LOW(0x9)
	BRNE _0x276
;    2742 			 	SendToSoundIC(11);
	CALL SUBOPT_0x8C
;    2743 				gpT_Table	= DogyBasic_PunchLeft_Torque;
	LDI  R30,LOW(_DogyBasic_PunchLeft_Torque*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_Torque*2)
	CALL SUBOPT_0x7E
;    2744 				gpE_Table	= DogyBasic_PunchLeft_Port;
	LDI  R30,LOW(_DogyBasic_PunchLeft_Port*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_Port*2)
	CALL SUBOPT_0x7F
;    2745 				gpPg_Table 	= DogyBasic_PunchLeft_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_PunchLeft_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2746 				gpDg_Table 	= DogyBasic_PunchLeft_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_PunchLeft_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2747 				gpIg_Table 	= DogyBasic_PunchLeft_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_PunchLeft_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2748 				gpFN_Table	= DogyBasic_PunchLeft_Frames;
	LDI  R30,LOW(_DogyBasic_PunchLeft_Frames*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_Frames*2)
	CALL SUBOPT_0x83
;    2749 				gpRT_Table	= DogyBasic_PunchLeft_TrTime;
	LDI  R30,LOW(_DogyBasic_PunchLeft_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_TrTime*2)
	CALL SUBOPT_0x84
;    2750 				gpPos_Table	= DogyBasic_PunchLeft_Position;
	LDI  R30,LOW(_DogyBasic_PunchLeft_Position*2)
	LDI  R31,HIGH(_DogyBasic_PunchLeft_Position*2)
	CALL SUBOPT_0x8B
;    2751 				Motion.NumOfScene = DOGYBASIC_PUNCHLEFT_NUM_OF_SCENES;
;    2752 				Motion.NumOfwCK = DOGYBASIC_PUNCHLEFT_NUM_OF_WCKS;
;    2753 				break;
	RJMP _0x26E
;    2754 			case BTN_D:
_0x276:
	CPI  R30,LOW(0xA)
	BRNE _0x277
;    2755 			 	SendToSoundIC(11);
	CALL SUBOPT_0x8C
;    2756 				gpT_Table	= DogyBasic_WalkBackward_Torque;
	LDI  R30,LOW(_DogyBasic_WalkBackward_Torque*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_Torque*2)
	CALL SUBOPT_0x7E
;    2757 				gpE_Table	= DogyBasic_WalkBackward_Port;
	LDI  R30,LOW(_DogyBasic_WalkBackward_Port*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_Port*2)
	CALL SUBOPT_0x7F
;    2758 				gpPg_Table 	= DogyBasic_WalkBackward_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_WalkBackward_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2759 				gpDg_Table 	= DogyBasic_WalkBackward_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_WalkBackward_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2760 				gpIg_Table 	= DogyBasic_WalkBackward_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_WalkBackward_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2761 				gpFN_Table	= DogyBasic_WalkBackward_Frames;
	LDI  R30,LOW(_DogyBasic_WalkBackward_Frames*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_Frames*2)
	CALL SUBOPT_0x83
;    2762 				gpRT_Table	= DogyBasic_WalkBackward_TrTime;
	LDI  R30,LOW(_DogyBasic_WalkBackward_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_TrTime*2)
	CALL SUBOPT_0x84
;    2763 				gpPos_Table	= DogyBasic_WalkBackward_Position;
	LDI  R30,LOW(_DogyBasic_WalkBackward_Position*2)
	LDI  R31,HIGH(_DogyBasic_WalkBackward_Position*2)
	CALL SUBOPT_0x8D
;    2764 				Motion.NumOfScene = DOGYBASIC_WALKBACKWARD_NUM_OF_SCENES;
;    2765 				Motion.NumOfwCK = DOGYBASIC_WALKBACKWARD_NUM_OF_WCKS;
;    2766 				break;
	RJMP _0x26E
;    2767 			case BTN_RA:
_0x277:
	CPI  R30,LOW(0xB)
	BRNE _0x279
;    2768 			 	SendToSoundIC(11);
	CALL SUBOPT_0x8C
;    2769 				gpT_Table	= DogyBasic_PunchRight_Torque;
	LDI  R30,LOW(_DogyBasic_PunchRight_Torque*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_Torque*2)
	CALL SUBOPT_0x7E
;    2770 				gpE_Table	= DogyBasic_PunchRight_Port;
	LDI  R30,LOW(_DogyBasic_PunchRight_Port*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_Port*2)
	CALL SUBOPT_0x7F
;    2771 				gpPg_Table 	= DogyBasic_PunchRight_RuntimePGain;
	LDI  R30,LOW(_DogyBasic_PunchRight_RuntimePGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_RuntimePGain*2)
	CALL SUBOPT_0x80
;    2772 				gpDg_Table 	= DogyBasic_PunchRight_RuntimeDGain;
	LDI  R30,LOW(_DogyBasic_PunchRight_RuntimeDGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_RuntimeDGain*2)
	CALL SUBOPT_0x81
;    2773 				gpIg_Table 	= DogyBasic_PunchRight_RuntimeIGain;
	LDI  R30,LOW(_DogyBasic_PunchRight_RuntimeIGain*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_RuntimeIGain*2)
	CALL SUBOPT_0x82
;    2774 				gpFN_Table	= DogyBasic_PunchRight_Frames;
	LDI  R30,LOW(_DogyBasic_PunchRight_Frames*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_Frames*2)
	CALL SUBOPT_0x83
;    2775 				gpRT_Table	= DogyBasic_PunchRight_TrTime;
	LDI  R30,LOW(_DogyBasic_PunchRight_TrTime*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_TrTime*2)
	CALL SUBOPT_0x84
;    2776 				gpPos_Table	= DogyBasic_PunchRight_Position;
	LDI  R30,LOW(_DogyBasic_PunchRight_Position*2)
	LDI  R31,HIGH(_DogyBasic_PunchRight_Position*2)
	CALL SUBOPT_0x8B
;    2777 				Motion.NumOfScene = DOGYBASIC_PUNCHRIGHT_NUM_OF_SCENES;
;    2778 				Motion.NumOfwCK = DOGYBASIC_PUNCHRIGHT_NUM_OF_WCKS;
;    2779 				break;
	RJMP _0x26E
;    2780 			default:
_0x279:
;    2781 				return;
	RJMP _0x312
;    2782 		}
_0x26E:
;    2783 	}
;    2784 	else if(F_PF == PF2){
	RJMP _0x27A
_0x26B:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x27B
;    2785 		return;
	RJMP _0x312
;    2786 	}
;    2787 	Motion.PF = F_PF;
_0x27B:
_0x27A:
_0x26A:
_0x25A:
	__PUTBMRN _Motion,5,12
;    2788 	M_PlayFlash();
	CALL _M_PlayFlash
;    2789 }
_0x312:
	ADIW R28,1
	RET
;    2790 //==============================================================================
;    2791 //						Digital Input Output 관련 함수들
;    2792 //==============================================================================
;    2793 
;    2794 #include <mega128.h>
;    2795 #include "Main.h"
;    2796 #include "Macro.h"
;    2797 #include "DIO.h"
;    2798 
;    2799 //------------------------------------------------------------------------------
;    2800 // 버튼 읽기
;    2801 //------------------------------------------------------------------------------
;    2802 void ReadButton(void)
;    2803 {
_ReadButton:
;    2804 	BYTE	lbtmp;
;    2805 
;    2806 	lbtmp = PINA & 0x03;
	ST   -Y,R16
;	lbtmp -> R16
	IN   R30,0x19
	ANDI R30,LOW(0x3)
	MOV  R16,R30
;    2807 
;    2808 	if(F_DOWNLOAD) return;
	SBRC R2,4
	RJMP _0x311
;    2809 
;    2810 	if(lbtmp == 0x02){
	CPI  R16,2
	BRNE _0x27D
;    2811 		gPF1BtnCnt++;		gPF2BtnCnt = 0;		gPF12BtnCnt = 0;
	LDS  R30,_gPF1BtnCnt
	LDS  R31,_gPF1BtnCnt+1
	ADIW R30,1
	STS  _gPF1BtnCnt,R30
	STS  _gPF1BtnCnt+1,R31
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8F
;    2812        	if(gPF1BtnCnt > 3000){
	CALL SUBOPT_0x90
	CPI  R26,LOW(0xBB9)
	LDI  R30,HIGH(0xBB9)
	CPC  R27,R30
	BRLO _0x27E
;    2813 			gBtn_val = PF1_BTN_LONG;
	LDI  R30,LOW(4)
	STS  _gBtn_val,R30
;    2814 			gPF1BtnCnt = 0;
	CALL SUBOPT_0x91
;    2815 		}
;    2816 	}
_0x27E:
;    2817 	else if(lbtmp == 0x01){
	RJMP _0x27F
_0x27D:
	CPI  R16,1
	BRNE _0x280
;    2818 		gPF1BtnCnt = 0;		gPF2BtnCnt++;		gPF12BtnCnt = 0;
	CALL SUBOPT_0x91
	LDS  R30,_gPF2BtnCnt
	LDS  R31,_gPF2BtnCnt+1
	ADIW R30,1
	STS  _gPF2BtnCnt,R30
	STS  _gPF2BtnCnt+1,R31
	CALL SUBOPT_0x8F
;    2819        	if(gPF2BtnCnt > 3000){
	CALL SUBOPT_0x92
	CPI  R26,LOW(0xBB9)
	LDI  R30,HIGH(0xBB9)
	CPC  R27,R30
	BRLO _0x281
;    2820 			gBtn_val = PF2_BTN_LONG;
	LDI  R30,LOW(5)
	STS  _gBtn_val,R30
;    2821 			gPF2BtnCnt = 0;
	CALL SUBOPT_0x8E
;    2822 		}
;    2823 	}
_0x281:
;    2824 	else if(lbtmp == 0x00){
	RJMP _0x282
_0x280:
	CPI  R16,0
	BRNE _0x283
;    2825 		gPF1BtnCnt = 0;		gPF2BtnCnt = 0;		gPF12BtnCnt++;
	CALL SUBOPT_0x91
	CALL SUBOPT_0x8E
	LDS  R30,_gPF12BtnCnt
	LDS  R31,_gPF12BtnCnt+1
	ADIW R30,1
	STS  _gPF12BtnCnt,R30
	STS  _gPF12BtnCnt+1,R31
;    2826        	if(gPF12BtnCnt > 2000){
	CALL SUBOPT_0x93
	CPI  R26,LOW(0x7D1)
	LDI  R30,HIGH(0x7D1)
	CPC  R27,R30
	BRLO _0x284
;    2827            	if(F_PF_CHANGED == 0){
	SBRC R3,1
	RJMP _0x285
;    2828 				gBtn_val = PF12_BTN_LONG;
	LDI  R30,LOW(6)
	STS  _gBtn_val,R30
;    2829 	       	    gPF12BtnCnt = 0;
	CALL SUBOPT_0x8F
;    2830 			}
;    2831 		}
_0x285:
;    2832 	}
_0x284:
;    2833 	else{
	RJMP _0x286
_0x283:
;    2834 		if(gPF1BtnCnt > 40 && gPF1BtnCnt < 500){
	CALL SUBOPT_0x90
	SBIW R26,41
	BRLO _0x288
	CALL SUBOPT_0x90
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0x289
_0x288:
	RJMP _0x287
_0x289:
;    2835 			gBtn_val = PF1_BTN_SHORT;
	LDI  R30,LOW(1)
	RJMP _0x330
;    2836 		}
;    2837 		else if(gPF2BtnCnt > 40 && gPF2BtnCnt < 500){
_0x287:
	CALL SUBOPT_0x92
	SBIW R26,41
	BRLO _0x28C
	CALL SUBOPT_0x92
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0x28D
_0x28C:
	RJMP _0x28B
_0x28D:
;    2838 			gBtn_val = PF2_BTN_SHORT;
	LDI  R30,LOW(2)
	RJMP _0x330
;    2839 		}
;    2840 		else if(gPF12BtnCnt > 40 && gPF12BtnCnt < 500){
_0x28B:
	CALL SUBOPT_0x93
	SBIW R26,41
	BRLO _0x290
	CALL SUBOPT_0x93
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0x291
_0x290:
	RJMP _0x28F
_0x291:
;    2841 			gBtn_val = PF12_BTN_SHORT;
	LDI  R30,LOW(3)
	RJMP _0x330
;    2842 		}
;    2843 		else
_0x28F:
;    2844 			gBtn_val = BTN_NOT_PRESSED;
	LDI  R30,LOW(0)
_0x330:
	STS  _gBtn_val,R30
;    2845 		gPF1BtnCnt = 0;
	CALL SUBOPT_0x91
;    2846 		gPF2BtnCnt = 0;
	CALL SUBOPT_0x8E
;    2847 		gPF12BtnCnt = 0;
	CALL SUBOPT_0x8F
;    2848 		F_PF_CHANGED = 0;
	CLT
	BLD  R3,1
;    2849 	}
_0x286:
_0x282:
_0x27F:
;    2850 } 
_0x311:
	LD   R16,Y+
	RET
;    2851 
;    2852 
;    2853 //------------------------------------------------------------------------------
;    2854 // 버튼 처리
;    2855 //------------------------------------------------------------------------------
;    2856 void ProcButton(void)
;    2857 {
_ProcButton:
;    2858 	WORD	i;
;    2859 	if(gBtn_val == PF12_BTN_LONG){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDS  R26,_gBtn_val
	CPI  R26,LOW(0x6)
	BRNE _0x293
;    2860 		gBtn_val = 0;
	LDI  R30,LOW(0)
	STS  _gBtn_val,R30
;    2861 		if(F_PS_PLUGGED){
	SBRS R2,5
	RJMP _0x294
;    2862 			BreakModeCmdSend();
	CALL _BreakModeCmdSend
;    2863 			ChargeNiMH();
	CALL _ChargeNiMH
;    2864 		}
;    2865 	}
_0x294:
;    2866 	else if(gBtn_val == PF1_BTN_LONG){
	RJMP _0x295
_0x293:
	LDS  R26,_gBtn_val
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x296
;    2867 		gBtn_val = 0;
	LDI  R30,LOW(0)
	STS  _gBtn_val,R30
;    2868 		if(F_PF==PF1_HUNO){
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x297
;    2869 			F_PF=PF1_DINO;
	LDI  R30,LOW(2)
	MOV  R12,R30
;    2870 			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Dino[i], U_Boundary_Dino[i]);
	__GETWRN 16,17,0
_0x299:
	__CPWRN 16,17,16
	BRSH _0x29A
	ST   -Y,R16
	MOVW R30,R16
	SUBI R30,LOW(-_L_Boundary_Dino*2)
	SBCI R31,HIGH(-_L_Boundary_Dino*2)
	CALL SUBOPT_0x94
	SUBI R30,LOW(-_U_Boundary_Dino*2)
	SBCI R31,HIGH(-_U_Boundary_Dino*2)
	CALL SUBOPT_0x95
;    2871 		}
	__ADDWRN 16,17,1
	RJMP _0x299
_0x29A:
;    2872 		else if(F_PF==PF1_DINO){
	RJMP _0x29B
_0x297:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x29C
;    2873 			F_PF=PF1_DOGY;
	LDI  R30,LOW(3)
	MOV  R12,R30
;    2874 			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Dogy[i], U_Boundary_Dogy[i]);
	__GETWRN 16,17,0
_0x29E:
	__CPWRN 16,17,16
	BRSH _0x29F
	ST   -Y,R16
	MOVW R30,R16
	SUBI R30,LOW(-_L_Boundary_Dogy*2)
	SBCI R31,HIGH(-_L_Boundary_Dogy*2)
	CALL SUBOPT_0x94
	SUBI R30,LOW(-_U_Boundary_Dogy*2)
	SBCI R31,HIGH(-_U_Boundary_Dogy*2)
	CALL SUBOPT_0x95
;    2875 		}
	__ADDWRN 16,17,1
	RJMP _0x29E
_0x29F:
;    2876 		else{
	RJMP _0x2A0
_0x29C:
;    2877 			F_PF=PF1_HUNO;
	LDI  R30,LOW(1)
	MOV  R12,R30
;    2878 			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Huno[i], U_Boundary_Huno[i]);
	__GETWRN 16,17,0
_0x2A2:
	__CPWRN 16,17,16
	BRSH _0x2A3
	ST   -Y,R16
	MOVW R30,R16
	SUBI R30,LOW(-_L_Boundary_Huno*2)
	SBCI R31,HIGH(-_L_Boundary_Huno*2)
	CALL SUBOPT_0x94
	SUBI R30,LOW(-_U_Boundary_Huno*2)
	SBCI R31,HIGH(-_U_Boundary_Huno*2)
	CALL SUBOPT_0x95
;    2879 		}
	__ADDWRN 16,17,1
	RJMP _0x2A2
_0x2A3:
_0x2A0:
_0x29B:
;    2880 		BreakModeCmdSend();
	RJMP _0x331
;    2881 		delay_ms(10);
;    2882 		F_PF_CHANGED = 1;
;    2883 		ePF = F_PF;
;    2884 	}
;    2885 	else if(gBtn_val == PF2_BTN_LONG){
_0x296:
	LDS  R26,_gBtn_val
	CPI  R26,LOW(0x5)
	BRNE _0x2A5
;    2886 		gBtn_val = 0;
	LDI  R30,LOW(0)
	STS  _gBtn_val,R30
;    2887 		F_PF = PF2;
	LDI  R30,LOW(4)
	MOV  R12,R30
;    2888 		BreakModeCmdSend();
_0x331:
	CALL _BreakModeCmdSend
;    2889 		delay_ms(10);
	CALL SUBOPT_0x34
;    2890 		F_PF_CHANGED = 1;
	SET
	BLD  R3,1
;    2891 		ePF = F_PF;
	MOV  R30,R12
	LDI  R26,LOW(_ePF)
	LDI  R27,HIGH(_ePF)
	CALL __EEPROMWRB
;    2892 	}
;    2893 }
_0x2A5:
_0x295:
	RJMP _0x310
;    2894 
;    2895 
;    2896 //------------------------------------------------------------------------------
;    2897 // Io 업데이트 처리
;    2898 //------------------------------------------------------------------------------
;    2899 void IoUpdate(void)
;    2900 {
_IoUpdate:
;    2901 	if(F_DOWNLOAD) return;
	SBRC R2,4
	RET
;    2902 	if(F_DIRECT_C_EN){
	SBRS R2,2
	RJMP _0x2A7
;    2903 			PF1_LED1_ON;
	CBI  0x1B,2
;    2904 			PF1_LED2_OFF;
	SBI  0x1B,3
;    2905 			PF2_LED_ON;
	CBI  0x1B,4
;    2906 			return;
	RET
;    2907 	}
;    2908 	switch(F_PF){
_0x2A7:
	MOV  R30,R12
;    2909 		case PF1_HUNO:
	CPI  R30,LOW(0x1)
	BRNE _0x2AB
;    2910 			PF1_LED1_ON;
	CBI  0x1B,2
;    2911 			PF1_LED2_OFF;
	SBI  0x1B,3
;    2912 			PF2_LED_OFF;
	SBI  0x1B,4
;    2913 			break;
	RJMP _0x2AA
;    2914 		case PF1_DINO:
_0x2AB:
	CPI  R30,LOW(0x2)
	BRNE _0x2AC
;    2915 			PF1_LED1_ON;
	CBI  0x1B,2
;    2916 			PF1_LED2_ON;
	CBI  0x1B,3
;    2917 			PF2_LED_OFF;
	SBI  0x1B,4
;    2918 			break;
	RJMP _0x2AA
;    2919 		case PF1_DOGY:
_0x2AC:
	CPI  R30,LOW(0x3)
	BRNE _0x2AD
;    2920 			PF1_LED1_OFF;
	SBI  0x1B,2
;    2921 			PF1_LED2_ON;
	CBI  0x1B,3
;    2922 			PF2_LED_OFF;
	SBI  0x1B,4
;    2923 			break;
	RJMP _0x2AA
;    2924 		case PF2:
_0x2AD:
	CPI  R30,LOW(0x4)
	BRNE _0x2AF
;    2925 			PF1_LED1_OFF;
	SBI  0x1B,2
;    2926 			PF1_LED2_OFF;
	SBI  0x1B,3
;    2927 			PF2_LED_ON;
	CBI  0x1B,4
;    2928 			break;
	RJMP _0x2AA
;    2929 		default:
_0x2AF:
;    2930 			F_PF = PF2;
	LDI  R30,LOW(4)
	MOV  R12,R30
;    2931 	}
_0x2AA:
;    2932 
;    2933 	if(gVOLTAGE>M_T_OF_POWER){
	LDI  R30,LOW(8600)
	LDI  R31,HIGH(8600)
	CP   R30,R5
	CPC  R31,R6
	BRSH _0x2B0
;    2934 		PWR_LED1_ON;
	CALL SUBOPT_0x2E
;    2935 		PWR_LED2_OFF;
	SBI  0x15,7
;    2936 		gPwrLowCount = 0;
	CALL SUBOPT_0x96
;    2937 	}
;    2938 	else if(gVOLTAGE>L_T_OF_POWER){
	RJMP _0x2B1
_0x2B0:
	LDI  R30,LOW(8100)
	LDI  R31,HIGH(8100)
	CP   R30,R5
	CPC  R31,R6
	BRSH _0x2B2
;    2939 		PWR_LED1_OFF;
	CALL SUBOPT_0x30
;    2940 		PWR_LED2_ON;
	CBI  0x15,7
;    2941 		gPwrLowCount++;
	CALL SUBOPT_0x97
;    2942 		if(gPwrLowCount>5000){
	CPI  R26,LOW(0x1389)
	LDI  R30,HIGH(0x1389)
	CPC  R27,R30
	BRLO _0x2B3
;    2943 			gPwrLowCount = 0;
	CALL SUBOPT_0x96
;    2944 			BreakModeCmdSend();
	CALL _BreakModeCmdSend
;    2945 		}
;    2946 	}
_0x2B3:
;    2947 	else{
	RJMP _0x2B4
_0x2B2:
;    2948 		PWR_LED1_OFF;
	CALL SUBOPT_0x30
;    2949 		if(g10MSEC<25)			PWR_LED2_ON;
	CALL SUBOPT_0x24
	SBIW R26,25
	BRSH _0x2B5
	CBI  0x15,7
;    2950 		else if(g10MSEC<50)		PWR_LED2_OFF;
	RJMP _0x2B6
_0x2B5:
	CALL SUBOPT_0x24
	SBIW R26,50
	BRSH _0x2B7
	RJMP _0x332
;    2951 		else if(g10MSEC<75)		PWR_LED2_ON;
_0x2B7:
	CALL SUBOPT_0x36
	BRSH _0x2B9
	CBI  0x15,7
;    2952 		else if(g10MSEC<100)	PWR_LED2_OFF;
	RJMP _0x2BA
_0x2B9:
	CALL SUBOPT_0x37
	BRSH _0x2BB
_0x332:
	SBI  0x15,7
;    2953 		gPwrLowCount++;
_0x2BB:
_0x2BA:
_0x2B6:
	CALL SUBOPT_0x97
;    2954 		if(gPwrLowCount>3000){
	CPI  R26,LOW(0xBB9)
	LDI  R30,HIGH(0xBB9)
	CPC  R27,R30
	BRLO _0x2BC
;    2955 			gPwrLowCount=0;
	CALL SUBOPT_0x96
;    2956 			BreakModeCmdSend();
	CALL _BreakModeCmdSend
;    2957 		}
;    2958 	}
_0x2BC:
_0x2B4:
_0x2B1:
;    2959 	if(F_ERR_CODE == NO_ERR)	ERR_LED_OFF;
	LDI  R30,LOW(255)
	CP   R30,R13
	BRNE _0x2BD
	SBI  0x1B,7
;    2960 	else ERR_LED_ON;
	RJMP _0x2BE
_0x2BD:
	CBI  0x1B,7
;    2961 }
_0x2BE:
	RET
;    2962 
;    2963 
;    2964 //------------------------------------------------------------------------------
;    2965 // 자체 테스트1
;    2966 //------------------------------------------------------------------------------
;    2967 void SelfTest1(void)
;    2968 {
_SelfTest1:
;    2969 	WORD	i;
;    2970 
;    2971 	if(F_DIRECT_C_EN)	return;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	SBRC R2,2
	RJMP _0x310
;    2972 
;    2973 	for(i=0;i<16;i++){
	__GETWRN 16,17,0
_0x2C1:
	__CPWRN 16,17,16
	BRSH _0x2C2
;    2974 		if((StandardZeroPos[i]+15)<eM_OriginPose[i]
;    2975 		 ||(StandardZeroPos[i]-15)>eM_OriginPose[i]){
	CALL SUBOPT_0xD
	MOV  R1,R30
	SUBI R30,-LOW(15)
	MOV  R0,R30
	CALL SUBOPT_0x9
	CP   R0,R30
	BRLO _0x2C4
	MOV  R30,R1
	SUBI R30,LOW(15)
	MOV  R0,R30
	CALL SUBOPT_0x9
	CP   R30,R0
	BRSH _0x2C3
_0x2C4:
;    2976 			F_ERR_CODE = ZERO_DATA_ERR;
	LDI  R30,LOW(8)
	MOV  R13,R30
;    2977 			return;
	RJMP _0x310
;    2978 		}
;    2979 	}
_0x2C3:
	__ADDWRN 16,17,1
	RJMP _0x2C1
_0x2C2:
;    2980 	PWR_LED1_ON;	delay_ms(60);	PWR_LED1_OFF;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x98
	CALL SUBOPT_0x30
;    2981 	PWR_LED2_ON;	delay_ms(60);	PWR_LED2_OFF;
	CBI  0x15,7
	CALL SUBOPT_0x98
	SBI  0x15,7
;    2982 	RUN_LED1_ON;	delay_ms(60);	RUN_LED1_OFF;
	CBI  0x1B,5
	CALL SUBOPT_0x98
	SBI  0x1B,5
;    2983 	RUN_LED2_ON;	delay_ms(60);	RUN_LED2_OFF;
	CBI  0x1B,6
	CALL SUBOPT_0x98
	SBI  0x1B,6
;    2984 	ERR_LED_ON;		delay_ms(60);	ERR_LED_OFF;
	CBI  0x1B,7
	CALL SUBOPT_0x98
	SBI  0x1B,7
;    2985 
;    2986 	PF2_LED_ON;		delay_ms(60);	PF2_LED_OFF;
	CBI  0x1B,4
	CALL SUBOPT_0x98
	SBI  0x1B,4
;    2987 	PF1_LED2_ON;	delay_ms(60);	PF1_LED2_OFF;
	CBI  0x1B,3
	CALL SUBOPT_0x98
	SBI  0x1B,3
;    2988 	PF1_LED1_ON;	delay_ms(60);	PF1_LED1_OFF;
	CBI  0x1B,2
	CALL SUBOPT_0x98
	SBI  0x1B,2
;    2989 }
	RJMP _0x310
;    2990 
;    2991 
;    2992 //------------------------------------------------------------------------------
;    2993 // IR 수신 처리
;    2994 //------------------------------------------------------------------------------
;    2995 void ProcIr(void)
;    2996 {
_ProcIr:
;    2997     WORD    i;
;    2998 
;    2999 	if(F_DOWNLOAD) return;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	SBRC R2,4
	RJMP _0x310
;    3000 	if(F_FIRST_M && gIrBuf[3]!=BTN_C && gIrBuf[3]!=BTN_SHARP_A && F_PF!=PF2) return;
	SBRS R3,3
	RJMP _0x2C8
	__GETB1MN _gIrBuf,3
	CPI  R30,LOW(0x7)
	BREQ _0x2C8
	__GETB1MN _gIrBuf,3
	CPI  R30,LOW(0x2B)
	BREQ _0x2C8
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x2C9
_0x2C8:
	RJMP _0x2C7
_0x2C9:
	RJMP _0x310
;    3001 	if(F_IR_RECEIVED){
_0x2C7:
	SBRS R3,2
	RJMP _0x2CA
;    3002 	    EIMSK &= 0xBF;
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;    3003 		F_IR_RECEIVED = 0;
	CLT
	BLD  R3,2
;    3004 		if((gIrBuf[0]==eRCodeH[0] && gIrBuf[1]==eRCodeM[0] && gIrBuf[2]==eRCodeL[0])
;    3005 		 ||(gIrBuf[0]==eRCodeH[1] && gIrBuf[1]==eRCodeM[1] && gIrBuf[2]==eRCodeL[1])
;    3006 		 ||(gIrBuf[0]==eRCodeH[2] && gIrBuf[1]==eRCodeM[2] && gIrBuf[2]==eRCodeL[2])
;    3007 		 ||(gIrBuf[0]==eRCodeH[3] && gIrBuf[1]==eRCodeM[3] && gIrBuf[2]==eRCodeL[3])
;    3008 		 ||(gIrBuf[0]==eRCodeH[4] && gIrBuf[1]==eRCodeM[4] && gIrBuf[2]==eRCodeL[4])){
	LDI  R26,LOW(_eRCodeH)
	LDI  R27,HIGH(_eRCodeH)
	CALL SUBOPT_0x99
	BRNE _0x2CC
	LDI  R26,LOW(_eRCodeM)
	LDI  R27,HIGH(_eRCodeM)
	CALL SUBOPT_0x9A
	BRNE _0x2CC
	LDI  R26,LOW(_eRCodeL)
	LDI  R27,HIGH(_eRCodeL)
	CALL SUBOPT_0x9B
	BREQ _0x2CE
_0x2CC:
	__POINTW2MN _eRCodeH,1
	CALL SUBOPT_0x99
	BRNE _0x2CF
	__POINTW2MN _eRCodeM,1
	CALL SUBOPT_0x9A
	BRNE _0x2CF
	__POINTW2MN _eRCodeL,1
	CALL SUBOPT_0x9B
	BREQ _0x2CE
_0x2CF:
	__POINTW2MN _eRCodeH,2
	CALL SUBOPT_0x99
	BRNE _0x2D1
	__POINTW2MN _eRCodeM,2
	CALL SUBOPT_0x9A
	BRNE _0x2D1
	__POINTW2MN _eRCodeL,2
	CALL SUBOPT_0x9B
	BREQ _0x2CE
_0x2D1:
	__POINTW2MN _eRCodeH,3
	CALL SUBOPT_0x99
	BRNE _0x2D3
	__POINTW2MN _eRCodeM,3
	CALL SUBOPT_0x9A
	BRNE _0x2D3
	__POINTW2MN _eRCodeL,3
	CALL SUBOPT_0x9B
	BREQ _0x2CE
_0x2D3:
	__POINTW2MN _eRCodeH,4
	CALL SUBOPT_0x99
	BRNE _0x2D5
	__POINTW2MN _eRCodeM,4
	CALL SUBOPT_0x9A
	BRNE _0x2D5
	__POINTW2MN _eRCodeL,4
	CALL SUBOPT_0x9B
	BREQ _0x2CE
_0x2D5:
	RJMP _0x2CB
_0x2CE:
;    3009 			switch(gIrBuf[3]){
	__GETB1MN _gIrBuf,3
;    3010 				case BTN_A:
	CPI  R30,LOW(0x1)
	BRNE _0x2DB
;    3011 					M_Play(BTN_A);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _M_Play
;    3012 					break;
	RJMP _0x2DA
;    3013 				case BTN_B:
_0x2DB:
	CPI  R30,LOW(0x2)
	BRNE _0x2DC
;    3014 					M_Play(BTN_B);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _M_Play
;    3015 					break;
	RJMP _0x2DA
;    3016 				case BTN_LR:
_0x2DC:
	CPI  R30,LOW(0x3)
	BRNE _0x2DD
;    3017 					M_Play(BTN_LR);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _M_Play
;    3018 					break;
	RJMP _0x2DA
;    3019 				case BTN_U:
_0x2DD:
	CPI  R30,LOW(0x4)
	BRNE _0x2DE
;    3020 					M_Play(BTN_U);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _M_Play
;    3021 					break;
	RJMP _0x2DA
;    3022 				case BTN_RR:
_0x2DE:
	CPI  R30,LOW(0x5)
	BRNE _0x2DF
;    3023 					M_Play(BTN_RR);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _M_Play
;    3024 					break;
	RJMP _0x2DA
;    3025 				case BTN_L:
_0x2DF:
	CPI  R30,LOW(0x6)
	BRNE _0x2E0
;    3026 					M_Play(BTN_L);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _M_Play
;    3027 					break;
	RJMP _0x2DA
;    3028 				case BTN_R:
_0x2E0:
	CPI  R30,LOW(0x8)
	BRNE _0x2E1
;    3029 					M_Play(BTN_R);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _M_Play
;    3030 					break;
	RJMP _0x2DA
;    3031 				case BTN_LA:
_0x2E1:
	CPI  R30,LOW(0x9)
	BRNE _0x2E2
;    3032 					M_Play(BTN_LA);
	LDI  R30,LOW(9)
	ST   -Y,R30
	CALL _M_Play
;    3033 					break;
	RJMP _0x2DA
;    3034 				case BTN_D:
_0x2E2:
	CPI  R30,LOW(0xA)
	BRNE _0x2E3
;    3035 					M_Play(BTN_D);
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _M_Play
;    3036 					break;
	RJMP _0x2DA
;    3037 				case BTN_RA:
_0x2E3:
	CPI  R30,LOW(0xB)
	BRNE _0x2E4
;    3038 					M_Play(BTN_RA);
	LDI  R30,LOW(11)
	ST   -Y,R30
	CALL _M_Play
;    3039 					break;
	RJMP _0x2DA
;    3040 				case BTN_C:
_0x2E4:
	CPI  R30,LOW(0x7)
	BRNE _0x2E5
;    3041 					F_FIRST_M = 0;
	CLT
	BLD  R3,3
;    3042 					M_Play(BTN_C);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _M_Play
;    3043 					break;
	RJMP _0x2DA
;    3044 				case BTN_1:
_0x2E5:
	CPI  R30,LOW(0xC)
	BRNE _0x2E6
;    3045 					break;
	RJMP _0x2DA
;    3046 				case BTN_2:
_0x2E6:
	CPI  R30,LOW(0xD)
	BRNE _0x2E7
;    3047 					break;
	RJMP _0x2DA
;    3048 				case BTN_3:
_0x2E7:
	CPI  R30,LOW(0xE)
	BRNE _0x2E8
;    3049 					break;
	RJMP _0x2DA
;    3050 				case BTN_4:
_0x2E8:
	CPI  R30,LOW(0xF)
	BRNE _0x2E9
;    3051 					break;
	RJMP _0x2DA
;    3052 				case BTN_5:
_0x2E9:
	CPI  R30,LOW(0x10)
	BRNE _0x2EA
;    3053 					break;
	RJMP _0x2DA
;    3054 				case BTN_6:
_0x2EA:
	CPI  R30,LOW(0x11)
	BRNE _0x2EB
;    3055 					break;
	RJMP _0x2DA
;    3056 				case BTN_7:
_0x2EB:
	CPI  R30,LOW(0x12)
	BRNE _0x2EC
;    3057 					break;
	RJMP _0x2DA
;    3058 				case BTN_8:
_0x2EC:
	CPI  R30,LOW(0x13)
	BRNE _0x2ED
;    3059 					break;
	RJMP _0x2DA
;    3060 				case BTN_9:
_0x2ED:
	CPI  R30,LOW(0x14)
	BRNE _0x2EE
;    3061 					break;
	RJMP _0x2DA
;    3062 				case BTN_0:
_0x2EE:
	CPI  R30,LOW(0x15)
	BRNE _0x2EF
;    3063 					M_Play(BTN_0);
	LDI  R30,LOW(21)
	ST   -Y,R30
	CALL _M_Play
;    3064 					break;
	RJMP _0x2DA
;    3065 				case BTN_STAR_A:
_0x2EF:
	CPI  R30,LOW(0x16)
	BRNE _0x2F0
;    3066 					M_Play(BTN_STAR_A);
	LDI  R30,LOW(22)
	ST   -Y,R30
	CALL _M_Play
;    3067 					break;
	RJMP _0x2DA
;    3068 				case BTN_STAR_B:
_0x2F0:
	CPI  R30,LOW(0x17)
	BRNE _0x2F1
;    3069 					M_Play(BTN_STAR_B);
	LDI  R30,LOW(23)
	ST   -Y,R30
	CALL _M_Play
;    3070 					break;
	RJMP _0x2DA
;    3071 				case BTN_STAR_C:
_0x2F1:
	CPI  R30,LOW(0x1C)
	BRNE _0x2F2
;    3072 					M_Play(BTN_STAR_C);
	LDI  R30,LOW(28)
	ST   -Y,R30
	CALL _M_Play
;    3073 					break;
	RJMP _0x2DA
;    3074 				case BTN_STAR_1:
_0x2F2:
	CPI  R30,LOW(0x21)
	BREQ _0x2DA
;    3075 					break;
;    3076 				case BTN_STAR_2:
	CPI  R30,LOW(0x22)
	BREQ _0x2DA
;    3077 					break;
;    3078 				case BTN_STAR_3:
	CPI  R30,LOW(0x23)
	BREQ _0x2DA
;    3079 					break;
;    3080 				case BTN_STAR_4:
	CPI  R30,LOW(0x24)
	BREQ _0x2DA
;    3081 					break;
;    3082 				case BTN_STAR_5:
	CPI  R30,LOW(0x25)
	BREQ _0x2DA
;    3083 					break;
;    3084 				case BTN_STAR_6:
	CPI  R30,LOW(0x26)
	BREQ _0x2DA
;    3085 					break;
;    3086 				case BTN_STAR_7:
	CPI  R30,LOW(0x27)
	BREQ _0x2DA
;    3087 					break;
;    3088 				case BTN_STAR_8:
	CPI  R30,LOW(0x28)
	BREQ _0x2DA
;    3089 					break;
;    3090 				case BTN_STAR_9:
	CPI  R30,LOW(0x29)
	BREQ _0x2DA
;    3091 					break;
;    3092 				case BTN_STAR_0:
	CPI  R30,LOW(0x2A)
	BREQ _0x2DA
;    3093 					break;
;    3094 				case BTN_SHARP_1:
	CPI  R30,LOW(0x36)
	BREQ _0x2DA
;    3095 					break;
;    3096 				case BTN_SHARP_2:
	CPI  R30,LOW(0x37)
	BREQ _0x2DA
;    3097 					break;
;    3098 				case BTN_SHARP_3:
	CPI  R30,LOW(0x38)
	BREQ _0x2DA
;    3099 					break;
;    3100 				case BTN_SHARP_4:
	CPI  R30,LOW(0x39)
	BREQ _0x2DA
;    3101 					break;
;    3102 				case BTN_SHARP_5:
	CPI  R30,LOW(0x3A)
	BREQ _0x2DA
;    3103 					break;
;    3104 				case BTN_SHARP_6:
	CPI  R30,LOW(0x3B)
	BREQ _0x2DA
;    3105 					break;
;    3106 				case BTN_SHARP_7:
	CPI  R30,LOW(0x3C)
	BREQ _0x2DA
;    3107 					break;
;    3108 				case BTN_SHARP_8:
	CPI  R30,LOW(0x3D)
	BREQ _0x2DA
;    3109 					break;
;    3110 				case BTN_SHARP_9:
	CPI  R30,LOW(0x3E)
	BREQ _0x2DA
;    3111 					break;
;    3112 				case BTN_SHARP_0:
	CPI  R30,LOW(0x3F)
	BREQ _0x2DA
;    3113 					break;
;    3114 				case BTN_SHARP_A:
	CPI  R30,LOW(0x2B)
	BRNE _0x307
;    3115 					if(F_PS_PLUGGED){
	SBRS R2,5
	RJMP _0x308
;    3116 						BreakModeCmdSend();
	CALL _BreakModeCmdSend
;    3117 						ChargeNiMH();
	CALL _ChargeNiMH
;    3118 					}
;    3119 					else{
_0x308:
;    3120 					}
;    3121 					break;
	RJMP _0x2DA
;    3122 				case BTN_SHARP_B:
_0x307:
	CPI  R30,LOW(0x2C)
	BREQ _0x2DA
;    3123 					break;
;    3124 				case BTN_SHARP_C:
	CPI  R30,LOW(0x31)
	BRNE _0x2DA
;    3125 					BasicPose(0, 50, 1000, 4);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x7D
;    3126 					BasicPose(0, 1, 100, 1);
	CALL SUBOPT_0x38
;    3127 					break;
;    3128 			}
_0x2DA:
;    3129 		}
;    3130 		if(F_RSV_MOTION){
_0x2CB:
	SBRS R3,4
	RJMP _0x30C
;    3131 			F_RSV_MOTION = 0;
	CLT
	BLD  R3,4
;    3132 			SendToPC(20,1);
	LDI  R30,LOW(20)
	CALL SUBOPT_0x1A
;    3133 			gFileCheckSum = 0;
;    3134 			sciTx1Data(gIrBuf[3]);
	__GETB1MN _gIrBuf,3
	ST   -Y,R30
	CALL _sciTx1Data
;    3135 			gFileCheckSum ^= gIrBuf[3];
	__GETB1MN _gIrBuf,3
	CALL SUBOPT_0xA
;    3136 			sciTx1Data(gFileCheckSum);
	CALL SUBOPT_0xB
;    3137 		}
;    3138 		for(i=0;i<IR_BUFFER_SIZE;i++)	gIrBuf[i]=0;
_0x30C:
	__GETWRN 16,17,0
_0x30E:
	__CPWRN 16,17,4
	BRSH _0x30F
	CALL SUBOPT_0x3A
;    3139 	    EIMSK |= 0x40;
	__ADDWRN 16,17,1
	RJMP _0x30E
_0x30F:
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
;    3140 	}
;    3141 }
_0x2CA:
_0x310:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x6:
	LDI  R30,0
	STS  _gRx1Step,R30
	STS  _gRx1Step+1,R30
	CLT
	BLD  R2,4
	SBI  0x1B,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0xA:
	LDS  R26,_gFileCheckSum
	EOR  R30,R26
	STS  _gFileCheckSum,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xB:
	LDS  R30,_gFileCheckSum
	ST   -Y,R30
	JMP  _sciTx1Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xF:
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDS  R30,_gTx0BufIdx
	SUBI R30,-LOW(1)
	STS  _gTx0BufIdx,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
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
SUBOPT_0x12:
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
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
SUBOPT_0x14:
	STS  _gRx1_DStep,R30
	STS  _gRx1_DStep+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:62 WORDS
SUBOPT_0x15:
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
SUBOPT_0x16:
	LDI  R30,0
	STS  _gRx1_DStep,R30
	STS  _gRx1_DStep+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x17:
	STS  _gRx1Step,R30
	STS  _gRx1Step+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	SBI  0xA,6
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _U1I_case301

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _SendToPC
	LDI  R30,LOW(0)
	STS  _gFileCheckSum,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	ST   -Y,R30
	CALL _sciTx1Data
	LDS  R26,_gFileCheckSum
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _gFileCheckSum,R30
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1E:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _SendToPC
	LDI  R30,LOW(0)
	STS  _gFileCheckSum,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x20:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x21:
	__GETB1MN _gRx1Buf,18
	ST   -Y,R30
	CALL _sciTx1Data
	__GETB1MN _gRx1Buf,18
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	CALL _sciTx1Data
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	ST   -Y,R30
	CALL _sciTx1Data
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x24:
	LDS  R26,_g10MSEC
	LDS  R27,_g10MSEC+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDS  R30,_gSEC_DCOUNT
	LDS  R31,_gSEC_DCOUNT+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	STS  _gSEC_DCOUNT,R30
	STS  _gSEC_DCOUNT+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDS  R30,_gMIN_DCOUNT
	LDS  R31,_gMIN_DCOUNT+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	STS  _gMIN_DCOUNT,R30
	STS  _gMIN_DCOUNT+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	__GETW1MN _Scene,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2A:
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
SUBOPT_0x2B:
	IN   R30,0x36
	ORI  R30,4
	OUT  0x36,R30
	IN   R30,0x37
	ORI  R30,4
	OUT  0x37,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	CALL _MakeFrame
	JMP  _SendFrame

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDI  R30,0
	STS  _gPSunplugCount,R30
	STS  _gPSunplugCount+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2E:
	LDS  R30,101
	ANDI R30,0xFB
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	CALL _Get_VOLTAGE
	JMP  _DetectPower

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x30:
	LDS  R30,101
	ORI  R30,4
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0x24
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x33:
	ST   -Y,R16
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(254)
	ST   -Y,R30
	JMP  _BoundSetCmdSend

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _BasicPose

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	RCALL SUBOPT_0x24
	CPI  R26,LOW(0x4B)
	LDI  R30,HIGH(0x4B)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x24
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x38:
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
SUBOPT_0x39:
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
	MOVW R30,R16
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	LDI  R26,LOW(_gIrBuf)
	LDI  R27,HIGH(_gIrBuf)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	CALL _sciTx1Data
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _sciTx1Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	CALL _AccStart
	LDI  R30,LOW(112)
	ST   -Y,R30
	CALL _AccByteWrite
	JMP  _AccAckRead

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3E:
	ST   -Y,R30
	CALL _AccByteWrite
	JMP  _AccAckRead

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3F:
	CALL _AccByteRead
	MOV  R16,R30
	JMP  _AccAckWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	SET
	BLD  R2,7
	LDI  R30,LOW(220)
	ST   -Y,R30
	JMP  _ADC_set

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	__GETD1S 0
	CALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x46:
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
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x47:
	LDD  R26,Y+2
	STD  Z+0,R26
	LDS  R30,_gTx0Cnt
	SUBI R30,-LOW(1)
	STS  _gTx0Cnt,R30
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x48:
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
SUBOPT_0x49:
	STD  Z+0,R26
	LDS  R30,_gTx0Cnt
	SUBI R30,-LOW(1)
	STS  _gTx0Cnt,R30
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4A:
	MOV  R18,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _sciTx0Data
	ST   -Y,R16
	CALL _sciTx0Data
	ST   -Y,R17
	JMP  _sciTx0Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4B:
	ST   -Y,R30
	CALL _sciTx0Data
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	ST   -Y,R30
	CALL _sciTx1Data
	LDI  R30,LOW(170)
	ST   -Y,R30
	CALL _sciTx1Data
	LDI  R30,LOW(85)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x4D:
	__MULBNWRU 16,17,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4E:
	__POINTW2MN _Motion,10
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4F:
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	__POINTW2MN _Motion,11
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	__POINTW2MN _Motion,12
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	__POINTW2MN _Motion,13
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	__POINTW2MN _Motion,14
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	__POINTW2MN _Motion,15
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	MOVW R30,R16
	LDI  R26,LOW(_gPoseDelta)
	LDI  R27,HIGH(_gPoseDelta)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x56:
	__GETW1MN _Motion,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x57:
	MOVW R30,R16
	SUBI R30,LOW(-_wCK_IDs*2)
	SBCI R31,HIGH(-_wCK_IDs*2)
	LPM  R30,Z
	LDI  R26,LOW(6)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x58:
	MOVW R0,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x59:
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x57

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	LD   R26,X
	CLR  R27
	MOVW R30,R22
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	LD   R30,X
	ST   -Y,R30
	JMP  _SendSetCmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5C:
	LDS  R30,_gTx0BufIdx
	SUBI R30,LOW(1)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	LD   R30,Z
	ST   -Y,R30
	JMP  _sciTx0Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x5E:
	__MULBNWRU 16,17,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5F:
	__POINTW2MN _Scene,6
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x60:
	__POINTW2MN _Scene,10
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	LDS  R30,_gScIdx
	LDS  R31,_gScIdx+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x63:
	__PUTW1MN _Scene,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	__PUTW1MN _Scene,4
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x65:
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x66:
	__POINTW2MN _Scene,7
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x67:
	__POINTW2MN _Scene,8
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x68:
	__POINTW2MN _Scene,9
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x69:
	MOVW R30,R16
	SUBI R30,LOW(-_wCK_IDs*2)
	SBCI R31,HIGH(-_wCK_IDs*2)
	LPM  R30,Z
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	MOVW R22,R30
	RJMP SUBOPT_0x56

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6B:
	LDS  R26,_gScIdx
	LDS  R27,_gScIdx+1
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6C:
	LDS  R26,_gpPos_Table
	LDS  R27,_gpPos_Table+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
	RJMP SUBOPT_0x69

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6D:
	LDS  R26,_gpT_Table
	LDS  R27,_gpT_Table+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6E:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6F:
	MOVW R30,R16
	LDI  R26,LOW(_gUnitD)
	LDI  R27,HIGH(_gUnitD)
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x70:
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
SUBOPT_0x71:
	MOVW R30,R16
	LDI  R26,LOW(_gUnitD)
	LDI  R27,HIGH(_gUnitD)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:245 WORDS
SUBOPT_0x72:
	__PUTW1MN _Motion,6
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	__PUTW1MN _Motion,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x73:
	__MULBNWRU 17,18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	LDI  R26,LOW(_eM_OriginPose)
	LDI  R27,HIGH(_eM_OriginPose)
	ADD  R26,R17
	ADC  R27,R18
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x75:
	__MULBNWRU 17,18,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x76:
	CALL _GetPose
	LDI  R30,LOW(255)
	CP   R30,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x77:
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x78:
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _abs

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x79:
	CALL _SendExPortD
	CALL _CalcFrameInterval
	LDI  R30,LOW(255)
	CP   R30,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	CALL _CalcUnitMove
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7B:
	ST   -Y,R16
	CALL _PosRead
	MOVW R18,R30
	LDI  R30,LOW(444)
	LDI  R31,HIGH(444)
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7C:
	LDS  R26,_gpPos_Table
	LDS  R27,_gpPos_Table+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7D:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x7E:
	STS  _gpT_Table,R30
	STS  _gpT_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x7F:
	STS  _gpE_Table,R30
	STS  _gpE_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x80:
	STS  _gpPg_Table,R30
	STS  _gpPg_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x81:
	STS  _gpDg_Table,R30
	STS  _gpDg_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x82:
	STS  _gpIg_Table,R30
	STS  _gpIg_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x83:
	STS  _gpFN_Table,R30
	STS  _gpFN_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x84:
	STS  _gpRT_Table,R30
	STS  _gpRT_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x85:
	STS  _gpPos_Table,R30
	STS  _gpPos_Table+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x86:
	RCALL SUBOPT_0x85
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x72

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x87:
	RCALL SUBOPT_0x85
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP SUBOPT_0x72

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x88:
	RCALL SUBOPT_0x85
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x72

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x89:
	RCALL SUBOPT_0x85
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	RJMP SUBOPT_0x72

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8A:
	LDI  R30,LOW(13)
	ST   -Y,R30
	JMP  _SendToSoundIC

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8B:
	RCALL SUBOPT_0x85
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP SUBOPT_0x72

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8C:
	LDI  R30,LOW(11)
	ST   -Y,R30
	JMP  _SendToSoundIC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8D:
	RCALL SUBOPT_0x85
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP SUBOPT_0x72

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8E:
	LDI  R30,0
	STS  _gPF2BtnCnt,R30
	STS  _gPF2BtnCnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8F:
	LDI  R30,0
	STS  _gPF12BtnCnt,R30
	STS  _gPF12BtnCnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x90:
	LDS  R26,_gPF1BtnCnt
	LDS  R27,_gPF1BtnCnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x91:
	LDI  R30,0
	STS  _gPF1BtnCnt,R30
	STS  _gPF1BtnCnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x92:
	LDS  R26,_gPF2BtnCnt
	LDS  R27,_gPF2BtnCnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x93:
	LDS  R26,_gPF12BtnCnt
	LDS  R27,_gPF12BtnCnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x94:
	LPM  R30,Z
	ST   -Y,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x95:
	LPM  R30,Z
	ST   -Y,R30
	JMP  _BoundSetCmdSend

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x96:
	LDI  R30,0
	STS  _gPwrLowCount,R30
	STS  _gPwrLowCount+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x97:
	LDS  R30,_gPwrLowCount
	LDS  R31,_gPwrLowCount+1
	ADIW R30,1
	STS  _gPwrLowCount,R30
	STS  _gPwrLowCount+1,R31
	LDS  R26,_gPwrLowCount
	LDS  R27,_gPwrLowCount+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x98:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x99:
	CALL __EEPROMRDB
	LDS  R26,_gIrBuf
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9A:
	CALL __EEPROMRDB
	__GETB2MN _gIrBuf,1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9B:
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
