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

void ProcComm(void)
{
   	BYTE	lbtmp;
   	
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

void Robot_Forward(void)
{
    M_Play(BTN_U);  M_Play(BTN_U);    M_Play(BTN_RR);
}

void Robot_Backward(void)
{
    M_Play(BTN_D);
}

void User_Func(void)
{
    while(1){
        Get_AD_PSD();
        if( gDistance <= 12 )   Robot_Backward();
        else if( gDistance <= 30 ){ 
            Robot_Turn_Left_90();
            Get_AD_PSD();
            if((gDistance <= 30)){  Robot_Turn_Left_180();
                 Get_AD_PSD();
                 if((gDistance <= 30))  Robot_Turn_Right_90();
            }
        }
        else{    Robot_Forward();
        }
    }

}

//------------------------------------------------------------------------------
// 메인 함수
//------------------------------------------------------------------------------
void main(void) {
	WORD    l10MSEC;

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
		ProcComm();
	}
}
