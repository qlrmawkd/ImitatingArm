//==============================================================================
//	 RoboBuilder MainController
//==============================================================================
#include <mega128.h>
#include <stdio.h>
#include <delay.h>

#include "Macro.h"
#include "Main.h"
#include "Comm.h"
#include "Dio.h"
#include "Adc.h"
#include "math.h"
#include "accel.h"

BYTE	F_PF;
BYTE	F_ERR_CODE;
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
BYTE	F_EEPROM_BUSY;

char	gTx0Buf[TX0_BUF_SIZE];
BYTE	gTx0Cnt;
BYTE	gRx0Cnt;
BYTE	gTx0BufIdx;
char	gRx0Buf[RX0_BUF_SIZE];
char	gRx1Buf[RX1_BUF_SIZE];
WORD	gRx1Step;
WORD	gRx1_DStep;
WORD	gFieldIdx;
BYTE	gFileCheckSum;
BYTE	gRxData;

WORD	gPF1BtnCnt;
WORD	gPF2BtnCnt;
WORD	gPF12BtnCnt;
BYTE	gBtn_val;

WORD    g10MSEC;
BYTE    gSEC;
BYTE    gMIN;
BYTE    gHOUR;
WORD	gSEC_DCOUNT;
WORD	gMIN_DCOUNT;

WORD    gPSplugCount;
WORD    gPSunplugCount;
WORD	gPwrLowCount;

char	gIrBuf[IR_BUFFER_SIZE];
BYTE	gIrBitIndex = 0;

signed char	gAccX;
signed char	gAccY;
signed char	gAccZ;

BYTE	gSoundMinTh;

int		gFrameIdx = 0;
WORD	TxInterval = 0;
float	gUnitD[MAX_wCK];
BYTE	gLastID;
BYTE flash	*gpT_Table;
BYTE flash	*gpE_Table;
BYTE flash	*gpPg_Table;
BYTE flash	*gpDg_Table;
BYTE flash	*gpIg_Table;
WORD flash	*gpFN_Table;
WORD flash	*gpRT_Table;
BYTE flash	*gpPos_Table;


BYTE flash	StandardZeroPos[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
125,202,162, 66,108,124, 48, 88,184,142, 90, 40,125,161,210,127};

BYTE flash	U_Boundary_Huno[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
174,228,254,130,185,254,180,126,208,208,254,224,198,254,228,254};

BYTE flash	L_Boundary_Huno[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
  1, 70,124, 40, 41, 73, 22,  1,120, 57,  1, 23,  1,  1, 25, 40};

BYTE flash	U_Boundary_Dino[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
174,228,254,130,185,254,185,126,208,230,254,254,205,254,254,254};

BYTE flash	L_Boundary_Dino[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
  1, 75,124, 40, 41, 73, 22,  1,120, 45,  1,  1, 25,  1, 45, 45};

BYTE flash	U_Boundary_Dogy[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
254,225,225,210,254,254,225,185,203,205,254,230,205,254,230,254};

BYTE flash	L_Boundary_Dogy[16]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
  1, 25, 25, 25, 45,  1, 25, 82,  5,  1,  1, 20,  1,  1, 17, 40};

struct TwCK_in_Motion{
	BYTE	Exist;
	BYTE	RPgain;
	BYTE	RDgain;
	BYTE	RIgain;
	BYTE	PortEn;
	BYTE	InitPos;
};

struct TwCK_in_Scene{
	BYTE	Exist;
	BYTE	SPos;
	BYTE	DPos;
	BYTE	Torq;
	BYTE	ExPortD;
};

struct TMotion{
	BYTE	RIdx;
	DWORD	AIdx;
	BYTE	PF;
	WORD	NumOfScene;
	WORD	NumOfwCK;
	struct	TwCK_in_Motion  wCK[MAX_wCK];
	WORD	FileSize;
}Motion;

struct TScene{
	WORD	Idx;
	WORD	NumOfFrame;
	WORD	RTime;
	struct	TwCK_in_Scene   wCK[MAX_wCK];
}Scene;

WORD	gScIdx;

eeprom  char    eData[13];
eeprom	BYTE	eRCodeH[NUM_OF_REMOCON];
eeprom	BYTE	eRCodeM[NUM_OF_REMOCON];
eeprom	BYTE	eRCodeL[NUM_OF_REMOCON];
eeprom	BYTE	eM_OriginPose[NUM_OF_WCK_HUNO]={
/* ID
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 */
124,202,162, 65,108,125, 46, 88,184,142, 90, 40,125,161,210,126};

int		gPoseDelta[31];
eeprom	BYTE	ePF = 1;

eeprom  BYTE    eNumOfM = 0;
eeprom  BYTE    eNumOfA = 0;
eeprom  WORD    eM_Addr[20];
eeprom  WORD    eM_FSize[20];
eeprom  WORD    eA_Addr[10];
eeprom  WORD    eA_FSize[10];

BYTE    gDownNumOfM;
BYTE    gDownNumOfA;

WORD Sound_Length[25]={
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


void U1I_case301(BYTE LC)
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
			RUN_LED2_OFF;
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
		RUN_LED2_OFF;
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
	RUN_LED2_OFF;
}


void U1I_case502(BYTE LC)
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
		F_ERR_CODE = NO_ERR;
		for(i = 0; i < 16; i++){
			if((StandardZeroPos[i]+15) < gRx1Buf[RX1_BUF_SIZE-17+i]
			 ||(StandardZeroPos[i]-15) > gRx1Buf[RX1_BUF_SIZE-17+i]){
				F_ERR_CODE = ZERO_SET_ERR;
				break;
			}
		}
		if(F_ERR_CODE == NO_ERR){
			for(i = 0; i < 16; i++)
				eM_OriginPose[i] = gRx1Buf[RX1_BUF_SIZE-17+i];

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
	RUN_LED2_OFF;
}


void U1I_case703(void)
{
	WORD    lwtmp;
	BYTE	lbtmp;

	if(gFileCheckSum == gRxData){
		if(gDownNumOfM == 0){
			if(gRx1Buf[RX1_BUF_SIZE-2] == 1)
				lwtmp = 0x6000;
			else if(gRx1Buf[RX1_BUF_SIZE-2] == 2)
				lwtmp = 0x2000;
		}
		else{
			if(gRx1Buf[RX1_BUF_SIZE-2] == 1){
				lwtmp = eM_Addr[gDownNumOfM-1] + eM_FSize[gDownNumOfM-1];
				lwtmp = lwtmp + 64 - (eM_FSize[gDownNumOfM-1]%64);
				lwtmp = 0x6000 - lwtmp;
			}
			else if(gRx1Buf[RX1_BUF_SIZE-2] == 2){
				lwtmp = eA_Addr[gDownNumOfA-1] + eA_FSize[gDownNumOfA-1];
				lwtmp = lwtmp + 64 - (eA_FSize[gDownNumOfA-1]%64);
				lwtmp = 0x8000 - lwtmp;
			}
		}
		SendToPC(15,4);
		gFileCheckSum = 0;
		sciTx1Data(0x00);
		sciTx1Data(0x00);
		lbtmp = (BYTE)((lwtmp>>8) & 0xFF);
		sciTx1Data(lbtmp);
		gFileCheckSum ^= lbtmp;
		lbtmp = (BYTE)(lwtmp & 0xFF);
		sciTx1Data(lbtmp);
		gFileCheckSum ^= lbtmp;
		sciTx1Data(gFileCheckSum);
	}
	gRx1Step = 0;
	F_DOWNLOAD = 0;
	RUN_LED2_OFF;
}


//------------------------------------------------------------------------------
// UART0 송신 인터럽트(패킷 송신용)
//------------------------------------------------------------------------------
interrupt [USART0_TXC] void usart0_tx_isr(void)
{
	if(gTx0BufIdx < gTx0Cnt){
		while(!(UCSR0A & DATA_REGISTER_EMPTY));
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
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
	int		i;
	char	data;
	data = UDR0;
	if(F_DIRECT_C_EN){
		while ( (UCSR1A & DATA_REGISTER_EMPTY) == 0 );
		UDR1 = data;
		return;
	}
	gRx0Cnt++;
	for(i = 1; i < RX0_BUF_SIZE; i++) gRx0Buf[i-1] = gRx0Buf[i];
	gRx0Buf[RX0_BUF_SIZE-1] = data;
}


//------------------------------------------------------------------------------
// UART1 수신 인터럽트(RF모듈, PC에서 받은 신호)
//------------------------------------------------------------------------------
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
    WORD    i;
    
    gRxData = UDR1;
	if(F_DIRECT_C_EN){
		while( (UCSR0A & DATA_REGISTER_EMPTY) == 0 );
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

   	for(i = 1; i < RX1_BUF_SIZE; i++) gRx1Buf[i-1] = gRx1Buf[i];
   	gRx1Buf[RX1_BUF_SIZE-1] = gRxData;

    if(F_DOWNLOAD == 0
     && gRx1Buf[RX1_BUF_SIZE-8] == 0xFF
     && gRx1Buf[RX1_BUF_SIZE-7] == 0xFF
     && gRx1Buf[RX1_BUF_SIZE-6] == 0xAA
     && gRx1Buf[RX1_BUF_SIZE-5] == 0x55
     && gRx1Buf[RX1_BUF_SIZE-4] == 0xAA
     && gRx1Buf[RX1_BUF_SIZE-3] == 0x55
     && gRx1Buf[RX1_BUF_SIZE-2] == 0x37
     && gRx1Buf[RX1_BUF_SIZE-1] == 0xBA){
		F_DOWNLOAD = 1;
		F_RSV_SOUND_READ = 0;
		F_RSV_BTN_READ = 0;
		RUN_LED2_ON;
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
    	    else if(gRxData == 15){
    	        gRx1Step = 700;
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
				RUN_LED2_OFF;
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
    	case 700:
			U1I_case100();
    	    break;
    	case 701:
			U1I_case301(1);
       	 	break;
    	case 702:
    		gFileCheckSum ^= gRxData;
			if(gRxData == 1 || gRxData == 2){
				gRx1Step = 703;
			}
			else{
				gRx1Step = 0;
				F_DOWNLOAD = 0;
				RUN_LED2_OFF;
			}
       	 	break;
    	case 703:
    		U1I_case703();
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
				RUN_LED2_OFF;
			    TIMSK &= 0xFE;
				EIMSK &= 0xBF;
				UCSR0B |= 0x80;
				UCSR0B &= 0xBF;
				F_DIRECT_C_EN = 1;
				PF1_LED1_ON;
				PF1_LED2_OFF;
				PF2_LED_ON;
				return;
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			RUN_LED2_OFF;
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
			RUN_LED2_OFF;
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
			RUN_LED2_OFF;
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
				RUN_LED2_OFF;
			}
       	 	break;
    	case 1203:
			if(gFileCheckSum == gRxData){
				F_RSV_MOTION = 1;
				if(gRx1Buf[RX1_BUF_SIZE-2] == 0x07)	F_MOTION_STOPPED = 1;
				gRx1Step = 0;
				F_DOWNLOAD = 0;
				RUN_LED2_OFF;
				UCSR0B |= 0x40;
				EIMSK |= 0x40;
				F_IR_RECEIVED = 1;
				gIrBuf[0] = eRCodeH[0];
				gIrBuf[1] = eRCodeM[0];
				gIrBuf[2] = eRCodeL[0];
				gIrBuf[3] = gRx1Buf[RX1_BUF_SIZE-2];
				return;
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			RUN_LED2_OFF;
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
				RUN_LED2_OFF;
			}
       	 	break;
    	case 1303:
			if(gFileCheckSum == gRxData){
				SendToSoundIC(gRx1Buf[RX1_BUF_SIZE-2]);
				delay_ms(200 + Sound_Length[gRx1Buf[RX1_BUF_SIZE-2]-1]);
				SendToPC(21,1);
				gFileCheckSum = 0;
				sciTx1Data(gRx1Buf[RX1_BUF_SIZE-2]);
				gFileCheckSum ^= gRx1Buf[RX1_BUF_SIZE-2];
				sciTx1Data(gFileCheckSum);
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			RUN_LED2_OFF;
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
			RUN_LED2_OFF;
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
				gSoundMinTh = gRx1Buf[RX1_BUF_SIZE-2];
				F_RSV_SOUND_READ = 1;
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			RUN_LED2_OFF;
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
			RUN_LED2_OFF;
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
			RUN_LED2_OFF;			// 연결 상태 LED 표시 해제
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
				RUN_LED2_OFF;
			}
       	 	break;
    	case 2303:
			if(gFileCheckSum == gRxData){
				if(gRx1Buf[RX1_BUF_SIZE-2] == 1){
					gDownNumOfM = 0;
					eNumOfM = 0;
				}
				else if(gRx1Buf[RX1_BUF_SIZE-2] == 2){
					gDownNumOfA = 0;
					eNumOfA = 0;
				}
				SendToPC(31,1);
				gFileCheckSum = 0;
				sciTx1Data(gRx1Buf[RX1_BUF_SIZE-2]);
				gFileCheckSum ^= gRx1Buf[RX1_BUF_SIZE-2];
				sciTx1Data(gFileCheckSum);
			}
			gRx1Step = 0;
			F_DOWNLOAD = 0;
			RUN_LED2_OFF;
       	 	break;
	}
	UCSR0B |= 0x40;
	EIMSK |= 0x40;
}


//------------------------------------------------------------------------------
// 타이머0 오버플로 인터럽트
//------------------------------------------------------------------------------
interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
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
interrupt [TIM1_OVF] void timer1_ovf_isr(void) {
	if( gFrameIdx == Scene.NumOfFrame ) {
   	    gFrameIdx = 0;
    	RUN_LED1_OFF;
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
interrupt [EXT_INT6] void ext_int6_isr(void) {
	BYTE width;
	WORD i;

	width = TCNT2;
	TCNT2 = 0;

	if(gIrBitIndex == 0xFF){
		if((width >= IR_HEADER_LT) && (width <= IR_HEADER_UT)){
			F_IR_RECEIVED = 0;
			gIrBitIndex = 0;
			for(i = 0; i < IR_BUFFER_SIZE; i++)
                gIrBuf[i] = 0;
        }
	}
	else{
        if((width >= IR_LOW_BIT_LT)&&(width <= IR_LOW_BIT_UT))
            gIrBitIndex++;
        else if((width >= IR_HIGH_BIT_LT)&&(width <= IR_HIGH_BIT_UT)){
            if(gIrBitIndex != 0)
                gIrBuf[(BYTE)(gIrBitIndex/8)] |= 0x01<<(gIrBitIndex%8);
            else
                gIrBuf[0] = 0x01;
            gIrBitIndex++;
        }
        else gIrBitIndex = 0xFF;
      
        if(gIrBitIndex == (IR_BUFFER_SIZE * 8)){
            F_IR_RECEIVED = 1;
            gIrBitIndex = 0xFF;
		}
	}
}


//------------------------------------------------------------------------------
// A/D 변환 완료 인터럽트
//------------------------------------------------------------------------------
interrupt [ADC_INT] void adc_isr(void) {
	WORD i;
	gAD_val=(signed char)ADCH;
	switch(gAD_Ch_Index){
		case PSD_CH:
    	    gPSD_val = (BYTE)gAD_val;
			break; 
		case VOLTAGE_CH:
			i = (BYTE)gAD_val;
			gVOLTAGE = i*57;
			break; 
		case MIC_CH:
			if((BYTE)gAD_val < 230)
				gMIC_val = (BYTE)gAD_val;
			else
				gMIC_val = 0;
			break; 
	}  
	F_AD_CONVERTING = 0;    
}


void ADC_set(BYTE mode)
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
		if(gVOLTAGE >= U_T_OF_POWER)
			gPSunplugCount = 0;
		else
			gPSunplugCount++;
		if(gPSunplugCount > 6){
			F_PS_PLUGGED = 0;
			gPSunplugCount = 0;
		}
	}
	else{
		if(gVOLTAGE >= U_T_OF_POWER){
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
		PWR_LED2_OFF;
		PWR_LED1_ON;
		Get_VOLTAGE();	DetectPower();
		if(F_PS_PLUGGED == 0) break;
		CHARGE_ENABLE;
		delay_ms(40);
		CHARGE_DISABLE;
		delay_ms(500-40);
		PWR_LED1_OFF;
		Get_VOLTAGE();	DetectPower();
		if(F_PS_PLUGGED == 0) break;
		delay_ms(500);
	}
	gMIN_DCOUNT = 85;
	while(gMIN_DCOUNT){
		PWR_LED2_OFF;
		if(g10MSEC > 50)	PWR_LED1_ON;
		else			PWR_LED1_OFF;
		if(g10MSEC == 0 || g10MSEC == 50){
			Get_VOLTAGE();
			DetectPower();
		}
		if(F_PS_PLUGGED == 0) break;
		CHARGE_ENABLE;
	}
	CHARGE_DISABLE;
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
    PORTF=0x00;
    DDRF=0x00;

	// Port G initialization
	// Func4=In Func3=In Func2=Out Func1=In Func0=In 
	// State4=T State3=T State2=0 State1=T State0=T 
	PORTG=0x00;
	DDRG=0x04;

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
	OCR1CH=0x00;
	OCR1CL=0x00;

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
	// INT6: On
	// INT6 Mode: Falling Edge
	// INT7: Off
	EICRA=0x00;
	EICRB=0x20;
	EIMSK=0x40;
	EIFR=0x40;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x00;
    ETIMSK=0x00;

    // USART0 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART0 Receiver: On
    // USART0 Transmitter: On
    // USART0 Mode: Asynchronous
    // USART0 Baud rate: 115200
    UCSR0A=0x00;
	UCSR0B=0x98;
    UCSR0C=0x06;
    UBRR0H=0x00;
	UBRR0L=BR115200;

    // USART1 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART1 Receiver: On
    // USART1 Transmitter: On
    // USART1 Mode: Asynchronous
    // USART1 Baud rate: 115200
    UCSR1A=0x00;
    UCSR1B=0x98;
    UCSR1C=0x06;
    UBRR1H=0x00;
	UBRR1L=BR115200;

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
    ADMUX=ADC_VREF_TYPE;
    ADCSRA=0x00;
    
    TWCR = 0;
}


//------------------------------------------------------------------------------
// 플래그 초기화
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
	F_PF = ePF;
	F_SCENE_PLAYING = 0;
	F_ACTION_PLAYING = 0;
	F_MOTION_STOPPED = 0;
	F_DIRECT_C_EN = 0;
	F_CHARGING = 0;
	F_MIC_INPUT = 0;
	F_ERR_CODE = NO_ERR;
	F_DOWNLOAD = 0;

	gTx0Cnt = 0;
	gTx0BufIdx = 0;
	PSD_OFF;
    g10MSEC=0;
    gSEC=0;
    gMIN=0;
    gHOUR=0;
    F_PS_PLUGGED = 0;
    F_PF_CHANGED = 0;
    F_IR_RECEIVED = 0;
    F_EEPROM_BUSY = 0;
	P_EEP_VCC(1);

	gDownNumOfM = 0;
	gDownNumOfA = 0;
	F_FIRST_M = 1;
}


void SpecialMode(void)
{
	int i;

	if(F_PF == PF1_HUNO)
		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	else if(F_PF == PF1_DINO)
		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	else if(F_PF == PF1_DOGY)
		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);
	else if(F_PF == PF2)
		for(i = 0; i < 16; i++) BoundSetCmdSend(i, 1, 254);

	BreakModeCmdSend();
	delay_ms(10);
	
	if(PINA.0 == 0 && PINA.1 == 1){
		BasicPose(0, 150, 3000, 4);
		delay_ms(100);
		if(F_ERR_CODE != NO_ERR){
			gSEC_DCOUNT = 30;
			EIMSK &= 0xBF;
			while(gSEC_DCOUNT){
				if(g10MSEC < 25)		ERR_LED_ON;
				else if(g10MSEC < 50)	ERR_LED_OFF;
				else if(g10MSEC < 75)	ERR_LED_ON;
				else if(g10MSEC < 100)	ERR_LED_OFF;
			}
			F_ERR_CODE = NO_ERR;
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
			if(g10MSEC > 50){	RUN_LED1_OFF;	RUN_LED2_OFF;	}
			else{				RUN_LED1_ON;	RUN_LED2_ON;	}
			if(F_IR_RECEIVED){
			    EIMSK &= 0xBF;
				F_IR_RECEIVED = 0;
				if(gIrBuf[3] == BTN_C){
					for(i = 1; i < NUM_OF_REMOCON; i++){
						eRCodeH[i-1] = eRCodeH[i];
						eRCodeM[i-1] = eRCodeM[i];
						eRCodeL[i-1] = eRCodeL[i];
					}
					eRCodeH[NUM_OF_REMOCON-1] = gIrBuf[0]; 
					eRCodeM[NUM_OF_REMOCON-1] = gIrBuf[1]; 
					eRCodeL[NUM_OF_REMOCON-1] = gIrBuf[2];

					for(i = 0; i < 3; i++){
						PF1_LED1_ON; PF1_LED2_ON; PF2_LED_ON; RUN_LED1_ON; 
						RUN_LED2_ON; ERR_LED_ON; PWR_LED1_ON; PWR_LED2_ON;
						delay_ms(500);
						PF1_LED1_OFF; PF1_LED2_OFF; PF2_LED_OFF; RUN_LED1_OFF; 
						RUN_LED2_OFF; ERR_LED_OFF; PWR_LED1_OFF; PWR_LED2_ON;
						delay_ms(500);
					}

					for(i = 0; i < IR_BUFFER_SIZE; i++)	gIrBuf[i]=0;
				    EIMSK |= 0x40;
					break;
				}
				for(i = 0; i < IR_BUFFER_SIZE; i++)	gIrBuf[i]=0;
			    EIMSK |= 0x40;
			}
		}
	}
}

void Robot_Turn_Left_90(void)
{
    M_Play(BTN_LR);M_Play(BTN_LR);M_Play(BTN_LR);
}

void Robot_Turn_Left_180(void)
{
    M_Play(BTN_LR);M_Play(BTN_LR);M_Play(BTN_LR);
    M_Play(BTN_LR);M_Play(BTN_LR);
}

void Robot_Turn_Right_90(void)
{
    M_Play(BTN_RR);M_Play(BTN_RR);M_Play(BTN_RR);M_Play(BTN_LR);
}

void User_Func(void)
{
    #define LEFT     0
    #define CENTER   1
    #define RIGHT    2
    
    BYTE Obstacle_State=0;
    
    while(1)
    {
        Get_AD_PSD();
        if( gDistance <= 12 ){
            M_Play(BTN_D);
        }
        else if( gDistance <= 30 ){
            Obstacle_State |= (1<<CENTER);
            Robot_Turn_Left_90();
            Get_AD_PSD();
            if((gDistance <= 30))
            {    Obstacle_State |= (1<<LEFT);
                 Robot_Turn_Left_180();
                 Get_AD_PSD();
                 if((gDistance <= 30))
                 {    Obstacle_State |= (1<<RIGHT);
                      Robot_Turn_Right_90();
                 }
            }
        }
        else{   M_Play(BTN_U);M_Play(BTN_RR);M_Play(BTN_U);
                Obstacle_State = 0;
        }
    }

}
//------------------------------------------------------------------------------
// 메인 함수
//------------------------------------------------------------------------------
void main(void) {
	WORD    l10MSEC;
	BYTE	lbtmp;

	HW_init();
	SW_init();
	Acc_init();

	#asm("sei");
	TIMSK |= 0x01;

	SpecialMode();

	P_BMC504_RESET(0);
	delay_ms(20);
	P_BMC504_RESET(1);

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
}
//==============================================================================
//						Communication & Command 함수들
//==============================================================================

#include <mega128.h>
#include <string.h>
#include "Main.h"
#include "Macro.h"
#include "Comm.h"
#include "HunoBasic_080819.h"
#include "DinoBasic_2.h"
#include "DogyBasic_2.h"
#include "my_demo1.h"	// 사용자 모션 파일


BYTE flash fM1_BasicPose[16]={
/* ID
 0 ,1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9  , 10, 11, 12, 13, 14, 15 */
125,179,199, 88,108,126, 72, 49,163,141, 51, 47, 49,199,205,205};

BYTE flash fM2_BasicPose[16]={
/* ID
 0 ,1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9  , 10, 11, 12, 13, 14, 15 */
125,179,199, 88,108,126, 72, 49,163,141, 89,127, 47,159,112,171};

BYTE flash fM3_BasicPose[16]={
/* ID
 0 ,1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9  , 10, 11, 12, 13, 14, 15 */
159,209,127,127,200, 91, 41,127,127, 52,143, 39, 52,109,210,200};


//------------------------------------------------------------------------------
// 시리얼 포트로 한 문자를 전송하기 위한 함수
//------------------------------------------------------------------------------
void sciTx0Data(BYTE td)
{
	while(!(UCSR0A & DATA_REGISTER_EMPTY));
	UDR0 = td;
}

void sciTx1Data(BYTE td)
{
	while(!(UCSR1A & DATA_REGISTER_EMPTY));
	UDR1 = td;
}


//------------------------------------------------------------------------------
// 시리얼 포트로 한 문자를 받을때까지 대기하기 위한 함수
//------------------------------------------------------------------------------
BYTE sciRx0Ready(void)
{
	WORD	startT;

	startT = g10MSEC;
	while(!(UCSR0A & RX_COMPLETE)){
        if(g10MSEC < startT){
            if((100 - startT + g10MSEC) > RX_T_OUT) break;
        }
		else if((g10MSEC-startT) > RX_T_OUT) break;
	}
	return UDR0;
}

BYTE sciRx1Ready(void)
{
	WORD	startT;

	startT = g10MSEC;
	while(!(UCSR1A & RX_COMPLETE)){
        if(g10MSEC < startT){
            if((100 - startT + g10MSEC) > RX_T_OUT) break;
        }
		else if((g10MSEC-startT) > RX_T_OUT) break;
	}
	return UDR1;
}


//------------------------------------------------------------------------------
// wCK에게 동작 명령 패킷(4바이트)을 보내는 함수                                                                     */
//------------------------------------------------------------------------------
void SendOperCmd(BYTE Data1,BYTE Data2)
{
	BYTE CheckSum; 
	CheckSum = (Data1^Data2)&0x7f;

	gTx0Buf[gTx0Cnt] = HEADER;
	gTx0Cnt++;

	gTx0Buf[gTx0Cnt] = Data1;
	gTx0Cnt++;

	gTx0Buf[gTx0Cnt] = Data2;
	gTx0Cnt++;

	gTx0Buf[gTx0Cnt] = CheckSum;
	gTx0Cnt++;

}


//------------------------------------------------------------------------------
// wCK의 파라미터를 설정할 때 사용한다
//------------------------------------------------------------------------------
void SendSetCmd(BYTE ID, BYTE Data1, BYTE Data2, BYTE Data3)
{
	BYTE	CheckSum; 

	ID = (BYTE)(7<<5)|ID; 
	CheckSum = (ID^Data1^Data2^Data3)&0x7f;

	gTx0Buf[gTx0Cnt] = HEADER;
	gTx0Cnt++;

	gTx0Buf[gTx0Cnt] = ID;
	gTx0Cnt++;

	gTx0Buf[gTx0Cnt] = Data1;
	gTx0Cnt++;

	gTx0Buf[gTx0Cnt] = Data2;
	gTx0Cnt++;

	gTx0Buf[gTx0Cnt] = Data3;
	gTx0Cnt++;

	gTx0Buf[gTx0Cnt] = CheckSum;
	gTx0Cnt++;
}


//------------------------------------------------------------------------------
// 위치 명령(Position Send Command)을 보내는 함수
//------------------------------------------------------------------------------
void PosSend(BYTE ID, BYTE Position, BYTE SpeedLevel) 
{
	BYTE Data1;

	Data1 = (SpeedLevel<<5) | ID;
	SendOperCmd(Data1,Position);
}


//------------------------------------------------------------------------------
// 브레이크 모드 명령을 보내는 함수
//------------------------------------------------------------------------------
void BreakModeCmdSend(void)
{
	BYTE	Data1, Data2;
	BYTE	CheckSum; 

	Data1 = (6<<5) | 31;
	Data2 = 0x20;
	CheckSum = (Data1^Data2)&0x7f;

	sciTx0Data(HEADER);
	sciTx0Data(Data1);
	sciTx0Data(Data2);
	sciTx0Data(CheckSum);
} 


//------------------------------------------------------------------------------
// 이동범위 설정 명령을 보내는 함수
//------------------------------------------------------------------------------
void BoundSetCmdSend(BYTE ID, BYTE B_L, BYTE B_U)
{
	BYTE	Data1, Data2;
	BYTE	CheckSum; 

	Data1 = (7<<5) | ID;
	Data2 = 17;
	CheckSum = (Data1^Data2^B_U^B_L)&0x7f;

	sciTx0Data(HEADER);
	sciTx0Data(Data1);
	sciTx0Data(Data2);
	sciTx0Data(B_L);
	sciTx0Data(B_U);
	sciTx0Data(CheckSum);
}

//------------------------------------------------------------------------------
// 위치 읽기 명령(Position Send Command)을 보내는 함수
//------------------------------------------------------------------------------
WORD PosRead(BYTE ID) 
{
	BYTE	Data1, Data2;
	BYTE	CheckSum; 
	WORD	startT;

	Data1 = (5<<5) | ID;
	Data2 = 0;
	gRx0Cnt = 0;
	CheckSum = (Data1^Data2)&0x7f;
	RX0_OFF;
	sciTx0Data(HEADER);
	sciTx0Data(Data1);
	sciTx0Data(Data2);
	sciTx0Data(CheckSum);
	RX0_ON;
	startT = g10MSEC;
	while(gRx0Cnt < 2){
        if(g10MSEC < startT){
            if((100 - startT + g10MSEC) > RX_T_OUT)
            	return 444;
        }
		else if((g10MSEC - startT) > RX_T_OUT) return 444;
	}
	return (WORD)gRx0Buf[RX0_BUF_SIZE - 1];
} 


//------------------------------------------------------------------------------
// 사운드 칩에게 명령 보내는 함수
//------------------------------------------------------------------------------
void SendToSoundIC(BYTE cmd) 
{
	BYTE	CheckSum; 

	gRx0Cnt = 0;
	CheckSum = (29^cmd)&0x7f;
	sciTx0Data(HEADER);
	delay_ms(1);
	sciTx0Data(29);
	delay_ms(1);
	sciTx0Data(cmd);
	delay_ms(1);
	sciTx0Data(CheckSum);
} 


//------------------------------------------------------------------------------
// PC와 통신할 때 사용
//------------------------------------------------------------------------------
void SendToPC(BYTE Cmd, BYTE CSize)
{
	sciTx1Data(0xFF);
	sciTx1Data(0xFF);
	sciTx1Data(0xAA);
	sciTx1Data(0x55);
	sciTx1Data(0xAA);
	sciTx1Data(0x55);
	sciTx1Data(0x37);
	sciTx1Data(0xBA);
	sciTx1Data(Cmd);
	sciTx1Data(F_PF);
	sciTx1Data(0);
	sciTx1Data(0);
	sciTx1Data(0);
	sciTx1Data(CSize);
}



//------------------------------------------------------------------------------
// Flash에서 모션 정보 읽기
//------------------------------------------------------------------------------
void GetMotionFromFlash(void)
{
	WORD	i;

	for(i=0;i<MAX_wCK;i++){
		Motion.wCK[i].Exist		= 0;
		Motion.wCK[i].RPgain	= 0;
		Motion.wCK[i].RDgain	= 0;
		Motion.wCK[i].RIgain	= 0;
		Motion.wCK[i].PortEn	= 0;
		Motion.wCK[i].InitPos	= 0;
		gPoseDelta[i] = 0;
	}
	gLastID = wCK_IDs[Motion.NumOfwCK-1];
	for(i=0;i<Motion.NumOfwCK;i++){
		Motion.wCK[wCK_IDs[i]].Exist	= 1;
		Motion.wCK[wCK_IDs[i]].RPgain	= *(gpPg_Table+i);
		Motion.wCK[wCK_IDs[i]].RDgain	= *(gpDg_Table+i);
		Motion.wCK[wCK_IDs[i]].RIgain	= *(gpIg_Table+i);
		Motion.wCK[wCK_IDs[i]].PortEn	= 1;
		Motion.wCK[wCK_IDs[i]].InitPos	= MotionZeroPos[i];
	}
	for(i=0;i<Motion.NumOfwCK;i++)
		gPoseDelta[i] = (int)eM_OriginPose[i] - (int)Motion.wCK[i].InitPos;
}


//------------------------------------------------------------------------------
// Runtime P,D,I 이득 송신
//------------------------------------------------------------------------------
void SendTGain(void)
{
	WORD	i;

	RX0_INT_OFF;
	TX0_INT_ON;

	while(gTx0Cnt);
	for(i=0;i<MAX_wCK;i++){
		if(Motion.wCK[i].Exist)
			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);


	while(gTx0Cnt);
	for(i=0;i<MAX_wCK;i++){
		if(Motion.wCK[i].Exist)
			SendSetCmd(i, 24, Motion.wCK[i].RIgain, Motion.wCK[i].RIgain);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
	delay_ms(5);
}


//------------------------------------------------------------------------------
// 확장 포트값 송신
//------------------------------------------------------------------------------
void SendExPortD(void)
{
	WORD	i;

	UCSR0B &= 0x7F;
	UCSR0B |= 0x40;

	while(gTx0Cnt);
	for(i=0;i<MAX_wCK;i++){
		if(Scene.wCK[i].Exist)
			SendSetCmd(i, 100, Scene.wCK[i].ExPortD, Scene.wCK[i].ExPortD);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
}


//------------------------------------------------------------------------------
// Flash에서 씬 정보 읽기
//------------------------------------------------------------------------------
void GetSceneFromFlash(void)
{
	WORD i;
	
	Scene.NumOfFrame = gpFN_Table[gScIdx];
	Scene.RTime = gpRT_Table[gScIdx];
	for(i=0; i < MAX_wCK; i++){
		Scene.wCK[i].Exist		= 0;
		Scene.wCK[i].SPos		= 0;
		Scene.wCK[i].DPos		= 0;
		Scene.wCK[i].Torq		= 0;
		Scene.wCK[i].ExPortD	= 0;
	}
	for(i=0; i < Motion.NumOfwCK; i++){
		Scene.wCK[wCK_IDs[i]].Exist		= 1;
		Scene.wCK[wCK_IDs[i]].SPos		= gpPos_Table[Motion.NumOfwCK*gScIdx+i];
		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[Motion.NumOfwCK*(gScIdx+1)+i];
		Scene.wCK[wCK_IDs[i]].Torq		= gpT_Table[Motion.NumOfwCK*gScIdx+i];
		Scene.wCK[wCK_IDs[i]].ExPortD	= gpE_Table[Motion.NumOfwCK*gScIdx+i];
	}
	UCSR0B &= 0x7F;
	UCSR0B |= 0x40;
	delay_us(1300);
}


//------------------------------------------------------------------------------
// 프레임 송신 간격 계산
//------------------------------------------------------------------------------
void CalcFrameInterval(void)
{
	float	tmp;

	if((Scene.RTime / Scene.NumOfFrame) < 20){
		F_ERR_CODE = INTERVAL_ERR;
		return;
	}
	tmp = (float)Scene.RTime * 14.4;
	tmp = tmp  / (float)Scene.NumOfFrame;
	TxInterval = 65535 - (WORD)tmp - 5;

	RUN_LED1_ON;
	F_SCENE_PLAYING = 1;
	F_MOTION_STOPPED = 0;
	TCCR1B = 0x05;

	if(TxInterval <= 65509)	
		TCNT1 = TxInterval+26;
	else
		TCNT1 = 65535;

	TIFR |= 0x04;
	TIMSK |= 0x04;
}


//------------------------------------------------------------------------------
// 프레임당 단위 이동량 계산
//------------------------------------------------------------------------------
void CalcUnitMove(void)
{
	WORD	i;

	for(i=0; i < MAX_wCK; i++){
		if(Scene.wCK[i].Exist){
			if(Scene.wCK[i].SPos != Scene.wCK[i].DPos){
				gUnitD[i] = (float)((int)Scene.wCK[i].DPos - (int)Scene.wCK[i].SPos);
				gUnitD[i] = (float)(gUnitD[i] / Scene.NumOfFrame);
				if(gUnitD[i] > 253)			gUnitD[i] = 254;
				else if(gUnitD[i] < -253)	gUnitD[i] = -254;
			}
			else
				gUnitD[i] = 0;
		}
	}
	gFrameIdx = 0;
}


//------------------------------------------------------------------------------
// 한 프레임 송신 준비
//------------------------------------------------------------------------------
void MakeFrame(void)
{
	BYTE	i, tmp;
	int		wTmp;

	while(gTx0Cnt);
	gFrameIdx++;

	for(i=0; i < MAX_wCK; i++){
		if(Scene.wCK[i].Exist){
			if(Scene.wCK[i].Torq < 5){
				wTmp = (int)Scene.wCK[i].SPos + Round((float)gFrameIdx*gUnitD[i],1 );
				if(Motion.PF != PF2){
					wTmp = wTmp + gPoseDelta[i];
				}
				if(wTmp > 254)		wTmp = 254;
				else if(wTmp < 1)	wTmp = 1;
				tmp = (BYTE)wTmp;
			}
			else{
				tmp = Scene.wCK[i].DPos;
			}
			PosSend(i,tmp, Scene.wCK[i].Torq);
		}
	}
}


//------------------------------------------------------------------------------
// 한 프레임 송신
//------------------------------------------------------------------------------
void SendFrame(void)
{
	if(gTx0Cnt == 0)	return;

	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);
}


//------------------------------------------------------------------------------
// HUNO의 0점 자세, HUNO, DINO, DOGY 기본 자세 동작
//------------------------------------------------------------------------------
void BasicPose(BYTE PF, WORD NOF, WORD RT, BYTE TQ)
{
	BYTE	trigger = 0;
	WORD	i;

	if(F_CHARGING)	return;
	if(F_PF == PF2)	return;
	if(F_PF != PF1_HUNO && PF == 0){
		F_ERR_CODE = PF_MATCH_ERR;
		return;
	}
	
	if(NOF != 1){
		if(PF == PF1_HUNO)		SendToSoundIC(1);
		else if(PF == PF1_DOGY)	SendToSoundIC(9);
	}

	Motion.PF = PF;
	Motion.NumOfScene = 1;
	Motion.NumOfwCK = 16;
	gLastID = 15;

	for(i=0; i < Motion.NumOfwCK; i++){
		Motion.wCK[i].Exist		= 1;
		if(i>9){
			Motion.wCK[i].RPgain	= 15;
			Motion.wCK[i].RDgain	= 25;
		}
		else{
			Motion.wCK[i].RPgain	= 20;
			Motion.wCK[i].RDgain	= 30;
		}
		Motion.wCK[i].RIgain	= 0;
		Motion.wCK[i].PortEn	= 1;
		Motion.wCK[i].InitPos	= (int)MotionZeroPos[i];
		gPoseDelta[i] = (int)eM_OriginPose[i] - (int)MotionZeroPos[i];
	}
	SendTGain();
	F_ERR_CODE = NO_ERR;
	for(i=0; i < MAX_wCK; i++){					
		if(Motion.wCK[i].Exist){ Scene.wCK[i].Exist = 1; }
	}
	GetPose();
	if(F_ERR_CODE != NO_ERR)	return;
	trigger = 0;
	for(i=0; i < Motion.NumOfwCK; i++){
		if( abs((float)Scene.wCK[i].DPos - (float)Scene.wCK[i].SPos) > 5 ){
			trigger = 1;
			break;
		}
	}
	if(trigger){
		trigger = 0;
		Scene.NumOfFrame = NOF;
		Scene.RTime = RT;
	}
	else{
		Scene.NumOfFrame = 1;
		Scene.RTime = 20;
	}

	for(i=0; i < Motion.NumOfwCK; i++){
		if(PF == 0){			Scene.wCK[i].DPos = eM_OriginPose[i];}
		else if(PF == PF1_HUNO){Scene.wCK[i].DPos = fM1_BasicPose[i];}
		else if(PF == PF1_DINO){Scene.wCK[i].DPos = fM2_BasicPose[i];}
		else if(PF == PF1_DOGY){Scene.wCK[i].DPos = fM3_BasicPose[i];}
		Scene.wCK[i].Torq		= TQ;
		Scene.wCK[i].ExPortD	= 1;
	}
	RUN_LED1_ON;
	SendExPortD();

	CalcFrameInterval();
	if(F_ERR_CODE != NO_ERR)	return;
	CalcUnitMove();
	MakeFrame();
	SendFrame();
	while(F_SCENE_PLAYING);
	if(F_MOTION_STOPPED == 1)	return;
	if(NOF > 1){
		delay_ms(800);
		GetPose();
		if(F_ERR_CODE != NO_ERR)	return;
		for(i=0; i < Motion.NumOfwCK; i++){
			if( abs((float)Scene.wCK[i].DPos - (float)Scene.wCK[i].SPos) > 10 ){
				F_ERR_CODE = WCK_POS_ERR;
				break;
			}
		}
	}
	RUN_LED1_OFF;
}


//------------------------------------------------------------------------------
// 현재 자세 읽기
//------------------------------------------------------------------------------
void GetPose(void)
{
	WORD	i, tmp;

	UCSR0B |= 0x80;
	UCSR0B &= 0xBF;
	for(i=0; i < MAX_wCK; i++){
		if(Motion.wCK[i].Exist){
			tmp = PosRead(i);
			if(tmp == 444){
				tmp = PosRead(i);
				if(tmp == 444){
					tmp = PosRead(i);
					if(tmp == 444){
						F_ERR_CODE = WCK_NO_ACK_ERR;
						return;
					}
				}
			}
			Scene.wCK[i].SPos = (BYTE)tmp;
		}
	}
}



//------------------------------------------------------------------------------
// 모션 트위닝 씬 실행
//------------------------------------------------------------------------------
void MotionTweenFlash(BYTE GapMax)
{
	WORD	i;

	Scene.NumOfFrame = (WORD)GapMax;
	Scene.RTime = (WORD)GapMax*20;
	for(i=0;i<MAX_wCK;i++){
		Scene.wCK[i].Exist		= 0;
		Scene.wCK[i].DPos		= 0;
		Scene.wCK[i].Torq		= 0;
		Scene.wCK[i].ExPortD	= 0;
	}
	for(i=0;i<Motion.NumOfwCK;i++){
		Scene.wCK[wCK_IDs[i]].Exist		= 1;
		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[i];
		Scene.wCK[wCK_IDs[i]].Torq		= 3;
		Scene.wCK[wCK_IDs[i]].ExPortD	= 0;
	}
	UCSR0B &= 0x7F;
	UCSR0B |= 0x40;
	SendExPortD();
	CalcFrameInterval();
	if(F_ERR_CODE != NO_ERR)	return;
	CalcUnitMove();
	MakeFrame();
	SendFrame();
	while(F_SCENE_PLAYING);
	if(F_MOTION_STOPPED == 1)	return;
}


//------------------------------------------------------------------------------
// 모션 플레이(내부 Flash 데이터 이용)
//------------------------------------------------------------------------------
void M_PlayFlash(void)
{
	float	lGapMax = 0;
	WORD	i;

	if(F_CHARGING) return;

	GetMotionFromFlash();
	SendTGain();

	F_ERR_CODE = NO_ERR;

	GetPose();
	if(F_ERR_CODE != NO_ERR)	return;
	for(i=0;i<Motion.NumOfwCK;i++){
		if( abs((float)gpPos_Table[i]-(float)Scene.wCK[i].SPos) > lGapMax )
			lGapMax = abs((float)gpPos_Table[i]-(float)Scene.wCK[i].SPos);
		if(gpT_Table[i] == 6)
			lGapMax = 0;
	}
	if(lGapMax > POS_MARGIN)	MotionTweenFlash((BYTE)(lGapMax/3));

	for(i=0; i < Motion.NumOfScene; i++){
		gScIdx = i;
		GetSceneFromFlash();
		SendExPortD();
		CalcFrameInterval();
		if(F_ERR_CODE != NO_ERR)	break;
		CalcUnitMove();
		MakeFrame();
		SendFrame();
		while(F_SCENE_PLAYING);
		if(F_MOTION_STOPPED == 1)	break;
	}
}


//------------------------------------------------------------------------------
// 모션 실행
//------------------------------------------------------------------------------
void M_Play(BYTE BtnCode)
{
	if(BtnCode == BTN_C){
		P_BMC504_RESET(0);
		delay_ms(20);
		P_BMC504_RESET(1);
		delay_ms(20);
		BasicPose(F_PF, 50, 1000, 4);
		if(F_ERR_CODE != NO_ERR){
			gSEC_DCOUNT = 5;
			EIMSK &= 0xBF;
			while(gSEC_DCOUNT){
				if(g10MSEC == 0 || g10MSEC == 50){
					Get_VOLTAGE();
					DetectPower();
					IoUpdate();
				}
				if(g10MSEC < 25)		ERR_LED_ON;
				else if(g10MSEC < 50)	ERR_LED_OFF;
				else if(g10MSEC < 75)	ERR_LED_ON;
				else if(g10MSEC < 100)	ERR_LED_OFF;
			}
			F_ERR_CODE = NO_ERR;
			EIMSK |= 0x40;
		}
		return;
	}
	if(F_PF == PF1_HUNO){
		switch(BtnCode){
			case BTN_A:
			 	SendToSoundIC(7);
				gpT_Table	= HUNOBASIC_GETUPFRONT_Torque;
				gpE_Table	= HUNOBASIC_GETUPFRONT_Port;
				gpPg_Table 	= HUNOBASIC_GETUPFRONT_RuntimePGain;
				gpDg_Table 	= HUNOBASIC_GETUPFRONT_RuntimeDGain;
				gpIg_Table 	= HUNOBASIC_GETUPFRONT_RuntimeIGain;
				gpFN_Table	= HUNOBASIC_GETUPFRONT_Frames;
				gpRT_Table	= HUNOBASIC_GETUPFRONT_TrTime;
				gpPos_Table	= HUNOBASIC_GETUPFRONT_Position;
				Motion.NumOfScene = HUNOBASIC_GETUPFRONT_NUM_OF_SCENES;
				Motion.NumOfwCK = HUNOBASIC_GETUPFRONT_NUM_OF_WCKS;
				break;
			case BTN_B:
			 	SendToSoundIC(8);
				gpT_Table	= HUNOBASIC_GETUPBACK_Torque;
				gpE_Table	= HUNOBASIC_GETUPBACK_Port;
				gpPg_Table 	= HUNOBASIC_GETUPBACK_RuntimePGain;
				gpDg_Table 	= HUNOBASIC_GETUPBACK_RuntimeDGain;
				gpIg_Table 	= HUNOBASIC_GETUPBACK_RuntimeIGain;
				gpFN_Table	= HUNOBASIC_GETUPBACK_Frames;
				gpRT_Table	= HUNOBASIC_GETUPBACK_TrTime;
				gpPos_Table	= HUNOBASIC_GETUPBACK_Position;
				Motion.NumOfScene = HUNOBASIC_GETUPBACK_NUM_OF_SCENES;
				Motion.NumOfwCK = HUNOBASIC_GETUPBACK_NUM_OF_WCKS;
				break;
			case BTN_LR:
			 	SendToSoundIC(4);
				gpT_Table	= HUNOBASIC_TURNLEFT_Torque;
				gpE_Table	= HUNOBASIC_TURNLEFT_Port;
				gpPg_Table 	= HUNOBASIC_TURNLEFT_RuntimePGain;
				gpDg_Table 	= HUNOBASIC_TURNLEFT_RuntimeDGain;
				gpIg_Table 	= HUNOBASIC_TURNLEFT_RuntimeIGain;
				gpFN_Table	= HUNOBASIC_TURNLEFT_Frames;
				gpRT_Table	= HUNOBASIC_TURNLEFT_TrTime;
				gpPos_Table	= HUNOBASIC_TURNLEFT_Position;
				Motion.NumOfScene = HUNOBASIC_TURNLEFT_NUM_OF_SCENES;
				Motion.NumOfwCK = HUNOBASIC_TURNLEFT_NUM_OF_WCKS;
				break;
			case BTN_U:
			 	//SendToSoundIC(2);
				gpT_Table	= HUNOBASIC_WALKFORWARD_Torque;
				gpE_Table	= HUNOBASIC_WALKFORWARD_Port;
				gpPg_Table 	= HUNOBASIC_WALKFORWARD_RuntimePGain;
				gpDg_Table 	= HUNOBASIC_WALKFORWARD_RuntimeDGain;
				gpIg_Table 	= HUNOBASIC_WALKFORWARD_RuntimeIGain;
				gpFN_Table	= HUNOBASIC_WALKFORWARD_Frames;
				gpRT_Table	= HUNOBASIC_WALKFORWARD_TrTime;
				gpPos_Table	= HUNOBASIC_WALKFORWARD_Position;
				Motion.NumOfScene = HUNOBASIC_WALKFORWARD_NUM_OF_SCENES;
				Motion.NumOfwCK = HUNOBASIC_WALKFORWARD_NUM_OF_WCKS;
				break;
			case BTN_RR:
			 	SendToSoundIC(4);
				gpT_Table	= HUNOBASIC_TURNRIGHT_Torque;
				gpE_Table	= HUNOBASIC_TURNRIGHT_Port;
				gpPg_Table 	= HUNOBASIC_TURNRIGHT_RuntimePGain;
				gpDg_Table 	= HUNOBASIC_TURNRIGHT_RuntimeDGain;
				gpIg_Table 	= HUNOBASIC_TURNRIGHT_RuntimeIGain;
				gpFN_Table	= HUNOBASIC_TURNRIGHT_Frames;
				gpRT_Table	= HUNOBASIC_TURNRIGHT_TrTime;
				gpPos_Table	= HUNOBASIC_TURNRIGHT_Position;
				Motion.NumOfScene = HUNOBASIC_TURNRIGHT_NUM_OF_SCENES;
				Motion.NumOfwCK = HUNOBASIC_TURNRIGHT_NUM_OF_WCKS;
				break;
			case BTN_L:
			 	SendToSoundIC(5);
				gpT_Table	= HUNOBASIC_SIDEWALKLEFT_Torque;
				gpE_Table	= HUNOBASIC_SIDEWALKLEFT_Port;
				gpPg_Table 	= HUNOBASIC_SIDEWALKLEFT_RuntimePGain;
				gpDg_Table 	= HUNOBASIC_SIDEWALKLEFT_RuntimeDGain;
				gpIg_Table 	= HUNOBASIC_SIDEWALKLEFT_RuntimeIGain;
				gpFN_Table	= HUNOBASIC_SIDEWALKLEFT_Frames;
				gpRT_Table	= HUNOBASIC_SIDEWALKLEFT_TrTime;
				gpPos_Table	= HUNOBASIC_SIDEWALKLEFT_Position;
				Motion.NumOfScene = HUNOBASIC_SIDEWALKLEFT_NUM_OF_SCENES;
				Motion.NumOfwCK = HUNOBASIC_SIDEWALKLEFT_NUM_OF_WCKS;
				break;
			case BTN_R:
			 	SendToSoundIC(5);
				gpT_Table	= HUNOBASIC_SIDEWALKRIGHT_Torque;
				gpE_Table	= HUNOBASIC_SIDEWALKRIGHT_Port;
				gpPg_Table 	= HUNOBASIC_SIDEWALKRIGHT_RuntimePGain;
				gpDg_Table 	= HUNOBASIC_SIDEWALKRIGHT_RuntimeDGain;
				gpIg_Table 	= HUNOBASIC_SIDEWALKRIGHT_RuntimeIGain;
				gpFN_Table	= HUNOBASIC_SIDEWALKRIGHT_Frames;
				gpRT_Table	= HUNOBASIC_SIDEWALKRIGHT_TrTime;
				gpPos_Table	= HUNOBASIC_SIDEWALKRIGHT_Position;
				Motion.NumOfScene = HUNOBASIC_SIDEWALKRIGHT_NUM_OF_SCENES;
				Motion.NumOfwCK = HUNOBASIC_SIDEWALKRIGHT_NUM_OF_WCKS;
				break;
			case BTN_LA:
			 	SendToSoundIC(6);
				gpT_Table	= HUNOBASIC_PUNCHLEFT_Torque;
				gpE_Table	= HUNOBASIC_PUNCHLEFT_Port;
				gpPg_Table 	= HUNOBASIC_PUNCHLEFT_RuntimePGain;
				gpDg_Table 	= HUNOBASIC_PUNCHLEFT_RuntimeDGain;
				gpIg_Table 	= HUNOBASIC_PUNCHLEFT_RuntimeIGain;
				gpFN_Table	= HUNOBASIC_PUNCHLEFT_Frames;
				gpRT_Table	= HUNOBASIC_PUNCHLEFT_TrTime;
				gpPos_Table	= HUNOBASIC_PUNCHLEFT_Position;
				Motion.NumOfScene = HUNOBASIC_PUNCHLEFT_NUM_OF_SCENES;
				Motion.NumOfwCK = HUNOBASIC_PUNCHLEFT_NUM_OF_WCKS;
				break;
			case BTN_D:
			 	SendToSoundIC(3);
				gpT_Table	= HUNOBASIC_WALKBACKWARD_Torque;
				gpE_Table	= HUNOBASIC_WALKBACKWARD_Port;
				gpPg_Table 	= HUNOBASIC_WALKBACKWARD_RuntimePGain;
				gpDg_Table 	= HUNOBASIC_WALKBACKWARD_RuntimeDGain;
				gpIg_Table 	= HUNOBASIC_WALKBACKWARD_RuntimeIGain;
				gpFN_Table	= HUNOBASIC_WALKBACKWARD_Frames;
				gpRT_Table	= HUNOBASIC_WALKBACKWARD_TrTime;
				gpPos_Table	= HUNOBASIC_WALKBACKWARD_Position;
				Motion.NumOfScene = HUNOBASIC_WALKBACKWARD_NUM_OF_SCENES;
				Motion.NumOfwCK = HUNOBASIC_WALKBACKWARD_NUM_OF_WCKS;
				break;
			case BTN_RA:
			 	SendToSoundIC(6);
				gpT_Table	= HUNOBASIC_PUNCHRIGHT_Torque;
				gpE_Table	= HUNOBASIC_PUNCHRIGHT_Port;
				gpPg_Table 	= HUNOBASIC_PUNCHRIGHT_RuntimePGain;
				gpDg_Table 	= HUNOBASIC_PUNCHRIGHT_RuntimeDGain;
				gpIg_Table 	= HUNOBASIC_PUNCHRIGHT_RuntimeIGain;
				gpFN_Table	= HUNOBASIC_PUNCHRIGHT_Frames;
				gpRT_Table	= HUNOBASIC_PUNCHRIGHT_TrTime;
				gpPos_Table	= HUNOBASIC_PUNCHRIGHT_Position;
				Motion.NumOfScene = HUNOBASIC_PUNCHRIGHT_NUM_OF_SCENES;
				Motion.NumOfwCK = HUNOBASIC_PUNCHRIGHT_NUM_OF_WCKS;
				break;
			case BTN_0:
				gpT_Table	= MY_DEMO1_Torque;
				gpE_Table	= MY_DEMO1_Port;
				gpPg_Table 	= MY_DEMO1_RuntimePGain;
				gpDg_Table 	= MY_DEMO1_RuntimeDGain;
				gpIg_Table 	= MY_DEMO1_RuntimeIGain;
				gpFN_Table	= MY_DEMO1_Frames;
				gpRT_Table	= MY_DEMO1_TrTime;
				gpPos_Table	= MY_DEMO1_Position;
				Motion.NumOfScene = MY_DEMO1_NUM_OF_SCENES;
				Motion.NumOfwCK = MY_DEMO1_NUM_OF_WCKS;
				break;
			default:
				return;
		}
	}
	else if(F_PF == PF1_DINO){
		switch(BtnCode){
			case BTN_A:
	 			SendToSoundIC(13);
				gpT_Table	= DinoBasic_GetupFront_Torque;
				gpE_Table	= DinoBasic_GetupFront_Port;
				gpPg_Table 	= DinoBasic_GetupFront_RuntimePGain;
				gpDg_Table 	= DinoBasic_GetupFront_RuntimeDGain;
				gpIg_Table 	= DinoBasic_GetupFront_RuntimeIGain;
				gpFN_Table	= DinoBasic_GetupFront_Frames;
				gpRT_Table	= DinoBasic_GetupFront_TrTime;
				gpPos_Table	= DinoBasic_GetupFront_Position;
				Motion.NumOfScene = DINOBASIC_GETUPFRONT_NUM_OF_SCENES;
				Motion.NumOfwCK = DINOBASIC_GETUPFRONT_NUM_OF_WCKS;
				break;
			case BTN_B:
	 			SendToSoundIC(13);
				gpT_Table	= DinoBasic_GetupBack_Torque;
				gpE_Table	= DinoBasic_GetupBack_Port;
				gpPg_Table 	= DinoBasic_GetupBack_RuntimePGain;
				gpDg_Table 	= DinoBasic_GetupBack_RuntimeDGain;
				gpIg_Table 	= DinoBasic_GetupBack_RuntimeIGain;
				gpFN_Table	= DinoBasic_GetupBack_Frames;
				gpRT_Table	= DinoBasic_GetupBack_TrTime;
				gpPos_Table	= DinoBasic_GetupBack_Position;
				Motion.NumOfScene = DINOBASIC_GETUPBACK_NUM_OF_SCENES;
				Motion.NumOfwCK = DINOBASIC_GETUPBACK_NUM_OF_WCKS;
				break;
			case BTN_LR:
			 	SendToSoundIC(13);
				gpT_Table	= DinoBasic_TurnLeft_Torque;
				gpE_Table	= DinoBasic_TurnLeft_Port;
				gpPg_Table 	= DinoBasic_TurnLeft_RuntimePGain;
				gpDg_Table 	= DinoBasic_TurnLeft_RuntimeDGain;
				gpIg_Table 	= DinoBasic_TurnLeft_RuntimeIGain;
				gpFN_Table	= DinoBasic_TurnLeft_Frames;
				gpRT_Table	= DinoBasic_TurnLeft_TrTime;
				gpPos_Table	= DinoBasic_TurnLeft_Position;
				Motion.NumOfScene = DINOBASIC_TURNLEFT_NUM_OF_SCENES;
				Motion.NumOfwCK = DINOBASIC_TURNLEFT_NUM_OF_WCKS;
				break;
			case BTN_U:
			 	SendToSoundIC(14);
				gpT_Table	= DinoBasic_WalkForward_Torque;
				gpE_Table	= DinoBasic_WalkForward_Port;
				gpPg_Table 	= DinoBasic_WalkForward_RuntimePGain;
				gpDg_Table 	= DinoBasic_WalkForward_RuntimeDGain;
				gpIg_Table 	= DinoBasic_WalkForward_RuntimeIGain;
				gpFN_Table	= DinoBasic_WalkForward_Frames;
				gpRT_Table	= DinoBasic_WalkForward_TrTime;
				gpPos_Table	= DinoBasic_WalkForward_Position;
				Motion.NumOfScene = DINOBASIC_WALKFORWARD_NUM_OF_SCENES;
				Motion.NumOfwCK = DINOBASIC_WALKFORWARD_NUM_OF_WCKS;
				break;
			case BTN_RR:
			 	SendToSoundIC(13);
				gpT_Table	= DinoBasic_TurnRight_Torque;
				gpE_Table	= DinoBasic_TurnRight_Port;
				gpPg_Table 	= DinoBasic_TurnRight_RuntimePGain;
				gpDg_Table 	= DinoBasic_TurnRight_RuntimeDGain;
				gpIg_Table 	= DinoBasic_TurnRight_RuntimeIGain;
				gpFN_Table	= DinoBasic_TurnRight_Frames;
				gpRT_Table	= DinoBasic_TurnRight_TrTime;
				gpPos_Table	= DinoBasic_TurnRight_Position;
				Motion.NumOfScene = DINOBASIC_TURNRIGHT_NUM_OF_SCENES;
				Motion.NumOfwCK = DINOBASIC_TURNRIGHT_NUM_OF_WCKS;
				break;
			case BTN_L:
			 	SendToSoundIC(13);
				gpT_Table	= DinoBasic_SidewalkLeft_Torque;
				gpE_Table	= DinoBasic_SidewalkLeft_Port;
				gpPg_Table 	= DinoBasic_SidewalkLeft_RuntimePGain;
				gpDg_Table 	= DinoBasic_SidewalkLeft_RuntimeDGain;
				gpIg_Table 	= DinoBasic_SidewalkLeft_RuntimeIGain;
				gpFN_Table	= DinoBasic_SidewalkLeft_Frames;
				gpRT_Table	= DinoBasic_SidewalkLeft_TrTime;
				gpPos_Table	= DinoBasic_SidewalkLeft_Position;
				Motion.NumOfScene = DINOBASIC_SIDEWALKLEFT_NUM_OF_SCENES;
				Motion.NumOfwCK = DINOBASIC_SIDEWALKLEFT_NUM_OF_WCKS;
				break;
			case BTN_R:
			 	SendToSoundIC(13);
				gpT_Table	= DinoBasic_SidewalkRight_Torque;
				gpE_Table	= DinoBasic_SidewalkRight_Port;
				gpPg_Table 	= DinoBasic_SidewalkRight_RuntimePGain;
				gpDg_Table 	= DinoBasic_SidewalkRight_RuntimeDGain;
				gpIg_Table 	= DinoBasic_SidewalkRight_RuntimeIGain;
				gpFN_Table	= DinoBasic_SidewalkRight_Frames;
				gpRT_Table	= DinoBasic_SidewalkRight_TrTime;
				gpPos_Table	= DinoBasic_SidewalkRight_Position;
				Motion.NumOfScene = DINOBASIC_SIDEWALKRIGHT_NUM_OF_SCENES;
				Motion.NumOfwCK = DINOBASIC_SIDEWALKRIGHT_NUM_OF_WCKS;
				break;
			case BTN_LA:
			 	SendToSoundIC(13);
				gpT_Table	= DinoBasic_PunchLeft_Torque;
				gpE_Table	= DinoBasic_PunchLeft_Port;
				gpPg_Table 	= DinoBasic_PunchLeft_RuntimePGain;
				gpDg_Table 	= DinoBasic_PunchLeft_RuntimeDGain;
				gpIg_Table 	= DinoBasic_PunchLeft_RuntimeIGain;
				gpFN_Table	= DinoBasic_PunchLeft_Frames;
				gpRT_Table	= DinoBasic_PunchLeft_TrTime;
				gpPos_Table	= DinoBasic_PunchLeft_Position;
				Motion.NumOfScene = DINOBASIC_PUNCHLEFT_NUM_OF_SCENES;
				Motion.NumOfwCK = DINOBASIC_PUNCHLEFT_NUM_OF_WCKS;
				break;
			case BTN_D:
			 	SendToSoundIC(13);
				gpT_Table	= DinoBasic_WalkBackward_Torque;
				gpE_Table	= DinoBasic_WalkBackward_Port;
				gpPg_Table 	= DinoBasic_WalkBackward_RuntimePGain;
				gpDg_Table 	= DinoBasic_WalkBackward_RuntimeDGain;
				gpIg_Table 	= DinoBasic_WalkBackward_RuntimeIGain;
				gpFN_Table	= DinoBasic_WalkBackward_Frames;
				gpRT_Table	= DinoBasic_WalkBackward_TrTime;
				gpPos_Table	= DinoBasic_WalkBackward_Position;
				Motion.NumOfScene = DINOBASIC_WALKBACKWARD_NUM_OF_SCENES;
				Motion.NumOfwCK = DINOBASIC_WALKBACKWARD_NUM_OF_WCKS;
				break;
			case BTN_RA:
			 	SendToSoundIC(13);
				gpT_Table	= DinoBasic_PunchRight_Torque;
				gpE_Table	= DinoBasic_PunchRight_Port;
				gpPg_Table 	= DinoBasic_PunchRight_RuntimePGain;
				gpDg_Table 	= DinoBasic_PunchRight_RuntimeDGain;
				gpIg_Table 	= DinoBasic_PunchRight_RuntimeIGain;
				gpFN_Table	= DinoBasic_PunchRight_Frames;
				gpRT_Table	= DinoBasic_PunchRight_TrTime;
				gpPos_Table	= DinoBasic_PunchRight_Position;
				Motion.NumOfScene = DINOBASIC_PUNCHRIGHT_NUM_OF_SCENES;
				Motion.NumOfwCK = DINOBASIC_PUNCHRIGHT_NUM_OF_WCKS;
				break;
			default:
				return;
		}
	}
	else if(F_PF == PF1_DOGY){
		switch(BtnCode){
			case BTN_A:
	 			SendToSoundIC(12);
				gpT_Table	= DogyBasic_GetupFront_Torque;
				gpE_Table	= DogyBasic_GetupFront_Port;
				gpPg_Table 	= DogyBasic_GetupFront_RuntimePGain;
				gpDg_Table 	= DogyBasic_GetupFront_RuntimeDGain;
				gpIg_Table 	= DogyBasic_GetupFront_RuntimeIGain;
				gpFN_Table	= DogyBasic_GetupFront_Frames;
				gpRT_Table	= DogyBasic_GetupFront_TrTime;
				gpPos_Table	= DogyBasic_GetupFront_Position;
				Motion.NumOfScene = DOGYBASIC_GETUPFRONT_NUM_OF_SCENES;
				Motion.NumOfwCK = DOGYBASIC_GETUPFRONT_NUM_OF_WCKS;
				break;
			case BTN_B:
	 			SendToSoundIC(12);
				gpT_Table	= DogyBasic_GetupBack_Torque;
				gpE_Table	= DogyBasic_GetupBack_Port;
				gpPg_Table 	= DogyBasic_GetupBack_RuntimePGain;
				gpDg_Table 	= DogyBasic_GetupBack_RuntimeDGain;
				gpIg_Table 	= DogyBasic_GetupBack_RuntimeIGain;
				gpFN_Table	= DogyBasic_GetupBack_Frames;
				gpRT_Table	= DogyBasic_GetupBack_TrTime;
				gpPos_Table	= DogyBasic_GetupBack_Position;
				Motion.NumOfScene = DOGYBASIC_GETUPBACK_NUM_OF_SCENES;
				Motion.NumOfwCK = DOGYBASIC_GETUPBACK_NUM_OF_WCKS;
				break;
			case BTN_LR:
			 	SendToSoundIC(11);
				gpT_Table	= DogyBasic_TurnLeft_Torque;
				gpE_Table	= DogyBasic_TurnLeft_Port;
				gpPg_Table 	= DogyBasic_TurnLeft_RuntimePGain;
				gpDg_Table 	= DogyBasic_TurnLeft_RuntimeDGain;
				gpIg_Table 	= DogyBasic_TurnLeft_RuntimeIGain;
				gpFN_Table	= DogyBasic_TurnLeft_Frames;
				gpRT_Table	= DogyBasic_TurnLeft_TrTime;
				gpPos_Table	= DogyBasic_TurnLeft_Position;
				Motion.NumOfScene = DOGYBASIC_TURNLEFT_NUM_OF_SCENES;
				Motion.NumOfwCK = DOGYBASIC_TURNLEFT_NUM_OF_WCKS;
				break;
			case BTN_U:
			 	SendToSoundIC(10);
				gpT_Table	= DogyBasic_WalkForward_Torque;
				gpE_Table	= DogyBasic_WalkForward_Port;
				gpPg_Table 	= DogyBasic_WalkForward_RuntimePGain;
				gpDg_Table 	= DogyBasic_WalkForward_RuntimeDGain;
				gpIg_Table 	= DogyBasic_WalkForward_RuntimeIGain;
				gpFN_Table	= DogyBasic_WalkForward_Frames;
				gpRT_Table	= DogyBasic_WalkForward_TrTime;
				gpPos_Table	= DogyBasic_WalkForward_Position;
				Motion.NumOfScene = DOGYBASIC_WALKFORWARD_NUM_OF_SCENES;
				Motion.NumOfwCK = DOGYBASIC_WALKFORWARD_NUM_OF_WCKS;
				break;
			case BTN_RR:
			 	SendToSoundIC(11);
				gpT_Table	= DogyBasic_TurnRight_Torque;
				gpE_Table	= DogyBasic_TurnRight_Port;
				gpPg_Table 	= DogyBasic_TurnRight_RuntimePGain;
				gpDg_Table 	= DogyBasic_TurnRight_RuntimeDGain;
				gpIg_Table 	= DogyBasic_TurnRight_RuntimeIGain;
				gpFN_Table	= DogyBasic_TurnRight_Frames;
				gpRT_Table	= DogyBasic_TurnRight_TrTime;
				gpPos_Table	= DogyBasic_TurnRight_Position;
				Motion.NumOfScene = DOGYBASIC_TURNRIGHT_NUM_OF_SCENES;
				Motion.NumOfwCK = DOGYBASIC_TURNRIGHT_NUM_OF_WCKS;
				break;
			case BTN_L:
			 	SendToSoundIC(11);
				gpT_Table	= DogyBasic_SidewalkLeft_Torque;
				gpE_Table	= DogyBasic_SidewalkLeft_Port;
				gpPg_Table 	= DogyBasic_SidewalkLeft_RuntimePGain;
				gpDg_Table 	= DogyBasic_SidewalkLeft_RuntimeDGain;
				gpIg_Table 	= DogyBasic_SidewalkLeft_RuntimeIGain;
				gpFN_Table	= DogyBasic_SidewalkLeft_Frames;
				gpRT_Table	= DogyBasic_SidewalkLeft_TrTime;
				gpPos_Table	= DogyBasic_SidewalkLeft_Position;
				Motion.NumOfScene = DOGYBASIC_SIDEWALKLEFT_NUM_OF_SCENES;
				Motion.NumOfwCK = DOGYBASIC_SIDEWALKLEFT_NUM_OF_WCKS;
				break;
			case BTN_R:
			 	SendToSoundIC(11);
				gpT_Table	= DogyBasic_SidewalkRight_Torque;
				gpE_Table	= DogyBasic_SidewalkRight_Port;
				gpPg_Table 	= DogyBasic_SidewalkRight_RuntimePGain;
				gpDg_Table 	= DogyBasic_SidewalkRight_RuntimeDGain;
				gpIg_Table 	= DogyBasic_SidewalkRight_RuntimeIGain;
				gpFN_Table	= DogyBasic_SidewalkRight_Frames;
				gpRT_Table	= DogyBasic_SidewalkRight_TrTime;
				gpPos_Table	= DogyBasic_SidewalkRight_Position;
				Motion.NumOfScene = DOGYBASIC_SIDEWALKRIGHT_NUM_OF_SCENES;
				Motion.NumOfwCK = DOGYBASIC_SIDEWALKRIGHT_NUM_OF_WCKS;
				break;
			case BTN_LA:
			 	SendToSoundIC(11);
				gpT_Table	= DogyBasic_PunchLeft_Torque;
				gpE_Table	= DogyBasic_PunchLeft_Port;
				gpPg_Table 	= DogyBasic_PunchLeft_RuntimePGain;
				gpDg_Table 	= DogyBasic_PunchLeft_RuntimeDGain;
				gpIg_Table 	= DogyBasic_PunchLeft_RuntimeIGain;
				gpFN_Table	= DogyBasic_PunchLeft_Frames;
				gpRT_Table	= DogyBasic_PunchLeft_TrTime;
				gpPos_Table	= DogyBasic_PunchLeft_Position;
				Motion.NumOfScene = DOGYBASIC_PUNCHLEFT_NUM_OF_SCENES;
				Motion.NumOfwCK = DOGYBASIC_PUNCHLEFT_NUM_OF_WCKS;
				break;
			case BTN_D:
			 	SendToSoundIC(11);
				gpT_Table	= DogyBasic_WalkBackward_Torque;
				gpE_Table	= DogyBasic_WalkBackward_Port;
				gpPg_Table 	= DogyBasic_WalkBackward_RuntimePGain;
				gpDg_Table 	= DogyBasic_WalkBackward_RuntimeDGain;
				gpIg_Table 	= DogyBasic_WalkBackward_RuntimeIGain;
				gpFN_Table	= DogyBasic_WalkBackward_Frames;
				gpRT_Table	= DogyBasic_WalkBackward_TrTime;
				gpPos_Table	= DogyBasic_WalkBackward_Position;
				Motion.NumOfScene = DOGYBASIC_WALKBACKWARD_NUM_OF_SCENES;
				Motion.NumOfwCK = DOGYBASIC_WALKBACKWARD_NUM_OF_WCKS;
				break;
			case BTN_RA:
			 	SendToSoundIC(11);
				gpT_Table	= DogyBasic_PunchRight_Torque;
				gpE_Table	= DogyBasic_PunchRight_Port;
				gpPg_Table 	= DogyBasic_PunchRight_RuntimePGain;
				gpDg_Table 	= DogyBasic_PunchRight_RuntimeDGain;
				gpIg_Table 	= DogyBasic_PunchRight_RuntimeIGain;
				gpFN_Table	= DogyBasic_PunchRight_Frames;
				gpRT_Table	= DogyBasic_PunchRight_TrTime;
				gpPos_Table	= DogyBasic_PunchRight_Position;
				Motion.NumOfScene = DOGYBASIC_PUNCHRIGHT_NUM_OF_SCENES;
				Motion.NumOfwCK = DOGYBASIC_PUNCHRIGHT_NUM_OF_WCKS;
				break;
			default:
				return;
		}
	}
	else if(F_PF == PF2){
		return;
	}
	Motion.PF = F_PF;
	M_PlayFlash();
}
//==============================================================================
//						Digital Input Output 관련 함수들
//==============================================================================

#include <mega128.h>
#include "Main.h"
#include "Macro.h"
#include "DIO.h"

//------------------------------------------------------------------------------
// 버튼 읽기
//------------------------------------------------------------------------------
void ReadButton(void)
{
	BYTE	lbtmp;

	lbtmp = PINA & 0x03;

	if(F_DOWNLOAD) return;

	if(lbtmp == 0x02){
		gPF1BtnCnt++;		gPF2BtnCnt = 0;		gPF12BtnCnt = 0;
       	if(gPF1BtnCnt > 3000){
			gBtn_val = PF1_BTN_LONG;
			gPF1BtnCnt = 0;
		}
	}
	else if(lbtmp == 0x01){
		gPF1BtnCnt = 0;		gPF2BtnCnt++;		gPF12BtnCnt = 0;
       	if(gPF2BtnCnt > 3000){
			gBtn_val = PF2_BTN_LONG;
			gPF2BtnCnt = 0;
		}
	}
	else if(lbtmp == 0x00){
		gPF1BtnCnt = 0;		gPF2BtnCnt = 0;		gPF12BtnCnt++;
       	if(gPF12BtnCnt > 2000){
           	if(F_PF_CHANGED == 0){
				gBtn_val = PF12_BTN_LONG;
	       	    gPF12BtnCnt = 0;
			}
		}
	}
	else{
		if(gPF1BtnCnt > 40 && gPF1BtnCnt < 500){
			gBtn_val = PF1_BTN_SHORT;
		}
		else if(gPF2BtnCnt > 40 && gPF2BtnCnt < 500){
			gBtn_val = PF2_BTN_SHORT;
		}
		else if(gPF12BtnCnt > 40 && gPF12BtnCnt < 500){
			gBtn_val = PF12_BTN_SHORT;
		}
		else
			gBtn_val = BTN_NOT_PRESSED;
		gPF1BtnCnt = 0;
		gPF2BtnCnt = 0;
		gPF12BtnCnt = 0;
		F_PF_CHANGED = 0;
	}
} 


//------------------------------------------------------------------------------
// 버튼 처리
//------------------------------------------------------------------------------
void ProcButton(void)
{
	WORD	i;
	if(gBtn_val == PF12_BTN_LONG){
		gBtn_val = 0;
		if(F_PS_PLUGGED){
			BreakModeCmdSend();
			ChargeNiMH();
		}
	}
	else if(gBtn_val == PF1_BTN_LONG){
		gBtn_val = 0;
		if(F_PF==PF1_HUNO){
			F_PF=PF1_DINO;
			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Dino[i], U_Boundary_Dino[i]);
		}
		else if(F_PF==PF1_DINO){
			F_PF=PF1_DOGY;
			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Dogy[i], U_Boundary_Dogy[i]);
		}
		else{
			F_PF=PF1_HUNO;
			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Huno[i], U_Boundary_Huno[i]);
		}
		BreakModeCmdSend();
		delay_ms(10);
		F_PF_CHANGED = 1;
		ePF = F_PF;
	}
	else if(gBtn_val == PF2_BTN_LONG){
		gBtn_val = 0;
		F_PF = PF2;
		BreakModeCmdSend();
		delay_ms(10);
		F_PF_CHANGED = 1;
		ePF = F_PF;
	}
}


//------------------------------------------------------------------------------
// Io 업데이트 처리
//------------------------------------------------------------------------------
void IoUpdate(void)
{
	if(F_DOWNLOAD) return;
	if(F_DIRECT_C_EN){
			PF1_LED1_ON;
			PF1_LED2_OFF;
			PF2_LED_ON;
			return;
	}
	switch(F_PF){
		case PF1_HUNO:
			PF1_LED1_ON;
			PF1_LED2_OFF;
			PF2_LED_OFF;
			break;
		case PF1_DINO:
			PF1_LED1_ON;
			PF1_LED2_ON;
			PF2_LED_OFF;
			break;
		case PF1_DOGY:
			PF1_LED1_OFF;
			PF1_LED2_ON;
			PF2_LED_OFF;
			break;
		case PF2:
			PF1_LED1_OFF;
			PF1_LED2_OFF;
			PF2_LED_ON;
			break;
		default:
			F_PF = PF2;
	}

	if(gVOLTAGE>M_T_OF_POWER){
		PWR_LED1_ON;
		PWR_LED2_OFF;
		gPwrLowCount = 0;
	}
	else if(gVOLTAGE>L_T_OF_POWER){
		PWR_LED1_OFF;
		PWR_LED2_ON;
		gPwrLowCount++;
		if(gPwrLowCount>5000){
			gPwrLowCount = 0;
			BreakModeCmdSend();
		}
	}
	else{
		PWR_LED1_OFF;
		if(g10MSEC<25)			PWR_LED2_ON;
		else if(g10MSEC<50)		PWR_LED2_OFF;
		else if(g10MSEC<75)		PWR_LED2_ON;
		else if(g10MSEC<100)	PWR_LED2_OFF;
		gPwrLowCount++;
		if(gPwrLowCount>3000){
			gPwrLowCount=0;
			BreakModeCmdSend();
		}
	}
	if(F_ERR_CODE == NO_ERR)	ERR_LED_OFF;
	else ERR_LED_ON;
}


//------------------------------------------------------------------------------
// 자체 테스트1
//------------------------------------------------------------------------------
void SelfTest1(void)
{
	WORD	i;

	if(F_DIRECT_C_EN)	return;

	for(i=0;i<16;i++){
		if((StandardZeroPos[i]+15)<eM_OriginPose[i]
		 ||(StandardZeroPos[i]-15)>eM_OriginPose[i]){
			F_ERR_CODE = ZERO_DATA_ERR;
			return;
		}
	}
	PWR_LED1_ON;	delay_ms(60);	PWR_LED1_OFF;
	PWR_LED2_ON;	delay_ms(60);	PWR_LED2_OFF;
	RUN_LED1_ON;	delay_ms(60);	RUN_LED1_OFF;
	RUN_LED2_ON;	delay_ms(60);	RUN_LED2_OFF;
	ERR_LED_ON;		delay_ms(60);	ERR_LED_OFF;

	PF2_LED_ON;		delay_ms(60);	PF2_LED_OFF;
	PF1_LED2_ON;	delay_ms(60);	PF1_LED2_OFF;
	PF1_LED1_ON;	delay_ms(60);	PF1_LED1_OFF;
}


//------------------------------------------------------------------------------
// IR 수신 처리
//------------------------------------------------------------------------------
void ProcIr(void)
{
    WORD    i;

	if(F_DOWNLOAD) return;
	if(F_FIRST_M && gIrBuf[3]!=BTN_C && gIrBuf[3]!=BTN_SHARP_A && F_PF!=PF2) return;
	if(F_IR_RECEIVED){
	    EIMSK &= 0xBF;
		F_IR_RECEIVED = 0;
		if((gIrBuf[0]==eRCodeH[0] && gIrBuf[1]==eRCodeM[0] && gIrBuf[2]==eRCodeL[0])
		 ||(gIrBuf[0]==eRCodeH[1] && gIrBuf[1]==eRCodeM[1] && gIrBuf[2]==eRCodeL[1])
		 ||(gIrBuf[0]==eRCodeH[2] && gIrBuf[1]==eRCodeM[2] && gIrBuf[2]==eRCodeL[2])
		 ||(gIrBuf[0]==eRCodeH[3] && gIrBuf[1]==eRCodeM[3] && gIrBuf[2]==eRCodeL[3])
		 ||(gIrBuf[0]==eRCodeH[4] && gIrBuf[1]==eRCodeM[4] && gIrBuf[2]==eRCodeL[4])){
			switch(gIrBuf[3]){
				case BTN_A:
					M_Play(BTN_A);
					break;
				case BTN_B:
					M_Play(BTN_B);
					break;
				case BTN_LR:
					M_Play(BTN_LR);
					break;
				case BTN_U:
					M_Play(BTN_U);
					break;
				case BTN_RR:
					M_Play(BTN_RR);
					break;
				case BTN_L:
					M_Play(BTN_L);
					break;
				case BTN_R:
					M_Play(BTN_R);
					break;
				case BTN_LA:
					M_Play(BTN_LA);
					break;
				case BTN_D:
					M_Play(BTN_D);
					break;
				case BTN_RA:
					M_Play(BTN_RA);
					break;
				case BTN_C:
					F_FIRST_M = 0;
					M_Play(BTN_C);
					break;
				case BTN_1:
					break;
				case BTN_2:
					break;
				case BTN_3:
					break;
				case BTN_4:
					break;
				case BTN_5:
					break;
				case BTN_6:
					break;
				case BTN_7:
					break;
				case BTN_8:
					break;
				case BTN_9:
				    User_Func();
					break;
				case BTN_0:
					M_Play(BTN_0);
					break;
				case BTN_STAR_A:
					M_Play(BTN_STAR_A);
					break;
				case BTN_STAR_B:
					M_Play(BTN_STAR_B);
					break;
				case BTN_STAR_C:
					M_Play(BTN_STAR_C);
					break;
				case BTN_STAR_1:
					break;
				case BTN_STAR_2:
					break;
				case BTN_STAR_3:
					break;
				case BTN_STAR_4:
					break;
				case BTN_STAR_5:
					break;
				case BTN_STAR_6:
					break;
				case BTN_STAR_7:
					break;
				case BTN_STAR_8:
					break;
				case BTN_STAR_9:
					break;
				case BTN_STAR_0:
					break;
				case BTN_SHARP_1:
					break;
				case BTN_SHARP_2:
					break;
				case BTN_SHARP_3:
					break;
				case BTN_SHARP_4:
					break;
				case BTN_SHARP_5:
					break;
				case BTN_SHARP_6:
					break;
				case BTN_SHARP_7:
					break;
				case BTN_SHARP_8:
					break;
				case BTN_SHARP_9:
					break;
				case BTN_SHARP_0:
					break;
				case BTN_SHARP_A:
					if(F_PS_PLUGGED){
						BreakModeCmdSend();
						ChargeNiMH();
					}
					else{
					}
					break;
				case BTN_SHARP_B:
					break;
				case BTN_SHARP_C:
					BasicPose(0, 50, 1000, 4);
					BasicPose(0, 1, 100, 1);
					break;
			}
		}
		if(F_RSV_MOTION){
			F_RSV_MOTION = 0;
			SendToPC(20,1);
			gFileCheckSum = 0;
			sciTx1Data(gIrBuf[3]);
			gFileCheckSum ^= gIrBuf[3];
			sciTx1Data(gFileCheckSum);
		}
		for(i=0;i<IR_BUFFER_SIZE;i++)	gIrBuf[i]=0;
	    EIMSK |= 0x40;
	}
}
//==============================================================================
//						A/D converter 관련 함수들
//==============================================================================
#include <mega128.h>
#include "Main.h"
#include "Macro.h"

//------------------------------------------------------------------------------
// PSD 거리센서 신호 A/D
//------------------------------------------------------------------------------
void Get_AD_PSD(void)
{
	float	tmp = 0;
	float	dist;
	
	EIMSK &= 0xBF;
	PSD_ON;
   	delay_ms(50);
	gAD_Ch_Index = PSD_CH;
   	F_AD_CONVERTING = 1;
   	ADC_set(ADC_MODE_SINGLE);
   	while(F_AD_CONVERTING);            
   	tmp = tmp + gPSD_val;
	PSD_OFF;
	EIMSK |= 0x40;

	dist = 1117.2 / (tmp - 6.89);
	if(dist < 0) dist = 50;
	else if(dist < 10) dist = 10;
	else if(dist > 50) dist = 50;
	gDistance = (BYTE)dist;
}


//------------------------------------------------------------------------------
// MIC 신호 A/D
//------------------------------------------------------------------------------
void Get_AD_MIC(void)
{
	WORD	i;
	float	tmp = 0;
	
	gAD_Ch_Index = MIC_CH;
	for(i = 0; i < 50; i++){
    	F_AD_CONVERTING = 1;
	   	ADC_set(ADC_MODE_SINGLE);
    	while(F_AD_CONVERTING);            
    	tmp = tmp + gMIC_val;
    }
    tmp = tmp / 50;
	gSoundLevel = (BYTE)tmp;
}


//------------------------------------------------------------------------------
// 전원 전압 A/D
//------------------------------------------------------------------------------
void Get_VOLTAGE(void)
{
	if(F_DOWNLOAD) return;
	gAD_Ch_Index = VOLTAGE_CH;
	F_AD_CONVERTING = 1;
   	ADC_set(ADC_MODE_SINGLE);
	while(F_AD_CONVERTING);
}
#include <mega128.h>
#include "Main.h"
#include "Macro.h"
#include "accel.h"

//==============================================================//
// Start
//==============================================================//
void AccStart(void)
{
SDI_SET_OUTPUT;
SCK_SET_OUTPUT;
	P_ACC_SDI(1);
	P_ACC_SCK(1);
	#asm("nop");
	#asm("nop");
	P_ACC_SDI(0);
	#asm("nop");
	#asm("nop");
	P_ACC_SCK(0);
	#asm("nop");
	#asm("nop");
}


//==============================================================//
// Stop
//==============================================================//
void AccStop(void)
{
SDI_SET_OUTPUT;
SCK_SET_OUTPUT;
	P_ACC_SDI(0);
	P_ACC_SCK(1);
	#asm("nop");
	#asm("nop");
	P_ACC_SDI(1);
	#asm("nop");
	#asm("nop");
SDI_SET_INPUT;
SCK_SET_INPUT;
}


//==============================================================//
//
//==============================================================//
void AccByteWrite(BYTE bData)
{
	BYTE	i;
	BYTE	bTmp;

SDI_SET_OUTPUT;
	for(i=0; i<8; i++){
		bTmp = CHK_BIT7(bData);
    	if(bTmp){
			P_ACC_SDI(1);
		}else{
			P_ACC_SDI(0);
		}
		#asm("nop");
		#asm("nop");
		P_ACC_SCK(1);;
		#asm("nop");
		#asm("nop");
		#asm("nop");
		#asm("nop");
		P_ACC_SCK(0);
		#asm("nop");
		#asm("nop");
		bData =	bData << 1;
	}
}


//==============================================================//
//
//==============================================================//
char AccByteRead(void)
{
	BYTE	i;
	char	bTmp = 0;

SDI_SET_INPUT;
	for(i = 0; i < 8;	i++){
		bTmp = bTmp << 1;
		#asm("nop");
		#asm("nop");
		#asm("nop");
		#asm("nop");
		P_ACC_SCK(1);
		#asm("nop");
		#asm("nop");
		if(SDI_CHK)	bTmp |= 0x01;
		#asm("nop");
		#asm("nop");
		P_ACC_SCK(0);
	}
SDI_SET_OUTPUT;

	return	bTmp;
}


//==============================================================//
//
//==============================================================//
void AccAckRead(void)
{
SDI_SET_INPUT;
	#asm("nop");
	#asm("nop");
	P_ACC_SDI(1);
	#asm("nop");
	#asm("nop");
	P_ACC_SCK(1);
	#asm("nop");
	#asm("nop");
	P_ACC_SCK(0);
	#asm("nop");
	#asm("nop");
SDI_SET_OUTPUT;
	#asm("nop");
	#asm("nop");
}


//==============================================================//
//
//==============================================================//
void AccAckWrite(void)
{
SDI_SET_OUTPUT;
	#asm("nop");
	#asm("nop");
	P_ACC_SDI(0);
	#asm("nop");
	#asm("nop");
	P_ACC_SCK(1);
	#asm("nop");
	#asm("nop");
	P_ACC_SCK(0);
	#asm("nop");
	#asm("nop");
	P_ACC_SDI(1);
	#asm("nop");
	#asm("nop");
}


//==============================================================//
//
//==============================================================//
void AccNotAckWrite(void)
{
SDI_SET_OUTPUT;
	#asm("nop");
	#asm("nop");
	P_ACC_SDI(1);
	#asm("nop");
	#asm("nop");
	P_ACC_SCK(1);
	#asm("nop");
	#asm("nop");
	P_ACC_SCK(0);
	#asm("nop");
	#asm("nop");
}


//==============================================================//
//==============================================================//
void Acc_init(void)
{
	AccStart();
	AccByteWrite(0x70);
	AccAckRead();
	AccByteWrite(0x14);
	AccAckRead();
	AccByteWrite(0x03);
	AccAckRead();
	AccStop();
}

//==============================================================//
//==============================================================//
void AccGetData(void)
{
	signed char	bTmp = 0;

	AccStart();
	AccByteWrite(0x70);
	AccAckRead();
	AccByteWrite(0x02);
	AccAckRead();
	AccStop();

	#asm("nop");
	#asm("nop");
	#asm("nop");
	#asm("nop");

	AccStart();
	AccByteWrite(0x71);
	AccAckRead();

	bTmp = AccByteRead();
	AccAckWrite();

	bTmp = AccByteRead();
	AccAckWrite();
	gAccX = bTmp;

	bTmp = AccByteRead();
	AccAckWrite();

	bTmp = AccByteRead();
	AccAckWrite();
	gAccY = bTmp;

	bTmp = AccByteRead();
	AccAckWrite();

	bTmp = AccByteRead();
	AccNotAckWrite();
	gAccZ = bTmp;

	AccStop();
}
