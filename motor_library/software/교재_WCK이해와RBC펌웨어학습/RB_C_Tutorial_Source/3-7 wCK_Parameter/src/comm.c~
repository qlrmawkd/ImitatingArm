//==============================================================================
//						Communication & Command 함수들
//==============================================================================

#include <mega128.h>
#include <string.h>
#include "Main.h"
#include "Macro.h"
#include "Comm.h"
#include "p_ex1.h"

//------------------------------------------------------------------------------
// 시리얼 포트로 한 문자를 전송하기 위한 함수
//------------------------------------------------------------------------------
void sciTx0Data(BYTE td)
{
	while(!(UCSR0A&(1<<UDRE))); 	// 이전의 전송이 완료될때까지 대기
	UDR0=td;
}

void sciTx1Data(BYTE td)
{
	while(!(UCSR1A&(1<<UDRE))); 	// 이전의 전송이 완료될때까지 대기
	UDR1=td;
}


//------------------------------------------------------------------------------
// 시리얼 포트로 한 문자를 받을때까지 대기하기 위한 함수
//------------------------------------------------------------------------------
BYTE sciRx0Ready(void)
{
	WORD	startT;
	startT = gMSEC;
	while(!(UCSR0A&(1<<RXC)) ){ 	// 한 문자가 수신될때까지 대기
        if(gMSEC<startT){
			// 타임 아웃시 로컬 탈출
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
	while(!(UCSR1A&(1<<RXC)) ){ 	// 한 문자가 수신될때까지 대기
        if(gMSEC<startT){
			// 타임 아웃시 로컬 탈출
            if((1000 - startT + gMSEC)>RX_T_OUT) break;
        }
		else if((gMSEC-startT)>RX_T_OUT) break;
	}
	return UDR1;
}


//------------------------------------------------------------------------------
// wCK의 파라미터를 설정할 때 사용
// Input	: Data1, Data2, Data3, Data4
// Output	: None
//------------------------------------------------------------------------------
void SendSetCmd(BYTE ID, BYTE Data1, BYTE Data2, BYTE Data3)
{
	BYTE CheckSum; 
	ID=(BYTE)(7<<5)|ID; 
	CheckSum = (ID^Data1^Data2^Data3)&0x7f;

	gTx0Buf[gTx0Cnt]=HEADER;
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
	BYTE CheckSum; 
	BYTE i, tmp, Data;

	Data = (Scene.wCK[0].Torq<<5) | 31;

	gTx0Buf[gTx0Cnt]=HEADER;
	gTx0Cnt++;			// 송신할 바이트수 증가

	gTx0Buf[gTx0Cnt]=Data;
	gTx0Cnt++;			// 송신할 바이트수 증가

	gTx0Buf[gTx0Cnt]=16;
	gTx0Cnt++;			// 송신할 바이트수 증가

	CheckSum = 0;
	for(i=0;i<MAX_wCK;i++){	// 각 wCK 데이터 준비
		if(Scene.wCK[i].Exist){	// 존재하는 ID만 준비
			lwtmp = (int)Scene.wCK[i].SPos + (int)((float)gFrameIdx*gUnitD[i]);
			if(lwtmp>254)		lwtmp = 254;
			else if(lwtmp<1)	lwtmp = 1;
			tmp = (BYTE)lwtmp;
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
// 확장 명령 I/O Write를 수행하기 위한 함수
// Input	: ID, IOchannel
// Output	: None
//------------------------------------------------------------------------------
void IOwrite(BYTE ID, BYTE IOchannel)
{
    BYTE CheckSum; 
	ID=(BYTE)(7<<5)|ID; 
	CheckSum = (ID^100^IOchannel^IOchannel)&0x7f;

	gTx0Buf[gTx0Cnt]=HEADER;    gTx0Cnt++;			// 송신할 바이트수 증가
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
WORD PosRead(BYTE ID) 
{
	BYTE	Data1, Data2;
	BYTE	CheckSum, Load, Position; 
	WORD	startT;

	Data1 = (5<<5) | ID;
	Data2 = 0;
	gRx0Cnt = 0;			// 수신 바이트 수 초기화
	CheckSum = (Data1^Data2)&0x7f;
	sciTx0Data(HEADER);
	sciTx0Data(Data1);
	sciTx0Data(Data2);
	sciTx0Data(CheckSum);
	startT = gMSEC;
	while(gRx0Cnt<2){
        if(gMSEC<startT){ 	// 밀리초 카운트가 리셋된 경우
            if((1000 - startT + gMSEC)>RX_T_OUT)
            	return 444;	// 타임아웃시 로컬 탈출
        }
		else if((gMSEC-startT)>RX_T_OUT) return 444;
	}
	return gRx0Buf[RX0_BUF_SIZE-1];
} 


//------------------------------------------------------------------------------
// Flash에서 모션 정보 읽기
//	MRIdx : 모션 상대 인덱스
//------------------------------------------------------------------------------
void GetMotionFromFlash(void)
{
	WORD i;

	for(i=0;i<MAX_wCK;i++){				// wCK 파라미터 구조체 초기화
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
	WORD i;

	UCSR0B &= 0x7F;   		// UART0 Rx인터럽트 미사용
	UCSR0B |= 0x40;   		// UART0 Tx인터럽트 사용

	while(gTx0Cnt);			// 이전 패킷 송신이 끝날 때까지 대기
	for(i=0;i<MAX_wCK;i++){					// Runtime P,D이득 설정 패킷 준비
		if(Motion.wCK[i].Exist)				// 존재하는 ID만 준비
			SendSetCmd(i, 11, Motion.wCK[i].RPgain, Motion.wCK[i].RDgain);
	}
	gTx0BufIdx++;
	sciTx0Data(gTx0Buf[gTx0BufIdx-1]);		// 첫바이트 송신 시작


	while(gTx0Cnt);			// 이전 패킷 송신이 끝날 때까지 대기
	for(i=0;i<MAX_wCK;i++){					// Runtime I이득 설정 패킷 준비
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
	WORD i;

	UCSR0B &= 0x7F;   		// UART0 Rx인터럽트 미사용
	UCSR0B |= 0x40;   		// UART0 Tx인터럽트 사용

	while(gTx0Cnt);			// 이전 패킷 송신이 끝날 때까지 대기
	for(i=0;i<MAX_wCK;i++){					// Runtime P,D이득 설정 패킷 준비
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
	WORD i;
	
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
	TxInterval = 65535 - (WORD)tmp - 43;

	RUN_LED1_ON;
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
	WORD i;

	for(i=0;i<MAX_wCK;i++){
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
	WORD i;

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
	Motion.NumOfScene 	= M_EX1_NUM_OF_SCENES;
	Motion.NumOfwCK 	= M_EX1_NUM_OF_WCKS;
	M_PlayFlash();
}
