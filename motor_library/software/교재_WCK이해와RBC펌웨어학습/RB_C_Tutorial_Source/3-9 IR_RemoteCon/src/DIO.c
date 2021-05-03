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
