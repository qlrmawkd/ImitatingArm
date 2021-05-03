//==============================================================================
//	 RoboBuilder MainController Sample Program	1.0
//										2008.04.14	Robobuilder co., ltd.
// �� �� �ҽ��ڵ�� Tab Size = 4�� �������� �����Ǿ����ϴ�
//==============================================================================
#include <mega128.h>

// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>

#include "Macro.h"
#include "Main.h"
#include "Comm.h"
#include "Dio.h"
#include "math.h"

// �÷���----------------------------------------------------------------------
bit 	F_PLAYING;				// ��� ������ ǥ��
bit 	F_DIRECT_C_EN;			// wCK �������� ��������(1:����, 0:�Ұ�)

// ��ư �Է� ó����------------------------------------------------------------
WORD    gBtnCnt;				// ��ư ���� ó���� ī����

// �ð� ������-----------------------------------------------------------------
WORD    gMSEC;
BYTE    gSEC;
BYTE    gMIN;
BYTE    gHOUR;

// UART ��ſ�-----------------------------------------------------------------
char	gTx0Buf[TX0_BUF_SIZE];		// UART0 �۽� ����
BYTE	gTx0Cnt;					// UART0 �۽� ��� ����Ʈ ��
BYTE	gRx0Cnt;					// UART0 ���� ����Ʈ ��
BYTE	gTx0BufIdx;					// UART0 �۽� ���� �ε���
char	gRx0Buf[RX0_BUF_SIZE];		// UART0 ���� ����
BYTE	gOldRx1Byte;				// UART1 �ֱ� ���� ����Ʈ
char	gRx1Buf[RX1_BUF_SIZE];		// UART1 ���� ����
BYTE	gRx1Index;					// UART1 ���� ���ۿ� �ε���
WORD	gRx1Step;					// UART1 ���� ��Ŷ �ܰ� ����
WORD	gRx1_DStep;					// �������� ��忡�� UART1 ���� ��Ŷ �ܰ� ����
WORD	gFieldIdx;					// �ʵ��� ����Ʈ �ε���
WORD	gFileByteIndex;				// ������ ����Ʈ �ε���
BYTE	gFileCheckSum;				// ���ϳ��� CheckSum
BYTE	gRxData;					// ���ŵ����� ����

// ��� �����-----------------------------------------------------------------
int		gFrameIdx=0;	    // ������̺��� ������ �ε���
WORD	TxInterval=0;		// ������ �۽� ����
float	gUnitD[MAX_wCK];	// ���� ���� ����
BYTE flash	*gpT_Table;		// ��� ��ũ��� ���̺� ������
BYTE flash	*gpE_Table;		// ��� Ȯ����Ʈ�� ���̺� ������
BYTE flash	*gpPg_Table;	// ��� Runtime P�̵� ���̺� ������
BYTE flash	*gpDg_Table;	// ��� Runtime D�̵� ���̺� ������
BYTE flash	*gpIg_Table;	// ��� Runtime I�̵� ���̺� ������
WORD flash	*gpFN_Table;	// �� ������ �� ���̺� ������
WORD flash	*gpRT_Table;	// �� ����ð� ���̺� ������
BYTE flash	*gpPos_Table;	// ��� ��ġ�� ���̺� ������

// �׼� ������ ���� ü��
//      - ũ�� : wCK < Frame < Scene < Motion < Action
//      - �������� wCK�� �� Frame�� �̷��
//        �������� Frame �� �� Scene�� �̷��
//        �������� Scene �� �� Motion�� �̷��
//        �������� Motion �� �� Action�� �̷��

struct TwCK_in_Motion{  // �� �� ��ǿ��� ����ϴ� wCK ����
	BYTE	Exist;			// wCK ����
	BYTE	RPgain;			// Runtime P�̵�
	BYTE	RDgain;			// Runtime D�̵�
	BYTE	RIgain;			// Runtime I�̵�
	BYTE	PortEn;			// Ȯ����Ʈ �������(0:������, 1:�����)
	BYTE	InitPos;		// ��������� ���� �� ���� �κ��� ���� ��ġ����
};

struct TwCK_in_Scene{	// �� �� ������ ����ϴ� wCK ����
	BYTE	Exist;			// wCK ����
	BYTE	SPos;			// ù �������� wCK ��ġ
	BYTE	DPos;			// �� �������� wCK ��ġ
	BYTE	Torq;			// ��ũ
	BYTE	ExPortD;		// Ȯ����Ʈ ��� ������(1~3)
};

struct TMotion{			// �� �� ��ǿ��� ����ϴ� ������
	BYTE	PF;				// ��ǿ� �´� �÷���
	BYTE	RIdx;			// ����� ��� �ε���
	DWORD	AIdx;			// ����� ���� �ε���
	WORD	NumOfScene;		// �� ��
	WORD	NumOfwCK;		// wCK ��
	struct	TwCK_in_Motion  wCK[MAX_wCK];	// wCK �Ķ����
	WORD	FileSize;		// ���� ũ��
}Motion;

struct TScene{			// �� �� ������ ����ϴ� ������
	WORD	Idx;			// �� �ε���(0~65535)
	WORD	NumOfFrame;		// ������ ��
	WORD	RTime;			// �� ���� �ð�[msec]
	struct	TwCK_in_Scene   wCK[MAX_wCK];	// wCK ������
}Scene;

WORD	gSIdx;			// �� �ε���(0~65535)

//------------------------------------------------------------------------------
// UART0 �۽� ���ͷ�Ʈ(��Ŷ �۽ſ�)
//------------------------------------------------------------------------------
interrupt [USART0_TXC] void usart0_tx_isr(void) {
	if(gTx0BufIdx<gTx0Cnt){			// ���� �����Ͱ� ����������
    	while(!(UCSR0A&(1<<UDRE))); 	// ���� ����Ʈ ������ �Ϸ�ɶ����� ���
		UDR0=gTx0Buf[gTx0BufIdx];		// 1����Ʈ �۽�
    	gTx0BufIdx++;      				// ���� �ε��� ����
	}
	else if(gTx0BufIdx==gTx0Cnt){	// �۽� �Ϸ�
		gTx0BufIdx = 0;					// ���� �ε��� �ʱ�ȭ
		gTx0Cnt = 0;					// �۽� ��� ����Ʈ�� �ʱ�ȭ
	}
}


//------------------------------------------------------------------------------
// UART0 ���� ���ͷ�Ʈ(wCK, �����⿡�� ���� ��ȣ)
//------------------------------------------------------------------------------
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
	int		i;
    char	data;
	data=UDR0;
	gRx0Cnt++;
    // ���ŵ����͸� FIFO�� ����
   	for(i=1; i<RX0_BUF_SIZE; i++) gRx0Buf[i-1] = gRx0Buf[i];
   	gRx0Buf[RX0_BUF_SIZE-1] = data;
}


//------------------------------------------------------------------------------
// Ÿ�̸�0 �����÷� ���ͷ�Ʈ (�ð� ������ 0.998ms ����)
//------------------------------------------------------------------------------
interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
	TCNT0 = 25;
	// 1ms ���� ����
    if(++gMSEC>999){
		// 1s ���� ����
        gMSEC=0;
        if(++gSEC>59){
			// 1m ���� ����
            gSEC=0;
            if(++gMIN>59){
				// 1h ���� ����
                gMIN=0;
                if(++gHOUR>23)
                    gHOUR=0;
            }
        }
    }
}


//------------------------------------------------------------------------------
// Ÿ�̸�1 �����÷� ���ͷ�Ʈ (������ �۽�)
//------------------------------------------------------------------------------
interrupt [TIM1_OVF] void timer1_ovf_isr(void) {
	if( gFrameIdx == Scene.NumOfFrame ) {   // ������ �������̾�����
   	    gFrameIdx = 0;
    	RUN_LED1_OFF;
		F_PLAYING=0;		// ��� ������ ǥ������
		TIMSK &= 0xfb;  	// Timer1 Overflow Interrupt ����
		TCCR1B=0x00;
		return;
	}
	TCNT1=TxInterval;
	TIFR |= 0x04;		// Ÿ�̸� ���ͷ�Ʈ �÷��� �ʱ�ȭ
	TIMSK |= 0x04;		// Timer1 Overflow Interrupt Ȱ��ȭ(140��)
	MakeFrame();		// �� ������ �غ�
	SendFrame();		// �� ������ �۽�
}


//------------------------------------------------------------------------------
// �ϵ���� �ʱ�ȭ
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

	// Ÿ�̸� 0---------------------------------------------------------------
	// : ���� �ð� ���������� ���(ms ����)
	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: 230.400 kHz
	// Clock ���� �ֱ� = 1/230400 = 4.34us
	// Overflow �ð� = 255*1/230400 = 1.107ms
	// 1ms �ֱ� overflow�� ���� ī��Ʈ ���۰� =  255-230 = 25
	// Mode: Normal top=FFh
	// OC0 output: Disconnected
	ASSR=0x00;
	TCCR0=0x04;
	TCNT0=0x00;
	OCR0=0x00;

	// Ÿ�̸� 1---------------------------------------------------------------
	// : ��� �÷��̽� ������ �۽� ���� ���������� ���
	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: 14.400 kHz
	// Clock ���� �ֱ� = 1/14400 = 69.4us
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

	// Ÿ�̸� 2---------------------------------------------------------------
	// Timer/Counter 2 initialization
	// Clock source: System Clock
	// Clock value: 14.400 kHz
	// Clock ���� �ֱ� = 1/14400 = 69.4us
	// Mode: Normal top=FFh
	// OC2 output: Disconnected
	TCCR2=0x05;
	TCNT2=0x00;
	OCR2=0x00;

	// Ÿ�̸� 3---------------------------------------------------------------
	// : ���ӵ� ���� ��ȣ �м������� ���
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
	UCSR1B=0x18;		// �������ͷ�Ʈ ������
	UCSR1C=0x06;
	UBRR1H=0x00;
	UBRR1L=BR115200;	// UART1 �� BAUD RATE�� 115200�� ����

	TWCR = 0;
}


//------------------------------------------------------------------------------
// �÷��� �ʱ�ȭ
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
	F_PLAYING = 0;          // ������ �ƴ�

	gTx0Cnt = 0;			// UART0 �۽� ��� ����Ʈ ��
	gTx0BufIdx = 0;			// TX0 ���� �ε��� �ʱ�ȭ
	PSD_OFF;                // PSD �Ÿ����� ���� OFF
	gMSEC=0;
	gSEC=0;
	gMIN=0;
	gHOUR=0;
}


void SpecialMode(void)
{
	int i;

	// PF2 ��ư�� ���������� wCK �������� ���� ����
	if(PINA.0==1 && PINA.1==0){
		delay_ms(10);
		if(PINA.0==1){
		    TIMSK &= 0xFE;     // Timer0 Overflow Interrupt �̻��
			EIMSK &= 0xBF;		// EXT6(������ ����) ���ͷ�Ʈ �̻��
			UCSR0B |= 0x80;   	// UART0 Rx���ͷ�Ʈ ���
			UCSR0B &= 0xBF;   	// UART0 Tx���ͷ�Ʈ �̻��
		}
	}
}

//------------------------------------------------------------------------------
// ���� �Լ�
//------------------------------------------------------------------------------
void main(void) {
	WORD    i, lMSEC;

	HW_init();			// �ϵ���� �ʱ�ȭ
	SW_init();			// ���� �ʱ�ȭ
	#asm("sei");
	TIMSK |= 0x01;		// Timer0 Overflow Interrupt Ȱ��ȭ

	SpecialMode();
    
    SendSetCmd(1, ID_SET, 10, 10);  // ID 1�� wCk�� ID�� 10���� ����
    
	while(1){
		/*
		lMSEC = gMSEC;
		ReadButton();	    // ��ư �б�
		IoUpdate();		    // IO ���� UPDATE
		while(lMSEC==gMSEC);
		*/
		PositionMove(1, 1, 200);        // ��ũ1, ID1, ��ǥ��ġ 200 
		IOwrite( 1, 0);                 // ID 1, 0�� LED ON
		PWR_LED2_ON;    delay_ms(500);                          
		PWR_LED2_OFF;    delay_ms(500);                             		

		PositionMove(1, 1, 50);        // ��ũ1, ID1, ��ǥ��ġ 200 
		IOwrite( 1, 3);                 // ID 1, 0��, 1�� LED ON
		PWR_LED1_ON;    delay_ms(500);
		PWR_LED1_OFF;    delay_ms(500);

    }
}
//==============================================================================
//						Communication & Command �Լ���
//==============================================================================

#include <mega128.h>
#include <string.h>
#include "Main.h"
#include "Macro.h"
#include "Comm.h"
#include "p_ex1.h"

//------------------------------------------------------------------------------
// �ø��� ��Ʈ�� �� ���ڸ� �����ϱ� ���� �Լ�
//------------------------------------------------------------------------------
void sciTx0Data(BYTE td)
{
	while(!(UCSR0A&(1<<UDRE))); 	// ������ ������ �Ϸ�ɶ����� ���
	UDR0=td;
}

void sciTx1Data(BYTE td)
{
	while(!(UCSR1A&(1<<UDRE))); 	// ������ ������ �Ϸ�ɶ����� ���
	UDR1=td;
}


//------------------------------------------------------------------------------
// �ø��� ��Ʈ�� �� ���ڸ� ���������� ����ϱ� ���� �Լ�
//------------------------------------------------------------------------------
BYTE sciRx0Ready(void)
{
	WORD	startT;
	startT = gMSEC;
	while(!(UCSR0A&(1<<RXC)) ){ 	// �� ���ڰ� ���ŵɶ����� ���
        if(gMSEC<startT){
			// Ÿ�� �ƿ��� ���� Ż��
            if((1000 - startT + gMSEC)>RX_T_OUT) break;
        }
		else if((gMSEC-startT)>RX_T_OUT) break;
	}
	return UDR0;
}

BYTE sciRx1Ready(void)
{
	WORD	startT;
	startT = gMSEC;
	while(!(UCSR1A&(1<<RXC)) ){ 	// �� ���ڰ� ���ŵɶ����� ���
        if(gMSEC<startT){
			// Ÿ�� �ƿ��� ���� Ż��
            if((1000 - startT + gMSEC)>RX_T_OUT) break;
        }
		else if((gMSEC-startT)>RX_T_OUT) break;
	}
	return UDR1;
}

//------------------------------------------------------------------------------
// 8bit ��� Position Move�� �����ϱ� ���� �Լ�
// Input	: torq, ID, position
// Output	: None
//------------------------------------------------------------------------------
void PositionMove(BYTE torq, BYTE ID, BYTE position)
{
	BYTE CheckSum; 
	ID= (BYTE)(torq << 5) | ID; 
	CheckSum = (ID ^ position) & 0x7f;
	
	sciTx0Data(0xff);
	sciTx0Data(ID);
	sciTx0Data(position);
	sciTx0Data(CheckSum);

}

//------------------------------------------------------------------------------
// Ȯ�� ��� I/O Write�� �����ϱ� ���� �Լ�
// Input	: ID, IOchannel
// Output	: None
//------------------------------------------------------------------------------
void IOwrite( BYTE ID, BYTE IOchannel)
{
	BYTE CheckSum; 
	ID=(BYTE)(7<<5)|ID;
	IOchannel &= 0x03; 
	CheckSum = (ID^100^IOchannel^IOchannel)&0x7f;

	gTx0Buf[gTx0Cnt]=HEADER;	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=ID;    	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=100;    	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=IOchannel;	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=IOchannel; gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=CheckSum;	gTx0Cnt++;			// �۽��� ����Ʈ�� ����    
	
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����

}

//------------------------------------------------------------------------------
// wCK�� �Ķ���͸� ������ �� ���
// Input	: Data1, Data2, Data3, Data4
// Output	: None
//------------------------------------------------------------------------------
void SendSetCmd(BYTE ID, BYTE Data1, BYTE Data2, BYTE Data3)
{
	BYTE CheckSum; 
	ID=(BYTE)(7<<5)|ID; 
	CheckSum = (ID^Data1^Data2^Data3)&0x7f;

	gTx0Buf[gTx0Cnt]=HEADER;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����

	gTx0Buf[gTx0Cnt]=ID;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����

	gTx0Buf[gTx0Cnt]=Data1;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����

	gTx0Buf[gTx0Cnt]=Data2;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����

	gTx0Buf[gTx0Cnt]=Data3;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����

	gTx0Buf[gTx0Cnt]=CheckSum;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
}


//------------------------------------------------------------------------------
// ����ȭ ��ġ ���(Synchronized Position Send Command)�� ������ �Լ�
//------------------------------------------------------------------------------
void SyncPosSend(void) 
{
	int lwtmp;
	BYTE CheckSum; 
	BYTE i, tmp, Data;

	Data = (Scene.wCK[0].Torq<<5) | 31;

	gTx0Buf[gTx0Cnt]=HEADER;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����

	gTx0Buf[gTx0Cnt]=Data;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����

	gTx0Buf[gTx0Cnt]=16;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����

	CheckSum = 0;
	for(i=0;i<MAX_wCK;i++){	// �� wCK ������ �غ�
		if(Scene.wCK[i].Exist){	// �����ϴ� ID�� �غ�
			lwtmp = (int)Scene.wCK[i].SPos + (int)((float)gFrameIdx*gUnitD[i]);
			if(lwtmp>254)		lwtmp = 254;
			else if(lwtmp<1)	lwtmp = 1;
			tmp = (BYTE)lwtmp;
			gTx0Buf[gTx0Cnt] = tmp;
			gTx0Cnt++;			// �۽��� ����Ʈ�� ����
			CheckSum = CheckSum^tmp;
		}
	}
	CheckSum = CheckSum & 0x7f;

	gTx0Buf[gTx0Cnt]=CheckSum;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
} 


//------------------------------------------------------------------------------
// ��ġ �б� ���(Position Send Command)�� ������ �Լ�
// Input	: ID, SpeedLevel, Position
// Output	: Current
// UART0 RX ���ͷ�Ʈ, Timer0 ���ͷ�Ʈ�� Ȱ��ȭ �Ǿ� �־�� ��
//------------------------------------------------------------------------------
WORD PosRead(BYTE ID) 
{
	BYTE	Data1, Data2;
	BYTE	CheckSum, Load, Position; 
	WORD	startT;

	Data1 = (5<<5) | ID;
	Data2 = 0;
	gRx0Cnt = 0;			// ���� ����Ʈ �� �ʱ�ȭ
	CheckSum = (Data1^Data2)&0x7f;
	sciTx0Data(HEADER);
	sciTx0Data(Data1);
	sciTx0Data(Data2);
	sciTx0Data(CheckSum);
	startT = gMSEC;
	while(gRx0Cnt<2){
        if(gMSEC<startT){ 	// �и��� ī��Ʈ�� ���µ� ���
            if((1000 - startT + gMSEC)>RX_T_OUT)
            	return 444;	// Ÿ�Ӿƿ��� ���� Ż��
        }
		else if((gMSEC-startT)>RX_T_OUT) return 444;
	}
	return gRx0Buf[RX0_BUF_SIZE-1];
} 


//------------------------------------------------------------------------------
// Flash���� ��� ���� �б�
//	MRIdx : ��� ��� �ε���
//------------------------------------------------------------------------------
void GetMotionFromFlash(void)
{
	WORD i;

	for(i=0;i<MAX_wCK;i++){				// wCK �Ķ���� ����ü �ʱ�ȭ
		Motion.wCK[i].Exist		= 0;
		Motion.wCK[i].RPgain	= 0;
		Motion.wCK[i].RDgain	= 0;
		Motion.wCK[i].RIgain	= 0;
		Motion.wCK[i].PortEn	= 0;
		Motion.wCK[i].InitPos	= 0;
	}
	for(i=0;i<Motion.NumOfwCK;i++){		// �� wCK �Ķ���� �ҷ�����
		Motion.wCK[wCK_IDs[i]].Exist		= 1;
		Motion.wCK[wCK_IDs[i]].RPgain	= *(gpPg_Table+i);
		Motion.wCK[wCK_IDs[i]].RDgain	= *(gpDg_Table+i);
		Motion.wCK[wCK_IDs[i]].RIgain	= *(gpIg_Table+i);
		Motion.wCK[wCK_IDs[i]].PortEn	= 1;
		Motion.wCK[wCK_IDs[i]].InitPos	= MotionZeroPos[i];
	}
}


//------------------------------------------------------------------------------
// Runtime P,D,I �̵� �۽�
// 		: ����������� Runtime P,D,I�̵��� �ҷ��ͼ� wCK���� ������
//------------------------------------------------------------------------------
void SendTGain(void)
{
	WORD i;

	UCSR0B &= 0x7F;   		// UART0 Rx���ͷ�Ʈ �̻��
	UCSR0B |= 0x40;   		// UART0 Tx���ͷ�Ʈ ���

	while(gTx0Cnt);			// ���� ��Ŷ �۽��� ���� ������ ���
	for(i=0;i<MAX_wCK;i++){					// Runtime P,D�̵� ���� ��Ŷ �غ�
		if(Motion.wCK[i].Exist)				// �����ϴ� ID�� �غ�
			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����


	while(gTx0Cnt);			// ���� ��Ŷ �۽��� ���� ������ ���
	for(i=0;i<MAX_wCK;i++){					// Runtime I�̵� ���� ��Ŷ �غ�
		if(Motion.wCK[i].Exist)				// �����ϴ� ID�� �غ�
			SendSetCmd(i, 24, Motion.wCK[i].RIgain, Motion.wCK[i].RIgain);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����
}


//------------------------------------------------------------------------------
// Ȯ�� ��Ʈ�� �۽�
// 		: �� �������� Ȯ�� ��Ʈ���� �ҷ��ͼ� wCK���� ������
//------------------------------------------------------------------------------
void SendExPortD(void)
{
	WORD i;

	UCSR0B &= 0x7F;   		// UART0 Rx���ͷ�Ʈ �̻��
	UCSR0B |= 0x40;   		// UART0 Tx���ͷ�Ʈ ���

	while(gTx0Cnt);			// ���� ��Ŷ �۽��� ���� ������ ���
	for(i=0;i<MAX_wCK;i++){					// Runtime P,D�̵� ���� ��Ŷ �غ�
		if(Scene.wCK[i].Exist)				// �����ϴ� ID�� �غ�
			SendSetCmd(i, 100, Scene.wCK[i].ExPortD, Scene.wCK[i].ExPortD);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����
}


//------------------------------------------------------------------------------
// Flash���� �� ���� �б�
//	ScIdx : �� �ε���
//------------------------------------------------------------------------------
void GetSceneFromFlash(void)
{
	WORD i;
	
	Scene.NumOfFrame = gpFN_Table[gSIdx];	// �����Ӽ�
	Scene.RTime = gpRT_Table[gSIdx];		// �� ���� �ð�[msec]
	for(i=0;i<Motion.NumOfwCK;i++){			// �� wCK ������ �ʱ�ȭ
		Scene.wCK[i].Exist		= 0;
		Scene.wCK[i].SPos		= 0;
		Scene.wCK[i].DPos		= 0;
		Scene.wCK[i].Torq		= 0;
		Scene.wCK[i].ExPortD	= 0;
	}
	for(i=0;i<Motion.NumOfwCK;i++){			// �� wCK ������ ����
		Scene.wCK[wCK_IDs[i]].Exist		= 1;
		Scene.wCK[wCK_IDs[i]].SPos		= gpPos_Table[Motion.NumOfwCK*gSIdx+i];
		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[Motion.NumOfwCK*(gSIdx+1)+i];
		Scene.wCK[wCK_IDs[i]].Torq		= gpT_Table[Motion.NumOfwCK*gSIdx+i];
		Scene.wCK[wCK_IDs[i]].ExPortD	= gpE_Table[Motion.NumOfwCK*gSIdx+i];
	}
	UCSR0B &= 0x7F;   		// UART0 Rx���ͷ�Ʈ �̻��
	UCSR0B |= 0x40;   		// UART0 Tx���ͷ�Ʈ ���

	delay_us(1300);
}


//------------------------------------------------------------------------------
// ������ �۽� ���� ���
// 		: �� ���� �ð��� �����Ӽ��� ������ interval�� ���Ѵ�
//------------------------------------------------------------------------------
void CalcFrameInterval(void)
{
	float tmp;
	if((Scene.RTime / Scene.NumOfFrame)<20){
		return;
	}
	tmp = (float)Scene.RTime * 14.4;
	tmp = tmp  / (float)Scene.NumOfFrame;
	TxInterval = 65535 - (WORD)tmp - 43;

	RUN_LED1_ON;
	F_PLAYING=1;		// ��� ������ ǥ��
	TCCR1B=0x05;

	if(TxInterval<=65509)	
		TCNT1=TxInterval+26;
	else
		TCNT1=65535;

	TIFR |= 0x04;		// Ÿ�̸� ���ͷ�Ʈ �÷��� �ʱ�ȭ
	TIMSK |= 0x04;		// Timer1 Overflow Interrupt Ȱ��ȭ(140��)
}


//------------------------------------------------------------------------------
// �����Ӵ� ���� �̵��� ���
//------------------------------------------------------------------------------
void CalcUnitMove(void)
{
	WORD i;

	for(i=0;i<MAX_wCK;i++){
		if(Scene.wCK[i].Exist){	// �����ϴ� ID�� �غ�
			if(Scene.wCK[i].SPos!=Scene.wCK[i].DPos){
				// �����Ӵ� ���� ���� ������ ���
				gUnitD[i] = (float)((int)Scene.wCK[i].DPos-(int)Scene.wCK[i].SPos);
				gUnitD[i] = (float)(gUnitD[i]/Scene.NumOfFrame);
				if(gUnitD[i]>253)	gUnitD[i]=254;
				else if(gUnitD[i]<-253)	gUnitD[i]=-254;
			}
			else
				gUnitD[i] = 0;
		}
	}
	gFrameIdx=0;				// ������ �ε��� �ʱ�ȭ
}


//------------------------------------------------------------------------------
// �� ������ �۽� �غ�
//------------------------------------------------------------------------------
void MakeFrame(void)
{
	while(gTx0Cnt);			// ���� ������ �۽��� ���� ������ ���
	gFrameIdx++;			// ������ �ε��� ����
	SyncPosSend();			// ����ȭ ��ġ ������� �۽�
}


//------------------------------------------------------------------------------
// �� ������ �۽�
//------------------------------------------------------------------------------
void SendFrame(void)
{
	if(gTx0Cnt==0)	return;	// ���� �����Ͱ� ������ ���� ����
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����
}


//------------------------------------------------------------------------------
// 
//------------------------------------------------------------------------------
void M_PlayFlash(void)
{
	float tmp;
	WORD i;

	GetMotionFromFlash();		// �� wCK �Ķ���� �ҷ�����
	SendTGain();				// Runtime�̵� �۽�
	for(i=0;i<Motion.NumOfScene;i++){
		gSIdx = i;
		GetSceneFromFlash();	// �� ���� �ҷ��´�
		SendExPortD();			// Ȯ�� ��Ʈ�� �۽�
		CalcFrameInterval();	// ������ �۽� ���� ���, Ÿ�̸�1 ����
		CalcUnitMove();			// �����Ӵ� ���� �̵��� ���
		MakeFrame();			// �� ������ �غ�
		SendFrame();			// �� ������ �۽�
		while(F_PLAYING);
	}
}


void SampleMotion1(void)	// ���� ��� 1
{
	gpT_Table			= M_EX1_Torque;
	gpE_Table			= M_EX1_Port;
	gpPg_Table 			= M_EX1_RuntimePGain;
	gpDg_Table 			= M_EX1_RuntimeDGain;
	gpIg_Table 			= M_EX1_RuntimeIGain;
	gpFN_Table			= M_EX1_Frames;
	gpRT_Table			= M_EX1_TrTime;
	gpPos_Table			= M_EX1_Position;
	Motion.NumOfScene 	= M_EX1_NUM_OF_SCENES;
	Motion.NumOfwCK 	= M_EX1_NUM_OF_WCKS;
	M_PlayFlash();
}
//==============================================================================
//						Digital Input Output ���� �Լ���
//==============================================================================

#include <mega128.h>
#include "Main.h"
#include "Macro.h"
#include "DIO.h"


//------------------------------------------------------------------------------
// ��ư �б�
//------------------------------------------------------------------------------
void ReadButton(void)
{
	int		i;
	BYTE	lbtmp;

	lbtmp = PINA & 0x03;
	if((lbtmp!=0x03)){
		if(++gBtnCnt>100){   // ������ 0.1�� �̻� �����Ǹ� �Է� ����
			if(lbtmp==0x02){	// PF1 ��ư ���������� ���� ��� ����
				SampleMotion1();
			}
		}
	}
	else{
	    gBtnCnt=0;
    }
} 


//------------------------------------------------------------------------------
// Io ������Ʈ ó��
//------------------------------------------------------------------------------
void IoUpdate(void)
{
	// ��� ǥ�� LED ó��
	if(F_DIRECT_C_EN){		// ���� ���� ����̸�
		PF1_LED1_ON;
		PF1_LED2_OFF;
		PF2_LED_ON;
		return;
	}
}
