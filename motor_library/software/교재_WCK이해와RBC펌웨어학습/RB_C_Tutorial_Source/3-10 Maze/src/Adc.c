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
