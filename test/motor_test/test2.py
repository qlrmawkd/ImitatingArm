import os, sys
import serial
import time

ser = serial.Serial('/dev/ttyUSB0', 9600, timeout=5)

def run():
    ser.write(bytes(bytearray([0x01,0x02,0x03,0x04,0x05])))

if __name__ == "__main__":
    run()
