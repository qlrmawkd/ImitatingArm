//==============================================================================
//						Digital Input Output 관련 함수들
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
void ReadButton(void);
void ReadButton(void);
void ProcButton(void);
void IoUpdate(void);
void ProcIr(void);
void SelfTest1(void);
//------------------------------------------------------------------------------
// 버튼 읽기
//------------------------------------------------------------------------------
void ReadButton(void)
{
	unsigned char	lbtmp;
	lbtmp = PINA & 0x03;
	if(F_DOWNLOAD) return;
	if(lbtmp == 0x02){
		gPF1BtnCnt++;		gPF2BtnCnt = 0;		gPF12BtnCnt = 0;
       	if(gPF1BtnCnt > 3000){
			gBtn_val = 4;
			gPF1BtnCnt = 0;
		}
	}
	else if(lbtmp == 0x01){
		gPF1BtnCnt = 0;		gPF2BtnCnt++;		gPF12BtnCnt = 0;
       	if(gPF2BtnCnt > 3000){
			gBtn_val = 5;
			gPF2BtnCnt = 0;
		}
	}
	else if(lbtmp == 0x00){
		gPF1BtnCnt = 0;		gPF2BtnCnt = 0;		gPF12BtnCnt++;
       	if(gPF12BtnCnt > 2000){
           	if(F_PF_CHANGED == 0){
				gBtn_val = 6;
	       	    gPF12BtnCnt = 0;
			}
		}
	}
	else{
		if(gPF1BtnCnt > 40 && gPF1BtnCnt < 500){
			gBtn_val = 1;
		}
		else if(gPF2BtnCnt > 40 && gPF2BtnCnt < 500){
			gBtn_val = 2;
		}
		else if(gPF12BtnCnt > 40 && gPF12BtnCnt < 500){
			gBtn_val = 3;
		}
		else
			gBtn_val = 0;
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
	unsigned int	i;
	if(gBtn_val == 6){
		gBtn_val = 0;
		if(F_PS_PLUGGED){
			BreakModeCmdSend();
			ChargeNiMH();
		}
	}
	else if(gBtn_val == 4){
		gBtn_val = 0;
		if(F_PF==1){
			F_PF=2;
			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Dino[i], U_Boundary_Dino[i]);
		}
		else if(F_PF==2){
			F_PF=3;
			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Dogy[i], U_Boundary_Dogy[i]);
		}
		else{
			F_PF=1;
			for(i=0;i<16;i++) BoundSetCmdSend(i, L_Boundary_Huno[i], U_Boundary_Huno[i]);
		}
		BreakModeCmdSend();
		delay_ms(10);
		F_PF_CHANGED = 1;
		ePF = F_PF;
	}
	else if(gBtn_val == 5){
		gBtn_val = 0;
		F_PF = 4;
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
			(PORTA &= 0xFB);
			(PORTA |= 0x08);
			(PORTA &= 0xEF);
			return;
	}
	switch(F_PF){
		case 1:
			(PORTA &= 0xFB);
			(PORTA |= 0x08);
			(PORTA |= 0x10);
			break;
		case 2:
			(PORTA &= 0xFB);
			(PORTA &= 0xF7);
			(PORTA |= 0x10);
			break;
		case 3:
			(PORTA |= 0x04);
			(PORTA &= 0xF7);
			(PORTA |= 0x10);
			break;
		case 4:
			(PORTA |= 0x04);
			(PORTA |= 0x08);
			(PORTA &= 0xEF);
			break;
		default:
			F_PF = 4;
	}
	if(gVOLTAGE>8600){
		((*(unsigned char *) 0x65) &= 0xFB);
		(PORTC |= 0x80);
		gPwrLowCount = 0;
	}
	else if(gVOLTAGE>8100){
		((*(unsigned char *) 0x65) |= 0x04);
		(PORTC &= 0x7F);
		gPwrLowCount++;
		if(gPwrLowCount>5000){
			gPwrLowCount = 0;
			BreakModeCmdSend();
		}
	}
	else{
		((*(unsigned char *) 0x65) |= 0x04);
		if(g10MSEC<25)			(PORTC &= 0x7F);
		else if(g10MSEC<50)		(PORTC |= 0x80);
		else if(g10MSEC<75)		(PORTC &= 0x7F);
		else if(g10MSEC<100)	(PORTC |= 0x80);
		gPwrLowCount++;
		if(gPwrLowCount>3000){
			gPwrLowCount=0;
			BreakModeCmdSend();
		}
	}
	if(F_ERR_CODE == 0xff)	(PORTA |= 0x80);
	else (PORTA &= 0x7F);
}
//------------------------------------------------------------------------------
// 자체 테스트1
//------------------------------------------------------------------------------
void SelfTest1(void)
{
	unsigned int	i;
	if(F_DIRECT_C_EN)	return;
	for(i=0;i<16;i++){
		if((StandardZeroPos[i]+15)<eM_OriginPose[i]
		 ||(StandardZeroPos[i]-15)>eM_OriginPose[i]){
			F_ERR_CODE = 8;
			return;
		}
	}
	((*(unsigned char *) 0x65) &= 0xFB);	delay_ms(60);	((*(unsigned char *) 0x65) |= 0x04);
	(PORTC &= 0x7F);	delay_ms(60);	(PORTC |= 0x80);
	(PORTA &= 0xDF);	delay_ms(60);	(PORTA |= 0x20);
	(PORTA &= 0xBF);	delay_ms(60);	(PORTA |= 0x40);
	(PORTA &= 0x7F);		delay_ms(60);	(PORTA |= 0x80);
	(PORTA &= 0xEF);		delay_ms(60);	(PORTA |= 0x10);
	(PORTA &= 0xF7);	delay_ms(60);	(PORTA |= 0x08);
	(PORTA &= 0xFB);	delay_ms(60);	(PORTA |= 0x04);
}
//------------------------------------------------------------------------------
// IR 수신 처리
//------------------------------------------------------------------------------
void ProcIr(void)
{
    unsigned int    i;
	if(F_DOWNLOAD) return;
	if(F_FIRST_M && gIrBuf[3]!=0x07		 && gIrBuf[3]!=0x2B		 && F_PF!=4) return;
	if(F_IR_RECEIVED){
	    EIMSK &= 0xBF;
		F_IR_RECEIVED = 0;
		if((gIrBuf[0]==eRCodeH[0] && gIrBuf[1]==eRCodeM[0] && gIrBuf[2]==eRCodeL[0])
		 ||(gIrBuf[0]==eRCodeH[1] && gIrBuf[1]==eRCodeM[1] && gIrBuf[2]==eRCodeL[1])
		 ||(gIrBuf[0]==eRCodeH[2] && gIrBuf[1]==eRCodeM[2] && gIrBuf[2]==eRCodeL[2])
		 ||(gIrBuf[0]==eRCodeH[3] && gIrBuf[1]==eRCodeM[3] && gIrBuf[2]==eRCodeL[3])
		 ||(gIrBuf[0]==eRCodeH[4] && gIrBuf[1]==eRCodeM[4] && gIrBuf[2]==eRCodeL[4])){
			switch(gIrBuf[3]){
				case 0x01		:
					M_Play(0x01		);
					break;
				case 0x02		:
					M_Play(0x02		);
					break;
				case 0x03		:
					M_Play(0x03		);
					break;
				case 0x04		:
					M_Play(0x04		);
					break;
				case 0x05		:
					M_Play(0x05		);
					break;
				case 0x06		:
					M_Play(0x06		);
					break;
				case 0x08		:
					M_Play(0x08		);
					break;
				case 0x09		:
					M_Play(0x09		);
					break;
				case 0x0A		:
					M_Play(0x0A		);
					break;
				case 0x0B		:
					M_Play(0x0B		);
					break;
				case 0x07		:
					F_FIRST_M = 0;
					M_Play(0x07		);
					break;
				case 0x0C		:
					break;
				case 0x0D		:
					break;
				case 0x0E		:
					break;
				case 0x0F		:
					break;
				case 0x10		:
					break;
				case 0x11		:
					break;
				case 0x12		:
					break;
				case 0x13		:
					break;
				case 0x14		:
				    User_Func();
					break;
				case 0x15		:
					M_Play(0x15		);
					break;
				case 0x16		:
					M_Play(0x16		);
					break;
				case 0x17		:
					M_Play(0x17		);
					break;
				case 0x1C		:
					M_Play(0x1C		);
					break;
				case 0x21		:
					break;
				case 0x22		:
					break;
				case 0x23		:
					break;
				case 0x24		:
					break;
				case 0x25		:
					break;
				case 0x26		:
					break;
				case 0x27		:
					break;
				case 0x28		:
					break;
				case 0x29		:
					break;
				case 0x2A		:
					break;
				case 0x36		:
					break;
				case 0x37		:
					break;
				case 0x38		:
					break;
				case 0x39		:
					break;
				case 0x3A		:
					break;
				case 0x3B		:
					break;
				case 0x3C		:
					break;
				case 0x3D		:
					break;
				case 0x3E		:
					break;
				case 0x3F		:
					break;
				case 0x2B		:
					if(F_PS_PLUGGED){
						BreakModeCmdSend();
						ChargeNiMH();
					}
					else{
					}
					break;
				case 0x2C		:
					break;
				case 0x31		:
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
		for(i=0;i<4;i++)	gIrBuf[i]=0;
	    EIMSK |= 0x40;
	}
}
