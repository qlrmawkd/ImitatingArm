#include "src/sam160.h"

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  MyMotor motor(Serial);
}

void loop() {
  // put your main code here, to run repeatedly:

}
