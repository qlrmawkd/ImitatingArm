//==============================================================================
//						Communication & Command 함수들
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
// CodeVisionAVR C Compiler
// (C) 1998-2005 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for string functions
#pragma used+
char *strcat(char *str1,char *str2);
char *strcatf(char *str1,char flash *str2);
char *strchr(char *str,char c);
signed char strcmp(char *str1,char *str2);
signed char strcmpf(char *str1,char flash *str2);
char *strcpy(char *dest,char *src);
char *strcpyf(char *dest,char flash *src);
unsigned char strcspn(char *str,char *set);
unsigned char strcspnf(char *str,char flash *set);
unsigned int strlenf(char flash *str);
char *strncat(char *str1,char *str2,unsigned char n);
char *strncatf(char *str1,char flash *str2,unsigned char n);
signed char strncmp(char *str1,char *str2,unsigned char n);
signed char strncmpf(char *str1,char flash *str2,unsigned char n);
char *strncpy(char *dest,char *src,unsigned char n);
char *strncpyf(char *dest,char flash *src,unsigned char n);
char *strpbrk(char *str,char *set);
char *strpbrkf(char *str,char flash *set);
signed char strpos(char *str,char c);
char *strrchr(char *str,char c);
char *strrpbrk(char *str,char *set);
char *strrpbrkf(char *str,char flash *set);
signed char strrpos(char *str,char c);
char *strstr(char *str1,char *str2);
char *strstrf(char *str1,char flash *str2);
unsigned char strspn(char *str,char *set);
unsigned char strspnf(char *str,char flash *set);
char *strtok(char *str1,char flash *str2);
 unsigned int strlen(char *str);
void *memccpy(void *dest,void *src,char c,unsigned n);
void *memchr(void *buf,unsigned char c,unsigned n);
signed char memcmp(void *buf1,void *buf2,unsigned n);
signed char memcmpf(void *buf1,void flash *buf2,unsigned n);
void *memcpy(void *dest,void *src,unsigned n);
void *memcpyf(void *dest,void flash *src,unsigned n);
void *memmove(void *dest,void *src,unsigned n);
void *memset(void *buf,unsigned char c,unsigned n);
#pragma used-
#pragma library string.lib
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
//==========================================================
// Project : [ p_ex1 ]
// SoftWare : Motion Builder v1.10 beta
// Date,Time : 2008-04-14 오후 2:25:11
// Format : ME_FMT#1
// Number of Motions : 1
// Number of wCKs : 16
//==========================================================
unsigned char flash wCK_IDs[16]={
unsigned char flash wCK_IDs[16]={
	  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15
};
unsigned char flash MotionZeroPos[16]={
	/* ID
	  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
	125,202,162, 66,108,125, 51, 86,183,142, 89, 42,124,161,208,127
};
//----------------------------------------------------------
// Motion Name : M_EX1
//----------------------------------------------------------
unsigned char flash M_EX1_RuntimePGain[16]={
	/* ID
	  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
	 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
};
unsigned char flash M_EX1_RuntimeDGain[16]={
	/* ID
	  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
	 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30
};
unsigned char flash M_EX1_RuntimeIGain[16]={
	/* ID
	  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
	  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
};
unsigned int flash M_EX1_Frames[10]={
	    1,   30,   10,    3,   10,   10,    1,    1,   10,   30
};
unsigned int flash M_EX1_TrTime[10]={
	  500, 1000,  300,  100,  300,  300,   50,  600,  300, 1000
};
unsigned char flash M_EX1_Position[11][16]={
	/* ID
	    0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
	{ 125,179,199, 88,108,126, 72, 49,163,141, 51, 47, 49,199,205,205 },
	{ 125,179,199, 88,108,126, 72, 49,163,141, 51, 47, 49,199,205,205 },	// Idx:0 - Scene_0
	{ 125,150,248,112,108,126,100,  1,139,141, 51, 47, 49,199,205,205 },	// Idx:1 - Scene_1
	{ 125,150,248,112,108,126,100,  1,139,141,109, 39,  6,177,205,242 },	// Idx:2 - Scene_2
	{ 125,150,248,112,108,126,100,  1,139,141,171, 39, 81,169,205,241 },	// Idx:3 - Scene_3
	{ 125,150,248,112,108,126,100,  1,139,141,109, 39,  6,177,205,242 },	// Idx:4 - Scene_2
	{ 125,150,248,112,108,126,100,  1,139,141,171, 39, 81,169,205,241 },	// Idx:5 - Scene_4
	{ 125,150,248,112,108,126,100,  1,139,141, 42, 43, 31, 54,206,133 },	// Idx:6 - Scene_6
	{ 125,150,248,112,108,126,100,  1,139,141, 42, 43, 31, 54,206,133 },	// Idx:7 - Scene_6
	{ 125,150,248,112,108,126,100,  1,139,141,109, 39,  6,177,205,242 },	// Idx:8 - Scene_2
	{ 125,150,248,112,108,126,100,  1,139,141, 51, 47, 49,199,206,205 } 	// Idx:9 - Scene_1
};
unsigned char flash M_EX1_Torque[10][16]={
	/* ID
	    0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
	{   2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 },	// Idx:0 - Scene_0
	{   2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 },	// Idx:1 - Scene_1
	{   2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 },	// Idx:2 - Scene_2
	{   2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 },	// Idx:3 - Scene_3
	{   2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 },	// Idx:4 - Scene_2
	{   2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 },	// Idx:5 - Scene_4
	{   2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 },	// Idx:6 - Scene_6
	{   2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 },	// Idx:7 - Scene_6
	{   2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 },	// Idx:8 - Scene_2
	{   2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 } 	// Idx:9 - Scene_1
};
unsigned char flash M_EX1_Port[10][16]={
	/* ID
	    0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
	{   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },	// Idx:0 - Scene_0
	{   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },	// Idx:1 - Scene_1
	{   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },	// Idx:2 - Scene_2
	{   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },	// Idx:3 - Scene_3
	{   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },	// Idx:4 - Scene_2
	{   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },	// Idx:5 - Scene_4
	{   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },	// Idx:6 - Scene_6
	{   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },	// Idx:7 - Scene_6
	{   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },	// Idx:8 - Scene_2
	{   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 } 	// Idx:9 - Scene_1
};
//------------------------------------------------------------------------------
// 시리얼 포트로 한 문자를 전송하기 위한 함수
//------------------------------------------------------------------------------
void sciTx0Data(unsigned char td)
{
	while(!(UCSR0A&(1<<5))); 	// 이전의 전송이 완료될때까지 대기
	UDR0=td;
}
void sciTx1Data(unsigned char td)
{
	while(!((*(unsigned char *) 0x9b)&(1<<5))); 	// 이전의 전송이 완료될때까지 대기
	(*(unsigned char *) 0x9c)=td;
}
//------------------------------------------------------------------------------
// 시리얼 포트로 한 문자를 받을때까지 대기하기 위한 함수
//------------------------------------------------------------------------------
unsigned char sciRx0Ready(void)
{
	unsigned int	startT;
	startT = gMSEC;
	while(!(UCSR0A&(1<<7)) ){ 	// 한 문자가 수신될때까지 대기
        if(gMSEC<startT){
			// 타임 아웃시 로컬 탈출
            if((1000 - startT + gMSEC)>20	) break;
        }
		else if((gMSEC-startT)>20	) break;
	}
	return UDR0;
}
unsigned char sciRx1Ready(void)
{
	unsigned int	startT;
	startT = gMSEC;
	while(!((*(unsigned char *) 0x9b)&(1<<7)) ){ 	// 한 문자가 수신될때까지 대기
        if(gMSEC<startT){
			// 타임 아웃시 로컬 탈출
            if((1000 - startT + gMSEC)>20	) break;
        }
		else if((gMSEC-startT)>20	) break;
	}
	return (*(unsigned char *) 0x9c);
}
//------------------------------------------------------------------------------
// wCK의 파라미터를 설정할 때 사용
// Input	: Data1, Data2, Data3, Data4
// Output	: None
//------------------------------------------------------------------------------
void SendSetCmd(unsigned char ID, unsigned char Data1, unsigned char Data2, unsigned char Data3)
{
	unsigned char CheckSum; 
	ID=(unsigned char)(7<<5)|ID; 
	CheckSum = (ID^Data1^Data2^Data3)&0x7f;
	gTx0Buf[gTx0Cnt]=0xFF ;
	gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=ID;
	gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=Data1;
	gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=Data2;
	gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=Data3;
	gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=CheckSum;
	gTx0Cnt++;			// 송신할 바이트수 증가
}
//------------------------------------------------------------------------------
// 동기화 위치 명령(Synchronized Position Send Command)을 보내는 함수
//------------------------------------------------------------------------------
void SyncPosSend(void) 
{
	int lwtmp;
	unsigned char CheckSum; 
	unsigned char i, tmp, Data;
	Data = (Scene.wCK[0].Torq<<5) | 31;
	gTx0Buf[gTx0Cnt]=0xFF ;
	gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=Data;
	gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=16;
	gTx0Cnt++;			// 송신할 바이트수 증가
	CheckSum = 0;
	for(i=0;i<31	;i++){	// 각 wCK 데이터 준비
		if(Scene.wCK[i].Exist){	// 존재하는 ID만 준비
			lwtmp = (int)Scene.wCK[i].SPos + (int)((float)gFrameIdx*gUnitD[i]);
			if(lwtmp>254)		lwtmp = 254;
			else if(lwtmp<1)	lwtmp = 1;
			tmp = (unsigned char)lwtmp;
			gTx0Buf[gTx0Cnt] = tmp;
			gTx0Cnt++;			// 송신할 바이트수 증가
			CheckSum = CheckSum^tmp;
		}
	}
	CheckSum = CheckSum & 0x7f;
	gTx0Buf[gTx0Cnt]=CheckSum;
	gTx0Cnt++;			// 송신할 바이트수 증가
} 
//------------------------------------------------------------------------------
// 8bit 명령 Position Move를 실행하기 위한 함수
// Input	: torq ID, Position
// Output	: None
//------------------------------------------------------------------------------
void PositionMove(unsigned char torq, unsigned char ID, unsigned char position)
{
    unsigned char CheckSum;
    ID = (unsigned char)(torq << 5) | ID;
    CheckSum = (ID ^ position) & 0x7f;
        sciTx0Data(0xff);
	sciTx0Data(ID);
	sciTx0Data(position);
	sciTx0Data(CheckSum);
}                       
//------------------------------------------------------------------------------
// 확장 명령 I/O Write를 수행하기 위한 함수
// Input	: ID, IOchannel
// Output	: None
//------------------------------------------------------------------------------
void IOwrite(unsigned char ID, unsigned char IOchannel)
{
    unsigned char CheckSum; 
	ID=(unsigned char)(7<<5)|ID; 
	CheckSum = (ID^100^IOchannel^IOchannel)&0x7f;
	gTx0Buf[gTx0Cnt]=0xFF ;    gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=ID;        gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=100;       gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=IOchannel;	gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=IOchannel;	gTx0Cnt++;			// 송신할 바이트수 증가
	gTx0Buf[gTx0Cnt]=CheckSum; 	gTx0Cnt++;			// 송신할 바이트수 증가   
		gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작
	}
//------------------------------------------------------------------------------
// 위치 읽기 명령(Position Send Command)을 보내는 함수
// Input	: ID, SpeedLevel, Position
// Output	: Current
// UART0 RX 인터럽트, Timer0 인터럽트가 활성화 되어 있어야 함
//------------------------------------------------------------------------------
unsigned int PosRead(unsigned char ID) 
{
	unsigned char	Data1, Data2;
	unsigned char	CheckSum, Load, Position; 
	unsigned int	startT;
	Data1 = (5<<5) | ID;
	Data2 = 0;
	gRx0Cnt = 0;			// 수신 바이트 수 초기화
	CheckSum = (Data1^Data2)&0x7f;
	sciTx0Data(0xFF );
	sciTx0Data(Data1);
	sciTx0Data(Data2);
	sciTx0Data(CheckSum);
	startT = gMSEC;
	while(gRx0Cnt<2){
        if(gMSEC<startT){ 	// 밀리초 카운트가 리셋된 경우
            if((1000 - startT + gMSEC)>20	)
            	return 444;	// 타임아웃시 로컬 탈출
        }
		else if((gMSEC-startT)>20	) return 444;
	}
	return gRx0Buf[8		-1];
} 
//------------------------------------------------------------------------------
// Flash에서 모션 정보 읽기
//	MRIdx : 모션 상대 인덱스
//------------------------------------------------------------------------------
void GetMotionFromFlash(void)
{
	unsigned int i;
	for(i=0;i<31	;i++){				// wCK 파라미터 구조체 초기화
		Motion.wCK[i].Exist		= 0;
		Motion.wCK[i].RPgain	= 0;
		Motion.wCK[i].RDgain	= 0;
		Motion.wCK[i].RIgain	= 0;
		Motion.wCK[i].PortEn	= 0;
		Motion.wCK[i].InitPos	= 0;
	}
	for(i=0;i<Motion.NumOfwCK;i++){		// 각 wCK 파라미터 불러오기
		Motion.wCK[wCK_IDs[i]].Exist		= 1;
		Motion.wCK[wCK_IDs[i]].RPgain	= *(gpPg_Table+i);
		Motion.wCK[wCK_IDs[i]].RDgain	= *(gpDg_Table+i);
		Motion.wCK[wCK_IDs[i]].RIgain	= *(gpIg_Table+i);
		Motion.wCK[wCK_IDs[i]].PortEn	= 1;
		Motion.wCK[wCK_IDs[i]].InitPos	= MotionZeroPos[i];
	}
}
//------------------------------------------------------------------------------
// Runtime P,D,I 이득 송신
// 		: 모션정보에서 Runtime P,D,I이득을 불러와서 wCK에게 보낸다
//------------------------------------------------------------------------------
void SendTGain(void)
{
	unsigned int i;
	UCSR0B &= 0x7F;   		// UART0 Rx인터럽트 미사용
	UCSR0B |= 0x40;   		// UART0 Tx인터럽트 사용
	while(gTx0Cnt);			// 이전 패킷 송신이 끝날 때까지 대기
	for(i=0;i<31	;i++){					// Runtime P,D이득 설정 패킷 준비
		if(Motion.wCK[i].Exist)				// 존재하는 ID만 준비
			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작
	while(gTx0Cnt);			// 이전 패킷 송신이 끝날 때까지 대기
	for(i=0;i<31	;i++){					// Runtime I이득 설정 패킷 준비
		if(Motion.wCK[i].Exist)				// 존재하는 ID만 준비
			SendSetCmd(i, 24, Motion.wCK[i].RIgain, Motion.wCK[i].RIgain);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작
}
//------------------------------------------------------------------------------
// 확장 포트값 송신
// 		: 씬 정보에서 확장 포트값을 불러와서 wCK에게 보낸다
//------------------------------------------------------------------------------
void SendExPortD(void)
{
	unsigned int i;
	UCSR0B &= 0x7F;   		// UART0 Rx인터럽트 미사용
	UCSR0B |= 0x40;   		// UART0 Tx인터럽트 사용
	while(gTx0Cnt);			// 이전 패킷 송신이 끝날 때까지 대기
	for(i=0;i<31	;i++){					// Runtime P,D이득 설정 패킷 준비
		if(Scene.wCK[i].Exist)				// 존재하는 ID만 준비
			SendSetCmd(i, 100, Scene.wCK[i].ExPortD, Scene.wCK[i].ExPortD);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작
}
//------------------------------------------------------------------------------
// Flash에서 씬 정보 읽기
//	ScIdx : 씬 인덱스
//------------------------------------------------------------------------------
void GetSceneFromFlash(void)
{
	unsigned int i;
		Scene.NumOfFrame = gpFN_Table[gSIdx];	// 프레임수
	Scene.RTime = gpRT_Table[gSIdx];		// 씬 수행 시간[msec]
	for(i=0;i<Motion.NumOfwCK;i++){			// 각 wCK 데이터 초기화
		Scene.wCK[i].Exist		= 0;
		Scene.wCK[i].SPos		= 0;
		Scene.wCK[i].DPos		= 0;
		Scene.wCK[i].Torq		= 0;
		Scene.wCK[i].ExPortD	= 0;
	}
	for(i=0;i<Motion.NumOfwCK;i++){			// 각 wCK 데이터 저장
		Scene.wCK[wCK_IDs[i]].Exist		= 1;
		Scene.wCK[wCK_IDs[i]].SPos		= gpPos_Table[Motion.NumOfwCK*gSIdx+i];
		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[Motion.NumOfwCK*(gSIdx+1)+i];
		Scene.wCK[wCK_IDs[i]].Torq		= gpT_Table[Motion.NumOfwCK*gSIdx+i];
		Scene.wCK[wCK_IDs[i]].ExPortD	= gpE_Table[Motion.NumOfwCK*gSIdx+i];
	}
	UCSR0B &= 0x7F;   		// UART0 Rx인터럽트 미사용
	UCSR0B |= 0x40;   		// UART0 Tx인터럽트 사용
	delay_us(1300);
}
//------------------------------------------------------------------------------
// 프레임 송신 간격 계산
// 		: 씬 수행 시간을 프레임수로 나눠서 interval을 정한다
//------------------------------------------------------------------------------
void CalcFrameInterval(void)
{
	float tmp;
	if((Scene.RTime / Scene.NumOfFrame)<20){
		return;
	}
	tmp = (float)Scene.RTime * 14.4;
	tmp = tmp  / (float)Scene.NumOfFrame;
	TxInterval = 65535 - (unsigned int)tmp - 43;
	(PORTA &= 0xDF)     ;
	F_PLAYING=1;		// 모션 실행중 표시
	TCCR1B=0x05;
	if(TxInterval<=65509)	
		TCNT1=TxInterval+26;
	else
		TCNT1=65535;
	TIFR |= 0x04;		// 타이머 인터럽트 플래그 초기화
	TIMSK |= 0x04;		// Timer1 Overflow Interrupt 활성화(140쪽)
}
//------------------------------------------------------------------------------
// 프레임당 단위 이동량 계산
//------------------------------------------------------------------------------
void CalcUnitMove(void)
{
	unsigned int i;
	for(i=0;i<31	;i++){
		if(Scene.wCK[i].Exist){	// 존재하는 ID만 준비
			if(Scene.wCK[i].SPos!=Scene.wCK[i].DPos){
				// 프레임당 단위 변위 증가량 계산
				gUnitD[i] = (float)((int)Scene.wCK[i].DPos-(int)Scene.wCK[i].SPos);
				gUnitD[i] = (float)(gUnitD[i]/Scene.NumOfFrame);
				if(gUnitD[i]>253)	gUnitD[i]=254;
				else if(gUnitD[i]<-253)	gUnitD[i]=-254;
			}
			else
				gUnitD[i] = 0;
		}
	}
	gFrameIdx=0;				// 프레임 인덱스 초기화
}
//------------------------------------------------------------------------------
// 한 프레임 송신 준비
//------------------------------------------------------------------------------
void MakeFrame(void)
{
	while(gTx0Cnt);			// 이전 프레임 송신이 끝날 때까지 대기
	gFrameIdx++;			// 프레임 인덱스 증가
	SyncPosSend();			// 동기화 위치 명령으로 송신
}
//------------------------------------------------------------------------------
// 한 프레임 송신
//------------------------------------------------------------------------------
void SendFrame(void)
{
	if(gTx0Cnt==0)	return;	// 보낼 데이터가 없으면 실행 안함
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작
}
//------------------------------------------------------------------------------
// 
//------------------------------------------------------------------------------
void M_PlayFlash(void)
{
	float tmp;
	unsigned int i;
	GetMotionFromFlash();		// 각 wCK 파라미터 불러오기
	SendTGain();				// Runtime이득 송신
	for(i=0;i<Motion.NumOfScene;i++){
		gSIdx = i;
		GetSceneFromFlash();	// 한 씬을 불러온다
		SendExPortD();			// 확장 포트값 송신
		CalcFrameInterval();	// 프레임 송신 간격 계산, 타이머1 시작
		CalcUnitMove();			// 프레임당 단위 이동량 계산
		MakeFrame();			// 한 프레임 준비
		SendFrame();			// 한 프레임 송신
		while(F_PLAYING);
	}
}
void SampleMotion1(void)	// 샘플 모션 1
{
	gpT_Table			= M_EX1_Torque;
	gpE_Table			= M_EX1_Port;
	gpPg_Table 			= M_EX1_RuntimePGain;
	gpDg_Table 			= M_EX1_RuntimeDGain;
	gpIg_Table 			= M_EX1_RuntimeIGain;
	gpFN_Table			= M_EX1_Frames;
	gpRT_Table			= M_EX1_TrTime;
	gpPos_Table			= M_EX1_Position;
	Motion.NumOfScene 	= 10;
	Motion.NumOfwCK 	= 16;
	M_PlayFlash();
}
