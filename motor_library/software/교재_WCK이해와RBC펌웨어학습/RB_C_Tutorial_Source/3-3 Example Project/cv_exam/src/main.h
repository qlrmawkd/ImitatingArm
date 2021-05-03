//==============================================================================
// 하드웨어 의존적인 정의들
//==============================================================================
//#define			EXT_INT0_ENABLE		SET_BIT6(GICR)
//#define			EXT_INT0_DISABLE	CLR_BIT6(GICR)

#define	PF1_LED1_ON			CLR_BIT2(PORTA)     // BLUE
#define	PF1_LED1_OFF		SET_BIT2(PORTA)
#define	PF1_LED2_ON			CLR_BIT3(PORTA)     // GREEN
#define	PF1_LED2_OFF		SET_BIT3(PORTA)
#define	PF2_LED_ON			CLR_BIT4(PORTA)     // YELLOW
#define	PF2_LED_OFF			SET_BIT4(PORTA)
#define	RUN_LED1_ON			CLR_BIT5(PORTA)     // BLUE
#define	RUN_LED1_OFF		SET_BIT5(PORTA)
#define	RUN_LED2_ON			CLR_BIT6(PORTA)     // GREEN
#define	RUN_LED2_OFF		SET_BIT6(PORTA)
#define	ERR_LED_ON			CLR_BIT7(PORTA)     // RED
#define	ERR_LED_OFF			SET_BIT7(PORTA)
#define	PWR_LED1_ON			CLR_BIT2(PORTG)     // GREEN
#define	PWR_LED1_OFF		SET_BIT2(PORTG)
#define	PWR_LED2_ON			CLR_BIT7(PORTC)     // RED
#define	PWR_LED2_OFF		SET_BIT7(PORTC)
#define	PSD_ON		        SET_BIT5(PORTB) // 거리센서용 전원 제어
#define	PSD_OFF			    CLR_BIT5(PORTB) // 거리센서용 전원 제어

#define	CHARGE_ENABLE       SET_BIT4(PORTB) // 충전 포트
#define	CHARGE_DISABLE      CLR_BIT4(PORTB)

#define	U_T_OF_POWER		9500			// 아답터 인식 기준 전압[mV]
#define	M_T_OF_POWER		8600			// 전원 충분 기준 전압[mV]
#define	L_T_OF_POWER		8100			// 동작가능 최저 기준 전압[mV]

#define	MAX_wCK			31	// wCK ID 최대 개수

//==============================================================================
//						UART 통신 관련
//==============================================================================
#define TX0_BUF_SIZE    186     // UART0 송신 버퍼 크기 (최대 31*6 = 186)
#define RX0_BUF_SIZE    8		// UART0 수신 버퍼 크기
#define RX1_BUF_SIZE    20      // UART1 수신 버퍼 크기

//==============================================================================
//						Send 명령어 관련
//==============================================================================
#define ID_SET      12

