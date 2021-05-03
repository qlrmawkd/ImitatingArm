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