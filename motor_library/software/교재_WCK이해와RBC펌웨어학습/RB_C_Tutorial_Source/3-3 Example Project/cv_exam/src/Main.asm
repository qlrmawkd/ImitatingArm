
;CodeVisionAVR C Compiler V1.24.8d Professional
;(C) Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 14.745600 MHz
;Memory model           : Medium
;Optimize for           : Speed
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: Yes
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

	.MACRO __GETBRPF
	OUT  RAMPZ,R22
	ELPM R@0,Z
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

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
	LDI  R29,BYTE3(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	OUT  RAMPZ,R29
	ELPM R24,Z+
	ELPM R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	ELPM R26,Z+
	ELPM R27,Z+
	ELPM R0,Z+
	ELPM R1,Z+
	ELPM R28,Z+
	ELPM R29,Z+
	MOVW R22,R30
	IN   R29,RAMPZ
	MOVW R30,R0
	OUT  RAMPZ,R28
__GLOBAL_INI_LOOP:
	ELPM R0,Z+
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
	.DB  0 ; FIRST EEPROM LOCATION NOT USED, SEE ATMEL ERRATA SHEETS

	.DSEG
	.ORG 0x500
;       1 //===============================================================================================
;       2 //	 RoboBuilder MainController Sample Program	1.0
;       3 //							  2008.04.14	Robobuilder co., ltd.
;       4 //       Tap Size = 4
;       5 //===============================================================================================
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
;      18 // Flag ----------------------------------------------------------------------------------------
;      19 bit 	F_PLAYING;			// Show the motion running �;      20 bit 	F_DIRECT_C_EN;		        // wCK direct control mode (1:Available, 0:Not available)
;      21 
;      22 // Button Input----------------------------------------------------------------------------------
;      23 WORD    gBtnCnt;			// Button press process counter�;      24 
;      25 // Time Measurement ------------------------------------------------------------------------------
;      26 WORD    gMSEC;
;      27 BYTE    gSEC;
;      28 BYTE    gMIN;
;      29 BYTE    gHOUR;
;      30 
;      31 // UART Communication -----------------------------------------------------------------
;      32 char	gTx0Buf[TX0_BUF_SIZE];		// UART0 transmission buffer 
_gTx0Buf:
	.BYTE 0xBA
;      33 BYTE	gTx0Cnt;			// UART0 transmission idle byte number
;      34 BYTE	gRx0Cnt;			// UART0 receiving byte number
;      35 BYTE	gTx0BufIdx;			// UART0 transmission buffer index�;      36 char	gRx0Buf[RX0_BUF_SIZE];		// UART0 transmission buffer 
_gRx0Buf:
	.BYTE 0x8
;      37 BYTE	gOldRx1Byte;			// UART1 �ֱ� ���� ����Ʈ
;      38 char	gRx1Buf[RX1_BUF_SIZE];		// UART1 ���� ����
_gRx1Buf:
	.BYTE 0x14
;      39 BYTE	gRx1Index;			// UART1 ���� ���ۿ� �ε���
_gRx1Index:
	.BYTE 0x1
;      40 WORD	gRx1Step;			// UART1 ���� ��Ŷ �ܰ� ����
_gRx1Step:
	.BYTE 0x2
;      41 WORD	gRx1_DStep;			// �������� ��忡�� UART1 ���� ��Ŷ �ܰ� ����
_gRx1_DStep:
	.BYTE 0x2
;      42 WORD	gFieldIdx;			// �ʵ��� ����Ʈ �ε���
_gFieldIdx:
	.BYTE 0x2
;      43 WORD	gFileByteIndex;			// ������ ����Ʈ �ε���
_gFileByteIndex:
	.BYTE 0x2
;      44 BYTE	gFileCheckSum;			// ���ϳ��� CheckSum
_gFileCheckSum:
	.BYTE 0x1
;      45 BYTE	gRxData;			// ���ŵ����� ����
_gRxData:
	.BYTE 0x1
;      46 
;      47 // ��� �����-----------------------------------------------------------------
;      48 int		gFrameIdx=0;	    // ������̺��� ������ �ε���
_gFrameIdx:
	.BYTE 0x2
;      49 WORD	TxInterval=0;		// ������ �۽� ����
_TxInterval:
	.BYTE 0x2
;      50 float	gUnitD[MAX_wCK];	// ���� ���� ����
_gUnitD:
	.BYTE 0x7C
;      51 BYTE flash	*gpT_Table;	// ��� ��ũ��� ���̺� ������
_gpT_Table:
	.BYTE 0x4
;      52 BYTE flash	*gpE_Table;		// ��� Ȯ����Ʈ�� ���̺� ������
_gpE_Table:
	.BYTE 0x4
;      53 BYTE flash	*gpPg_Table;	// ��� Runtime P�̵� ���̺� ������
_gpPg_Table:
	.BYTE 0x4
;      54 BYTE flash	*gpDg_Table;	// ��� Runtime D�̵� ���̺� ������
_gpDg_Table:
	.BYTE 0x4
;      55 BYTE flash	*gpIg_Table;	// ��� Runtime I�̵� ���̺� ������
_gpIg_Table:
	.BYTE 0x4
;      56 WORD flash	*gpFN_Table;	// �� ������ �� ���̺� ������
_gpFN_Table:
	.BYTE 0x4
;      57 WORD flash	*gpRT_Table;	// �� ����ð� ���̺� ������
_gpRT_Table:
	.BYTE 0x4
;      58 BYTE flash	*gpPos_Table;	// ��� ��ġ�� ���̺� ������
_gpPos_Table:
	.BYTE 0x4
;      59 
;      60 // �׼� ������ ���� ü��
;      61 //      - ũ�� : wCK < Frame < Scene < Motion < Action
;      62 //      - �������� wCK�� �� Frame�� �̷��
;      63 //        �������� Frame �� �� Scene�� �̷��
;      64 //        �������� Scene �� �� Motion�� �̷��
;      65 //        �������� Motion �� �� Action�� �̷��
;      66 
;      67 struct TwCK_in_Motion{  // �� �� ��ǿ��� ����ϴ� wCK ����
;      68 	BYTE	Exist;			// wCK ����
;      69 	BYTE	RPgain;			// Runtime P�̵�
;      70 	BYTE	RDgain;			// Runtime D�̵�
;      71 	BYTE	RIgain;			// Runtime I�̵�
;      72 	BYTE	PortEn;			// Ȯ����Ʈ �������(0:������, 1:�����)
;      73 	BYTE	InitPos;		// ��������� ���� �� ���� �κ��� ���� ��ġ����
;      74 };
;      75 
;      76 struct TwCK_in_Scene{	// �� �� ������ ����ϴ� wCK ����
;      77 	BYTE	Exist;			// wCK ����
;      78 	BYTE	SPos;			// ù �������� wCK ��ġ
;      79 	BYTE	DPos;			// �� �������� wCK ��ġ
;      80 	BYTE	Torq;			// ��ũ
;      81 	BYTE	ExPortD;		// Ȯ����Ʈ ��� ������(1~3)
;      82 };
;      83 
;      84 struct TMotion{			// �� �� ��ǿ��� ����ϴ� ������
;      85 	BYTE	PF;				// ��ǿ� �´� �÷���
;      86 	BYTE	RIdx;			// ����� ��� �ε���
;      87 	DWORD	AIdx;			// ����� ���� �ε���
;      88 	WORD	NumOfScene;		// �� ��
;      89 	WORD	NumOfwCK;		// wCK ��
;      90 	struct	TwCK_in_Motion  wCK[MAX_wCK];	// wCK �Ķ����
;      91 	WORD	FileSize;		// ���� ũ��
;      92 }Motion;
_Motion:
	.BYTE 0xC6
;      93 
;      94 struct TScene{			// �� �� ������ ����ϴ� ������
;      95 	WORD	Idx;			// �� �ε���(0~65535)
;      96 	WORD	NumOfFrame;		// ������ ��
;      97 	WORD	RTime;			// �� ���� �ð�[msec]
;      98 	struct	TwCK_in_Scene   wCK[MAX_wCK];	// wCK ������
;      99 }Scene;
_Scene:
	.BYTE 0xA1
;     100 
;     101 WORD	gSIdx;			// �� �ε���(0~65535)
_gSIdx:
	.BYTE 0x2
;     102 
;     103 //------------------------------------------------------------------------------
;     104 // UART0 �۽� ���ͷ�Ʈ(��Ŷ �۽ſ�)
;     105 //------------------------------------------------------------------------------
;     106 interrupt [USART0_TXC] void usart0_tx_isr(void) {

	.CSEG
_usart0_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     107 	if(gTx0BufIdx<gTx0Cnt){			// ���� �����Ͱ� ����������
	CP   R13,R11
	BRLO PC+3
	JMP _0x3
;     108     	while(!(UCSR0A&(1<<UDRE))); 	// ���� ����Ʈ ������ �Ϸ�ɶ����� ���
_0x4:
	SBIC 0xB,5
	RJMP _0x6
	RJMP _0x4
_0x6:
;     109 		UDR0=gTx0Buf[gTx0BufIdx];		// 1����Ʈ �۽�
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	LD   R30,Z
	OUT  0xC,R30
;     110     	gTx0BufIdx++;      				// ���� �ε��� ����
	INC  R13
;     111 	}
;     112 	else if(gTx0BufIdx==gTx0Cnt){	// �۽� �Ϸ�
	RJMP _0x7
_0x3:
	CP   R11,R13
	BREQ PC+3
	JMP _0x8
;     113 		gTx0BufIdx = 0;					// ���� �ε��� �ʱ�ȭ
	CLR  R13
;     114 		gTx0Cnt = 0;					// �۽� ��� ����Ʈ�� �ʱ�ȭ
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
;     120 // UART0 ���� ���ͷ�Ʈ(wCK, �����⿡�� ���� ��ȣ)
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
;     128     // ���ŵ����͸� FIFO�� ����
;     129    	for(i=1; i<RX0_BUF_SIZE; i++) gRx0Buf[i-1] = gRx0Buf[i];
	__GETWRN 16,17,1
_0xA:
	__CPWRN 16,17,8
	BRLT PC+3
	JMP _0xB
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
_0x9:
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
;     135 // Ÿ�̸�0 �����÷� ���ͷ�Ʈ (�ð� ������ 0.998ms ����)
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
;     139 	// 1ms ���� ����
;     140     if(++gMSEC>999){
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRSH PC+3
	JMP _0xC
;     141 		// 1s ���� ����
;     142         gMSEC=0;
	CLR  R6
	CLR  R7
;     143         if(++gSEC>59){
	INC  R8
	LDI  R30,LOW(59)
	CP   R30,R8
	BRLO PC+3
	JMP _0xD
;     144 			// 1m ���� ����
;     145             gSEC=0;
	CLR  R8
;     146             if(++gMIN>59){
	INC  R9
	CP   R30,R9
	BRLO PC+3
	JMP _0xE
;     147 				// 1h ���� ����
;     148                 gMIN=0;
	CLR  R9
;     149                 if(++gHOUR>23)
	INC  R10
	LDI  R30,LOW(23)
	CP   R30,R10
	BRLO PC+3
	JMP _0xF
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
;     158 // Ÿ�̸�1 �����÷� ���ͷ�Ʈ (������ �۽�)
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
	IN   R30,RAMPZ
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     161 	if( gFrameIdx == Scene.NumOfFrame ) {   // ������ �������̾�����
	__GETW1MN _Scene,2
	LDS  R26,_gFrameIdx
	LDS  R27,_gFrameIdx+1
	CP   R30,R26
	CPC  R31,R27
	BREQ PC+3
	JMP _0x10
;     162    	    gFrameIdx = 0;
	LDI  R30,0
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R30
;     163     	RUN_LED1_OFF;
	SBI  0x1B,5
;     164 		F_PLAYING=0;		// ��� ������ ǥ������
	CLT
	BLD  R2,0
;     165 		TIMSK &= 0xfb;  	// Timer1 Overflow Interrupt ����
	IN   R30,0x37
	ANDI R30,0xFB
	OUT  0x37,R30
;     166 		TCCR1B=0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
;     167 		return;
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	OUT  RAMPZ,R30
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
	RETI
;     168 	}
;     169 	TCNT1=TxInterval;
_0x10:
	LDS  R30,_TxInterval
	LDS  R31,_TxInterval+1
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;     170 	TIFR |= 0x04;		// Ÿ�̸� ���ͷ�Ʈ �÷��� �ʱ�ȭ
	IN   R30,0x36
	ORI  R30,4
	OUT  0x36,R30
;     171 	TIMSK |= 0x04;		// Timer1 Overflow Interrupt Ȱ��ȭ(140��)
	IN   R30,0x37
	ORI  R30,4
	OUT  0x37,R30
;     172 	MakeFrame();		// �� ������ �غ�
	CALL _MakeFrame
;     173 	SendFrame();		// �� ������ �۽�
	CALL _SendFrame
;     174 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	OUT  RAMPZ,R30
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
	RETI
;     175 
;     176 
;     177 //------------------------------------------------------------------------------
;     178 // �ϵ���� �ʱ�ȭ
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
;     201 	// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
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
;     210 	DDRE=0x0a;
	LDI  R30,LOW(10)
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
;     224 	// Ÿ�̸� 0---------------------------------------------------------------
;     225 	// : ���� �ð� ���������� ���(ms ����)
;     226 	// Timer/Counter 0 initialization
;     227 	// Clock source: System Clock
;     228 	// Clock value: 230.400 kHz
;     229 	// Clock ���� �ֱ� = 1/230400 = 4.34us
;     230 	// Overflow �ð� = 255*1/230400 = 1.107ms
;     231 	// 1ms �ֱ� overflow�� ���� ī��Ʈ ���۰� =  255-230 = 25
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
;     239 	// Ÿ�̸� 1---------------------------------------------------------------
;     240 	// : ��� �÷��̽� ������ �۽� ���� ���������� ���
;     241 	// Timer/Counter 1 initialization
;     242 	// Clock source: System Clock
;     243 	// Clock value: 14.400 kHz
;     244 	// Clock ���� �ֱ� = 1/14400 = 69.4us
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
;     269 	// Ÿ�̸� 2---------------------------------------------------------------
;     270 	// Timer/Counter 2 initialization
;     271 	// Clock source: System Clock
;     272 	// Clock value: 14.400 kHz
;     273 	// Clock ���� �ֱ� = 1/14400 = 69.4us
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
;     280 	// Ÿ�̸� 3---------------------------------------------------------------
;     281 	// : ���ӵ� ���� ��ȣ �м������� ���
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
;     331 	UCSR1B=0x18;		// �������ͷ�Ʈ ������
	LDI  R30,LOW(24)
	STS  154,R30
;     332 	UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;     333 	UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
;     334 	UBRR1L=BR115200;	// UART1 �� BAUD RATE�� 115200�� ����
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
;     341 // �÷��� �ʱ�ȭ
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
;     352 	F_PLAYING = 0;          // ������ �ƴ�
	CLT
	BLD  R2,0
;     353 
;     354 	gTx0Cnt = 0;			// UART0 �۽� ��� ����Ʈ ��
	CLR  R11
;     355 	gTx0BufIdx = 0;			// TX0 ���� �ε��� �ʱ�ȭ
	CLR  R13
;     356 	PSD_OFF;                // PSD �Ÿ����� ���� OFF
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
;     368 	// PF2 ��ư�� ���������� wCK �������� ���� ����
;     369 	if(PINA.0==1 && PINA.1==0){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	SBIS 0x19,0
	RJMP _0x12
	SBIC 0x19,1
	RJMP _0x12
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
;     372 		    TIMSK &= 0xFE;     // Timer0 Overflow Interrupt �̻��
	IN   R30,0x37
	ANDI R30,0xFE
	OUT  0x37,R30
;     373 			EIMSK &= 0xBF;		// EXT6(������ ����) ���ͷ�Ʈ �̻��
	IN   R30,0x39
	ANDI R30,0xBF
	OUT  0x39,R30
;     374 			UCSR0B |= 0x80;   	// UART0 Rx���ͷ�Ʈ ���
	SBI  0xA,7
;     375 			UCSR0B &= 0xBF;   	// UART0 Tx���ͷ�Ʈ �̻��
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
;     381 // ���� �Լ�
;     382 //------------------------------------------------------------------------------
;     383 void main(void) {
_main:
;     384 	WORD    i, lMSEC;
;     385 
;     386 	HW_init();			// �ϵ���� �ʱ�ȭ
;	i -> R16,R17
;	lMSEC -> R18,R19
	CALL _HW_init
;     387 	SW_init();			// ���� �ʱ�ȭ
	CALL _SW_init
;     388 	#asm("sei");
	sei
;     389 	TIMSK |= 0x01;		// Timer0 Overflow Interrupt Ȱ��ȭ
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
;     390 
;     391 	SpecialMode();
	CALL _SpecialMode
;     392     
;     393     SendSetCmd(1, ID_SET, 10, 10);  // ID 1�� wCk�� ID�� 10���� ����
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	ST   -Y,R30
	CALL _SendSetCmd
;     394     
;     395 	while(1){
_0x15:
;     396 		/*
;     397 		lMSEC = gMSEC;
;     398 		ReadButton();	    // ��ư �б�
;     399 		IoUpdate();		    // IO ���� UPDATE
;     400 		while(lMSEC==gMSEC);
;     401 		*/
;     402 		PositionMove(1, 1, 200);        // ��ũ1, ID1, ��ǥ��ġ 200 
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(200)
	ST   -Y,R30
	CALL _PositionMove
;     403 		IOwrite( 1, 0);                 // ID 1, 0�� LED ON
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _IOwrite
;     404 		PWR_LED2_ON;    delay_ms(500);                          
	CBI  0x15,7
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     405 		PWR_LED2_OFF;    delay_ms(500);                             		
	SBI  0x15,7
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     406 
;     407 		PositionMove(1, 1, 50);        // ��ũ1, ID1, ��ǥ��ġ 200 
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	CALL _PositionMove
;     408 		IOwrite( 1, 3);                 // ID 1, 0��, 1�� LED ON
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _IOwrite
;     409 		PWR_LED1_ON;    delay_ms(500);
	LDS  R30,101
	ANDI R30,0xFB
	STS  101,R30
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     410 		PWR_LED1_OFF;    delay_ms(500);
	LDS  R30,101
	ORI  R30,4
	STS  101,R30
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     411 
;     412     }
	RJMP _0x15
_0x17:
;     413 }
_0x18:
	RJMP _0x18
;     414 //==============================================================================
;     415 //						Communication & Command �Լ���
;     416 //==============================================================================
;     417 
;     418 #include <mega128.h>
;     419 #include <string.h>
;     420 #include "Main.h"
;     421 #include "Macro.h"
;     422 #include "Comm.h"
;     423 #include "p_ex1.h"
;     424 
;     425 //------------------------------------------------------------------------------
;     426 // �ø��� ��Ʈ�� �� ���ڸ� �����ϱ� ���� �Լ�
;     427 //------------------------------------------------------------------------------
;     428 void sciTx0Data(BYTE td)
;     429 {
_sciTx0Data:
;     430 	while(!(UCSR0A&(1<<UDRE))); 	// ������ ������ �Ϸ�ɶ����� ���
;	td -> Y+0
_0x19:
	SBIC 0xB,5
	RJMP _0x1B
	RJMP _0x19
_0x1B:
;     431 	UDR0=td;
	LD   R30,Y
	OUT  0xC,R30
;     432 }
	ADIW R28,1
	RET
;     433 
;     434 void sciTx1Data(BYTE td)
;     435 {
;     436 	while(!(UCSR1A&(1<<UDRE))); 	// ������ ������ �Ϸ�ɶ����� ���
;	td -> Y+0
;     437 	UDR1=td;
;     438 }
;     439 
;     440 
;     441 //------------------------------------------------------------------------------
;     442 // �ø��� ��Ʈ�� �� ���ڸ� ���������� ����ϱ� ���� �Լ�
;     443 //------------------------------------------------------------------------------
;     444 BYTE sciRx0Ready(void)
;     445 {
;     446 	WORD	startT;
;     447 	startT = gMSEC;
;	startT -> R16,R17
;     448 	while(!(UCSR0A&(1<<RXC)) ){ 	// �� ���ڰ� ���ŵɶ����� ���
;     449         if(gMSEC<startT){
;     450 			// Ÿ�� �ƿ��� ���� Ż��
;     451             if((1000 - startT + gMSEC)>RX_T_OUT) break;
;     452         }
;     453 		else if((gMSEC-startT)>RX_T_OUT) break;
;     454 	}
;     455 	return UDR0;
;     456 }
;     457 
;     458 BYTE sciRx1Ready(void)
;     459 {
;     460 	WORD	startT;
;     461 	startT = gMSEC;
;	startT -> R16,R17
;     462 	while(!(UCSR1A&(1<<RXC)) ){ 	// �� ���ڰ� ���ŵɶ����� ���
;     463         if(gMSEC<startT){
;     464 			// Ÿ�� �ƿ��� ���� Ż��
;     465             if((1000 - startT + gMSEC)>RX_T_OUT) break;
;     466         }
;     467 		else if((gMSEC-startT)>RX_T_OUT) break;
;     468 	}
;     469 	return UDR1;
;     470 }
;     471 
;     472 //------------------------------------------------------------------------------
;     473 // 8bit ���� Position Move�� �����ϱ� ���� �Լ�
;     474 // Input	: torq, ID, position
;     475 // Output	: None
;     476 //------------------------------------------------------------------------------
;     477 void PositionMove(BYTE torq, BYTE ID, BYTE position)
;     478 {
_PositionMove:
;     479 	BYTE CheckSum; 
;     480 	ID= (BYTE)(torq << 5) | ID; 
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
;     481 	CheckSum = (ID ^ position) & 0x7f;
	LDD  R30,Y+1
	LDD  R26,Y+2
	EOR  R26,R30
	LDI  R30,LOW(127)
	AND  R30,R26
	MOV  R16,R30
;     482 	
;     483 	sciTx0Data(0xff);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _sciTx0Data
;     484 	sciTx0Data(ID);
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _sciTx0Data
;     485 	sciTx0Data(position);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _sciTx0Data
;     486 	sciTx0Data(CheckSum);
	ST   -Y,R16
	CALL _sciTx0Data
;     487 
;     488 }
	LDD  R16,Y+0
	ADIW R28,4
	RET
;     489 
;     490 //------------------------------------------------------------------------------
;     491 // Ȯ�� ���� I/O Write�� �����ϱ� ���� �Լ�
;     492 // Input	: ID, IOchannel
;     493 // Output	: None
;     494 //------------------------------------------------------------------------------
;     495 void IOwrite( BYTE ID, BYTE IOchannel)
;     496 {
_IOwrite:
;     497 	BYTE CheckSum; 
;     498 	ID=(BYTE)(7<<5)|ID;
	ST   -Y,R16
;	ID -> Y+2
;	IOchannel -> Y+1
;	CheckSum -> R16
	LDD  R30,Y+2
	ORI  R30,LOW(0xE0)
	STD  Y+2,R30
;     499 	IOchannel &= 0x03; 
	LDD  R30,Y+1
	ANDI R30,LOW(0x3)
	STD  Y+1,R30
;     500 	CheckSum = (ID^100^IOchannel^IOchannel)&0x7f;
	LDD  R26,Y+2
	LDI  R30,LOW(100)
	EOR  R30,R26
	LDD  R26,Y+1
	EOR  R30,R26
	EOR  R26,R30
	LDI  R30,LOW(127)
	AND  R30,R26
	MOV  R16,R30
;     501 
;     502 	gTx0Buf[gTx0Cnt]=HEADER;	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	LDI  R30,LOW(255)
	ST   X,R30
	INC  R11
;     503 	gTx0Buf[gTx0Cnt]=ID;    	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	LDD  R26,Y+2
	STD  Z+0,R26
	INC  R11
;     504 	gTx0Buf[gTx0Cnt]=100;    	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	LDI  R30,LOW(100)
	ST   X,R30
	INC  R11
;     505 	gTx0Buf[gTx0Cnt]=IOchannel;	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	LDD  R26,Y+1
	STD  Z+0,R26
	INC  R11
;     506 	gTx0Buf[gTx0Cnt]=IOchannel; gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	STD  Z+0,R26
	INC  R11
;     507 	gTx0Buf[gTx0Cnt]=CheckSum;	gTx0Cnt++;			// �۽��� ����Ʈ�� ����    
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	ST   X,R16
	INC  R11
;     508 	
;     509 	gTx0BufIdx++;
	INC  R13
;     510 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����
	MOV  R30,R13
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	LD   R30,Z
	ST   -Y,R30
	CALL _sciTx0Data
;     511 
;     512 }
	LDD  R16,Y+0
	ADIW R28,3
	RET
;     513 
;     514 //------------------------------------------------------------------------------
;     515 // wCK�� �Ķ���͸� ������ �� ���
;     516 // Input	: Data1, Data2, Data3, Data4
;     517 // Output	: None
;     518 //------------------------------------------------------------------------------
;     519 void SendSetCmd(BYTE ID, BYTE Data1, BYTE Data2, BYTE Data3)
;     520 {
_SendSetCmd:
;     521 	BYTE CheckSum; 
;     522 	ID=(BYTE)(7<<5)|ID; 
	ST   -Y,R16
;	ID -> Y+4
;	Data1 -> Y+3
;	Data2 -> Y+2
;	Data3 -> Y+1
;	CheckSum -> R16
	LDD  R30,Y+4
	ORI  R30,LOW(0xE0)
	STD  Y+4,R30
;     523 	CheckSum = (ID^Data1^Data2^Data3)&0x7f;
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
;     524 
;     525 	gTx0Buf[gTx0Cnt]=HEADER;
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	LDI  R30,LOW(255)
	ST   X,R30
;     526 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     527 
;     528 	gTx0Buf[gTx0Cnt]=ID;
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	LDD  R26,Y+4
	STD  Z+0,R26
;     529 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     530 
;     531 	gTx0Buf[gTx0Cnt]=Data1;
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	LDD  R26,Y+3
	STD  Z+0,R26
;     532 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     533 
;     534 	gTx0Buf[gTx0Cnt]=Data2;
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	LDD  R26,Y+2
	STD  Z+0,R26
;     535 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     536 
;     537 	gTx0Buf[gTx0Cnt]=Data3;
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	LDD  R26,Y+1
	STD  Z+0,R26
;     538 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     539 
;     540 	gTx0Buf[gTx0Cnt]=CheckSum;
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	ST   X,R16
;     541 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     542 }
	LDD  R16,Y+0
	ADIW R28,5
	RET
;     543 
;     544 
;     545 //------------------------------------------------------------------------------
;     546 // ����ȭ ��ġ ����(Synchronized Position Send Command)�� ������ �Լ�
;     547 //------------------------------------------------------------------------------
;     548 void SyncPosSend(void) 
;     549 {
_SyncPosSend:
;     550 	int lwtmp;
;     551 	BYTE CheckSum; 
;     552 	BYTE i, tmp, Data;
;     553 
;     554 	Data = (Scene.wCK[0].Torq<<5) | 31;
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
;     555 
;     556 	gTx0Buf[gTx0Cnt]=HEADER;
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	LDI  R30,LOW(255)
	ST   X,R30
;     557 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     558 
;     559 	gTx0Buf[gTx0Cnt]=Data;
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	ST   X,R21
;     560 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     561 
;     562 	gTx0Buf[gTx0Cnt]=16;
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	LDI  R30,LOW(16)
	ST   X,R30
;     563 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     564 
;     565 	CheckSum = 0;
	LDI  R18,LOW(0)
;     566 	for(i=0;i<MAX_wCK;i++){	// �� wCK ������ �غ�
	LDI  R19,LOW(0)
_0x2E:
	CPI  R19,31
	BRLO PC+3
	JMP _0x2F
;     567 		if(Scene.wCK[i].Exist){	// �����ϴ� ID�� �غ�
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
;     568 			lwtmp = (int)Scene.wCK[i].SPos + (int)((float)gFrameIdx*gUnitD[i]);
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
;     569 			if(lwtmp>254)		lwtmp = 254;
	__CPWRN 16,17,255
	BRGE PC+3
	JMP _0x31
	__GETWRN 16,17,254
;     570 			else if(lwtmp<1)	lwtmp = 1;
	RJMP _0x32
_0x31:
	__CPWRN 16,17,1
	BRLT PC+3
	JMP _0x33
	__GETWRN 16,17,1
;     571 			tmp = (BYTE)lwtmp;
_0x33:
_0x32:
	MOV  R20,R16
;     572 			gTx0Buf[gTx0Cnt] = tmp;
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	ST   X,R20
;     573 			gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     574 			CheckSum = CheckSum^tmp;
	EOR  R18,R20
;     575 		}
;     576 	}
_0x30:
_0x2D:
	SUBI R19,-1
	RJMP _0x2E
_0x2F:
;     577 	CheckSum = CheckSum & 0x7f;
	ANDI R18,LOW(127)
;     578 
;     579 	gTx0Buf[gTx0Cnt]=CheckSum;
	MOV  R26,R11
	LDI  R27,0
	SUBI R26,LOW(-_gTx0Buf)
	SBCI R27,HIGH(-_gTx0Buf)
	ST   X,R18
;     580 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	INC  R11
;     581 } 
	CALL __LOADLOCR6
	ADIW R28,6
	RET
;     582 
;     583 
;     584 //------------------------------------------------------------------------------
;     585 // ��ġ �б� ����(Position Send Command)�� ������ �Լ�
;     586 // Input	: ID, SpeedLevel, Position
;     587 // Output	: Current
;     588 // UART0 RX ���ͷ�Ʈ, Timer0 ���ͷ�Ʈ�� Ȱ��ȭ �Ǿ� �־�� ��
;     589 //------------------------------------------------------------------------------
;     590 WORD PosRead(BYTE ID) 
;     591 {
;     592 	BYTE	Data1, Data2;
;     593 	BYTE	CheckSum, Load, Position; 
;     594 	WORD	startT;
;     595 
;     596 	Data1 = (5<<5) | ID;
;	ID -> Y+7
;	Data1 -> R16
;	Data2 -> R17
;	CheckSum -> R18
;	Load -> R19
;	Position -> R20
;	startT -> Y+5
;     597 	Data2 = 0;
;     598 	gRx0Cnt = 0;			// ���� ����Ʈ �� �ʱ�ȭ
;     599 	CheckSum = (Data1^Data2)&0x7f;
;     600 	sciTx0Data(HEADER);
;     601 	sciTx0Data(Data1);
;     602 	sciTx0Data(Data2);
;     603 	sciTx0Data(CheckSum);
;     604 	startT = gMSEC;
;     605 	while(gRx0Cnt<2){
;     606         if(gMSEC<startT){ 	// �и��� ī��Ʈ�� ���µ� ���
;     607             if((1000 - startT + gMSEC)>RX_T_OUT)
;     608             	return 444;	// Ÿ�Ӿƿ��� ���� Ż��
;     609         }
;     610 		else if((gMSEC-startT)>RX_T_OUT) return 444;
;     611 	}
;     612 	return gRx0Buf[RX0_BUF_SIZE-1];
;     613 } 
;     614 
;     615 
;     616 //------------------------------------------------------------------------------
;     617 // Flash���� ��� ���� �б�
;     618 //	MRIdx : ��� ��� �ε���
;     619 //------------------------------------------------------------------------------
;     620 void GetMotionFromFlash(void)
;     621 {
;     622 	WORD i;
;     623 
;     624 	for(i=0;i<MAX_wCK;i++){				// wCK �Ķ���� ����ü �ʱ�ȭ
;	i -> R16,R17
;     625 		Motion.wCK[i].Exist		= 0;
;     626 		Motion.wCK[i].RPgain	= 0;
;     627 		Motion.wCK[i].RDgain	= 0;
;     628 		Motion.wCK[i].RIgain	= 0;
;     629 		Motion.wCK[i].PortEn	= 0;
;     630 		Motion.wCK[i].InitPos	= 0;
;     631 	}
;     632 	for(i=0;i<Motion.NumOfwCK;i++){		// �� wCK �Ķ���� �ҷ�����
;     633 		Motion.wCK[wCK_IDs[i]].Exist		= 1;
;     634 		Motion.wCK[wCK_IDs[i]].RPgain	= *(gpPg_Table+i);
;     635 		Motion.wCK[wCK_IDs[i]].RDgain	= *(gpDg_Table+i);
;     636 		Motion.wCK[wCK_IDs[i]].RIgain	= *(gpIg_Table+i);
;     637 		Motion.wCK[wCK_IDs[i]].PortEn	= 1;
;     638 		Motion.wCK[wCK_IDs[i]].InitPos	= MotionZeroPos[i];
;     639 	}
;     640 }
;     641 
;     642 
;     643 //------------------------------------------------------------------------------
;     644 // Runtime P,D,I �̵� �۽�
;     645 // 		: ����������� Runtime P,D,I�̵��� �ҷ��ͼ� wCK���� ������
;     646 //------------------------------------------------------------------------------
;     647 void SendTGain(void)
;     648 {
;     649 	WORD i;
;     650 
;     651 	UCSR0B &= 0x7F;   		// UART0 Rx���ͷ�Ʈ �̻��
;	i -> R16,R17
;     652 	UCSR0B |= 0x40;   		// UART0 Tx���ͷ�Ʈ ���
;     653 
;     654 	while(gTx0Cnt);			// ���� ��Ŷ �۽��� ���� ������ ���
;     655 	for(i=0;i<MAX_wCK;i++){					// Runtime P,D�̵� ���� ��Ŷ �غ�
;     656 		if(Motion.wCK[i].Exist)				// �����ϴ� ID�� �غ�
;     657 			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
;     658 	}
;     659 	gTx0BufIdx++;
;     660 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����
;     661 
;     662 
;     663 	while(gTx0Cnt);			// ���� ��Ŷ �۽��� ���� ������ ���
;     664 	for(i=0;i<MAX_wCK;i++){					// Runtime I�̵� ���� ��Ŷ �غ�
;     665 		if(Motion.wCK[i].Exist)				// �����ϴ� ID�� �غ�
;     666 			SendSetCmd(i, 24, Motion.wCK[i].RIgain, Motion.wCK[i].RIgain);
;     667 	}
;     668 	gTx0BufIdx++;
;     669 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����
;     670 }
;     671 
;     672 
;     673 //------------------------------------------------------------------------------
;     674 // Ȯ�� ��Ʈ�� �۽�
;     675 // 		: �� �������� Ȯ�� ��Ʈ���� �ҷ��ͼ� wCK���� ������
;     676 //------------------------------------------------------------------------------
;     677 void SendExPortD(void)
;     678 {
;     679 	WORD i;
;     680 
;     681 	UCSR0B &= 0x7F;   		// UART0 Rx���ͷ�Ʈ �̻��
;	i -> R16,R17
;     682 	UCSR0B |= 0x40;   		// UART0 Tx���ͷ�Ʈ ���
;     683 
;     684 	while(gTx0Cnt);			// ���� ��Ŷ �۽��� ���� ������ ���
;     685 	for(i=0;i<MAX_wCK;i++){					// Runtime P,D�̵� ���� ��Ŷ �غ�
;     686 		if(Scene.wCK[i].Exist)				// �����ϴ� ID�� �غ�
;     687 			SendSetCmd(i, 100, Scene.wCK[i].ExPortD, Scene.wCK[i].ExPortD);
;     688 	}
;     689 	gTx0BufIdx++;
;     690 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����
;     691 }
;     692 
;     693 
;     694 //------------------------------------------------------------------------------
;     695 // Flash���� �� ���� �б�
;     696 //	ScIdx : �� �ε���
;     697 //------------------------------------------------------------------------------
;     698 void GetSceneFromFlash(void)
;     699 {
;     700 	WORD i;
;     701 	
;     702 	Scene.NumOfFrame = gpFN_Table[gSIdx];	// �����Ӽ�
;	i -> R16,R17
;     703 	Scene.RTime = gpRT_Table[gSIdx];		// �� ���� �ð�[msec]
;     704 	for(i=0;i<Motion.NumOfwCK;i++){			// �� wCK ������ �ʱ�ȭ
;     705 		Scene.wCK[i].Exist		= 0;
;     706 		Scene.wCK[i].SPos		= 0;
;     707 		Scene.wCK[i].DPos		= 0;
;     708 		Scene.wCK[i].Torq		= 0;
;     709 		Scene.wCK[i].ExPortD	= 0;
;     710 	}
;     711 	for(i=0;i<Motion.NumOfwCK;i++){			// �� wCK ������ ����
;     712 		Scene.wCK[wCK_IDs[i]].Exist		= 1;
;     713 		Scene.wCK[wCK_IDs[i]].SPos		= gpPos_Table[Motion.NumOfwCK*gSIdx+i];
;     714 		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[Motion.NumOfwCK*(gSIdx+1)+i];
;     715 		Scene.wCK[wCK_IDs[i]].Torq		= gpT_Table[Motion.NumOfwCK*gSIdx+i];
;     716 		Scene.wCK[wCK_IDs[i]].ExPortD	= gpE_Table[Motion.NumOfwCK*gSIdx+i];
;     717 	}
;     718 	UCSR0B &= 0x7F;   		// UART0 Rx���ͷ�Ʈ �̻��
;     719 	UCSR0B |= 0x40;   		// UART0 Tx���ͷ�Ʈ ���
;     720 
;     721 	delay_us(1300);
;     722 }
;     723 
;     724 
;     725 //------------------------------------------------------------------------------
;     726 // ������ �۽� ���� ���
;     727 // 		: �� ���� �ð��� �����Ӽ��� ������ interval�� ���Ѵ�
;     728 //------------------------------------------------------------------------------
;     729 void CalcFrameInterval(void)
;     730 {
;     731 	float tmp;
;     732 	if((Scene.RTime / Scene.NumOfFrame)<20){
;	tmp -> Y+0
;     733 		return;
;     734 	}
;     735 	tmp = (float)Scene.RTime * 14.4;
;     736 	tmp = tmp  / (float)Scene.NumOfFrame;
;     737 	TxInterval = 65535 - (WORD)tmp - 43;
;     738 
;     739 	RUN_LED1_ON;
;     740 	F_PLAYING=1;		// ��� ������ ǥ��
;     741 	TCCR1B=0x05;
;     742 
;     743 	if(TxInterval<=65509)	
;     744 		TCNT1=TxInterval+26;
;     745 	else
;     746 		TCNT1=65535;
;     747 
;     748 	TIFR |= 0x04;		// Ÿ�̸� ���ͷ�Ʈ �÷��� �ʱ�ȭ
;     749 	TIMSK |= 0x04;		// Timer1 Overflow Interrupt Ȱ��ȭ(140��)
;     750 }
;     751 
;     752 
;     753 //------------------------------------------------------------------------------
;     754 // �����Ӵ� ���� �̵��� ���
;     755 //------------------------------------------------------------------------------
;     756 void CalcUnitMove(void)
;     757 {
;     758 	WORD i;
;     759 
;     760 	for(i=0;i<MAX_wCK;i++){
;	i -> R16,R17
;     761 		if(Scene.wCK[i].Exist){	// �����ϴ� ID�� �غ�
;     762 			if(Scene.wCK[i].SPos!=Scene.wCK[i].DPos){
;     763 				// �����Ӵ� ���� ���� ������ ���
;     764 				gUnitD[i] = (float)((int)Scene.wCK[i].DPos-(int)Scene.wCK[i].SPos);
;     765 				gUnitD[i] = (float)(gUnitD[i]/Scene.NumOfFrame);
;     766 				if(gUnitD[i]>253)	gUnitD[i]=254;
;     767 				else if(gUnitD[i]<-253)	gUnitD[i]=-254;
;     768 			}
;     769 			else
;     770 				gUnitD[i] = 0;
;     771 		}
;     772 	}
;     773 	gFrameIdx=0;				// ������ �ε��� �ʱ�ȭ
;     774 }
;     775 
;     776 
;     777 //------------------------------------------------------------------------------
;     778 // �� ������ �۽� �غ�
;     779 //------------------------------------------------------------------------------
;     780 void MakeFrame(void)
;     781 {
_MakeFrame:
;     782 	while(gTx0Cnt);			// ���� ������ �۽��� ���� ������ ���
_0x68:
	TST  R11
	BRNE PC+3
	JMP _0x6A
	RJMP _0x68
_0x6A:
;     783 	gFrameIdx++;			// ������ �ε��� ����
	LDS  R30,_gFrameIdx
	LDS  R31,_gFrameIdx+1
	ADIW R30,1
	STS  _gFrameIdx,R30
	STS  _gFrameIdx+1,R31
;     784 	SyncPosSend();			// ����ȭ ��ġ �������� �۽�
	CALL _SyncPosSend
;     785 }
	RET
;     786 
;     787 
;     788 //------------------------------------------------------------------------------
;     789 // �� ������ �۽�
;     790 //------------------------------------------------------------------------------
;     791 void SendFrame(void)
;     792 {
_SendFrame:
;     793 	if(gTx0Cnt==0)	return;	// ���� �����Ͱ� ������ ���� ����
	TST  R11
	BREQ PC+3
	JMP _0x6B
	RET
;     794 	gTx0BufIdx++;
_0x6B:
	INC  R13
;     795 	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����
	MOV  R30,R13
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_gTx0Buf)
	SBCI R31,HIGH(-_gTx0Buf)
	LD   R30,Z
	ST   -Y,R30
	CALL _sciTx0Data
;     796 }
	RET
;     797 
;     798 
;     799 //------------------------------------------------------------------------------
;     800 // 
;     801 //------------------------------------------------------------------------------
;     802 void M_PlayFlash(void)
;     803 {
;     804 	float tmp;
;     805 	WORD i;
;     806 
;     807 	GetMotionFromFlash();		// �� wCK �Ķ���� �ҷ�����
;	tmp -> Y+2
;	i -> R16,R17
;     808 	SendTGain();				// Runtime�̵� �۽�
;     809 	for(i=0;i<Motion.NumOfScene;i++){
;     810 		gSIdx = i;
;     811 		GetSceneFromFlash();	// �� ���� �ҷ��´�
;     812 		SendExPortD();			// Ȯ�� ��Ʈ�� �۽�
;     813 		CalcFrameInterval();	// ������ �۽� ���� ���, Ÿ�̸�1 ����
;     814 		CalcUnitMove();			// �����Ӵ� ���� �̵��� ���
;     815 		MakeFrame();			// �� ������ �غ�
;     816 		SendFrame();			// �� ������ �۽�
;     817 		while(F_PLAYING);
;     818 	}
;     819 }
;     820 
;     821 
;     822 void SampleMotion1(void)	// ���� ��� 1
;     823 {
;     824 	gpT_Table			= M_EX1_Torque;
;     825 	gpE_Table			= M_EX1_Port;
;     826 	gpPg_Table 			= M_EX1_RuntimePGain;
;     827 	gpDg_Table 			= M_EX1_RuntimeDGain;
;     828 	gpIg_Table 			= M_EX1_RuntimeIGain;
;     829 	gpFN_Table			= M_EX1_Frames;
;     830 	gpRT_Table			= M_EX1_TrTime;
;     831 	gpPos_Table			= M_EX1_Position;
;     832 	Motion.NumOfScene 	= M_EX1_NUM_OF_SCENES;
;     833 	Motion.NumOfwCK 	= M_EX1_NUM_OF_WCKS;
;     834 	M_PlayFlash();
;     835 }
;     836 //==============================================================================
;     837 //						Digital Input Output ���� �Լ���
;     838 //==============================================================================
;     839 
;     840 #include <mega128.h>
;     841 #include "Main.h"
;     842 #include "Macro.h"
;     843 #include "DIO.h"
;     844 
;     845 
;     846 //------------------------------------------------------------------------------
;     847 // ��ư �б�
;     848 //------------------------------------------------------------------------------
;     849 void ReadButton(void)
;     850 {
;     851 	int		i;
;     852 	BYTE	lbtmp;
;     853 
;     854 	lbtmp = PINA & 0x03;
;	i -> R16,R17
;	lbtmp -> R18
;     855 	if((lbtmp!=0x03)){
;     856 		if(++gBtnCnt>100){   // ������ 0.1�� �̻� �����Ǹ� �Է� ����
;     857 			if(lbtmp==0x02){	// PF1 ��ư ���������� ���� ��� ����
;     858 				SampleMotion1();
;     859 			}
;     860 		}
;     861 	}
;     862 	else{
;     863 	    gBtnCnt=0;
;     864     }
;     865 } 
;     866 
;     867 
;     868 //------------------------------------------------------------------------------
;     869 // Io ������Ʈ ó��
;     870 //------------------------------------------------------------------------------
;     871 void IoUpdate(void)
;     872 {
;     873 	// ��� ǥ�� LED ó��
;     874 	if(F_DIRECT_C_EN){		// ���� ���� ����̸�
;     875 		PF1_LED1_ON;
;     876 		PF1_LED2_OFF;
;     877 		PF2_LED_ON;
;     878 		return;
;     879 	}
;     880 }

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
