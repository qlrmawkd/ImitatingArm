#include "sam160.h"

/*---------------------------------------------------------------------------------------------------------------------------------------*/

void MyMotor::SendByte(u8 data) {
    rs485.Write(data, sizeof(data));
} // UART Transmit Function

u8 MyMotor::GetByte(u16 timeout) {
    u8 buf;
    rs485.Read(&buf);
    return buf;
} // UART Receive Function

/*--------------------Define Packet formation function -----------------------*/
/******************************************************************************/
/* Send Quick control Command Packet(4 bytes) to SAM */
/* Input : Data1, Data2 */
/* Output : None */
/******************************************************************************/
void MyMotor::Quick_Ctrl_CMD(u8 Data1, u8 Data2) {
    u8 CheckSum;
    CheckSum = (Data1 ^ Data2) & 0x7f;
    SendByte(HEADER);
    SendByte(Data1);
    SendByte(Data2);
    SendByte(CheckSum);
}
/******************************************************************************/
/* Send Quick setting Command Packet(6 bytes) to SAM */
/* Input : Data1, Data2, Data3, Data4 */
/* Output : None */
/******************************************************************************/
void MyMotor::Quick_Set_Expand_CMD(u8 Data1, u8 Data2, u8 Data3, u8 Data4) {
    u8 CheckSum;
    CheckSum = (Data1 ^ Data2 ^ Data3 ^ Data4) & 0x7f;
    SendByte(HEADER);
    SendByte(Data1);
    SendByte(Data2);
    SendByte(Data3);
    SendByte(Data4);
    SendByte(CheckSum);
}
/******************************************************************************/

/* Send Standard Command Packet(7 bytes) to SAM */
/* Input : Data1, Data2, Data3, Data4 */
/* Output : None */
/******************************************************************************/
void MyMotor::Standard_CMD(u8 Data1, u8 Data2, u8 Data3, u8 Data4) {
    u8 CheckSum;
    CheckSum = (0xe0 ^ Data1 ^ Data2 ^ Data3 ^ Data4) & 0x7f;
    SendByte(HEADER);
    SendByte(0xe0);
    SendByte(Data1);
    SendByte(Data2);
    SendByte(Data3);
    SendByte(Data4);
    SendByte(CheckSum);
}
/******************************************************************************/
/* Send Standard 8byte Command Packet(8 bytes) to SAM */
/* Input : Data1, Data2, Data3, Data4 , Data5 */
/* Output : None */
/******************************************************************************/
void MyMotor::Standard_8Byte_CMD(u8 Data1, u8 Data2, u8 Data3, u8 Data4, u8 Data5) {
    u8 CheckSum;
    CheckSum = (0xe0 ^ Data1 ^ Data2 ^ Data3 ^ Data4 ^ Data5) & 0x7f;
    SendByte(HEADER);
    SendByte(0xe0);
    SendByte(Data1);
    SendByte(Data2);
    SendByte(Data3);
    SendByte(Data4);
    SendByte(Data5);
    SendByte(CheckSum);
}
/*--------------------Define Quick control function --------------------------*/
/******************************************************************************/
/* Send Quick position control Command Packet(4 bytes) to SAM */
/* Input : SamId, Torq, TargetPos */
/* Output : Response 2Byte (Upper Byte : Current / Lower Byte : Position ) */
/******************************************************************************/
u16 MyMotor::Quick_PosControl_CMD(u8 SamId, u8 Torq, u8 TargetPos) {
    u16 ResponseData = 0;
    if((SamId <= 30) && (Torq <= 4) && (TargetPos <= 254)) {
        Quick_Ctrl_CMD((Torq << 5) | SamId, TargetPos);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }

    return ResponseData;
}

u16 MyMotor::MyQuick_PosControl_CMD(u8 SamId, u8 Torq, u8 TargetPos) {
    this->Quick_PosControl_CMD(SamId, Torq, TargetPos);
    this->Quick_PosControl_CMD(SamId, Torq, TargetPos);
    return this->Quick_PosControl_CMD(SamId, Torq, TargetPos);
}

/******************************************************************************/
/* Send Quick read status Command Packet(4bytes) to SAM */
/* Input : SamId, *Torq, *CurrentPos */
/* Output : Response 2Byte (Upper Byte : Torq / Lower Byte : Position ) */
/******************************************************************************/
u16 MyMotor::Quick_StatusRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if (SamId <= 30) {
        Quick_Ctrl_CMD(0xa0 | SamId, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}

/******************************************************************************/
/* Send for entering into Quick Passive mode Command Packet(4bytes) */
/* Input : SamId */
/* Output : Response 2Byte (Upper Byte : ID / Lower Byte : ID ) */
/******************************************************************************/
u16 MyMotor::Quick_PassiveMode_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if (SamId <= 30) {
        Quick_Ctrl_CMD(0xc0 | SamId, 0x10);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/******************************************************************************/
/* Send for entering into Quick Wheel mode Command Packet(4bytes) */
/* Input : SamId, Dir, WheelSpeed */
/* Output : Response 2Byte (Upper Byte : ID / Lower Byte : ID ) */
/******************************************************************************/
u16 MyMotor::Quick_WheelMode_CMD(u8 SamId, u8 Dir, u8 WheelSpeed) {
    u16 ResponseData = 0;
    if ((SamId <= 30) && (Dir == 3 || Dir == 4) && (WheelSpeed <= 15)) {
        Quick_Ctrl_CMD(0xc0 | SamId, (Dir << 4) | WheelSpeed);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/******************************************************************************/
/* Send for entering into Quick Brake mode Command Packet(4bytes) */
/* Input : None */
/* Output : Response 2Byte (Upper Byte : ID / Lower Byte : Position ) */
/******************************************************************************/
u16 MyMotor::Quick_BrakeMode_CMD(u8 SamId) {
    u16 ResponseData = 0;
    Quick_Ctrl_CMD(0xc0 | SamId, 0x20);
    ResponseData = GetByte(TIMEOUT) << 8;
    ResponseData |= GetByte(TIMEOUT);
    return ResponseData;
}
/*--------------------Define Quick setting function --------------------------*/
/******************************************************************************/
/* Send for setting of Quick baud rate Command Packet(6bytes) */
/* Input : SamId, Baud */
/* Output : Response 2Byte (Upper Byte : Baud / Lower Byte : Baud ) */
/******************************************************************************/
u16 MyMotor::Quick_BaudSet_CMD(u8 SamId, u8 Baud) {
    u16 ResponseData = 0;
    if ((SamId <= 30) && (Baud <= 9)) {
        Quick_Set_Expand_CMD(0xe0 | SamId, 8, Baud, Baud);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}

/******************************************************************************/
/* Send Quick RunTime P,D Gain setting Command Packet(6bytes) */
/* Input : SamId, RPgain, RDgain */
/* Output : Response 2Byte (Upper Byte : RPgain / Lower Byte : RDgain ) */
/******************************************************************************/
u16 MyMotor::Quick_RuntimePDgainSet_CMD(u8 SamId, u8 RPgain, u8 RDgain) {
    u16 ResponseData = 0;
    if ((SamId <= 30) && (1 <= RPgain) && (RPgain <= 254) && (0 <= RDgain) && (RDgain <= 254)) {
        Quick_Set_Expand_CMD(0xe0 | SamId, 11, RPgain, RDgain);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/******************************************************************************/
/* Send Quick 5bit ID setting Command Packet(6bytes) */
/* Input : SamId, NewID */
/* Output : Response 2Byte (Upper Byte : NewID / Lower Byte : NewID ) */
/******************************************************************************/
u16 MyMotor::Quick_IdSet_CMD(u8 SamId, u8 NewID) {
    u16 ResponseData = 0;
    if ((SamId <= 30) && (1 <= NewID) && (NewID <= 30)) {
        Quick_Set_Expand_CMD(0xe0 | SamId, 12, NewID, NewID);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/******************************************************************************/
/* Send Quick OverLoad setting Command Packet(6bytes) */
/* Input : SamId, OverLoad */
/* Output : Response 2Byte (Upper Byte : OverLoad / Lower Byte : OverLoad) */
/******************************************************************************/
u16 MyMotor::Quick_OverLoadSet_CMD(u8 SamId, u8 OverLoad) {
    u16 ResponseData = 0;
    if ((SamId <= 30) && (1 <= OverLoad) && (OverLoad <= 30)) {
        Quick_Set_Expand_CMD(0xe0 | SamId, 15, OverLoad, OverLoad);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/******************************************************************************/
/* Send Quick read OverLoad Command Packet(6bytes) */
/* Input : SamId, OverLoad */
/* Output : Response 2Byte (Upper Byte : OverLoad / Lower Byte : OverLoad) */
/******************************************************************************/
u16 MyMotor::Quick_OverLoadRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if (SamId <= 30) {
        Quick_Set_Expand_CMD(0xe0 | SamId, 16, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/******************************************************************************/
/* Send Quick boundary range setting Command Packet(6bytes) */
/* Input : SamId, LowerBound, UpperBound */
/* Output : Response 2Byte (Upper Byte : LowerBound / Lower Byte :UpperBound) */
/******************************************************************************/
u16 MyMotor::Quick_BoundarySet_CMD(u8 SamId, u8 LowerBound, u8 UpperBound) {
    u16 ResponseData = 0;
    if ((SamId <= 30) && (0 <= LowerBound) && (LowerBound <= 253) && (1 <= UpperBound) && (UpperBound <= 254)) {
        Quick_Set_Expand_CMD(0xe0 | SamId, 17, LowerBound, UpperBound);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/************************************************************************************/

/* Send Quick read boundary Command Packet(6bytes) */
/* Input : SamId */
/* Output : Response 2Byte (Upper Byte : LowerBound / Lower Byte :UpperBound) */
/************************************************************************************/
u16 MyMotor::Quick_BoundaryRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if (SamId <= 30) {
        Quick_Set_Expand_CMD(0xe0 | SamId, 18, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*--------------------Define Quick extension function ----------------------------------------------------------------------------*/
/******************************************************************************/
/* Send Quick write extension port Command Packet(6bytes) */
/* Input : SamId, ChannelData, LEDData */
/* Output : Response 2Byte (Upper Byte : WriteData / Lower Byte : WriteData) */
/******************************************************************************/
u16 MyMotor::Quick_ExpandPortWrite_CMD(u8 SamId, u8 ChannelData, u8 LEDData) {
    u16 ResponseData = 0;
    if ((SamId <= 30) && (ChannelData <= 3) && (LEDData <= 3)) {
        Quick_Set_Expand_CMD(0xe0 | SamId, 100, (ChannelData << 2) | LEDData, (ChannelData << 2) | LEDData);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/***********************************************************************************/
/* Send Quick read extension port AD value Command Packet(6bytes) */
/* Input : SamId */
/* Output : Expand AD Value */
/*********************************************************************************/
u16 MyMotor::Quick_ExpandPortADRead_CMD(u8 SamId) {
    u16 ExpandAD_Value = 0;
    if (SamId <= 30) {
        Quick_Set_Expand_CMD(0xe0 | SamId, 101, 0, 0);
        ExpandAD_Value = GetByte(TIMEOUT) << 7;
        ExpandAD_Value |= GetByte(TIMEOUT);
    }
    return ExpandAD_Value;
}
/*******************************************************************************/
/* Send Quick read motion data Command Packet(6bytes) */
/* Input : SamId */
/* Output : Response 2Byte (Upper Byte : Motion No./ Lower Byte : Motion No.) */
/*******************************************************************************/
u16 MyMotor::Quick_MotionDataRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if (SamId <= 30) {
        Quick_Set_Expand_CMD(0xe0 | SamId, 151, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*--------------------Define Standard control function ---------------------------------------------------------------------------*/
/*******************************************************************************************/
/* Send Standard ID setting Command Packet(7 bytes) */
/* Input : SamId, NewID */
/* Output : Response 2Byte (Upper Byte : NewID / Lower Byte : NewID) */
/*******************************************************************************************/
u16 MyMotor::Standard_IdSet_CMD(u8 SamId, u8 NewID) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (NewID <= 254)) {
        Standard_CMD(160, SamId, NewID, NewID);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard baud rate setting Command Packet(7bytes) */
/* Input : SamId, Baud */
/* Output : Response 2Byte (Upper Byte : Baud / Lower Byte : Baud) */
/*******************************************************************************************/
u16 MyMotor::Standard_BaudSet_CMD(u8 SamId, u8 Baud) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (Baud <= 9)) {
        Standard_CMD(161, SamId, Baud, Baud);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard CTRL Speed setting Command Packet(7bytes) */
/* Input : SamId, CTRLSpeed */
/* Output : CTRLSpeed */
/*******************************************************************************************/
u16 MyMotor::Standard_CTRLSpeedSet_CMD(u8 SamId, u16 CTRLSpeed) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (CTRLSpeed <= 4095)) {
        Standard_CMD(162, SamId, CTRLSpeed >> 7, CTRLSpeed & 0x7f);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read CTRL Speed Command Packet(7bytes) */
/* Input : SamId */
/* Output : CTRLSpeed */
/*******************************************************************************************/
u16 MyMotor::Standard_CTRLSpeedRead_CMD(u8 SamId) {

    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(163, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard CTRL Torq setting Command Packet(7bytes) */
/* Input : SamId, CTRLTorq */
/* Output : CTRLTorq */
/*******************************************************************************************/
u16 MyMotor::Standard_CTRLTorqSet_CMD(u8 SamId, u16 CTRLTorq) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (CTRLTorq <= 4095)) {
        Standard_CMD(164, SamId, CTRLTorq >> 7, CTRLTorq & 0x7f);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read CTRL Torq Command Packet(7bytes) */
/* Input : SamId */
/* Output : CTRLTorq */
/*******************************************************************************************/
u16 MyMotor::Standard_CTRLTorqRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(165, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/******************************************************************************/
/* Send Standard CTRL Accel setting Command Packet(7bytes) */
/* Input : SamId, CTRLAccel */
/* Output : CTRLAccel */
/******************************************************************************/
u16 MyMotor::Standard_CTRLAccelSet_CMD(u8 SamId, u16 CTRLAccel) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (CTRLAccel <= 4095)) {
        Standard_CMD(166, SamId, CTRLAccel >> 7, CTRLAccel & 0x7f);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/******************************************************************************/
/* Send Standard read CTRL Accel Command Packet(7bytes) */
/* Input : SamId */
/* Output : CTRLAccel */
/******************************************************************************/
u16 MyMotor::Standard_CTRLAccelRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(167, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/******************************************************************************/
/* Send Standard CTRL Decel setting Command Packet(7bytes) */
/* Input : SamId, CTRLDecel */
/* Output : CTRLDecel */
/*******************************************************************************************/
u16 MyMotor::Standard_CTRLDecelSet_CMD(u8 SamId, u16 CTRLDecel) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (CTRLDecel <= 4095)) {
        Standard_CMD(168, SamId, CTRLDecel >> 7, CTRLDecel & 0x7f);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read CTRL Decel Command Packet(7bytes) */
/* Input : SamId */
/* Output : CTRLDecel */
/*******************************************************************************************/
u16 MyMotor::Standard_CTRLDecelRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(169, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read current Speed Command Packet(7bytes) */
/* Input : SamId */
/* Output : CurrentSpeed */
/*******************************************************************************************/
s16 MyMotor::Standard_CurrentSpeedRead_CMD(u8 SamId) {
    s16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(170, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
        if(ResponseData & 0x4000) ResponseData = -ResponseData;
    }
    return ResponseData;
}

/*******************************************************************************************/
/* Send Standard read current Accel Command Packet(7bytes) */
/* Input : SamId */
/* Output : CurrentAccel */
/*******************************************************************************************/
s16 MyMotor::Standard_CurrentAccelRead_CMD(u8 SamId) {
    s16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(171, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
        if(ResponseData & 0x4000) ResponseData = -ResponseData;
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read current Load Command Packet(7bytes) */
/* Input : SamId */
/* Output : CurrentLoad */
/*******************************************************************************************/
u16 MyMotor::Standard_CurrentLoadRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(172, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read current position Command Packet(7bytes) */
/* Input : SamId */
/* Output : CurrentPos */
/*******************************************************************************************/
u16 MyMotor::Standard_CurrentPosRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(173, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard P,D gain setting Command Packet(7bytes) */
/* Input : SamId, Pgain, Dgain */
/* Output : Response 2Byte (Upper Byte : Pgain / Lower Byte : Dgain ) */
/*******************************************************************************************/
u16 MyMotor::Standard_PDgainSet_CMD(u8 SamId, u8 Pgain, u8 Dgain) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (1 <= Pgain) && (Pgain <= 254) && (Dgain <= 254)) {
        Standard_CMD(174, SamId, Pgain, Dgain);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read P,D gain Command Packet(7bytes) */
/* Input : SamId */
/* Output : Response 2Byte (Upper Byte : Pgain / Lower Byte : Dgain ) */
/*******************************************************************************************/
u16 MyMotor::Standard_PDgainRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(175, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;

}
/*******************************************************************************************/
/* Send Standard Runtime P,D gain setting Command Packet(7bytes) */
/* Input : SamId, RPgain, RDgain */
/* Output : Response 2Byte (Upper Byte : RPgain / Lower Byte : RDgain ) */
/*******************************************************************************************/
u16 MyMotor::Standard_RuntimePDgainSet_CMD(u8 SamId, u8 RPgain, u8 RDgain) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (1 <= RPgain) && (RPgain <= 254) && (RDgain <= 254)) {
        Standard_CMD(176, SamId, RPgain, RDgain);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard OverLoad setting Command Packet(7bytes) */
/* Input : SamId, OverLoad */
/* Output : OverLoad */
/*******************************************************************************************/
u16 MyMotor::Standard_OverLoadSet_CMD(u8 SamId, u16 OverLoad) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (OverLoad <= 4095)) {
        Standard_CMD(177, SamId, OverLoad >> 7, OverLoad & 0x7f);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read OverLoad Command Packet(7bytes) */
/* Input : SamId */
/* Output : OverLoad */
/*******************************************************************************************/
u16 MyMotor::Standard_OverLoadRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(178, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard Boundary setting Command Packet(7bytes) */
/* Input : SamId, LowerBoundary, UpperBoundary */
/* Output : Response 2Byte (Upper Byte : LowerBoundary / Lower Byte : UpperBoundary) */
/*******************************************************************************************/
u16 MyMotor::Standard_BoundarySet_CMD(u8 SamId, u8 LowerBoundary, u8 UpperBoundary) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (LowerBoundary <= 253) && (1 <= UpperBoundary) && (UpperBoundary <= 254)) {
        Standard_CMD(179, SamId, LowerBoundary, UpperBoundary);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read Boundary Command Packet(7bytes) */
/* Input : SamId */
/* Output : Response 2Byte (Upper Byte : LowerBoundary / Lower Byte : UpperBoundary) */
/*******************************************************************************************/
u16 MyMotor::Standard_BoundaryRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(180, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard I gain setting Command Packet(7bytes) */
/* Input : SamId, Igain */
/* Output : Response 2Byte (Upper Byte : Igain / Lower Byte :Igain) */
/*******************************************************************************************/
u16 MyMotor::Standard_IgainSet_CMD(u8 SamId, u8 Igain) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (Igain <= 254)) {
        Standard_CMD(181, SamId, Igain, Igain);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read I gain Command Packet(7bytes) */
/* Input : SamId */
/* Output : Response 2Byte (Upper Byte : Igain / Lower Byte :Igain) */
/*******************************************************************************************/
u16 MyMotor::Standard_IgainRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(182, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard Runtime I gain setting Command Packet(7bytes) */
/* Input : SamId, RIgain */
/* Output : Response 2Byte (Upper Byte : RIgain / Lower Byte : RIgain) */
/*******************************************************************************************/
u16 MyMotor::Standard_RuntimeIgainSet_CMD(u8 SamId, u8 RIgain) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (RIgain <= 254)) {
        Standard_CMD(183, SamId, RIgain, RIgain);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard Drive Mode setting Command Packet(7bytes) */
/* Input : SamId, ResponseLevel, Reverse */
/* Output : Response 2Byte (Upper Byte : DriveMode / Lower Byte : DriveMode) */
/*******************************************************************************************/
u16 MyMotor::Standard_DrivemodeSet_CMD(u8 SamId, u8 ResponseLevel, u8 Reverse) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (ResponseLevel <= 2) && (Reverse <= 1)) {
        Standard_CMD(184, SamId, (ResponseLevel << 4) | Reverse, (ResponseLevel << 4) | Reverse);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read Drive Mode Command Packet(7bytes) */
/* Input : SamId */
/* Output : Response 2Byte (Upper Byte : DriveMode / Lower Byte : DriveMode) */
/*******************************************************************************************/
u16 MyMotor::Standard_DrivemodeRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(185, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard AVGTorq setting Command Packet(7bytes) */
/* Input : SamId, AVGTorq */
/* Output : AVGTorq */
/*******************************************************************************************/
u16 MyMotor::Standard_AVGTorqSet_CMD(u8 SamId, u16 AVGTorq) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (AVGTorq <= 4095)) {
        Standard_CMD(186, SamId, AVGTorq >> 7, AVGTorq & 0x7f);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read AVGTorq Command Packet(7bytes) */
/* Input : SamId */
/* Output : AVGTorq */
/*******************************************************************************************/
u16 MyMotor::Standard_AVGTorqRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(187, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read Input Voltage Command Packet(7bytes) */
/* Input : SamId */
/* Output : InputVoltage */
/*******************************************************************************************/
u16 MyMotor::Standard_InputVoltageRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(188, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*-------------------- Define Standard extension function -------------------------------------------------------------------*/
/*******************************************************************************************/
/* Send Standard write extension port Command Packet(7bytes) */
/* Input : SamId, ChannelData, LEDData */
/* Output : Response 2Byte (Upper Byte : WriteData/ Lower Byte :WriteData) */
/*******************************************************************************************/
u16 MyMotor::Standard_ExpandPortWrite_CMD(u8 SamId, u8 ChannelData, u8 LEDData) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (ChannelData <= 3) && (LEDData <= 3)) {
        Standard_CMD(190, SamId, (ChannelData << 2) | LEDData, (ChannelData << 2) | LEDData);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read extension port Command Packet(7bytes) */
/* Input : SamId */
/* Output : ExpandAD */
/*******************************************************************************************/
u16 MyMotor::Standard_ExpandPortADRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(191, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}

/*******************************************************************************************/
/* Send Standard read MotionData Command Packet(7bytes) */
/* Input : SamId */
/* Output : Output : Response 2Byte (Upper Byte : Motion 수/ Lower Byte : Motion 수) */
/*******************************************************************************************/
u16 MyMotor::Standard_MotionDataRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(193, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard PING Command Packet(7bytes) */
/* Input : SamId */
/* Output : Output : Response 2Byte (Upper Byte : ID / Lower Byte : ID) */
/*******************************************************************************************/
u16 MyMotor::Standard_PING_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(194, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read FirmwareVersion Command Packet(7bytes) */
/* Input : SamId */
/* Output : Output : Response 2Byte (Upper Byte : ModelNumber / Lower Byte : FWversion) */
/*******************************************************************************************/
u16 MyMotor::Standard_FirmwareVersionRead_CMD(u8 SamId) {
    u16 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_CMD(195, SamId, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/****************************************************************************************************/
/* Send Standard zero position setting Command Packet(7bytes) */
/* Input : SamId, OffsetControl */
/* Output : Output : Response 2Byte (Upper Byte : OffsetControl / Lower Byte :OffsetControl) */
/****************************************************************************************************/
u16 MyMotor::Standard_OffsetControl_CMD(u8 SamId, u8 OffsetControl) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (OffsetControl <= 1)) {
        Standard_CMD(196, SamId, OffsetControl, OffsetControl);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard special mode setting Command Packet(7bytes) */
/* Input : SamId, ControlMode, WheelSpeed */
/* Output : Output : Response 2Byte (Upper Byte : ID / Lower Byte : ControlMode) */
/*******************************************************************************************/
u16 MyMotor::Standard_SpecialControl_CMD(u8 SamId, u8 ControlMode, u16 WheelSpeed) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (ControlMode <= 3) && (WheelSpeed <= 2000)) {
        if(ControlMode == 3) Standard_CMD(199, SamId, ((WheelSpeed >> 7) & 0x0f) | 0x30, WheelSpeed);
        else Standard_CMD(199, SamId, ControlMode << 4, 0);
        ResponseData = GetByte(TIMEOUT) << 8;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}

/********************************************************************************************/
/* Send Standard position control Command Packet(7bytes) */
/* Input : SamId, Position */
/* Output : Position */
/********************************************************************************************/
u16 MyMotor::Standard_PosControl_CMD(u8 SamId, u16 Position) {
    u16 ResponseData = 0;
    if ((SamId <= 254) && (Position <= 4095)) {
        Standard_CMD(200, SamId, Position >> 7, Position & 0x7f);
        ResponseData = GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard precision position control Command Packet(8bytes) */
/* Input : SamId, Position */
/* Output : Position */
/*******************************************************************************************/
u32 MyMotor::Standard_PrecisionPosControl_CMD(u8 SamId, u32 PrecisionPosition) {
    u32 ResponseData = 0;
    if ((SamId <= 254) && (PrecisionPosition <= 4096766)) {
        Standard_8Byte_CMD(202, SamId, PrecisionPosition >> 14, PrecisionPosition >> 7, PrecisionPosition & 0x7f);
        ResponseData = GetByte(TIMEOUT) << 14;
        ResponseData |= GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}
/*******************************************************************************************/
/* Send Standard read precision control Command Packet(8bytes) */
/* Input : SamId */
/* Output : Position */
/*******************************************************************************************/
u32 MyMotor::Standard_PrecisionPosRead_CMD(u8 SamId) {
    u32 ResponseData = 0;
    if ((SamId <= 254)) {
        Standard_8Byte_CMD(203, SamId, 0, 0, 0);
        ResponseData = GetByte(TIMEOUT) << 14;
        ResponseData |= GetByte(TIMEOUT) << 7;
        ResponseData |= GetByte(TIMEOUT);
    }
    return ResponseData;
}

void MyMotor::Close() {
    this->rs485.Close();
}