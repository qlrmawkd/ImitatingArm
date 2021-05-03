//==============================================================================
// 하드웨어 의존적인 정의들
//==============================================================================
#define	PF1_LED1_ON			CLR_BIT2(PORTA)
#define	PF1_LED1_OFF		SET_BIT2(PORTA)
#define	PF1_LED2_ON			CLR_BIT3(PORTA)
#define	PF1_LED2_OFF		SET_BIT3(PORTA)
#define	PF2_LED_ON			CLR_BIT4(PORTA)
#define	PF2_LED_OFF			SET_BIT4(PORTA)
#define	RUN_LED1_ON			CLR_BIT5(PORTA)
#define	RUN_LED1_OFF		SET_BIT5(PORTA)
#define	RUN_LED2_ON			CLR_BIT6(PORTA)
#define	RUN_LED2_OFF		SET_BIT6(PORTA)
#define	ERR_LED_ON			CLR_BIT7(PORTA)
#define	ERR_LED_OFF			SET_BIT7(PORTA)
#define	PWR_LED1_ON			CLR_BIT2(PORTG)
#define	PWR_LED1_OFF		SET_BIT2(PORTG)
#define	PWR_LED2_ON			CLR_BIT7(PORTC)
#define	PWR_LED2_OFF		SET_BIT7(PORTC)
#define	PSD_ON		        SET_BIT5(PORTB)
#define	PSD_OFF			    CLR_BIT5(PORTB)

#define P_BMC504_RESET(A)		if(A) SET_BIT6(PORTB);else CLR_BIT6(PORTB)
#define P_PWM_SOUND_CUTOFF(A)	if(A) CLR_BIT3(DDRE);else SET_BIT3(DDRE)

#define	SCL_HIGH			SET_BIT0(PORTD)
#define	SCL_LOW				CLR_BIT0(PORTD)
#define	SDA_HIGH			SET_BIT1(PORTD)
#define	SDA_LOW				CLR_BIT1(PORTD)
#define	SCL_SET_OUTPUT		SET_BIT0(DDRD)
#define	SCL_SET_INPUT		CLR_BIT0(DDRD)
#define	SDA_SET_OUTPUT		SET_BIT1(DDRD)
#define	SDA_SET_INPUT		CLR_BIT1(DDRD)
#define P_EEP_VCC(A)		if(A) SET_BIT2(PORTB);else CLR_BIT2(PORTB)
#define P_EEP_CLK(A)		if(A) SET_BIT0(PORTD);else CLR_BIT0(PORTD)
#define P_EEP_SIO(A)		if(A) SET_BIT1(PORTD);else CLR_BIT1(PORTD)

// 배터리 기준 전압 -----------------------------------------------
//#define	U_T_OF_POWER		12000		// 리튬폴리머 11.1V 배터리용
//#define	M_T_OF_POWER		9800
//#define	L_T_OF_POWER		9700
#define	U_T_OF_POWER		9650	// 표준 배터리용
#define	M_T_OF_POWER		8600
#define	L_T_OF_POWER		8100

#define	CHARGE_ENABLE		SET_BIT4(PORTB)
#define	CHARGE_DISABLE		CLR_BIT4(PORTB)

//==============================================================================
//						플랫폼(로봇 형태) 관련
//==============================================================================
#define	PF1_HUNO			1
#define	PF1_DINO			2
#define	PF1_DOGY			3
#define	PF2					4


//==============================================================================
//						버튼 관련
//==============================================================================
#define	BTN_NOT_PRESSED		0
#define	PF1_BTN_SHORT		1
#define	PF2_BTN_SHORT		2
#define	PF12_BTN_SHORT		3
#define	PF1_BTN_LONG		4
#define	PF2_BTN_LONG		5
#define	PF12_BTN_LONG		6


//==============================================================================
//						에러 코드(F_ERR_CODE에 저장)
//==============================================================================
#define	NO_ERR				0xff
#define	SEEPROM_WR_ERR		1
#define	CHKSUM_ERR			2
#define	OVER_NUM_OF_M	    3
#define	OVER_NUM_OF_A	    4
#define	PF_MATCH_ERR		5
#define	INTERVAL_ERR		6
#define	ZERO_SET_ERR		7
#define	ZERO_DATA_ERR		8
#define	WCK_NUM_ERR			9
#define	WCK_POS_ERR			10
#define	WCK_NO_ACK_ERR		11


//==============================================================================
//						UART 통신 관련
//==============================================================================
#define TX0_BUF_SIZE		186
#define RX0_BUF_SIZE		8
#define RX1_BUF_SIZE		20


//==============================================================================
//						A/D 관련
//==============================================================================
#define NUM_OF_AD_SAMPLE		10
#define ADC_VREF_TYPE			0x20
#define PSD_CH					0
#define VOLTAGE_CH				1
#define MIC_CH					0x0F
#define ADC_MODE_DISABLE		0x00     
#define ADC_MODE_SINGLE			0xDC
#define ADC_MODE_FREERUN_NOINT	0xE6
#define ADC_MODE_FREERUN_SP		0xED


//==============================================================================
//						액션/모션 관련
//==============================================================================
#define NUM_OF_WCK_HUNO		16
#define NUM_OF_WCK_DINO		16
#define NUM_OF_WCK_DOGY		16
#define	MAX_wCK				31
#define	POS_MARGIN			10


//==============================================================================
//						IR 리모컨 관련
//==============================================================================
#define NUM_OF_REMOCON		5
#define IR_BUFFER_SIZE		4
#define IR_HEADER_LT		63
#define IR_HEADER_UT		81
#define IR_LOW_BIT_LT		10
#define IR_LOW_BIT_UT		18
#define IR_HIGH_BIT_LT		19
#define IR_HIGH_BIT_UT		26

#define BTN_A		    0x01		// IR 리모컨 A
#define BTN_B		    0x02		// IR 리모컨 B
#define BTN_LR		    0x03		// IR 리모컨 좌회전
#define BTN_U		    0x04		// IR 리모컨 위로
#define BTN_RR		    0x05		// IR 리모컨 우회전
#define BTN_L		    0x06		// IR 리모컨 좌
#define BTN_C		    0x07		// IR 리모컨 중앙
#define BTN_R		    0x08		// IR 리모컨 우
#define BTN_LA		    0x09		// IR 리모컨 좌공격
#define BTN_D		    0x0A		// IR 리모컨 아래로
#define BTN_RA		    0x0B		// IR 리모컨 우공격
#define BTN_1		    0x0C		// IR 리모컨 1
#define BTN_2		    0x0D		// IR 리모컨 2
#define BTN_3		    0x0E		// IR 리모컨 3
#define BTN_4		    0x0F		// IR 리모컨 4
#define BTN_5		    0x10		// IR 리모컨 5
#define BTN_6		    0x11		// IR 리모컨 6
#define BTN_7		    0x12		// IR 리모컨 7
#define BTN_8		    0x13		// IR 리모컨 8
#define BTN_9		    0x14		// IR 리모컨 9
#define BTN_0		    0x15		// IR 리모컨 0

#define BTN_STAR_A		0x16		// IR 리모컨 *+A
#define BTN_STAR_B		0x17		// IR 리모컨 *+B
#define BTN_STAR_LR		0x18		// IR 리모컨 *+좌회전
#define BTN_STAR_U		0x19		// IR 리모컨 *+위로
#define BTN_STAR_RR		0x1A		// IR 리모컨 *+우회전
#define BTN_STAR_L		0x1B		// IR 리모컨 *+좌
#define BTN_STAR_C		0x1C		// IR 리모컨 *+중앙
#define BTN_STAR_R		0x1D		// IR 리모컨 *+우
#define BTN_STAR_LA		0x1E		// IR 리모컨 *+좌공격
#define BTN_STAR_D		0x1F		// IR 리모컨 *+아래로
#define BTN_STAR_RA		0x20		// IR 리모컨 *+우공격
#define BTN_STAR_1		0x21		// IR 리모컨 *+1
#define BTN_STAR_2		0x22		// IR 리모컨 *+2
#define BTN_STAR_3		0x23		// IR 리모컨 *+3
#define BTN_STAR_4		0x24		// IR 리모컨 *+4
#define BTN_STAR_5		0x25		// IR 리모컨 *+5
#define BTN_STAR_6		0x26		// IR 리모컨 *+6
#define BTN_STAR_7		0x27		// IR 리모컨 *+7
#define BTN_STAR_8		0x28		// IR 리모컨 *+8
#define BTN_STAR_9		0x29		// IR 리모컨 *+9
#define BTN_STAR_0		0x2A		// IR 리모컨 *+0

#define BTN_SHARP_A		0x2B		// IR 리모컨 #+A
#define BTN_SHARP_B		0x2C		// IR 리모컨 #+B
#define BTN_SHARP_LR    0x2D		// IR 리모컨 #+좌회전
#define BTN_SHARP_U		0x2E		// IR 리모컨 #+위로
#define BTN_SHARP_RR	0x2F		// IR 리모컨 #+우회전
#define BTN_SHARP_L		0x30		// IR 리모컨 #+좌
#define BTN_SHARP_C		0x31		// IR 리모컨 #+중앙
#define BTN_SHARP_R		0x32		// IR 리모컨 #+우
#define BTN_SHARP_LA	0x33		// IR 리모컨 #+좌공격
#define BTN_SHARP_D		0x34		// IR 리모컨 #+아래로
#define BTN_SHARP_RA	0x35		// IR 리모컨 #+우공격
#define BTN_SHARP_1		0x36		// IR 리모컨 #+1
#define BTN_SHARP_2		0x37		// IR 리모컨 #+2
#define BTN_SHARP_3		0x38		// IR 리모컨 #+3
#define BTN_SHARP_4		0x39		// IR 리모컨 #+4
#define BTN_SHARP_5		0x3A		// IR 리모컨 #+5
#define BTN_SHARP_6		0x3B		// IR 리모컨 #+6
#define BTN_SHARP_7		0x3C		// IR 리모컨 #+7
#define BTN_SHARP_8		0x3D		// IR 리모컨 #+8
#define BTN_SHARP_9		0x3E		// IR 리모컨 #+9
#define BTN_SHARP_0		0x3F		// IR 리모컨 #+0
