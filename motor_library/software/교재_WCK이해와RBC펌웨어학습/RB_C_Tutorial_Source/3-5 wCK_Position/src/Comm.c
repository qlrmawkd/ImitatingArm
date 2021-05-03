//==============================================================================
//						Communication & Command ÇÔ¼öµé
//==============================================================================

#include <mega128.h>
#include <string.h>
#include "Main.h"
#include "Macro.h"
#include "Comm.h"
#include "p_ex1.h"

//------------------------------------------------------------------------------
// ½Ã¸®¾ó Æ÷Æ®·Î ÇÑ ¹®ÀÚ¸¦ Àü¼ÛÇÏ±â À§ÇÑ ÇÔ¼ö
//------------------------------------------------------------------------------
void sciTx0Data(BYTE td)
{
	while(!(UCSR0A&(1<<UDRE))); 	// ÀÌÀüÀÇ Àü¼ÛÀÌ ¿Ï·áµÉ¶§±îÁö ´ë±â
	UDR0=td;
}

void sciTx1Data(BYTE td)
{
	while(!(UCSR1A&(1<<UDRE))); 	// ÀÌÀüÀÇ Àü¼ÛÀÌ ¿Ï·áµÉ¶§±îÁö ´ë±â
	UDR1=td;
}


//------------------------------------------------------------------------------
// ½Ã¸®¾ó Æ÷Æ®·Î ÇÑ ¹®ÀÚ¸¦ ¹ÞÀ»¶§±îÁö ´ë±âÇÏ±â À§ÇÑ ÇÔ¼ö
//------------------------------------------------------------------------------
BYTE sciRx0Ready(void)
{
	WORD	startT;
	startT = gMSEC;
	while(!(UCSR0A&(1<<RXC)) ){ 	// ÇÑ ¹®ÀÚ°¡ ¼ö½ÅµÉ¶§±îÁö ´ë±â
        if(gMSEC<startT){
			// Å¸ÀÓ ¾Æ¿ô½Ã ·ÎÄÃ Å»Ãâ
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
	while(!(UCSR1A&(1<<RXC)) ){ 	// ÇÑ ¹®ÀÚ°¡ ¼ö½ÅµÉ¶§±îÁö ´ë±â
        if(gMSEC<startT){
			// Å¸ÀÓ ¾Æ¿ô½Ã ·ÎÄÃ Å»Ãâ
            if((1000 - startT + gMSEC)>RX_T_OUT) break;
        }
		else if((gMSEC-startT)>RX_T_OUT) break;
	}
	return UDR1;
}


//------------------------------------------------------------------------------
// wCKÀÇ ÆÄ¶ó¹ÌÅÍ¸¦ ¼³Á¤ÇÒ ¶§ »ç¿ë
// Input	: Data1, Data2, Data3, Data4
// Output	: None
//------------------------------------------------------------------------------
void SendSetCmd(BYTE ID, BYTE Data1, BYTE Data2, BYTE Data3)
{
	BYTE CheckSum; 
	ID=(BYTE)(7<<5)|ID; 
	CheckSum = (ID^Data1^Data2^Data3)&0x7f;

	gTx0Buf[gTx0Cnt]=HEADER;
	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡

	gTx0Buf[gTx0Cnt]=ID;
	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡

	gTx0Buf[gTx0Cnt]=Data1;
	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡

	gTx0Buf[gTx0Cnt]=Data2;
	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡

	gTx0Buf[gTx0Cnt]=Data3;
	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡

	gTx0Buf[gTx0Cnt]=CheckSum;
	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
}


//------------------------------------------------------------------------------
// µ¿±âÈ­ À§Ä¡ ¸í·É(Synchronized Position Send Command)À» º¸³»´Â ÇÔ¼ö
//------------------------------------------------------------------------------
void SyncPosSend(void) 
{
	int lwtmp;
	BYTE CheckSum; 
	BYTE i, tmp, Data;

	Data = (Scene.wCK[0].Torq<<5) | 31;

	gTx0Buf[gTx0Cnt]=HEADER;
	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡

	gTx0Buf[gTx0Cnt]=Data;
	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡

	gTx0Buf[gTx0Cnt]=16;
	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡

	CheckSum = 0;
	for(i=0;i<MAX_wCK;i++){	// °¢ wCK µ¥ÀÌÅÍ ÁØºñ
		if(Scene.wCK[i].Exist){	// Á¸ÀçÇÏ´Â ID¸¸ ÁØºñ
			lwtmp = (int)Scene.wCK[i].SPos + (int)((float)gFrameIdx*gUnitD[i]);
			if(lwtmp>254)		lwtmp = 254;
			else if(lwtmp<1)	lwtmp = 1;
			tmp = (BYTE)lwtmp;
			gTx0Buf[gTx0Cnt] = tmp;
			gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
			CheckSum = CheckSum^tmp;
		}
	}
	CheckSum = CheckSum & 0x7f;

	gTx0Buf[gTx0Cnt]=CheckSum;
	gTx0Cnt++;			// ¼Û½ÅÇÒ ¹ÙÀÌÆ®¼ö Áõ°¡
} 

//------------------------------------------------------------------------------
// 8bit Command Position Move Function ö
// Input	: torq ID, Position
// Output	: None
//------------------------------------------------------------------------------
void PositionMove(BYTE torq, BYTE ID, BYTE position)
{
    BYTE CheckSum;
    ID = (BYTE)(torq << 5) | ID;
    CheckSum = (ID ^ position) & 0x7f;
    
    sciTx0Data(0xff);
	sciTx0Data(ID);
	sciTx0Data(position);
	sciTx0Data(CheckSum);
}                       

//------------------------------------------------------------------------------
// À§Ä¡ ÀÐ±â ¸í·É(Position Send Command)À» º¸³»´Â ÇÔ¼ö
// Input	: ID, SpeedLevel, Position
// Output	: Current
// UART0 RX ÀÎÅÍ·´Æ®, Timer0 ÀÎÅÍ·´Æ®°¡ È°¼ºÈ­ µÇ¾î ÀÖ¾î¾ß ÇÔ
//------------------------------------------------------------------------------
WORD PosRead(BYTE ID) 
{
	BYTE	Data1, Data2;
	BYTE	CheckSum, Load, Position; 
	WORD	startT;

	Data1 = (5<<5) | ID;
	Data2 = 0;
	gRx0Cnt = 0;			// ¼ö½Å ¹ÙÀÌÆ® ¼ö ÃÊ±âÈ­
	CheckSum = (Data1^Data2)&0x7f;
	sciTx0Data(HEADER);
	sciTx0Data(Data1);
	sciTx0Data(Data2);
	sciTx0Data(CheckSum);
	startT = gMSEC;
	while(gRx0Cnt<2){
        if(gMSEC<startT){ 	// ¹Ð¸®ÃÊ Ä«¿îÆ®°¡ ¸®¼ÂµÈ °æ¿ì
            if((1000 - startT + gMSEC)>RX_T_OUT)
            	return 444;	// Å¸ÀÓ¾Æ¿ô½Ã ·ÎÄÃ Å»Ãâ
        }
		else if((gMSEC-startT)>RX_T_OUT) return 444;
	}
	return gRx0Buf[RX0_BUF_SIZE-1];
} 


//------------------------------------------------------------------------------
// Flash¿¡¼­ ¸ð¼Ç Á¤º¸ ÀÐ±â
//	MRIdx : ¸ð¼Ç »ó´ë ÀÎµ¦½º
//------------------------------------------------------------------------------
void GetMotionFromFlash(void)
{
	WORD i;

	for(i=0;i<MAX_wCK;i++){				// wCK ÆÄ¶ó¹ÌÅÍ ±¸Á¶Ã¼ ÃÊ±âÈ­
		Motion.wCK[i].Exist		= 0;
		Motion.wCK[i].RPgain	= 0;
		Motion.wCK[i].RDgain	= 0;
		Motion.wCK[i].RIgain	= 0;
		Motion.wCK[i].PortEn	= 0;
		Motion.wCK[i].InitPos	= 0;
	}
	for(i=0;i<Motion.NumOfwCK;i++){		// °¢ wCK ÆÄ¶ó¹ÌÅÍ ºÒ·¯¿À±â
		Motion.wCK[wCK_IDs[i]].Exist		= 1;
		Motion.wCK[wCK_IDs[i]].RPgain	= *(gpPg_Table+i);
		Motion.wCK[wCK_IDs[i]].RDgain	= *(gpDg_Table+i);
		Motion.wCK[wCK_IDs[i]].RIgain	= *(gpIg_Table+i);
		Motion.wCK[wCK_IDs[i]].PortEn	= 1;
		Motion.wCK[wCK_IDs[i]].InitPos	= MotionZeroPos[i];
	}
}


//------------------------------------------------------------------------------
// Runtime P,D,I ÀÌµæ ¼Û½Å
// 		: ¸ð¼ÇÁ¤º¸¿¡¼­ Runtime P,D,IÀÌµæÀ» ºÒ·¯¿Í¼­ wCK¿¡°Ô º¸³½´Ù
//------------------------------------------------------------------------------
void SendTGain(void)
{
	WORD i;

	UCSR0B &= 0x7F;   		// UART0 RxÀÎÅÍ·´Æ® ¹Ì»ç¿ë
	UCSR0B |= 0x40;   		// UART0 TxÀÎÅÍ·´Æ® »ç¿ë

	while(gTx0Cnt);			// ÀÌÀü ÆÐÅ¶ ¼Û½ÅÀÌ ³¡³¯ ¶§±îÁö ´ë±â
	for(i=0;i<MAX_wCK;i++){					// Runtime P,DÀÌµæ ¼³Á¤ ÆÐÅ¶ ÁØºñ
		if(Motion.wCK[i].Exist)				// Á¸ÀçÇÏ´Â ID¸¸ ÁØºñ
			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// Ã¹¹ÙÀÌÆ® ¼Û½Å ½ÃÀÛ


	while(gTx0Cnt);			// ÀÌÀü ÆÐÅ¶ ¼Û½ÅÀÌ ³¡³¯ ¶§±îÁö ´ë±â
	for(i=0;i<MAX_wCK;i++){					// Runtime IÀÌµæ ¼³Á¤ ÆÐÅ¶ ÁØºñ
		if(Motion.wCK[i].Exist)				// Á¸ÀçÇÏ´Â ID¸¸ ÁØºñ
			SendSetCmd(i, 24, Motion.wCK[i].RIgain, Motion.wCK[i].RIgain);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// Ã¹¹ÙÀÌÆ® ¼Û½Å ½ÃÀÛ
}


//------------------------------------------------------------------------------
// È®Àå Æ÷Æ®°ª ¼Û½Å
// 		: ¾À Á¤º¸¿¡¼­ È®Àå Æ÷Æ®°ªÀ» ºÒ·¯¿Í¼­ wCK¿¡°Ô º¸³½´Ù
//------------------------------------------------------------------------------
void SendExPortD(void)
{
	WORD i;

	UCSR0B &= 0x7F;   		// UART0 RxÀÎÅÍ·´Æ® ¹Ì»ç¿ë
	UCSR0B |= 0x40;   		// UART0 TxÀÎÅÍ·´Æ® »ç¿ë

	while(gTx0Cnt);			// ÀÌÀü ÆÐÅ¶ ¼Û½ÅÀÌ ³¡³¯ ¶§±îÁö ´ë±â
	for(i=0;i<MAX_wCK;i++){					// Runtime P,DÀÌµæ ¼³Á¤ ÆÐÅ¶ ÁØºñ
		if(Scene.wCK[i].Exist)				// Á¸ÀçÇÏ´Â ID¸¸ ÁØºñ
			SendSetCmd(i, 100, Scene.wCK[i].ExPortD, Scene.wCK[i].ExPortD);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// Ã¹¹ÙÀÌÆ® ¼Û½Å ½ÃÀÛ
}


//------------------------------------------------------------------------------
// Flash¿¡¼­ ¾À Á¤º¸ ÀÐ±â
//	ScIdx : ¾À ÀÎµ¦½º
//------------------------------------------------------------------------------
void GetSceneFromFlash(void)
{
	WORD i;
	
	Scene.NumOfFrame = gpFN_Table[gSIdx];	// ÇÁ·¹ÀÓ¼ö
	Scene.RTime = gpRT_Table[gSIdx];		// ¾À ¼öÇà ½Ã°£[msec]
	for(i=0;i<Motion.NumOfwCK;i++){			// °¢ wCK µ¥ÀÌÅÍ ÃÊ±âÈ­
		Scene.wCK[i].Exist		= 0;
		Scene.wCK[i].SPos		= 0;
		Scene.wCK[i].DPos		= 0;
		Scene.wCK[i].Torq		= 0;
		Scene.wCK[i].ExPortD	= 0;
	}
	for(i=0;i<Motion.NumOfwCK;i++){			// °¢ wCK µ¥ÀÌÅÍ ÀúÀå
		Scene.wCK[wCK_IDs[i]].Exist		= 1;
		Scene.wCK[wCK_IDs[i]].SPos		= gpPos_Table[Motion.NumOfwCK*gSIdx+i];
		Scene.wCK[wCK_IDs[i]].DPos		= gpPos_Table[Motion.NumOfwCK*(gSIdx+1)+i];
		Scene.wCK[wCK_IDs[i]].Torq		= gpT_Table[Motion.NumOfwCK*gSIdx+i];
		Scene.wCK[wCK_IDs[i]].ExPortD	= gpE_Table[Motion.NumOfwCK*gSIdx+i];
	}
	UCSR0B &= 0x7F;   		// UART0 RxÀÎÅÍ·´Æ® ¹Ì»ç¿ë
	UCSR0B |= 0x40;   		// UART0 TxÀÎÅÍ·´Æ® »ç¿ë

	delay_us(1300);
}


//------------------------------------------------------------------------------
// ÇÁ·¹ÀÓ ¼Û½Å °£°Ý °è»ê
// 		: ¾À ¼öÇà ½Ã°£À» ÇÁ·¹ÀÓ¼ö·Î ³ª´²¼­ intervalÀ» Á¤ÇÑ´Ù
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
	F_PLAYING=1;		// ¸ð¼Ç ½ÇÇàÁß Ç¥½Ã
	TCCR1B=0x05;

	if(TxInterval<=65509)	
		TCNT1=TxInterval+26;
	else
		TCNT1=65535;

	TIFR |= 0x04;		// Å¸ÀÌ¸Ó ÀÎÅÍ·´Æ® ÇÃ·¡±× ÃÊ±âÈ­
	TIMSK |= 0x04;		// Timer1 Overflow Interrupt È°¼ºÈ­(140ÂÊ)
}


//------------------------------------------------------------------------------
// ÇÁ·¹ÀÓ´ç ´ÜÀ§ ÀÌµ¿·® °è»ê
//------------------------------------------------------------------------------
void CalcUnitMove(void)
{
	WORD i;

	for(i=0;i<MAX_wCK;i++){
		if(Scene.wCK[i].Exist){	// Á¸ÀçÇÏ´Â ID¸¸ ÁØºñ
			if(Scene.wCK[i].SPos!=Scene.wCK[i].DPos){
				// ÇÁ·¹ÀÓ´ç ´ÜÀ§ º¯À§ Áõ°¡·® °è»ê
				gUnitD[i] = (float)((int)Scene.wCK[i].DPos-(int)Scene.wCK[i].SPos);
				gUnitD[i] = (float)(gUnitD[i]/Scene.NumOfFrame);
				if(gUnitD[i]>253)	gUnitD[i]=254;
				else if(gUnitD[i]<-253)	gUnitD[i]=-254;
			}
			else
				gUnitD[i] = 0;
		}
	}
	gFrameIdx=0;				// ÇÁ·¹ÀÓ ÀÎµ¦½º ÃÊ±âÈ­
}


//------------------------------------------------------------------------------
// ÇÑ ÇÁ·¹ÀÓ ¼Û½Å ÁØºñ
//------------------------------------------------------------------------------
void MakeFrame(void)
{
	while(gTx0Cnt);			// ÀÌÀü ÇÁ·¹ÀÓ ¼Û½ÅÀÌ ³¡³¯ ¶§±îÁö ´ë±â
	gFrameIdx++;			// ÇÁ·¹ÀÓ ÀÎµ¦½º Áõ°¡
	SyncPosSend();			// µ¿±âÈ­ À§Ä¡ ¸í·ÉÀ¸·Î ¼Û½Å
}


//------------------------------------------------------------------------------
// ÇÑ ÇÁ·¹ÀÓ ¼Û½Å
//------------------------------------------------------------------------------
void SendFrame(void)
{
	if(gTx0Cnt==0)	return;	// º¸³¾ µ¥ÀÌÅÍ°¡ ¾øÀ¸¸é ½ÇÇà ¾ÈÇÔ
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// Ã¹¹ÙÀÌÆ® ¼Û½Å ½ÃÀÛ
}


//------------------------------------------------------------------------------
// 
//------------------------------------------------------------------------------
void M_PlayFlash(void)
{
	float tmp;
	WORD i;

	GetMotionFromFlash();		// °¢ wCK ÆÄ¶ó¹ÌÅÍ ºÒ·¯¿À±â
	SendTGain();				// RuntimeÀÌµæ ¼Û½Å
	for(i=0;i<Motion.NumOfScene;i++){
		gSIdx = i;
		GetSceneFromFlash();	// ÇÑ ¾ÀÀ» ºÒ·¯¿Â´Ù
		SendExPortD();			// È®Àå Æ÷Æ®°ª ¼Û½Å
		CalcFrameInterval();	// ÇÁ·¹ÀÓ ¼Û½Å °£°Ý °è»ê, Å¸ÀÌ¸Ó1 ½ÃÀÛ
		CalcUnitMove();			// ÇÁ·¹ÀÓ´ç ´ÜÀ§ ÀÌµ¿·® °è»ê
		MakeFrame();			// ÇÑ ÇÁ·¹ÀÓ ÁØºñ
		SendFrame();			// ÇÑ ÇÁ·¹ÀÓ ¼Û½Å
		while(F_PLAYING);
	}
}


void SampleMotion1(void)	// »ùÇÃ ¸ð¼Ç 1
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
