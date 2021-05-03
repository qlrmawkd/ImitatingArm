//==============================================================================
//	 RoboBuilder MainController
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
// 배터리 기준 전압 -----------------------------------------------
//#define	U_T_OF_POWER		12000		// 리튬폴리머 11.1V 배터리용
//#define	M_T_OF_POWER		9800
//#define	L_T_OF_POWER		9700
//==============================================================================
//						플랫폼(로봇 형태) 관련
//==============================================================================
//==============================================================================
//						버튼 관련
//==============================================================================
//==============================================================================
//						에러 코드(F_ERR_CODE에 저장)
//==============================================================================
//==============================================================================
//						UART 통신 관련
//==============================================================================
//==============================================================================
//						A/D 관련
//==============================================================================
//==============================================================================
//						액션/모션 관련
//==============================================================================
//==============================================================================
//						IR 리모컨 관련
//==============================================================================
void sciTx0Data(unsigned char td);
void sciTx1Data(unsigned char td);
unsigned char sciRx0Ready(void);
unsigned char sciRx1Ready(void);
void SendOperCmd(unsigned char Data1,unsigned char Data2);
void SendSetCmd(unsigned char ID, unsigned char Data1, unsigned char Data2, unsigned char Data3);
void PosSend(unsigned char ID, unsigned char SpeedLevel, unsigned char Position);
void PassiveModeCmdSend(unsigned char ID);
void BreakModeCmdSend(void);
void BoundSetCmdSend(unsigned char ID, unsigned char B_U, unsigned char B_L);
void SyncPosSendTune(void);
void SyncPosSend(void);
unsigned int PosRead(unsigned char ID);
void SendToSoundIC(unsigned char cmd);
void SendToPC(unsigned char Cmd, unsigned char CSize);
void MotionTweenFlash(unsigned char GapMax);
void GetMotionFromFlash(void);
void SendTGain(void);
void SendExPortD(void);
void GetSceneFromFlash(void);
void CalcFrameInterval(void);
void CalcUnitMove(void);
void MakeFrame(void);
void SendFrame(void);
void GetPose(void);
void BasicPose(unsigned char PF, unsigned int NOF, unsigned int RT, unsigned char TQ);
void M_Play(unsigned char BtnCode);
void ReadButton(void);
void ReadButton(void);
void ProcButton(void);
void IoUpdate(void);
void ProcIr(void);
void SelfTest1(void);
unsigned char	gAD_Ch_Index;
unsigned char	gAD_Ch_Index;
unsigned int	gVOLTAGE;
unsigned char	gDistance;
unsigned char	gSoundLevel;
unsigned char	gPSD_val;
unsigned char	gMIC_val;
signed char	gAD_val;
void Get_AD_PSD(void);
void Get_AD_MIC(void);
void Get_VOLTAGE(void);
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
void AccStart(void);
void AccStop(void);
void AccAckRead(void);
void AccAckWrite(void);
void AccNotAckWrite(void);
char AccByteRead(void);
void AccByteWrite(unsigned char bData);
void AccRead(void);
char AccReadData(unsigned char addr);
void Acc_init(void);
void AccGetData(void);
unsigned char	F_PF;
unsigned char	F_ERR_CODE;
bit 	F_SCENE_PLAYING;
bit 	F_ACTION_PLAYING;
bit 	F_DIRECT_C_EN;
bit 	F_MOTION_STOPPED;
bit     F_DOWNLOAD;
bit 	F_PS_PLUGGED;
bit 	F_CHARGING;
bit     F_AD_CONVERTING;
bit     F_MIC_INPUT;
bit     F_PF_CHANGED;
bit     F_IR_RECEIVED;
bit     F_FIRST_M;
bit		F_RSV_MOTION;
bit		F_RSV_SOUND_READ;
bit		F_RSV_BTN_READ;
bit		F_RSV_PSD_READ;
unsigned char	F_EEPROM_BUSY;
char	gTx0Buf[186];
unsigned char	gTx0Cnt;
unsigned char	gRx0Cnt;
unsigned char	gTx0BufIdx;
char	gRx0Buf[8];
char	gRx1Buf[20];
unsigned int	gRx1Step;
unsigned int	gRx1_DStep;
unsigned int	gFieldIdx;
unsigned char	gFileCheckSum;
unsigned char	gRxData;
unsigned int	gPF1BtnCnt;
unsigned int	gPF2BtnCnt;
unsigned int	gPF12BtnCnt;
unsigned char	gBtn_val;
unsigned int    g10MSEC;
unsigned char    gSEC;
unsigned char    gMIN;
unsigned char    gHOUR;
unsigned int	gSEC_DCOUNT;
unsigned int	gMIN_DCOUNT;
unsigned int    gPSplugCount;
unsigned int    gPSunplugCount;
unsigned int	gPwrLowCount;
char	gIrBuf[4];
unsigned char	gIrBitIndex = 0;
signed char	gAccX;
signed char	gAccY;
signed char	gAccZ;
unsigned char	gSoundMinTh;
int		gFrameIdx = 0;
unsigned int	TxInterval = 0;
float	gUnitD[31];
unsigned char	gLastID;
unsigned char flash	*gpT_Table;
unsigned char flash	*gpE_Table;
unsigned char flash	*gpPg_Table;
unsigned char flash	*gpDg_Table;
unsigned char flash	*gpIg_Table;
unsigned int flash	*gpFN_Table;
unsigned int flash	*gpRT_Table;
unsigned char flash	*gpPos_Table;
unsigned char flash	StandardZeroPos[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
125,202,162, 66,108,124, 48, 88,184,142, 90, 40,125,161,210,127};
unsigned char flash	U_Boundary_Huno[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
174,228,254,130,185,254,180,126,208,208,254,224,198,254,228,254};
unsigned char flash	L_Boundary_Huno[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
  1, 70,124, 40, 41, 73, 22,  1,120, 57,  1, 23,  1,  1, 25, 40};
unsigned char flash	U_Boundary_Dino[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
174,228,254,130,185,254,185,126,208,230,254,254,205,254,254,254};
unsigned char flash	L_Boundary_Dino[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
  1, 75,124, 40, 41, 73, 22,  1,120, 45,  1,  1, 25,  1, 45, 45};
unsigned char flash	U_Boundary_Dogy[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
254,225,225,210,254,254,225,185,203,205,254,230,205,254,230,254};
unsigned char flash	L_Boundary_Dogy[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
  1, 25, 25, 25, 45,  1, 25, 82,  5,  1,  1, 20,  1,  1, 17, 40};
struct TwCK_in_Motion{
	unsigned char	Exist;
	unsigned char	RPgain;
	unsigned char	RDgain;
	unsigned char	RIgain;
	unsigned char	PortEn;
	unsigned char	InitPos;
};
struct TwCK_in_Scene{
	unsigned char	Exist;
	unsigned char	SPos;
	unsigned char	DPos;
	unsigned char	Torq;
	unsigned char	ExPortD;
};
struct TMotion{
	unsigned char	RIdx;
	unsigned long	AIdx;
	unsigned char	PF;
	unsigned int	NumOfScene;
	unsigned int	NumOfwCK;
	struct	TwCK_in_Motion  wCK[31];
	unsigned int	FileSize;
}Motion;
struct TScene{
	unsigned int	Idx;
	unsigned int	NumOfFrame;
	unsigned int	RTime;
	struct	TwCK_in_Scene   wCK[31];
}Scene;
unsigned int	gScIdx;
eeprom  char    eData[13];
eeprom	unsigned char	eRCodeH[5];
eeprom	unsigned char	eRCodeM[5];
eeprom	unsigned char	eRCodeL[5];
eeprom	unsigned char	eM_OriginPose[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
124,202,162, 65,108,125, 46, 88,184,142, 90, 40,125,161,210,126};
int		gPoseDelta[31];
eeprom	unsigned char	ePF = 1;
eeprom  unsigned char    eNumOfM = 0;
eeprom  unsigned char    eNumOfA = 0;
eeprom  unsigned int    eM_Addr[20];
eeprom  unsigned int    eM_FSize[20];
eeprom  unsigned int    eA_Addr[10];
eeprom  unsigned int    eA_FSize[10];
unsigned char    gDownNumOfM;
unsigned char    gDownNumOfA;
unsigned int Sound_Length[25]={
2268,1001,832,365,838,417,5671,5916,780,2907,552,522,1525,2494,438,402,433,461,343,472,354,461,458,442,371};
int Round(float num,int precision)
{
	float tempNum;
	tempNum = num;
	if(tempNum - floor(tempNum) >= 0.5)
		return (int)( ceil(tempNum)  );
	else return (int)(floor(tempNum));
}
void U1I_case100(void)
{
	Motion.PF = gRxData;
	gFieldIdx = 0;
	gRx1Step++;
}
void U1I_case301(unsigned char LC)
{
	gFieldIdx++;
	if(gFieldIdx == 4){
		gFieldIdx = 0;
		gFileCheckSum = 0;
		if(gRxData == LC)	
			gRx1Step++;
		else{
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			(PORTA |= 0x40);
		}
	}
}
void U1I_case302(void)
{
	gFileCheckSum ^= gRxData;
	if(gRxData == 1)
		gRx1Step++;
	else{
		gRx1Step = 0;
		F_DOWNLOAD = 0;
		(PORTA |= 0x40);
	}
}
void U1I_case303(void)
{
	int		i;
	if(gRxData == 1){
		SendToPC(11,16);
		gFileCheckSum = 0;
		for(i = 0; i < 16; i++){
			sciTx1Data(eM_OriginPose[i]);
			gFileCheckSum ^= eM_OriginPose[i];
		}
		sciTx1Data(gFileCheckSum);
	}
	gRx1Step = 0;
	F_DOWNLOAD = 0;
	(PORTA |= 0x40);
}
void U1I_case502(unsigned char LC)
{
	gFileCheckSum ^= gRxData;
	gFieldIdx++;
	if(gFieldIdx == LC){
		gRx1Step++;
	}
}
void U1I_case603(void)
{
	int		i;
	if(gFileCheckSum == gRxData){
		F_ERR_CODE = 0xff;
		for(i = 0; i < 16; i++){
			if((StandardZeroPos[i]+15) < gRx1Buf[20-17+i]
			 ||(StandardZeroPos[i]-15) > gRx1Buf[20-17+i]){
				F_ERR_CODE = 7;
				break;
			}
		}
		if(F_ERR_CODE == 0xff){
			for(i = 0; i < 16; i++)
				eM_OriginPose[i] = gRx1Buf[20-17+i];
			SendToPC(14,16);
			gFileCheckSum = 0;
			for(i = 0; i < 16; i++){
				sciTx1Data(eM_OriginPose[i]);
				gFileCheckSum ^= eM_OriginPose[i];
			}
			sciTx1Data(gFileCheckSum);
		}
	}
	gRx1Step = 0;
	F_DOWNLOAD = 0;
	(PORTA |= 0x40);
}
void U1I_case703(void)
{
	unsigned int    lwtmp;
	unsigned char	lbtmp;
	if(gFileCheckSum == gRxData){
		if(gDownNumOfM == 0){
			if(gRx1Buf[20-2] == 1)
				lwtmp = 0x6000;
			else if(gRx1Buf[20-2] == 2)
				lwtmp = 0x2000;
		}
		else{
			if(gRx1Buf[20-2] == 1){
				lwtmp = eM_Addr[gDownNumOfM-1] + eM_FSize[gDownNumOfM-1];
				lwtmp = lwtmp + 64 - (eM_FSize[gDownNumOfM-1]%64);
				lwtmp = 0x6000 - lwtmp;
			}
			else if(gRx1Buf[20-2] == 2){
				lwtmp = eA_Addr[gDownNumOfA-1] + eA_FSize[gDownNumOfA-1];
				lwtmp = lwtmp + 64 - (eA_FSize[gDownNumOfA-1]%64);
				lwtmp = 0x8000 - lwtmp;
			}
		}
		SendToPC(15,4);
		gFileCheckSum = 0;
		sciTx1Data(0x00);
		sciTx1Data(0x00);
		lbtmp = (unsigned char)((lwtmp>>8) & 0xFF);
		sciTx1Data(lbtmp);
		gFileCheckSum ^= lbtmp;
		lbtmp = (unsigned char)(lwtmp & 0xFF);
		sciTx1Data(lbtmp);
		gFileCheckSum ^= lbtmp;
		sciTx1Data(gFileCheckSum);
	}
	gRx1Step = 0;
	F_DOWNLOAD = 0;
	(PORTA |= 0x40);
}
//------------------------------------------------------------------------------
// UART0 송신 인터럽트(패킷 송신용)
//------------------------------------------------------------------------------
interrupt [21] void usart0_tx_isr(void)
{
	if(gTx0BufIdx < gTx0Cnt){
		while(!(UCSR0A & (1<<5)));
		UDR0 = gTx0Buf[gTx0BufIdx];
    	gTx0BufIdx++;
	}
	else if(gTx0BufIdx == gTx0Cnt){
		gTx0BufIdx = 0;
		gTx0Cnt = 0;
	}
}
//------------------------------------------------------------------------------
// UART0 수신 인터럽트(wCK, 사운드모듈에서 받은 신호)
//------------------------------------------------------------------------------
interrupt [19] void usart0_rx_isr(void)
{
	int		i;
	char	data;
	data = UDR0;
	if(F_DIRECT_C_EN){
		while ( ((*(unsigned char *) 0x9b) & (1<<5)) == 0 );
		(*(unsigned char *) 0x9c) = data;
		return;
	}
	gRx0Cnt++;
	for(i = 1; i < 8; i++) gRx0Buf[i-1] = gRx0Buf[i];
	gRx0Buf[8-1] = data;
}
//------------------------------------------------------------------------------
// UART1 수신 인터럽트(RF모듈, PC에서 받은 신호)
//------------------------------------------------------------------------------
interrupt [31] void usart1_rx_isr(void)
{
    unsigned int    i;
        gRxData = (*(unsigned char *) 0x9c);
	if(F_DIRECT_C_EN){
		while( (UCSR0A & (1<<5)) == 0 );
		UDR0 = gRxData;
		if(gRxData == 0xff){
			gRx1_DStep = 1;
			gFileCheckSum = 0;
			return;
		}
		switch(gRx1_DStep){
			case 1:
				if(gRxData == 0xe0) gRx1_DStep = 2;
				else gRx1_DStep = 0;
				gFileCheckSum ^= gRxData;
				break;
			case 2:
				if(gRxData == 251) gRx1_DStep = 3;
				else gRx1_DStep = 0;
				gFileCheckSum ^= gRxData;
				break;
			case 3:
				if(gRxData == 1) gRx1_DStep = 4;
				else gRx1_DStep = 0;
				gFileCheckSum ^= gRxData;
				break;
			case 4:
				gRx1_DStep = 5;
				gFileCheckSum ^= gRxData;
				gFileCheckSum &= 0x7F;
				break;
			case 5:
				if(gRxData == gFileCheckSum){
				    TIMSK |= 0x01;
					EIMSK |= 0x40;
					UCSR0B &= 0x7F;
					UCSR0B |= 0x40;
					F_DIRECT_C_EN = 0;
				}
				gRx1_DStep = 0;
				break;
		}
		return;
	}
	UCSR0B &= 0xBF;
	EIMSK &= 0xBF;
   	for(i = 1; i < 20; i++) gRx1Buf[i-1] = gRx1Buf[i];
   	gRx1Buf[20-1] = gRxData;
    if(F_DOWNLOAD == 0
     && gRx1Buf[20-8] == 0xFF
     && gRx1Buf[20-7] == 0xFF
     && gRx1Buf[20-6] == 0xAA
     && gRx1Buf[20-5] == 0x55
     && gRx1Buf[20-4] == 0xAA
     && gRx1Buf[20-3] == 0x55
     && gRx1Buf[20-2] == 0x37
     && gRx1Buf[20-1] == 0xBA){
		F_DOWNLOAD = 1;
		F_RSV_SOUND_READ = 0;
		F_RSV_BTN_READ = 0;
		(PORTA &= 0xBF);
		gRx1Step = 1;
		UCSR0B |= 0x40;
		EIMSK |= 0x40;
		return;
	}
	switch(gRx1Step){          	
		case 1:
    	    if(gRxData == 11){
    	        gRx1Step = 300;
    	    }
    	    else if(gRxData == 14){
    	        gRx1Step = 600;
    	    }
    	    else if(gRxData == 16){
    	        gRx1Step = 800;
    	    }
    	    else if(gRxData == 17){
    	        gRx1Step = 900;
    	    }
    	    else if(gRxData == 18){
    	        gRx1Step = 1000;
    	    }
    	    else if(gRxData == 20){
    	        gRx1Step = 1200;
    	    }
    	    else if(gRxData == 21){
    	        gRx1Step = 1300;
    	    }
    	    else if(gRxData == 22){
    	        gRx1Step = 1400;
    	    }
    	    else if(gRxData == 23){
    	        gRx1Step = 1500;
    	    }
    	    else if(gRxData == 24){
    	        gRx1Step = 1600;
    	    }
    	    else if(gRxData == 26){
    	        gRx1Step = 1800;
    	    }
    	    else if(gRxData == 31){
    	        gRx1Step = 2300;
    	    }
    	    else{
				gRx1Step = 0;
				F_DOWNLOAD = 0;
				(PORTA |= 0x40);
				break;
			}    	    	
    	    break;
    	case 300:
			U1I_case100();
    	    break;
    	case 301:
			U1I_case301(1);
       	 	break;
    	case 302:
			U1I_case302();
       	 	break;
    	case 303:
    		U1I_case303();
       	 	break;
    	case 600:
			U1I_case100();
    	    break;
    	case 601:
			U1I_case301(16);
       	 	break;
    	case 602:
			U1I_case502(16);
       	 	break;
    	case 603:
    		U1I_case603();
       	 	break;
    	case 800:
			U1I_case100();
    	    break;
    	case 801:
			U1I_case301(1);
       	 	break;
    	case 802:
			U1I_case302();
       	 	break;
    	case 803:
			if(gFileCheckSum == gRxData){
				SendToPC(16,1);
				gFileCheckSum = 0;
				sciTx1Data(0x01);
				gFileCheckSum ^= 0x01;
				sciTx1Data(gFileCheckSum);
				gRx1Step = 0;
				F_DOWNLOAD = 0;
				(PORTA |= 0x40);
			    TIMSK &= 0xFE;
				EIMSK &= 0xBF;
				UCSR0B |= 0x80;
				UCSR0B &= 0xBF;
				F_DIRECT_C_EN = 1;
				(PORTA &= 0xFB);
				(PORTA |= 0x08);
				(PORTA &= 0xEF);
				return;
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			(PORTA |= 0x40);
       	 	break;
    	case 900:
			U1I_case100();
    	    break;
    	case 901:
			U1I_case301(1);
       	 	break;
    	case 902:
			U1I_case302();
       	 	break;
    	case 903:
			if(gFileCheckSum == gRxData){
				SendToPC(17,2);
				gFileCheckSum = 0;
				sciTx1Data(F_ERR_CODE);
				gFileCheckSum ^= F_ERR_CODE;
				sciTx1Data(F_PF);
				gFileCheckSum ^= F_PF;
				sciTx1Data(gFileCheckSum);
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			(PORTA |= 0x40);
       	 	break;
    	case 1000:
			U1I_case100();
    	    break;
    	case 1001:
			U1I_case301(1);
       	 	break;
    	case 1002:
			U1I_case302();
       	 	break;
    	case 1003:
			if(gFileCheckSum == gRxData){
				SendToPC(18,2);
				gFileCheckSum = 0;
				sciTx1Data(9);
				gFileCheckSum ^= 9;
				sciTx1Data(99);
				gFileCheckSum ^= 99;
				sciTx1Data(gFileCheckSum);
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			(PORTA |= 0x40);
       	 	break;
    	case 1200:
			U1I_case100();
    	    break;
    	case 1201:
			U1I_case301(1);
       	 	break;
    	case 1202:
			gFileCheckSum ^= gRxData;
			if(gRxData < 64)
				gRx1Step++;
			else{
				gRx1Step = 0;
				F_DOWNLOAD = 0;
				(PORTA |= 0x40);
			}
       	 	break;
    	case 1203:
			if(gFileCheckSum == gRxData){
				F_RSV_MOTION = 1;
				if(gRx1Buf[20-2] == 0x07)	F_MOTION_STOPPED = 1;
				gRx1Step = 0;
				F_DOWNLOAD = 0;
				(PORTA |= 0x40);
				UCSR0B |= 0x40;
				EIMSK |= 0x40;
				F_IR_RECEIVED = 1;
				gIrBuf[0] = eRCodeH[0];
				gIrBuf[1] = eRCodeM[0];
				gIrBuf[2] = eRCodeL[0];
				gIrBuf[3] = gRx1Buf[20-2];
				return;
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			(PORTA |= 0x40);
       	 	break;
    	case 1300:
			U1I_case100();
    	    break;
    	case 1301:
			U1I_case301(1);
       	 	break;
    	case 1302:
			gFileCheckSum ^= gRxData;
			if(gRxData < 26)
				gRx1Step++;
			else{
			gRx1Step = 0;
				F_DOWNLOAD = 0;
				(PORTA |= 0x40);
			}
       	 	break;
    	case 1303:
			if(gFileCheckSum == gRxData){
				SendToSoundIC(gRx1Buf[20-2]);
				delay_ms(200 + Sound_Length[gRx1Buf[20-2]-1]);
				SendToPC(21,1);
				gFileCheckSum = 0;
				sciTx1Data(gRx1Buf[20-2]);
				gFileCheckSum ^= gRx1Buf[20-2];
				sciTx1Data(gFileCheckSum);
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			(PORTA |= 0x40);
       	 	break;
    	case 1400:
			U1I_case100();
    	    break;
    	case 1401:
			U1I_case301(1);
       	 	break;
    	case 1402:
			U1I_case302();
       	 	break;
    	case 1403:
			if(gFileCheckSum == gRxData){
				F_RSV_PSD_READ = 1;
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			(PORTA |= 0x40);
       	 	break;
    	case 1500:
			U1I_case100();
    	    break;
    	case 1501:
			U1I_case301(2);
       	 	break;
    	case 1502:
			U1I_case502(2);
       	 	break;
    	case 1503:
			if(gFileCheckSum == gRxData){
				gSoundMinTh = gRx1Buf[20-2];
				F_RSV_SOUND_READ = 1;
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			(PORTA |= 0x40);
       	 	break;
    	case 1600:
			U1I_case100();
    	    break;
    	case 1601:
			U1I_case301(1);
       	 	break;
    	case 1602:
			U1I_case302();
       	 	break;
    	case 1603:
			if(gFileCheckSum == gRxData){
				F_RSV_BTN_READ = 1;
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			(PORTA |= 0x40);
       	 	break;
    	case 1800:
			U1I_case100();
    	    break;
    	case 1801:
			U1I_case301(1);
       	 	break;
    	case 1802:
			U1I_case302();
       	 	break;
    	case 1803:
			if(gFileCheckSum == gRxData){
				SendToPC(26,6);
				gFileCheckSum = 0;
				if(gAccX < 0){
	    			sciTx1Data(gAccX);
    				sciTx1Data(0xff);
        	    }
            	else{
	    			sciTx1Data(gAccX);
    				sciTx1Data(0);
        	    }
				gFileCheckSum ^= gAccX;
				if(gAccY < 0){
    				sciTx1Data(gAccY);
	    			sciTx1Data(0xff);
    	        }
        	    else{
    				sciTx1Data(gAccY);
	    			sciTx1Data(0);
    	        }
				gFileCheckSum ^= gAccY;
				if(gAccZ < 0){
	    			sciTx1Data(gAccZ);
    				sciTx1Data(0xff);
        	    }
            	else{
	    			sciTx1Data(gAccZ);
    				sciTx1Data(0);
        	    }
				gFileCheckSum ^= gAccZ;
				sciTx1Data(gFileCheckSum);
			}
			gRx1Step = 0;			// 다운로드 종료
			F_DOWNLOAD = 0;			// 다운로드 중 표시 해제
			(PORTA |= 0x40);			// 연결 상태 LED 표시 해제
       	 	break;
    	case 2300:
			U1I_case100();
    	    break;
    	case 2301:
			U1I_case301(1);
       	 	break;
    	case 2302:
			gFileCheckSum ^= gRxData;
			if(gRxData < 4)
				gRx1Step++;
			else{
				gRx1Step = 0;
				F_DOWNLOAD = 0;
				(PORTA |= 0x40);
			}
       	 	break;
    	case 2303:
			if(gFileCheckSum == gRxData){
				if(gRx1Buf[20-2] == 1){
					gDownNumOfM = 0;
					eNumOfM = 0;
				}
				else if(gRx1Buf[20-2] == 2){
					gDownNumOfA = 0;
					eNumOfA = 0;
				}
				SendToPC(31,1);
				gFileCheckSum = 0;
				sciTx1Data(gRx1Buf[20-2]);
				gFileCheckSum ^= gRx1Buf[20-2];
				sciTx1Data(gFileCheckSum);
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			(PORTA |= 0x40);
       	 	break;
	}
	UCSR0B |= 0x40;
	EIMSK |= 0x40;
}
//------------------------------------------------------------------------------
// 타이머0 오버플로 인터럽트
//------------------------------------------------------------------------------
interrupt [17] void timer0_ovf_isr(void) {
	TCNT0 = 111;
	if(++g10MSEC > 99){
        g10MSEC = 0;
        if(gSEC_DCOUNT > 0)	gSEC_DCOUNT--;
        if(++gSEC > 59){
            gSEC = 0;
	        if(gMIN_DCOUNT > 0)	gMIN_DCOUNT--;
            if(++gMIN > 59){
                gMIN = 0;
                if(++gHOUR > 23)
                    gHOUR = 0;
            }
		}
    }
}
//------------------------------------------------------------------------------
// 타이머1 오버플로 인터럽트
//------------------------------------------------------------------------------
interrupt [15] void timer1_ovf_isr(void) {
	if( gFrameIdx == Scene.NumOfFrame ) {
   	    gFrameIdx = 0;
    	(PORTA |= 0x20);
		F_SCENE_PLAYING = 0;
		TIMSK &= 0xfb;
		TCCR1B = 0x00;
		return;
	}
	TCNT1 = TxInterval;
	TIFR |= 0x04;
	TIMSK |= 0x04;
	MakeFrame();
	SendFrame();
}
//------------------------------------------------------------------------------
// 리모컨 수신용 IR수신 인터럽트
//------------------------------------------------------------------------------
interrupt [8] void ext_int6_isr(void) {
	unsigned char width;
	unsigned int i;
	width = TCNT2;
	TCNT2 = 0;
	if(gIrBitIndex == 0xFF){
		if((width >= 63) && (width <= 81)){
			F_IR_RECEIVED = 0;
			gIrBitIndex = 0;
			for(i = 0; i < 4; i++)
                gIrBuf[i] = 0;
        }
	}
	else{
        if((width >= 10)&&(width <= 18))
            gIrBitIndex++;
        else if((width >= 19)&&(width <= 26)){
            if(gIrBitIndex != 0)
                gIrBuf[(unsigned char)(gIrBitIndex/8)] |= 0x01<<(gIrBitIndex%8);
            else
                gIrBuf[0] = 0x01;
            gIrBitIndex++;
        }
        else gIrBitIndex = 0xFF;
              if(gIrBitIndex == (4 * 8)){
            F_IR_RECEIVED = 1;
            gIrBitIndex = 0xFF;
		}
	}
}
//------------------------------------------------------------------------------
// A/D 변환 완료 인터럽트
//------------------------------------------------------------------------------
interrupt [22] void adc_isr(void) {
	unsigned int i;
	gAD_val=(signed char)ADCH;
	switch(gAD_Ch_Index){
		case 0:
    	    gPSD_val = (unsigned char)gAD_val;
			break; 
		case 1:
			i = (unsigned char)gAD_val;
			gVOLTAGE = i*57;
			break; 
		case 0x0F:
			if((unsigned char)gAD_val < 230)
				gMIC_val = (unsigned char)gAD_val;
			else
				gMIC_val = 0;
			break; 
	}  
	F_AD_CONVERTING = 0;    
}
void ADC_set(unsigned char mode)
{                                    
	ADMUX=0x20 | gAD_Ch_Index;
	ADCSRA=mode;     
}		
//------------------------------------------------------------------------------
// 전원 검사
//------------------------------------------------------------------------------
void DetectPower(void)
{
	if(F_DOWNLOAD) return;
	if(F_PS_PLUGGED){
		if(gVOLTAGE >= 9650	)
			gPSunplugCount = 0;
		else
			gPSunplugCount++;
		if(gPSunplugCount > 6){
			F_PS_PLUGGED = 0;
			gPSunplugCount = 0;
		}
	}
	else{
		if(gVOLTAGE >= 9650	){
			gPSunplugCount = 0;
			gPSplugCount++;
		}
		else{
			gPSplugCount = 0;
		}
		if(gPSplugCount>2){
			F_PS_PLUGGED = 1;
			gPSplugCount = 0;
		}
	}
}
//-----------------------------------------------------------------------------
// NiMH 배터리 충전
//-----------------------------------------------------------------------------
void ChargeNiMH(void)
{
	F_CHARGING = 1;
	gMIN_DCOUNT = 5;
	while(gMIN_DCOUNT){
		(PORTC |= 0x80);
		((*(unsigned char *) 0x65) &= 0xFB);
		Get_VOLTAGE();	DetectPower();
		if(F_PS_PLUGGED == 0) break;
		(PORTB |= 0x10);
		delay_ms(40);
		(PORTB &= 0xEF);
		delay_ms(500-40);
		((*(unsigned char *) 0x65) |= 0x04);
		Get_VOLTAGE();	DetectPower();
		if(F_PS_PLUGGED == 0) break;
		delay_ms(500);
	}
	gMIN_DCOUNT = 85;
	while(gMIN_DCOUNT){
		(PORTC |= 0x80);
		if(g10MSEC > 50)	((*(unsigned char *) 0x65) &= 0xFB);
		else			((*(unsigned char *) 0x65) |= 0x04);
		if(g10MSEC == 0 || g10MSEC == 50){
			Get_VOLTAGE();
			DetectPower();
		}
		if(F_PS_PLUGGED == 0) break;
		(PORTB |= 0x10);
	}
	(PORTB &= 0xEF);
	F_CHARGING = 0;
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
	// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
	// State7=1 State6=T State5=T State4=T State3=T State2=T State1=P State0=P 
	PORTD=0x83;
	DDRD=0x80;
	// Port E initialization
	// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In 
	// State7=T State6=T State5=P State4=P State3=0 State2=T State1=T State0=T 
	PORTE=0x30;
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
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 14.400 kHz
    // Mode: Normal top=FFh
    // OC0 output: Disconnected
    ASSR=0x00;
    TCCR0=0x07;
    TCNT0=0x00;
    OCR0=0x00;
	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: 14.400 kHz
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
    // Mode: Normal top=FFh
    // OC2 output: Disconnected
    TCCR2=0x05;
    TCNT2=0x00;
    OCR2=0x00;
	// 타이머 3---------------------------------------------------------------
	// Timer/Counter 3 initialization
	// Clock source: System Clock
	// Clock value: 230.400 kHz
	// Mode: Normal top=FFFFh
	// Noise Canceler: Off
	// Input Capture on Falling Edge
	// OC3A output: Discon.
	// OC3B output: Discon.
	// OC3C output: Discon.
	// Timer 3 Overflow Interrupt: Off
	// Input Capture Interrupt: Off
	// Compare A Match Interrupt: Off
	// Compare B Match Interrupt: Off
	// Compare C Match Interrupt: Off
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
	// INT6: On
	// INT6 Mode: Falling Edge
	// INT7: Off
	(*(unsigned char *) 0x6a)=0x00;
	EICRB=0x20;
	EIMSK=0x40;
	EIFR=0x40;
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x00;
    (*(unsigned char *) 0x7d)=0x00;
    // USART0 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART0 Receiver: On
    // USART0 Transmitter: On
    // USART0 Mode: Asynchronous
    // USART0 Baud rate: 115200
    UCSR0A=0x00;
	UCSR0B=0x98;
    (*(unsigned char *) 0x95)=0x06;
    (*(unsigned char *) 0x90)=0x00;
	UBRR0L=7 ;
    // USART1 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART1 Receiver: On
    // USART1 Transmitter: On
    // USART1 Mode: Asynchronous
    // USART1 Baud rate: 115200
    (*(unsigned char *) 0x9b)=0x00;
    (*(unsigned char *) 0x9a)=0x98;
    (*(unsigned char *) 0x9d)=0x06;
    (*(unsigned char *) 0x98)=0x00;
	(*(unsigned char *) 0x99)=7 ;
	// Analog Comparator initialization
	// Analog Comparator: Off
	// Analog Comparator Input Capture by Timer/Counter 1: Off
	// Analog Comparator Output: Off
	ACSR=0x80;
	SFIOR=0x00;
    //ADC initialization
    //ADC Clock frequency: 460.800 kHz
    //ADC Voltage Reference: AREF pin
    //Only the 8 most significant bits of
    //the AD conversion result are used
    ADMUX=0x20;
    ADCSRA=0x00;
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
	F_PF = ePF;
	F_SCENE_PLAYING = 0;
	F_ACTION_PLAYING = 0;
	F_MOTION_STOPPED = 0;
	F_DIRECT_C_EN = 0;
	F_CHARGING = 0;
	F_MIC_INPUT = 0;
	F_ERR_CODE = 0xff;
	F_DOWNLOAD = 0;
	gTx0Cnt = 0;
	gTx0BufIdx = 0;
	(PORTB &= 0xDF);
    g10MSEC=0;
    gSEC=0;
    gMIN=0;
    gHOUR=0;
    F_PS_PLUGGED = 0;
    F_PF_CHANGED = 0;
    F_IR_RECEIVED = 0;
    F_EEPROM_BUSY = 0;
	if(1) (PORTB |= 0x04);else (PORTB &= 0xFB);
	gDownNumOfM = 0;
	gDownNumOfA = 0;
	F_FIRST_M = 1;
}
void SpecialMode(void)
{
	int i;
	if(F_PF == 1)
		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	else if(F_PF == 2)
		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	else if(F_PF == 3)
		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	else if(F_PF == 4)
		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	BreakModeCmdSend();
	delay_ms(10);
		if(PINA.0 == 0 && PINA.1 == 1){
		BasicPose(0, 150, 3000, 4);
		delay_ms(100);
		if(F_ERR_CODE != 0xff){
			gSEC_DCOUNT = 30;
			EIMSK &= 0xBF;
			while(gSEC_DCOUNT){
				if(g10MSEC < 25)		(PORTA &= 0x7F);
				else if(g10MSEC < 50)	(PORTA |= 0x80);
				else if(g10MSEC < 75)	(PORTA &= 0x7F);
				else if(g10MSEC < 100)	(PORTA |= 0x80);
			}
			F_ERR_CODE = 0xff;
			EIMSK |= 0x40;
		}
		else BasicPose(0, 1, 100, 1);
	}
	else if(PINA.0 == 1 && PINA.1 == 0){
		delay_ms(10);
		if(PINA.0 == 1){
		    TIMSK &= 0xFE;
			EIMSK &= 0xBF;
			UCSR0B |= 0x80;
			UCSR0B &= 0xBF;
			F_DIRECT_C_EN = 1;
		}
	}
	else if(PINA.0 == 0 && PINA.1 == 0){
		while(gSEC < 11){
			if(g10MSEC > 50){	(PORTA |= 0x20);	(PORTA |= 0x40);	}
			else{				(PORTA &= 0xDF);	(PORTA &= 0xBF);	}
			if(F_IR_RECEIVED){
			    EIMSK &= 0xBF;
				F_IR_RECEIVED = 0;
				if(gIrBuf[3] == 0x07		){
					for(i = 1; i < 5; i++){
						eRCodeH[i-1] = eRCodeH[i];
						eRCodeM[i-1] = eRCodeM[i];
						eRCodeL[i-1] = eRCodeL[i];
					}
					eRCodeH[5-1] = gIrBuf[0]; 
					eRCodeM[5-1] = gIrBuf[1]; 
					eRCodeL[5-1] = gIrBuf[2];
					for(i = 0; i < 3; i++){
						(PORTA &= 0xFB); (PORTA &= 0xF7); (PORTA &= 0xEF); (PORTA &= 0xDF); 
						(PORTA &= 0xBF); (PORTA &= 0x7F); ((*(unsigned char *) 0x65) &= 0xFB); (PORTC &= 0x7F);
						delay_ms(500);
						(PORTA |= 0x04); (PORTA |= 0x08); (PORTA |= 0x10); (PORTA |= 0x20); 
						(PORTA |= 0x40); (PORTA |= 0x80); ((*(unsigned char *) 0x65) |= 0x04); (PORTC &= 0x7F);
						delay_ms(500);
					}
					for(i = 0; i < 4; i++)	gIrBuf[i]=0;
				    EIMSK |= 0x40;
					break;
				}
				for(i = 0; i < 4; i++)	gIrBuf[i]=0;
			    EIMSK |= 0x40;
			}
		}
	}
}
void ProcComm(void)
{
	unsigned char	lbtmp;
	if(F_RSV_PSD_READ){
		F_RSV_PSD_READ = 0;
		Get_AD_PSD();
		SendToPC(22,2);
		gFileCheckSum = 0;
		sciTx1Data(gDistance);
		sciTx1Data(0);
		gFileCheckSum ^= gDistance;
		sciTx1Data(gFileCheckSum);
	}
	if(F_RSV_SOUND_READ){
		Get_AD_MIC();
		if(gSoundMinTh <= gSoundLevel){
			SendToPC(23,2);
			gFileCheckSum = 0;
			sciTx1Data(gSoundLevel);
			sciTx1Data(0);
			gFileCheckSum ^= gSoundLevel;
			sciTx1Data(gFileCheckSum);
		}
	}
	if(F_RSV_BTN_READ){
		lbtmp = PINA & 0x03;
		if(lbtmp == 0x02){	
			delay_ms(30);
			if(lbtmp == 0x02){
				SendToPC(24,2);
				gFileCheckSum = 0;
				sciTx1Data(1);
				sciTx1Data(0);
				gFileCheckSum ^= 1;
				sciTx1Data(gFileCheckSum);
				delay_ms(200);
			}
		}
		else if(lbtmp == 0x01){
			delay_ms(30);
			if(lbtmp == 0x01){
				SendToPC(24,2);
				gFileCheckSum = 0;
				sciTx1Data(2);
				sciTx1Data(0);
				gFileCheckSum ^= 2;
				sciTx1Data(gFileCheckSum);
				delay_ms(200);
			}
		}
	}
}
//------------------------------------------------------------------------------
// 메인 함수
//------------------------------------------------------------------------------
void main(void) {
	unsigned int    l10MSEC;
	HW_init();
	SW_init();
	Acc_init();
	#asm("sei");
	TIMSK |= 0x01;
	SpecialMode();
	if(0) (PORTB |= 0x40);else (PORTB &= 0xBF);
	delay_ms(20);
	if(1) (PORTB |= 0x40);else (PORTB &= 0xBF);
	SelfTest1();
	while(1){
		ReadButton();
		ProcButton();
		IoUpdate();
		if(g10MSEC == 0 || g10MSEC == 50){
			if(g10MSEC != l10MSEC){
				l10MSEC = g10MSEC;
				Get_VOLTAGE();
				DetectPower();
			}
		}
		ProcIr();
		AccGetData();
		ProcComm();
	}
}
