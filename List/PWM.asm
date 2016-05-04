
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega48V
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega48V
	#pragma AVRPART MEMORY PROG_FLASH 4096
	#pragma AVRPART MEMORY EEPROM 256
	#pragma AVRPART MEMORY INT_SRAM SIZE 767
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x02FF
	.EQU __DSTACK_SIZE=0x0080
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _EARLY_PWM_STATE=R3
	.DEF _mode=R6

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x3D:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x03
	.DW  _0x3D*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

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

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x180

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12.04.2014
;Author  : MakZ
;Company :
;Comments:
;
;
;Chip type               : ATmega48V
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
;*****************************************************/
;
;#include <mega48.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <sleep.h>
;#define MIN 2
;#define MAX 130
;#define MAX_MODE 3
;#define DELAY 20
;#define PULSE_BOTTOM_DELAY 0
;#define PULSE_TOP_DELAY 0
;#define STROBE_DELAY 100
;#define INT_DELAY 300
;#define CONTROL_PIN PIND.2
;#define OUTPUT_PIN PIND.5
;#define PWM_REGISTER OCR0B
;
;int EARLY_PWM_STATE = 0;
;
;enum mode
;{
;    pulse,
;    full,
;    cop_light,
;    off,
;    strobe
;}mode;
;
;void pulse_wait()
; 0000 0032 {

	.CSEG
; 0000 0033     if(PWM_REGISTER < 10)
; 0000 0034         delay_ms(DELAY);
; 0000 0035 
; 0000 0036     if(PWM_REGISTER < 8)
; 0000 0037         delay_ms(DELAY);
; 0000 0038 
; 0000 0039     if(PWM_REGISTER < 6)
; 0000 003A         delay_ms(DELAY);
; 0000 003B 
; 0000 003C     if(PWM_REGISTER < 5)
; 0000 003D         delay_ms(DELAY);
; 0000 003E 
; 0000 003F     if(PWM_REGISTER < 4)
; 0000 0040         delay_ms(DELAY);
; 0000 0041 
; 0000 0042     if(PWM_REGISTER < 3)
; 0000 0043         delay_ms(DELAY);
; 0000 0044 
; 0000 0045     if(PWM_REGISTER < 2)
; 0000 0046         delay_ms(DELAY);
; 0000 0047 }
;
;void pulse_mode()
; 0000 004A {
_pulse_mode:
; 0000 004B     PWM_REGISTER = MIN;
	LDI  R30,LOW(2)
	OUT  0x28,R30
; 0000 004C     OUTPUT_PIN = 1;
	SBI  0x9,5
; 0000 004D 
; 0000 004E     while(PWM_REGISTER != MAX && mode == pulse)
_0xC:
	IN   R30,0x28
	CPI  R30,LOW(0x82)
	BREQ _0xF
	LDI  R30,LOW(0)
	CP   R30,R6
	BREQ _0x10
_0xF:
	RJMP _0xE
_0x10:
; 0000 004F     {
; 0000 0050         PWM_REGISTER++;
	IN   R30,0x28
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x0
; 0000 0051         delay_ms(DELAY);
; 0000 0052         //pulse_wait();
; 0000 0053 
; 0000 0054         if(PWM_REGISTER==MAX)
	CPI  R30,LOW(0x82)
	BRNE _0x11
; 0000 0055             delay_ms(PULSE_TOP_DELAY); //top
	RCALL SUBOPT_0x1
; 0000 0056     }
_0x11:
	RJMP _0xC
_0xE:
; 0000 0057 
; 0000 0058     while(PWM_REGISTER != MIN && mode == pulse)
_0x12:
	IN   R30,0x28
	CPI  R30,LOW(0x2)
	BREQ _0x15
	LDI  R30,LOW(0)
	CP   R30,R6
	BREQ _0x16
_0x15:
	RJMP _0x14
_0x16:
; 0000 0059     {
; 0000 005A         PWM_REGISTER--;
	IN   R30,0x28
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x0
; 0000 005B         delay_ms(DELAY);
; 0000 005C         //pulse_wait();
; 0000 005D 
; 0000 005E         if(PWM_REGISTER==MIN)
	CPI  R30,LOW(0x2)
	BRNE _0x17
; 0000 005F             delay_ms(PULSE_BOTTOM_DELAY); //bottom
	RCALL SUBOPT_0x1
; 0000 0060     }
_0x17:
	RJMP _0x12
_0x14:
; 0000 0061 }
	RET
;
;void full_mode()
; 0000 0064 {
_full_mode:
; 0000 0065     OUTPUT_PIN = 1;
	SBI  0x9,5
; 0000 0066     PWM_REGISTER = 255;
	LDI  R30,LOW(255)
	OUT  0x28,R30
; 0000 0067 }
	RET
;
;void off_mode()
; 0000 006A {
_off_mode:
; 0000 006B     OUTPUT_PIN = 0;
	CBI  0x9,5
; 0000 006C     PWM_REGISTER = 0;
	RCALL SUBOPT_0x2
; 0000 006D     delay_ms(50);
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x3
	RCALL _delay_ms
; 0000 006E     sleep_enable();
	RCALL _sleep_enable
; 0000 006F     powerdown();
	RCALL _powerdown
; 0000 0070 }
	RET
;
;void strobe_mode(int delay)
; 0000 0073 {
_strobe_mode:
; 0000 0074     EARLY_PWM_STATE = PWM_REGISTER;
	ST   -Y,R27
	ST   -Y,R26
;	delay -> Y+0
	IN   R3,40
	CLR  R4
; 0000 0075 
; 0000 0076     PWM_REGISTER = 255;
	LDI  R30,LOW(255)
	OUT  0x28,R30
; 0000 0077     delay_ms(delay);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _delay_ms
; 0000 0078     PWM_REGISTER = 0;
	RCALL SUBOPT_0x2
; 0000 0079     delay_ms(delay);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _delay_ms
; 0000 007A 
; 0000 007B     PWM_REGISTER = EARLY_PWM_STATE;
	OUT  0x28,R3
; 0000 007C }
	ADIW R28,2
	RET
;
;void cop_light_mode()
; 0000 007F {
_cop_light_mode:
; 0000 0080     int i=0;
; 0000 0081     PWM_REGISTER = 0;
	RCALL __SAVELOCR2
;	i -> R16,R17
	__GETWRN 16,17,0
	RCALL SUBOPT_0x2
; 0000 0082     for(i=0; i<7; i++)
	__GETWRN 16,17,0
_0x1D:
	__CPWRN 16,17,7
	BRGE _0x1E
; 0000 0083     {
; 0000 0084         if(mode == cop_light)
	RCALL SUBOPT_0x4
	BRNE _0x1F
; 0000 0085             strobe_mode(STROBE_DELAY*0.6);
	__GETD1N 0x3C
	MOVW R26,R30
	RCALL _strobe_mode
; 0000 0086         else
	RJMP _0x20
_0x1F:
; 0000 0087             return;
	RJMP _0x2020001
; 0000 0088     }
_0x20:
	__ADDWRN 16,17,1
	RJMP _0x1D
_0x1E:
; 0000 0089 
; 0000 008A     if(mode == cop_light)
	RCALL SUBOPT_0x4
	BRNE _0x21
; 0000 008B         delay_ms(300);
	RCALL SUBOPT_0x5
; 0000 008C     if(mode == cop_light)
_0x21:
	RCALL SUBOPT_0x4
	BRNE _0x22
; 0000 008D         delay_ms(300);
	RCALL SUBOPT_0x5
; 0000 008E     if(mode == cop_light)
_0x22:
	RCALL SUBOPT_0x4
	BRNE _0x23
; 0000 008F         delay_ms(300);
	RCALL SUBOPT_0x5
; 0000 0090 }
_0x23:
_0x2020001:
	RCALL __LOADLOCR2P
	RET
;
;void mode_switch()
; 0000 0093 {
_mode_switch:
; 0000 0094     mode++;
	INC  R6
; 0000 0095     if(mode > MAX_MODE)
	LDI  R30,LOW(3)
	CP   R30,R6
	BRSH _0x24
; 0000 0096     {
; 0000 0097         mode = pulse;
	CLR  R6
; 0000 0098     }
; 0000 0099 }
_0x24:
	RET
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 009D {
_ext_int1_isr:
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
; 0000 009E     delay_ms(INT_DELAY);
	RCALL SUBOPT_0x5
; 0000 009F 
; 0000 00A0     if(CONTROL_PIN == 0)
	SBIC 0x9,2
	RJMP _0x25
; 0000 00A1     {
; 0000 00A2         while(CONTROL_PIN == 0)
_0x26:
	SBIC 0x9,2
	RJMP _0x28
; 0000 00A3         {
; 0000 00A4             strobe_mode(STROBE_DELAY);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x3
	RCALL _strobe_mode
; 0000 00A5         }
	RJMP _0x26
_0x28:
; 0000 00A6     }
; 0000 00A7     else
	RJMP _0x29
_0x25:
; 0000 00A8     {
; 0000 00A9         mode_switch();
	RCALL _mode_switch
; 0000 00AA     }
_0x29:
; 0000 00AB }
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
	RETI
;
;// Declare your global variables here
;
;void main(void)
; 0000 00B0 {
_main:
; 0000 00B1     // Declare your local variables here
; 0000 00B2 
; 0000 00B3     // Crystal Oscillator division factor: 0
; 0000 00B4     #pragma optsize-
; 0000 00B5     CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00B6     CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00B7     #ifdef _OPTIMIZE_SIZE_
; 0000 00B8     #pragma optsize+
; 0000 00B9     #endif
; 0000 00BA 
; 0000 00BB     // Input/Output Ports initialization
; 0000 00BC     // Port B initialization
; 0000 00BD     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00BE     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00BF     PORTB=0x00;
	OUT  0x5,R30
; 0000 00C0     DDRB=0x00;
	OUT  0x4,R30
; 0000 00C1 
; 0000 00C2     // Port C initialization
; 0000 00C3     // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C4     // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00C5     PORTC=0x00;
	OUT  0x8,R30
; 0000 00C6     DDRC=0x00;
	OUT  0x7,R30
; 0000 00C7 
; 0000 00C8     // Port D initialization
; 0000 00C9     // Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00CA     // State7=T State6=T State5=0 State4=T State3=T State2=P State1=T State0=T
; 0000 00CB     PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0xB,R30
; 0000 00CC     DDRD=0x20;
	LDI  R30,LOW(32)
	OUT  0xA,R30
; 0000 00CD 
; 0000 00CE     // Timer/Counter 0 initialization
; 0000 00CF     // Clock source: System Clock
; 0000 00D0     // Clock value: 39,063 kHz
; 0000 00D1     // Mode: Phase correct PWM top=0xFF
; 0000 00D2     // OC0A output: Disconnected
; 0000 00D3     // OC0B output: Non-Inverted PWM
; 0000 00D4     TCCR0A=0x21;
	LDI  R30,LOW(33)
	OUT  0x24,R30
; 0000 00D5     TCCR0B=0x04;
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 00D6     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00D7     OCR0A=0x00;
	OUT  0x27,R30
; 0000 00D8     OCR0B=0x00;
	RCALL SUBOPT_0x2
; 0000 00D9 
; 0000 00DA     // Timer/Counter 1 initialization
; 0000 00DB     // Clock source: System Clock
; 0000 00DC     // Clock value: Timer1 Stopped
; 0000 00DD     // Mode: Normal top=0xFFFF
; 0000 00DE     // OC1A output: Discon.
; 0000 00DF     // OC1B output: Discon.
; 0000 00E0     // Noise Canceler: Off
; 0000 00E1     // Input Capture on Falling Edge
; 0000 00E2     // Timer1 Overflow Interrupt: Off
; 0000 00E3     // Input Capture Interrupt: Off
; 0000 00E4     // Compare A Match Interrupt: Off
; 0000 00E5     // Compare B Match Interrupt: Off
; 0000 00E6     TCCR1A=0x00;
	LDI  R30,LOW(0)
	STS  128,R30
; 0000 00E7     TCCR1B=0x00;
	STS  129,R30
; 0000 00E8     TCNT1H=0x00;
	STS  133,R30
; 0000 00E9     TCNT1L=0x00;
	STS  132,R30
; 0000 00EA     ICR1H=0x00;
	STS  135,R30
; 0000 00EB     ICR1L=0x00;
	STS  134,R30
; 0000 00EC     OCR1AH=0x00;
	STS  137,R30
; 0000 00ED     OCR1AL=0x00;
	STS  136,R30
; 0000 00EE     OCR1BH=0x00;
	STS  139,R30
; 0000 00EF     OCR1BL=0x00;
	STS  138,R30
; 0000 00F0 
; 0000 00F1     // Timer/Counter 2 initialization
; 0000 00F2     // Clock source: System Clock
; 0000 00F3     // Clock value: Timer2 Stopped
; 0000 00F4     // Mode: Normal top=0xFF
; 0000 00F5     // OC2A output: Disconnected
; 0000 00F6     // OC2B output: Disconnected
; 0000 00F7     ASSR=0x00;
	STS  182,R30
; 0000 00F8     TCCR2A=0x00;
	STS  176,R30
; 0000 00F9     TCCR2B=0x00;
	STS  177,R30
; 0000 00FA     TCNT2=0x00;
	STS  178,R30
; 0000 00FB     OCR2A=0x00;
	STS  179,R30
; 0000 00FC     OCR2B=0x00;
	STS  180,R30
; 0000 00FD 
; 0000 00FE     // External Interrupt(s) initialization
; 0000 00FF     // INT0: Off
; 0000 0100     // INT1: On
; 0000 0101     // INT1 Mode: Low level
; 0000 0102     // Interrupt on any change on pins PCINT0-7: Off
; 0000 0103     // Interrupt on any change on pins PCINT8-14: Off
; 0000 0104     // Interrupt on any change on pins PCINT16-23: Off
; 0000 0105     EICRA=0x00;
	STS  105,R30
; 0000 0106     EIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x1D,R30
; 0000 0107     EIFR=0x02;
	OUT  0x1C,R30
; 0000 0108     PCICR=0x00;
	LDI  R30,LOW(0)
	STS  104,R30
; 0000 0109 
; 0000 010A     // Timer/Counter 0 Interrupt(s) initialization
; 0000 010B     TIMSK0=0x00;
	STS  110,R30
; 0000 010C 
; 0000 010D     // Timer/Counter 1 Interrupt(s) initialization
; 0000 010E     TIMSK1=0x00;
	STS  111,R30
; 0000 010F 
; 0000 0110     // Timer/Counter 2 Interrupt(s) initialization
; 0000 0111     TIMSK2=0x00;
	STS  112,R30
; 0000 0112 
; 0000 0113     // USART initialization
; 0000 0114     // USART disabled
; 0000 0115     UCSR0B=0x00;
	STS  193,R30
; 0000 0116 
; 0000 0117     // Analog Comparator initialization
; 0000 0118     // Analog Comparator: Off
; 0000 0119     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 011A     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 011B     ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 011C     DIDR1=0x00;
	STS  127,R30
; 0000 011D 
; 0000 011E     // ADC initialization
; 0000 011F     // ADC disabled
; 0000 0120     ADCSRA=0x00;
	STS  122,R30
; 0000 0121 
; 0000 0122     // SPI initialization
; 0000 0123     // SPI disabled
; 0000 0124     SPCR=0x00;
	OUT  0x2C,R30
; 0000 0125 
; 0000 0126     // TWI initialization
; 0000 0127     // TWI disabled
; 0000 0128     TWCR=0x00;
	STS  188,R30
; 0000 0129 
; 0000 012A     // Global enable interrupts
; 0000 012B     #asm("sei")
	sei
; 0000 012C 
; 0000 012D     while (1)
_0x2A:
; 0000 012E     {
; 0000 012F         while(mode == pulse)
_0x2D:
	TST  R6
	BRNE _0x2F
; 0000 0130         {
; 0000 0131             pulse_mode();
	RCALL _pulse_mode
; 0000 0132         }
	RJMP _0x2D
_0x2F:
; 0000 0133 
; 0000 0134         while(mode == full)
_0x30:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x32
; 0000 0135         {
; 0000 0136             full_mode();
	RCALL _full_mode
; 0000 0137         }
	RJMP _0x30
_0x32:
; 0000 0138 
; 0000 0139         while(mode == cop_light)
_0x33:
	RCALL SUBOPT_0x4
	BRNE _0x35
; 0000 013A         {
; 0000 013B             cop_light_mode();
	RCALL _cop_light_mode
; 0000 013C         }
	RJMP _0x33
_0x35:
; 0000 013D 
; 0000 013E         while(mode == strobe)
_0x36:
	LDI  R30,LOW(4)
	CP   R30,R6
	BRNE _0x38
; 0000 013F         {
; 0000 0140             strobe_mode(STROBE_DELAY);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x3
	RCALL _strobe_mode
; 0000 0141         }
	RJMP _0x36
_0x38:
; 0000 0142 
; 0000 0143         while(mode == off)
_0x39:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x3B
; 0000 0144         {
; 0000 0145             off_mode();
	RCALL _off_mode
; 0000 0146         }
	RJMP _0x39
_0x3B:
; 0000 0147     }
	RJMP _0x2A
; 0000 0148 }
_0x3C:
	RJMP _0x3C
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_sleep_enable:
   in   r30,power_ctrl_reg
   sbr  r30,__se_bit
   out  power_ctrl_reg,r30
	RET
_powerdown:
   in   r30,power_ctrl_reg
   cbr  r30,__sm_mask
   sbr  r30,__sm_powerdown
   out  power_ctrl_reg,r30
   in   r30,sreg
   sei
   sleep
   out  sreg,r30
	RET

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	OUT  0x28,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	IN   R30,0x28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(2)
	CP   R30,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RJMP _delay_ms


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
