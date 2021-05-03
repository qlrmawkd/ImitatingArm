main: main.o sam160.o rs485.o
	gcc -o main main.o sam160.o rs485.o

main.o: main.cpp
	gcc -c main.cpp

sam160.o: sam160.cpp
	gcc -c sam160.cpp

rs485.o: rs485.cpp
	gcc -c rs485.cpp
