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
			 	SendToSoundIC(2);
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