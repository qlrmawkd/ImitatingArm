#include "sam160.h"
#include <time.h>

int main() {
    char val;
    MyMotor motor;
    u8 SamId = (u8) 15;
    u8 Torq = (u8) 0x0;
    //motor.Quick_PosControl_CMD(SamId, Torq, (u8)0);
    
    for(int cnt = 50; cnt < 120; cnt+=10) {
        printf("%d\n", cnt);
        motor.Quick_PosControl_CMD(SamId, Torq, (u8)cnt);
        //usleep(1000000);
    }
    
    sleep(1);
    
    for(int cnt = 120; cnt >= 50; cnt-=10) {
        printf("%d\n", cnt);
        motor.Quick_PosControl_CMD(SamId, Torq, (u8)cnt);
        //sleep(1);
    }
    motor.Close();

    return 0;
}