#define	SCK_HIGH            SET_BIT4(PORTE)
#define	SCK_LOW             CLR_BIT4(PORTE)
#define	SDI_HIGH            SET_BIT5(PORTE)
#define	SDI_LOW             CLR_BIT5(PORTE)
#define	SCK_SET_OUTPUT      SET_BIT4(DDRE)
#define	SCK_SET_INPUT       CLR_BIT4(DDRE)
#define	SDI_SET_OUTPUT      SET_BIT5(DDRE)
#define	SDI_SET_INPUT       CLR_BIT5(DDRE)
#define P_ACC_SCK(A)	    if(A) SET_BIT4(PORTE);else CLR_BIT4(PORTE)
#define P_ACC_SDI(A)	    if(A) SET_BIT5(PORTE);else CLR_BIT5(PORTE)
#define SDI_CHK				CHK_BIT5(PINE)

void AccStart(void);
void AccStop(void);
void AccAckRead(void);
void AccAckWrite(void);
void AccNotAckWrite(void);
char AccByteRead(void);
void AccByteWrite(BYTE bData);
void AccRead(void);
char AccReadData(BYTE addr);
void Acc_init(void);
void AccGetData(void);
