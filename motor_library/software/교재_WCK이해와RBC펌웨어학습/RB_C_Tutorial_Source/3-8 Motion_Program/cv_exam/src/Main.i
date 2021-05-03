//==============================================================================
//	 RoboBuilder MainController Sample Program	1.0
//										2008.04.14	Robobuilder co., ltd.
// ※ 본 소스코드는 Tab Size = 4를 기준으로 편집되었습니다
//==============================================================================
// CodeVisionAVR C Compiler
// (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega128
#pragma used+
sfrb PINF=0;
sfrb PINE=1;
sfrb DDRE=2;
sfrb PORTE=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRR0L=9;
sfrb UCSR0B=0xa;
sfrb UCSR0A=0xb;
sfrb UDR0=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb SFIOR=0x20;
sfrb WDTCR=0x21;
sfrb OCDR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   // 16 bit access
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb ASSR=0x30;
sfrb OCR0=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TIFR=0x36;
sfrb TIMSK=0x37;
sfrb EIFR=0x38;
sfrb EIMSK=0x39;
sfrb EICRB=0x3a;
sfrb RAMPZ=0x3b;
sfrb XDIV=0x3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// Standard Input/Output functions
// CodeVisionAVR C Compiler
// (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for standard I/O functions
// CodeVisionAVR C Compiler
// (C) 1998-2002 Pavel Haiduc, HP InfoTech S.R.L.
// Variable length argument list macros
typedef char *va_list;
#pragma used+
char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
char *gets(char *str,unsigned int len);
void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);
                                               #pragma used-
#pragma library stdio.lib
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
//==============================================================================
// DATA TYPE
//==============================================================================
//==============================================================================
// BIT SET
//==============================================================================
//==============================================================================
// BIT CLEAR
//==============================================================================
//==============================================================================
// BIT CHECK
//==============================================================================
//==============================================================================
// BIT MASK
//==============================================================================
//==============================================================================
// 하드웨어 의존적인 정의들
//==============================================================================
//#define			EXT_INT0_ENABLE		SET_BIT6(GICR)
//#define			EXT_INT0_DISABLE	CLR_BIT6(GICR)
//==============================================================================
//						UART 통신 관련
//==============================================================================
//==============================================================================
//						Send 명령어 관련
//==============================================================================
// Frequency = 14.7456MHz 
// 클럭 14.7456 MHz일때의 보레이트 설정 상수 (에러 = 0%) 
void sciTx0Data(unsigned char td);
void sciTx1Data(unsigned char td);
unsigned char sciRx0Ready(void);
unsigned char sciRx1Ready(void);
void SendOperCmd(unsigned char Data1,unsigned char Data2);
void SendSetCmd(unsigned char ID, unsigned char Data1, unsigned char Data2, unsigned char Data3);
void PosSend(unsigned char ID, unsigned char SpeedLevel, unsigned char Position);
void PassiveModeCmdSend(unsigned char ID);
void SyncPosSend(void);
unsigned int PosRead(unsigned char ID);
void GetMotionFromFlash(void);
void SendTGain(void);
void SendExPortD(void);
void GetSceneFromFlash(void);
void CalcFrameInterval(void);
void CalcUnitMove(void);
void MakeFrame(void);
void SendFrame(void);
void M_BasicPose(unsigned char PF, unsigned int NOF, unsigned int RT, unsigned char TQ);
void PositionMove(unsigned char torq, unsigned char ID, unsigned char position);
void IOwrite(unsigned char ID, unsigned char IOchannel);
void ReadButton(void);
void ReadButton(void);
void IoUpdate(void);
/*
CodeVisionAVR C Compiler
Prototypes for mathematical functions

Portions (C) 1998-2001 Pavel Haiduc, HP InfoTech S.R.L.
Portions (C) 2000-2001 Yuri G. Salov
*/
#pragma used+
unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
signed char cmax(signed char a,signed char b);
int max(int a,int b);
long lmax(long a,long b);
float fmax(float a,float b);
signed char cmin(signed char a,signed char b);
int min(int a,int b);
long lmin(long a,long b);
float fmin(float a,float b);
signed char csign(signed char x);
signed char sign(int x);
signed char lsign(long x);
signed char fsign(float x);
unsigned char isqrt(unsigned int x);
unsigned int lsqrt(unsigned long x);
float sqrt(float x);
float floor(float x);
float ceil(float x);
float fmod(float x,float y);
float modf(float x,float *ipart);
float ldexp(float x,int expon);
float frexp(float x,int *expon);
float exp(float x);
float log(float x);
float log10(float x);
float pow(float x,float y);
float sin(float x);
float cos(float x);
float tan(float x);
float sinh(float x);
float cosh(float x);
float tanh(float x);
float asin(float x);
float acos(float x);
float atan(float x);
float atan2(float y,float x);
#pragma used-
#pragma library math.lib
// 플래그----------------------------------------------------------------------
bit 	F_PLAYING;				// 모션 실행중 표시
bit 	F_DIRECT_C_EN;			// wCK 직접제어 가능유무(1:가능, 0:불가)
// 버튼 입력 처리용------------------------------------------------------------
unsigned int    gBtnCnt;				// 버튼 눌림 처리용 카운터
// 시간 측정용-----------------------------------------------------------------
unsigned int    gMSEC;
unsigned char    gSEC;
unsigned char    gMIN;
unsigned char    gHOUR;
// UART 통신용-----------------------------------------------------------------
char	gTx0Buf[186     ];		// UART0 송신 버퍼
unsigned char	gTx0Cnt;					// UART0 송신 대기 바이트 수
unsigned char	gRx0Cnt;					// UART0 수신 바이트 수
unsigned char	gTx0BufIdx;					// UART0 송신 버퍼 인덱스
char	gRx0Buf[8		];		// UART0 수신 버퍼
unsigned char	gOldRx1Byte;				// UART1 최근 수신 바이트
char	gRx1Buf[20      ];		// UART1 수신 버퍼
unsigned char	gRx1Index;					// UART1 수신 버퍼용 인덱스
unsigned int	gRx1Step;					// UART1 수신 패킷 단계 구분
unsigned int	gRx1_DStep;					// 직접제어 모드에서 UART1 수신 패킷 단계 구분
unsigned int	gFieldIdx;					// 필드의 바이트 인덱스
unsigned int	gFileByteIndex;				// 파일의 바이트 인덱스
unsigned char	gFileCheckSum;				// 파일내용 CheckSum
unsigned char	gRxData;					// 수신데이터 저장
// 모션 제어용-----------------------------------------------------------------
int		gFrameIdx=0;	    // 모션테이블의 프레임 인덱스
unsigned int	TxInterval=0;		// 프레임 송신 간격
float	gUnitD[31	];	// 단위 증가 변위
unsigned char flash	*gpT_Table;		// 모션 토크모드 테이블 포인터
unsigned char flash	*gpE_Table;		// 모션 확장포트값 테이블 포인터
unsigned char flash	*gpPg_Table;	// 모션 Runtime P이득 테이블 포인터
unsigned char flash	*gpDg_Table;	// 모션 Runtime D이득 테이블 포인터
unsigned char flash	*gpIg_Table;	// 모션 Runtime I이득 테이블 포인터
unsigned int flash	*gpFN_Table;	// 씬 프레임 수 테이블 포인터
unsigned int flash	*gpRT_Table;	// 씬 실행시간 테이블 포인터
unsigned char flash	*gpPos_Table;	// 모션 위치값 테이블 포인터
// 액션 파일의 구성 체계
//      - 크기 : wCK < Frame < Scene < Motion < Action
//      - 여러개의 wCK가 모여 Frame을 이루고
//        여러개의 Frame 이 모여 Scene을 이루며
//        여러개의 Scene 이 모여 Motion을 이루고
//        여러개의 Motion 이 모여 Action을 이룬다
struct TwCK_in_Motion{  // 한 개 모션에서 사용하는 wCK 정보
	unsigned char	Exist;			// wCK 유무
	unsigned char	RPgain;			// Runtime P이득
	unsigned char	RDgain;			// Runtime D이득
	unsigned char	RIgain;			// Runtime I이득
	unsigned char	PortEn;			// 확장포트 사용유무(0:사용안함, 1:사용함)
	unsigned char	InitPos;		// 모션파일을 만들 때 사용된 로봇의 영점 위치정보
};
struct TwCK_in_Scene{	// 한 개 씬에서 사용하는 wCK 정보
	unsigned char	Exist;			// wCK 유무
	unsigned char	SPos;			// 첫 프레임의 wCK 위치
	unsigned char	DPos;			// 끝 프레임의 wCK 위치
	unsigned char	Torq;			// 토크
	unsigned char	ExPortD;		// 확장포트 출력 데이터(1~3)
};
struct TMotion{			// 한 개 모션에서 사용하는 정보들
	unsigned char	PF;				// 모션에 맞는 플랫폼
	unsigned char	RIdx;			// 모션의 상대 인덱스
	unsigned long	AIdx;			// 모션의 절대 인덱스
	unsigned int	NumOfScene;		// 씬 수
	unsigned int	NumOfwCK;		// wCK 수
	struct	TwCK_in_Motion  wCK[31	];	// wCK 파라미터
	unsigned int	FileSize;		// 파일 크기
}Motion;
struct TScene{			// 한 개 씬에서 사용하는 정보들
	unsigned int	Idx;			// 씬 인덱스(0~65535)
	unsigned int	NumOfFrame;		// 프레임 수
	unsigned int	RTime;			// 씬 수행 시간[msec]
	struct	TwCK_in_Scene   wCK[31	];	// wCK 데이터
}Scene;
unsigned int	gSIdx;			// 씬 인덱스(0~65535)
//------------------------------------------------------------------------------
// UART0 송신 인터럽트(패킷 송신용)
//------------------------------------------------------------------------------
interrupt [21] void usart0_tx_isr(void) {
	if(gTx0BufIdx<gTx0Cnt){			// 보낼 데이터가 남아있으면
    	while(!(UCSR0A&(1<<5))); 	// 이전 바이트 전송이 완료될때까지 대기
		UDR0=gTx0Buf[gTx0BufIdx];		// 1바이트 송신
    	gTx0BufIdx++;      				// 버퍼 인덱스 증가
	}
	else if(gTx0BufIdx==gTx0Cnt){	// 송신 완료
		gTx0BufIdx = 0;					// 버퍼 인덱스 초기화
		gTx0Cnt = 0;					// 송신 대기 바이트수 초기화
	}
}
//------------------------------------------------------------------------------
// UART0 수신 인터럽트(wCK, 사운드모듈에서 받은 신호)
//------------------------------------------------------------------------------
interrupt [19] void usart0_rx_isr(void)
{
	int		i;
    char	data;
	data=UDR0;
	gRx0Cnt++;
    // 수신데이터를 FIFO에 저장
   	for(i=1; i<8		; i++) gRx0Buf[i-1] = gRx0Buf[i];
   	gRx0Buf[8		-1] = data;
}
//------------------------------------------------------------------------------
// 타이머0 오버플로 인터럽트 (시간 측정용 0.998ms 간격)
//------------------------------------------------------------------------------
interrupt [17] void timer0_ovf_isr(void) {
	TCNT0 = 25;
	// 1ms 마다 실행
    if(++gMSEC>999){
		// 1s 마다 실행
        gMSEC=0;
        if(++gSEC>59){
			// 1m 마다 실행
            gSEC=0;
            if(++gMIN>59){
				// 1h 마다 실행
                gMIN=0;
                if(++gHOUR>23)
                    gHOUR=0;
            }
        }
    }
}
//------------------------------------------------------------------------------
// 타이머1 오버플로 인터럽트 (프레임 송신)
//------------------------------------------------------------------------------
interrupt [15] void timer1_ovf_isr(void) {
	if( gFrameIdx == Scene.NumOfFrame ) {   // 마지막 프레임이었으면
   	    gFrameIdx = 0;
    	(PORTA |= 0x20);
		F_PLAYING=0;		// 모션 실행중 표시해제
		TIMSK &= 0xfb;  	// Timer1 Overflow Interrupt 해제
		TCCR1B=0x00;
		return;
	}
	TCNT1=TxInterval;
	TIFR |= 0x04;		// 타이머 인터럽트 플래그 초기화
	TIMSK |= 0x04;		// Timer1 Overflow Interrupt 활성화(140쪽)
	MakeFrame();		// 한 프레임 준비
	SendFrame();		// 한 프레임 송신
}
//------------------------------------------------------------------------------
// 하드웨어 초기화
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
	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
	// State7=T State6=T State5=T State4=T State3=T State2=T State1=P State0=P 
	PORTD=0x03;
	DDRD=0x00;
	// Port E initialization
	// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In 
	// State7=T State6=P State5=P State4=P State3=0 State2=T State1=T State0=T 
	PORTE=0x70;
	DDRE=0x08;
	// Port F initialization
	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
	// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
	(*(unsigned char *) 0x62)=0x00;
	(*(unsigned char *) 0x61)=0x00;
	// Port G initialization
	// Func4=In Func3=In Func2=Out Func1=In Func0=In 
	// State4=T State3=T State2=0 State1=T State0=T 
	(*(unsigned char *) 0x65)=0x00;
	(*(unsigned char *) 0x64)=0x04;
	// 타이머 0---------------------------------------------------------------
	// : 범용 시간 측정용으로 사용(ms 단위)
	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: 230.400 kHz
	// Clock 증가 주기 = 1/230400 = 4.34us
	// Overflow 시간 = 255*1/230400 = 1.107ms
	// 1ms 주기 overflow를 위한 카운트 시작값 =  255-230 = 25
	// Mode: Normal top=FFh
	// OC0 output: Disconnected
	ASSR=0x00;
	TCCR0=0x04;
	TCNT0=0x00;
	OCR0=0x00;
	// 타이머 1---------------------------------------------------------------
	// : 모션 플레이시 프레임 송신 간격 조절용으로 사용
	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: 14.400 kHz
	// Clock 증가 주기 = 1/14400 = 69.4us
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
	(*(unsigned char *) 0x79)=0x00;
	(*(unsigned char *) 0x78)=0x00;
	// 타이머 2---------------------------------------------------------------
	// Timer/Counter 2 initialization
	// Clock source: System Clock
	// Clock value: 14.400 kHz
	// Clock 증가 주기 = 1/14400 = 69.4us
	// Mode: Normal top=FFh
	// OC2 output: Disconnected
	TCCR2=0x05;
	TCNT2=0x00;
	OCR2=0x00;
	// 타이머 3---------------------------------------------------------------
	// : 가속도 센서 신호 분석용으로 사용
	(*(unsigned char *) 0x8b)=0x00;
	(*(unsigned char *) 0x8a)=0x03;
	(*(unsigned char *) 0x89)=0x00;
	(*(unsigned char *) 0x88)=0x00;
	(*(unsigned char *) 0x81)=0x00;
	(*(unsigned char *) 0x80)=0x00;
	(*(unsigned char *) 0x87)=0x00;
	(*(unsigned char *) 0x86)=0x00;
	(*(unsigned char *) 0x85)=0x00;
	(*(unsigned char *) 0x84)=0x00;
	(*(unsigned char *) 0x83)=0x00;
	(*(unsigned char *) 0x82)=0x00;
	// External Interrupt(s) initialization
	// INT0: Off
	// INT1: Off
	// INT2: Off
	// INT3: Off
	// INT4: Off
	// INT5: Off
	// INT6: Off
	// INT7: Off
	(*(unsigned char *) 0x6a)=0x00;
	EICRB=0x00;
	EIMSK=0x00;
	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x00;
	(*(unsigned char *) 0x7d)=0x00;
	// USART0 initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART0 Receiver: Off
	// USART0 Transmitter: On
	// USART0 Mode: Asynchronous
	// USART0 Baud rate: 115200
	UCSR0A=0x00;
	UCSR0B=0x48;
	(*(unsigned char *) 0x95)=0x06;
	(*(unsigned char *) 0x90)=0x00;
	UBRR0L=0x07;
	// USART1 initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART1 Receiver: On
	// USART1 Transmitter: On
	// USART1 Mode: Asynchronous
	// USART1 Baud rate: 115200
	(*(unsigned char *) 0x9b)=0x00;
	(*(unsigned char *) 0x9a)=0x18;		// 수신인터럽트 사용안함
	(*(unsigned char *) 0x9d)=0x06;
	(*(unsigned char *) 0x98)=0x00;
	(*(unsigned char *) 0x99)=7 ;	// UART1 의 BAUD RATE를 115200로 설정
	(*(unsigned char *) 0x74) = 0;
}
//------------------------------------------------------------------------------
// 플래그 초기화
//------------------------------------------------------------------------------
void SW_init(void) {
	(PORTA |= 0x04);
	(PORTA |= 0x08);
	(PORTA |= 0x10);
	((*(unsigned char *) 0x65) |= 0x04);
	(PORTC |= 0x80);
	(PORTA |= 0x20);
	(PORTA |= 0x40);
	(PORTA |= 0x80);
	F_PLAYING = 0;          // 동작중 아님
	gTx0Cnt = 0;			// UART0 송신 대기 바이트 수
	gTx0BufIdx = 0;			// TX0 버퍼 인덱스 초기화
	(PORTB &= 0xDF) ;                // PSD 거리센서 전원 OFF
	gMSEC=0;
	gSEC=0;
	gMIN=0;
	gHOUR=0;
}
void SpecialMode(void)
{
	int i;
	// PF2 버튼이 눌러졌으면 wCK 직접제어 모드로 진입
	if(PINA.0==1 && PINA.1==0){
		delay_ms(10);
		if(PINA.0==1){
		    TIMSK &= 0xFE;     // Timer0 Overflow Interrupt 미사용
			EIMSK &= 0xBF;		// EXT6(리모컨 수신) 인터럽트 미사용
			UCSR0B |= 0x80;   	// UART0 Rx인터럽트 사용
			UCSR0B &= 0xBF;   	// UART0 Tx인터럽트 미사용
		}
	}
}
//------------------------------------------------------------------------------
// 메인 함수
//------------------------------------------------------------------------------
void main(void) {
	unsigned int    i, lMSEC;
	HW_init();			// 하드웨어 초기화
	SW_init();			// 변수 초기화
	#asm("sei");
	TIMSK |= 0x01;		// Timer0 Overflow Interrupt 활성화
	SpecialMode();
    	SendSetCmd(1, 12, 10, 10);
		while(1){
				lMSEC = gMSEC;
		ReadButton();	    // 버튼 읽기
		IoUpdate();		    // IO 상태 UPDATE
		while(lMSEC==gMSEC);
		    }
}
