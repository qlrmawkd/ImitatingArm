#define TIMEOUT 0
#define HEADER 0xFF
#include "rs485.h"
/*--------------------data definition ------------------------------------------------------------------------------------------------*/
typedef signed long s32; // 4 byte
typedef signed short s16; // 2 byte
typedef signed char s8; // 1 byte
typedef unsigned long u32; // 4 byte
typedef unsigned short u16; // 2 byte
typedef unsigned char u8; // 1 byte
/*--------------------Serial Communication function --------------------------------------------------------------------------------*/
/* ※ User should define the functions in accordance with Micro-Controller Unit or PC Application support. */
/*---------------------------------------------------------------------------------------------------------------------------------------*/
class MyMotor {
    private:
        RS485 rs485;
        void SendByte(u8 data); // UART Transmit Function
        u8 GetByte(u16 timeout); // UART Receive Function
    public:
        /*--------------------Packet formation function -----------------------------------------------------------*/
        void Quick_Ctrl_CMD(u8 Data1, u8 Data2);
        void Quick_Set_Expand_CMD(u8 Data1, u8 Data2, u8 Data3, u8 Data4);
        void Standard_CMD(u8 Data1, u8 Data2, u8 Data3, u8 Data4);
        void Standard_8Byte_CMD(u8 Data1, u8 Data2, u8 Data3, u8 Data4, u8 Data5);
        /*--------------------Quick control function ----------------------------------------------------------------------------------------*/
        u16 Quick_PosControl_CMD(u8 SamId, u8 Torq, u8 TargetPos);
        u16 MyQuick_PosControl_CMD(u8 SamId, u8 Torq, u8 TargetPos);
        u16 Quick_StatusRead_CMD(u8 SamId);
        u16 Quick_PassiveMode_CMD(u8 SamId);
        u16 Quick_WheelMode_CMD(u8 SamId, u8 Dir, u8 WheelSpeed);
        u16 Quick_BrakeMode_CMD(u8 SamId);
        /*--------------------Quick setting function ------------------------------------------------------------------------------------*/
        u16 Quick_BaudSet_CMD(u8 SamId, u8 Baud);
        u16 Quick_RuntimePDgainSet_CMD(u8 SamId, u8 RPgain, u8 RDgain);
        u16 Quick_IdSet_CMD(u8 SamId, u8 NewID);
        u16 Quick_OverLoadSet_CMD(u8 SamId, u8 OverLoad);
        u16 Quick_OverLoadRead_CMD(u8 SamId);
        u16 Quick_BoundarySet_CMD(u8 SamId, u8 LowerBound, u8 UpperLowerBound);
        u16 Quick_BoundaryRead_CMD(u8 SamId);

        /*--------------------Quick extension function ---------------------------------------------------------------------------------------*/
        u16 Quick_ExpandPortWrite_CMD(u8 SamId, u8 ChannelData, u8 LEDData);
        u16 Quick_ExpandPortADRead_CMD(u8 SamId);
        u16 Quick_MotionDataRead_CMD(u8 SamId);
        /*--------------------Standard control function ----------------------------------------------------------------------------------------*/
        u16 Standard_IdSet_CMD(u8 SamId, u8 NewID);
        u16 Standard_BaudSet_CMD(u8 SamId, u8 Baud);
        u16 Standard_CTRLSpeedSet_CMD(u8 SamId, u16 CTRLSpeed);
        u16 Standard_CTRLSpeedRead_CMD(u8 SamId);
        u16 Standard_CTRLTorqSet_CMD(u8 SamId, u16 CTRLTorq);
        u16 Standard_CTRLTorqRead_CMD(u8 SamId);
        u16 Standard_CTRLAccelSet_CMD(u8 SamId, u16 CTRLAccel);
        u16 Standard_CTRLAccelRead_CMD(u8 SamId);
        u16 Standard_CTRLDecelSet_CMD(u8 SamId, u16 CTRLDecel);
        u16 Standard_CTRLDecelRead_CMD(u8 SamId);
        s16 Standard_CurrentSpeedRead_CMD(u8 SamId);
        s16 Standard_CurrentAccelRead_CMD(u8 SamId);
        u16 Standard_CurrentLoadRead_CMD(u8 SamId);
        u16 Standard_CurrentPosRead_CMD(u8 SamId);
        u16 Standard_PDgainSet_CMD(u8 SamId, u8 Pgain, u8 Dgain);
        u16 Standard_PDgainRead_CMD(u8 SamId);
        u16 Standard_RuntimePDgainSet_CMD(u8 SamId, u8 RPgain, u8 RDgain);
        u16 Standard_OverLoadSet_CMD(u8 SamId, u16 OverLoad);
        u16 Standard_OverLoadRead_CMD(u8 SamId);
        u16 Standard_BoundarySet_CMD(u8 SamId, u8 LowerBoundary, u8 UpperBoundary);
        u16 Standard_BoundaryRead_CMD(u8 SamId);
        u16 Standard_IgainSet_CMD(u8 SamId, u8 Igain);
        u16 Standard_IgainRead_CMD(u8 SamId);
        u16 Standard_RuntimeIgainSet_CMD(u8 SamId, u8 RIgain);
        u16 Standard_DrivemodeSet_CMD(u8 SamId, u8 ResponseLevel, u8 Reverse);
        u16 Standard_DrivemodeRead_CMD(u8 SamId);
        u16 Standard_AVGTorqSet_CMD(u8 SamId, u16 AVGTorq);
        u16 Standard_AVGTorqRead_CMD(u8 SamId);
        u16 Standard_InputVoltageRead_CMD(u8 SamId);

        /*--------------------Standard extension function --------------------------------------------------------------------------------------*/
        u16 Standard_ExpandPortWrite_CMD(u8 SamId, u8 ChannelData, u8 LEDData);
        u16 Standard_ExpandPortADRead_CMD(u8 SamId);
        u16 Standard_MotionDataRead_CMD(u8 SamId);
        u16 Standard_PING_CMD(u8 SamId);
        u16 Standard_FirmwareVersionRead_CMD(u8 SamId);
        u16 Standard_OffsetControl_CMD(u8 SamId, u8 OffsetControl);
        u16 Standard_SpecialControl_CMD(u8 SamId, u8 ControlMode, u16 WheelSpeed);
        u16 Standard_PosControl_CMD(u8 SamId, u16 Position);
        u32 Standard_PrecisionPosControl_CMD(u8 SamId, u32 PrecisionPosition);
        u32 Standard_PrecisionPosRead_CMD(u8 SamId);
        void Close();
};