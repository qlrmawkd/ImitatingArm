//===============================================================================================
//	 RoboBuilder MainController Sample Program	1.0
//							  2008.04.14	Robobuilder co., ltd.
//       Tap Size = 4
//===============================================================================================
#include <mega128.h>

// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>

#include "Macro.h"
#include "Main.h"
#include "Comm.h"
#include "Dio.h"
#include "math.h"

// Flag ----------------------------------------------------------------------------------------
bit 	F_PLAYING;			// Show the motion running Ã
bit 	F_DIRECT_C_EN;		        // wCK direct control mode (1:Available, 0:Not available)

// Button Input----------------------------------------------------------------------------------
WORD    gBtnCnt;			// Button press process counterÍ

// Time Measurement ------------------------------------------------------------------------------
WORD    gMSEC;
BYTE    gSEC;
BYTE    gMIN;
BYTE    gHOUR;

// UART Communication -----------------------------------------------------------------
char	gTx0Buf[TX0_BUF_SIZE];		// UART0 transmission buffer 
BYTE	gTx0Cnt;			// UART0 transmission idle byte number
BYTE	gRx0Cnt;			// UART0 receiving byte number
BYTE	gTx0BufIdx;			// UART0 transmission buffer indexº
char	gRx0Buf[RX0_BUF_SIZE];		// UART0 transmission buffer 
BYTE	gOldRx1Byte;			// UART1 ÃÖ±Ù ¼ö½Å ¹ÙÀÌÆ®
char	gRx1Buf[RX1_BUF_SIZE];		// UART1 ¼ö½Å ¹öÆÛ
BYTE	gRx1Index;			// UART1 ¼ö½Å ¹öÆÛ¿ë ÀÎµ¦½º
WORD	gRx1Step;			// UART1 ¼ö½Å ÆÐÅ¶ ´Ü°è ±¸ºÐ
WORD	gRx1_DStep;			// Á÷Á¢Á¦¾î ¸ðµå¿¡¼­ UART1 ¼ö½Å ÆÐÅ¶ ´Ü°è ±¸ºÐ
WORD	gFieldIdx;			// ÇÊµåÀÇ ¹ÙÀÌÆ® ÀÎµ¦½º
WORD	gFileByteIndex;			// ÆÄÀÏÀÇ ¹ÙÀÌÆ® ÀÎµ¦½º
BYTE	gFileCheckSum;			// ÆÄÀÏ³»¿ë CheckSum
BYTE	gRxData;			// ¼ö½Åµ¥ÀÌÅÍ ÀúÀå

// ¸ð¼Ç Á¦¾î¿ë-----------------------------------------------------------------
int		gFrameIdx=0;	    // ¸ð¼ÇÅ×ÀÌºíÀÇ ÇÁ·¹ÀÓ ÀÎµ¦½º
WORD	TxInterval=0;		// ÇÁ·¹ÀÓ ¼Û½Å °£°Ý
float	gUnitD[MAX_wCK];	// ´ÜÀ§ Áõ°¡ º¯À§
BYTE flash	*gpT_Table;	// ¸ð¼Ç ÅäÅ©¸ðµå Å×ÀÌºí Æ÷ÀÎÅÍ
BYTE flash	*gpE_Table;		// ¸ð¼Ç È®ÀåÆ÷Æ®°ª Å×ÀÌºí Æ÷ÀÎÅÍ
BYTE flash	*gpPg_Table;	// ¸ð¼Ç Runtime PÀÌµæ Å×ÀÌºí Æ÷ÀÎÅÍ
BYTE flash	*gpDg_Table;	// ¸ð¼Ç Runtime DÀÌµæ Å×ÀÌºí Æ÷ÀÎÅÍ
BYTE flash	*gpIg_Table;	// ¸ð¼Ç Runtime IÀÌµæ Å×ÀÌºí Æ÷ÀÎÅÍ
WORD flash	*gpFN_Table;	// ¾À ÇÁ·¹ÀÓ ¼ö Å×ÀÌºí Æ÷ÀÎÅÍ
WORD flash	*gpRT_Table;	// ¾À ½ÇÇà½Ã°£ Å×ÀÌºí Æ÷ÀÎÅÍ
BYTE flash	*gpPos_Table;	// ¸ð¼Ç À§Ä¡°ª Å×ÀÌºí Æ÷ÀÎÅÍ

// ¾×¼Ç ÆÄÀÏÀÇ ±¸¼º Ã¼°è
//      - Å©±â : wCK < Frame < Scene < Motion < Action
//      - ¿©·¯°³ÀÇ wCK°¡ ¸ð¿© FrameÀ» ÀÌ·ç°í
//        ¿©·¯°³ÀÇ Frame ÀÌ ¸ð¿© SceneÀ» ÀÌ·ç¸ç
//        ¿©·¯°³ÀÇ Scene ÀÌ ¸ð¿© MotionÀ» ÀÌ·ç°í
//        ¿©·¯°³ÀÇ Motion ÀÌ ¸ð¿© ActionÀ» ÀÌ·é´Ù

struct TwCK_in_Motion{  // ÇÑ °³ ¸ð¼Ç¿¡¼­ »ç¿ëÇÏ´Â wCK Á¤º¸
	BYTE	Exist;			// wCK À¯¹«
	BYTE	RPgain;			// Runtime PÀÌµæ
	BYTE	RDgain;			// Runtime DÀÌµæ
	BYTE	RIgain;			// Runtime IÀÌµæ
	BYTE	PortEn;			// È®ÀåÆ÷Æ® »ç¿ëÀ¯¹«(0:»ç¿ë¾ÈÇÔ, 1:»ç¿ëÇÔ)
	BYTE	InitPos;		// ¸ð¼ÇÆÄÀÏÀ» ¸¸µé ¶§ »ç¿ëµÈ ·Îº¿ÀÇ ¿µÁ¡ À§Ä¡Á¤º¸
};

struct TwCK_in_Scene{	// ÇÑ °³ ¾À¿¡¼­ »ç¿ëÇÏ´Â wCK Á¤º¸
	BYTE	Exist;			// wCK À¯¹«
	BYTE	SPos;			// Ã¹ ÇÁ·¹ÀÓÀÇ wCK À§Ä¡
	BYTE	DPos;			// ³¡ ÇÁ·¹ÀÓÀÇ wCK À§Ä¡
	BYTE	Torq;			// ÅäÅ©
	BYTE	ExPortD;		// È®ÀåÆ÷Æ® Ãâ·Â µ¥ÀÌÅÍ(1~3)
};

struct TMotion{			// ÇÑ °³ ¸ð¼Ç¿¡¼­ »ç¿ëÇÏ´Â Á¤º¸µé
	BYTE	PF;				// ¸ð¼Ç¿¡ ¸Â´Â ÇÃ·§Æû
	BYTE	RIdx;			// ¸ð¼ÇÀÇ »ó´ë ÀÎµ¦½º
	DWORD	AIdx;			// ¸ð¼ÇÀÇ Àý´ë ÀÎµ¦½º
	WORD	NumOfScene;		// ¾À ¼ö
	WORD	NumOfwCK;		// wCK ¼ö
	struct	TwCK_in_Motion  wCK[MAX_wCK];	// wCK ÆÄ¶ó¹ÌÅÍ
	WORD	FileSize;		// ÆÄÀÏ Å©±â
}Motion;

struct TScene{			// ÇÑ °³ ¾À¿¡¼­ »ç¿ëÇÏ´Â Á¤º¸µé
	WORD	Idx;			// ¾À ÀÎµ¦½º(0~65535)
	WORD	NumOfFrame;		// ÇÁ·¹ÀÓ ¼ö
	WORD	RTime;			// ¾À ¼öÇà ½Ã°£[msec]
	struct	TwCK_in_Scene   wCK[MAX_wCK];	// wCK µ¥ÀÌÅÍ
}Scene;

WORD	gSIdx;			// ¾À ÀÎµ¦½º(0~65535)

//------------------------------------------------------------------------------
// UART0 ¼Û½Å ÀÎÅÍ·´Æ®(ÆÐÅ¶ ¼Û½Å¿ë)
//------------------------------------------------------------------------------
interrupt [USART0_TXC] void usart0_tx_isr(void) {
	if(gTx0BufIdx<gTx0Cnt){			// º¸³¾ µ¥ÀÌÅÍ°¡ ³²¾ÆÀÖÀ¸¸é
    	while(!(UCSR0A&(1<<UDRE))); 	// ÀÌÀü ¹ÙÀÌÆ® Àü¼ÛÀÌ ¿Ï·áµÉ¶§±îÁö ´ë±â
		UDR0=gTx0Buf[gTx0BufIdx];		// 1¹ÙÀÌÆ® ¼Û½Å
    	gTx0BufIdx++;      				// ¹öÆÛ ÀÎµ¦½º Áõ°¡
	}
	else if(gTx0BufIdx==gTx0Cnt){	// ¼Û½Å ¿Ï·á
		gTx0BufIdx = 0;					// ¹öÆÛ ÀÎµ¦½º ÃÊ±âÈ­
		gTx0Cnt = 0;					// ¼Û½Å ´ë±â ¹ÙÀÌÆ®¼ö ÃÊ±âÈ­
	}
}


//------------------------------------------------------------------------------
// UART0 ¼ö½Å ÀÎÅÍ·´Æ®(wCK, »ç¿îµå¸ðµâ¿¡¼­ ¹ÞÀº ½ÅÈ£)
//------------------------------------------------------------------------------
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
	int		i;
    char	data;
	data=UDR0;
	gRx0Cnt++;
    // ¼ö½Åµ¥ÀÌÅÍ¸¦ FIFO¿¡ ÀúÀå
   	for(i=1; i<RX0_BUF_SIZE; i++) gRx0Buf[i-1] = gRx0Buf[i];
   	gRx0Buf[RX0_BUF_SIZE-1] = data;
}


//------------------------------------------------------------------------------
// Å¸ÀÌ¸Ó0 ¿À¹öÇÃ·Î ÀÎÅÍ·´Æ® (½Ã°£ ÃøÁ¤¿ë 0.998ms °£°Ý)
//------------------------------------------------------------------------------
interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
	TCNT0 = 25;
	// 1ms ¸¶´Ù ½ÇÇà
    if(++gMSEC>999){
		// 1s ¸¶´Ù ½ÇÇà
        gMSEC=0;
        if(++gSEC>59){
			// 1m ¸¶´Ù ½ÇÇà
            gSEC=0;
            if(++gMIN>59){
				// 1h ¸¶´Ù ½ÇÇà
                gMIN=0;
                if(++gHOUR>23)
                    gHOUR=0;
            }
        }
    }
}


//------------------------------------------------------------------------------
// Å¸ÀÌ¸Ó1 ¿À¹öÇÃ·Î ÀÎÅÍ·´Æ® (ÇÁ·¹ÀÓ ¼Û½Å)
//------------------------------------------------------------------------------
interrupt [TIM1_OVF] void timer1_ovf_isr(void) {
	if( gFrameIdx == Scene.NumOfFrame ) {   // ¸¶Áö¸· ÇÁ·¹ÀÓÀÌ¾úÀ¸¸é
   	    gFrameIdx = 0;
    	RUN_LED1_OFF;
		F_PLAYING=0;		// ¸ð¼Ç ½ÇÇàÁß Ç¥½ÃÇØÁ¦
		TIMSK &= 0xfb;  	// Timer1 Overflow Interrupt ÇØÁ¦
		TCCR1B=0x00;
		return;
	}
	TCNT1=TxInterval;
	TIFR |= 0x04;		// Å¸ÀÌ¸Ó ÀÎÅÍ·´Æ® ÇÃ·¡±× ÃÊ±âÈ­
	TIMSK |= 0x04;		// Timer1 Overflow Interrupt È°¼ºÈ­(140ÂÊ)
	MakeFrame();		// ÇÑ ÇÁ·¹ÀÓ ÁØºñ
	SendFrame();		// ÇÑ ÇÁ·¹ÀÓ ¼Û½Å
}


//------------------------------------------------------------------------------
// ÇÏµå¿þ¾î ÃÊ±âÈ­
//------------------------------------------------------------------------------
void HW_init(void) {
	// Input/Output Ports initialization
	// Port A initialization
	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=P State0=P 
	PORTA=0x03;
	DDRA=0xFC;

	// Port B initialization
	// Func7=In Func6=Out Func5=Out Func4=Out Func3=In Func2=Out Func1=In Func0=In 
	// State7=T State6=0 State5=0 State4=0 State3=T State2=0 State1=T State0=T 
	PORTB=0x00;
	DDRB=0x74;

	// Port C initialization
	// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
	// State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
	PORTC=0x00;
	DDRC=0x80;

	// Port D initialization
	// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
	// State7=T State6=T State5=T State4=T State3=T State2=T State1=P State0=P 
	PORTD=0x83;
	DDRD=0x80;

	// Port E initialization
	// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In 
	// State7=T State6=P State5=P State4=P State3=0 State2=T State1=T State0=T 
	PORTE=0x70;
	DDRE=0x0a;

	// Port F initialization
	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
	// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
	PORTF=0x00;
	DDRF=0x00;

	// Port G initialization
	// Func4=In Func3=In Func2=Out Func1=In Func0=In 
	// State4=T State3=T State2=0 State1=T State0=T 
	PORTG=0x00;
	DDRG=0x04;

	// Å¸ÀÌ¸Ó 0---------------------------------------------------------------
	// : ¹ü¿ë ½Ã°£ ÃøÁ¤¿ëÀ¸·Î »ç¿ë(ms ´ÜÀ§)
	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: 230.400 kHz
	// Clock Áõ°¡ ÁÖ±â = 1/230400 = 4.34us
	// Overflow ½Ã°£ = 255*1/230400 = 1.107ms
	// 1ms ÁÖ±â overflow¸¦ À§ÇÑ Ä«¿îÆ® ½ÃÀÛ°ª =  255-230 = 25
	// Mode: Normal top=FFh
	// OC0 output: Disconnected
	ASSR=0x00;
	TCCR0=0x04;
	TCNT0=0x00;
	OCR0=0x00;

	// Å¸ÀÌ¸Ó 1---------------------------------------------------------------
	// : ¸ð¼Ç ÇÃ·¹ÀÌ½Ã ÇÁ·¹ÀÓ ¼Û½Å °£°Ý Á¶Àý¿ëÀ¸·Î »ç¿ë
	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: 14.400 kHz
	// Clock Áõ°¡ ÁÖ±â = 1/14400 = 69.4us
	// Mode: Normal top=FFFFh
	// OC1A output: Discon.
	// OC1B output: Discon.
	// OC1C output: Discon.
	// Noise Canceler: Off
	// Input Capture on Falling Edge
	// Timer 1 Overflow Interrupt: On
	// Input Capture Interrupt: Off
	// Compare A Match Interrupt: Off
	// Compare B Match Interrupt: Off
	// Compare C Match Interrupt: Off
	TCCR1A=0x00;
	TCCR1B=0x05;
	TCNT1H=0x00;
	TCNT1L=0x00;
	ICR1H=0x00;
	ICR1L=0x00;
	OCR1AH=0x00;
	OCR1AL=0x00;
	OCR1BH=0x00;
	OCR1BL=0x00;
	OCR1CH=0x00;
	OCR1CL=0x00;

	// Å¸ÀÌ¸Ó 2---------------------------------------------------------------
	// Timer/Counter 2 initialization
	// Clock source: System Clock
	// Clock value: 14.400 kHz
	// Clock Áõ°¡ ÁÖ±â = 1/14400 = 69.4us
	// Mode: Normal top=FFh
	// OC2 output: Disconnected
	TCCR2=0x05;
	TCNT2=0x00;
	OCR2=0x00;

	// Å¸ÀÌ¸Ó 3---------------------------------------------------------------
	// : °¡¼Óµµ ¼¾¼­ ½ÅÈ£ ºÐ¼®¿ëÀ¸·Î »ç¿ë
	TCCR3A=0x00;
	TCCR3B=0x03;
	TCNT3H=0x00;
	TCNT3L=0x00;
	ICR3H=0x00;
	ICR3L=0x00;
	OCR3AH=0x00;
	OCR3AL=0x00;
	OCR3BH=0x00;
	OCR3BL=0x00;
	OCR3CH=0x00;
	OCR3CL=0x00;

	// External Interrupt(s) initialization
	// INT0: Off
	// INT1: Off
	// INT2: Off
	// INT3: Off
	// INT4: Off
	// INT5: Off
	// INT6: Off
	// INT7: Off
	EICRA=0x00;
	EICRB=0x00;
	EIMSK=0x00;

	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x00;
	ETIMSK=0x00;

	// USART0 initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART0 Receiver: Off
	// USART0 Transmitter: On
	// USART0 Mode: Asynchronous
	// USART0 Baud rate: 115200
	UCSR0A=0x00;
	UCSR0B=0x48;
	UCSR0C=0x06;
	UBRR0H=0x00;
	UBRR0L=0x07;

	// USART1 initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART1 Receiver: On
	// USART1 Transmitter: On
	// USART1 Mode: Asynchronous
	// USART1 Baud rate: 115200
	UCSR1A=0x00;
	UCSR1B=0x18;		// ¼ö½ÅÀÎÅÍ·´Æ® »ç¿ë¾ÈÇÔ
	UCSR1C=0x06;
	UBRR1H=0x00;
	UBRR1L=BR115200;	// UART1 ÀÇ BAUD RATE¸¦ 115200·Î ¼³Á¤

	TWCR = 0;
}


//------------------------------------------------------------------------------
// ÇÃ·¡±× ÃÊ±âÈ­
//------------------------------------------------------------------------------
void SW_init(void) {
	PF1_LED1_OFF;
	PF1_LED2_OFF;
	PF2_LED_OFF;
	PWR_LED1_OFF;
	PWR_LED2_OFF;
	RUN_LED1_OFF;
	RUN_LED2_OFF;
	ERR_LED_OFF;
	F_PLAYING = 0;          // µ¿ÀÛÁß ¾Æ´Ô

	gTx0Cnt = 0;			// UART0 ¼Û½Å ´ë±â ¹ÙÀÌÆ® ¼ö
	gTx0BufIdx = 0;			// TX0 ¹öÆÛ ÀÎµ¦½º ÃÊ±âÈ­
	PSD_OFF;                // PSD °Å¸®¼¾¼­ Àü¿ø OFF
	gMSEC=0;
	gSEC=0;
	gMIN=0;
	gHOUR=0;
}


void SpecialMode(void)
{
	int i;

	// PF2 ¹öÆ°ÀÌ ´­·¯Á³À¸¸é wCK Á÷Á¢Á¦¾î ¸ðµå·Î ÁøÀÔ
	if(PINA.0==1 && PINA.1==0){
		delay_ms(10);
		if(PINA.0==1){
		    TIMSK &= 0xFE;     // Timer0 Overflow Interrupt ¹Ì»ç¿ë
			EIMSK &= 0xBF;		// EXT6(¸®¸ðÄÁ ¼ö½Å) ÀÎÅÍ·´Æ® ¹Ì»ç¿ë
			UCSR0B |= 0x80;   	// UART0 RxÀÎÅÍ·´Æ® »ç¿ë
			UCSR0B &= 0xBF;   	// UART0 TxÀÎÅÍ·´Æ® ¹Ì»ç¿ë
		}
	}
}

//------------------------------------------------------------------------------
// ¸ÞÀÎ ÇÔ¼ö
//------------------------------------------------------------------------------
void main(void) {
	WORD    i, lMSEC;

	HW_init();			// ÇÏµå¿þ¾î ÃÊ±âÈ­
	SW_init();			// º¯¼ö ÃÊ±âÈ­
	#asm("sei");
	TIMSK |= 0x01;		// Timer0 Overflow Interrupt È°¼ºÈ­

	SpecialMode();
    
    SendSetCmd(1, ID_SET, 10, 10);  // ID 1¹ø wCkÀÇ ID¸¦ 10À¸·Î º¯°æ
    
	while(1){
		/*
		lMSEC = gMSEC;
		ReadButton();	    // ¹öÆ° ÀÐ±â
		IoUpdate();		    // IO »óÅÂ UPDATE
		while(lMSEC==gMSEC);
		*/
		PositionMove(1, 1, 200);        // ÅäÅ©1, ID1, ¸ñÇ¥À§Ä¡ 200 
		IOwrite( 1, 0);                 // ID 1, 0¹ø LED ON
		PWR_LED2_ON;    delay_ms(500);                          
		PWR_LED2_OFF;    delay_ms(500);                             		

		PositionMove(1, 1, 50);        // ÅäÅ©1, ID1, ¸ñÇ¥À§Ä¡ 200 
		IOwrite( 1, 3);                 // ID 1, 0¹ø, 1¹ø LED ON
		PWR_LED1_ON;    delay_ms(500);
		PWR_LED1_OFF;    delay_ms(500);

    }
}
