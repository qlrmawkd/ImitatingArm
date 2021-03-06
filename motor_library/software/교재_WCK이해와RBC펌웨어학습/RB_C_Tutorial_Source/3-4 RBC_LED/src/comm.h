#define	RXB8	1
#define	TXB8	0
#define	UPE		2
#define	OVR		3
#define	FE		4
#define	UDRE	5
#define	RXC		7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// Frequency = 14.7456MHz 
// 클럭 14.7456 MHz일때의 보레이트 설정 상수 (에러 = 0%) 
#define BR9600		95 
#define BR19200		47 
#define BR38400		23 
#define BR57600		15
#define BR115200	7 
#define BR460800	1 

#define HEADER			0xFF 
#define WHEEL_ACT_CCW 	3 
#define WHEEL_ACT_CW	4 

#define START			0
#define STOP			1
#define PAUSE			2
#define RESUME    		3

#define RX_T_OUT    	20	// 수신 대기시간[msec]


void sciTx0Data(BYTE td);
void sciTx1Data(BYTE td);
BYTE sciRx0Ready(void);
BYTE sciRx1Ready(void);
void SendOperCmd(BYTE Data1,BYTE Data2);
void SendSetCmd(BYTE ID, BYTE Data1, BYTE Data2, BYTE Data3);
void PosSend(BYTE ID, BYTE SpeedLevel, BYTE Position);
void PassiveModeCmdSend(BYTE ID);
void SyncPosSend(void);
WORD PosRead(BYTE ID);
void GetMotionFromFlash(void);
void SendTGain(void);
void SendExPortD(void);
void GetSceneFromFlash(void);
void CalcFrameInterval(void);
void CalcUnitMove(void);
void MakeFrame(void);
void SendFrame(void);
void M_BasicPose(BYTE PF, WORD NOF, WORD RT, BYTE TQ);

