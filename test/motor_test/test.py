import time
import serial
read_temperature = b'\x02\x30\x31\x52\x58\x54\x50\x30\x03\x3E'
ser = serial.Serial('/dev/ttyUSB0', 1500000, timeout=1) #시리얼포트 연결
cnt = 0
try:
    while(True):
        print(cnt)
        cnt+=1
        ser.write(read_temperature)
        time.sleep(0.1)
    response = ser.readline()
    print(response)
except KeyboardInterrupt:
    ser.close()

