//==============================================================================
//						Communication & Command �Լ���
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
// �ϵ���� �������� ���ǵ�
//==============================================================================
//#define			EXT_INT0_ENABLE		SET_BIT6(GICR)
//#define			EXT_INT0_DISABLE	CLR_BIT6(GICR)
//==============================================================================
//						UART ��� ����
//==============================================================================
//==============================================================================
//						Send ��ɾ� ����
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
// Ŭ�� 14.7456 MHz�϶��� ������Ʈ ���� ��� (���� = 0%) 
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
// Date,Time : 2008-04-14 ���� 2:25:11
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
// �ø��� ��Ʈ�� �� ���ڸ� �����ϱ� ���� �Լ�
//------------------------------------------------------------------------------
void sciTx0Data(unsigned char td)
{
	while(!(UCSR0A&(1<<5))); 	// ������ ������ �Ϸ�ɶ����� ���
	UDR0=td;
}
void sciTx1Data(unsigned char td)
{
	while(!((*(unsigned char *) 0x9b)&(1<<5))); 	// ������ ������ �Ϸ�ɶ����� ���
	(*(unsigned char *) 0x9c)=td;
}
//------------------------------------------------------------------------------
// �ø��� ��Ʈ�� �� ���ڸ� ���������� ����ϱ� ���� �Լ�
//------------------------------------------------------------------------------
unsigned char sciRx0Ready(void)
{
	unsigned int	startT;
	startT = gMSEC;
	while(!(UCSR0A&(1<<7)) ){ 	// �� ���ڰ� ���ŵɶ����� ���
        if(gMSEC<startT){
			// Ÿ�� �ƿ��� ���� Ż��
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
	while(!((*(unsigned char *) 0x9b)&(1<<7)) ){ 	// �� ���ڰ� ���ŵɶ����� ���
        if(gMSEC<startT){
			// Ÿ�� �ƿ��� ���� Ż��
            if((1000 - startT + gMSEC)>20	) break;
        }
		else if((gMSEC-startT)>20	) break;
	}
	return (*(unsigned char *) 0x9c);
}
//------------------------------------------------------------------------------
// wCK�� �Ķ���͸� ������ �� ���
// Input	: Data1, Data2, Data3, Data4
// Output	: None
//------------------------------------------------------------------------------
void SendSetCmd(unsigned char ID, unsigned char Data1, unsigned char Data2, unsigned char Data3)
{
	unsigned char CheckSum; 
	ID=(unsigned char)(7<<5)|ID; 
	CheckSum = (ID^Data1^Data2^Data3)&0x7f;
	gTx0Buf[gTx0Cnt]=0xFF ;
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
	unsigned char CheckSum; 
	unsigned char i, tmp, Data;
	Data = (Scene.wCK[0].Torq<<5) | 31;
	gTx0Buf[gTx0Cnt]=0xFF ;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=Data;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=16;
	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	CheckSum = 0;
	for(i=0;i<31	;i++){	// �� wCK ������ �غ�
		if(Scene.wCK[i].Exist){	// �����ϴ� ID�� �غ�
			lwtmp = (int)Scene.wCK[i].SPos + (int)((float)gFrameIdx*gUnitD[i]);
			if(lwtmp>254)		lwtmp = 254;
			else if(lwtmp<1)	lwtmp = 1;
			tmp = (unsigned char)lwtmp;
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
// 8bit ��� Position Move�� �����ϱ� ���� �Լ�
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
// Ȯ�� ��� I/O Write�� �����ϱ� ���� �Լ�
// Input	: ID, IOchannel
// Output	: None
//------------------------------------------------------------------------------
void IOwrite(unsigned char ID, unsigned char IOchannel)
{
    unsigned char CheckSum; 
	ID=(unsigned char)(7<<5)|ID; 
	CheckSum = (ID^100^IOchannel^IOchannel)&0x7f;
	gTx0Buf[gTx0Cnt]=0xFF ;    gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=ID;        gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=100;       gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=IOchannel;	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=IOchannel;	gTx0Cnt++;			// �۽��� ����Ʈ�� ����
	gTx0Buf[gTx0Cnt]=CheckSum; 	gTx0Cnt++;			// �۽��� ����Ʈ�� ����   
		gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����
	}
//------------------------------------------------------------------------------
// ��ġ �б� ���(Position Send Command)�� ������ �Լ�
// Input	: ID, SpeedLevel, Position
// Output	: Current
// UART0 RX ���ͷ�Ʈ, Timer0 ���ͷ�Ʈ�� Ȱ��ȭ �Ǿ� �־�� ��
//------------------------------------------------------------------------------
unsigned int PosRead(unsigned char ID) 
{
	unsigned char	Data1, Data2;
	unsigned char	CheckSum, Load, Position; 
	unsigned int	startT;
	Data1 = (5<<5) | ID;
	Data2 = 0;
	gRx0Cnt = 0;			// ���� ����Ʈ �� �ʱ�ȭ
	CheckSum = (Data1^Data2)&0x7f;
	sciTx0Data(0xFF );
	sciTx0Data(Data1);
	sciTx0Data(Data2);
	sciTx0Data(CheckSum);
	startT = gMSEC;
	while(gRx0Cnt<2){
        if(gMSEC<startT){ 	// �и��� ī��Ʈ�� ���µ� ���
            if((1000 - startT + gMSEC)>20	)
            	return 444;	// Ÿ�Ӿƿ��� ���� Ż��
        }
		else if((gMSEC-startT)>20	) return 444;
	}
	return gRx0Buf[8		-1];
} 
//------------------------------------------------------------------------------
// Flash���� ��� ���� �б�
//	MRIdx : ��� ��� �ε���
//------------------------------------------------------------------------------
void GetMotionFromFlash(void)
{
	unsigned int i;
	for(i=0;i<31	;i++){				// wCK �Ķ���� ����ü �ʱ�ȭ
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
	unsigned int i;
	UCSR0B &= 0x7F;   		// UART0 Rx���ͷ�Ʈ �̻��
	UCSR0B |= 0x40;   		// UART0 Tx���ͷ�Ʈ ���
	while(gTx0Cnt);			// ���� ��Ŷ �۽��� ���� ������ ���
	for(i=0;i<31	;i++){					// Runtime P,D�̵� ���� ��Ŷ �غ�
		if(Motion.wCK[i].Exist)				// �����ϴ� ID�� �غ�
			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// ù����Ʈ �۽� ����
	while(gTx0Cnt);			// ���� ��Ŷ �۽��� ���� ������ ���
	for(i=0;i<31	;i++){					// Runtime I�̵� ���� ��Ŷ �غ�
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
	unsigned int i;
	UCSR0B &= 0x7F;   		// UART0 Rx���ͷ�Ʈ �̻��
	UCSR0B |= 0x40;   		// UART0 Tx���ͷ�Ʈ ���
	while(gTx0Cnt);			// ���� ��Ŷ �۽��� ���� ������ ���
	for(i=0;i<31	;i++){					// Runtime P,D�̵� ���� ��Ŷ �غ�
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
	unsigned int i;
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
	TxInterval = 65535 - (unsigned int)tmp - 43;
	(PORTA &= 0xDF)     ;
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
	unsigned int i;
	for(i=0;i<31	;i++){
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
	unsigned int i;
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
	Motion.NumOfScene 	= 10;
	Motion.NumOfwCK 	= 16;
	M_PlayFlash();
}
