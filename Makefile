CC = gcc
SRC = src/
CFLAGS = -fopenmp -pg -ftree-vectorize -msse4 -mavx -mtune=native -fno-omit-frame-pointer -Ofast -march=native -Wall -Wextra -Wpedantic -Wfatal-errors -Wshadow -Wcast-align -ffast-math -O3 -fno-exceptions -fno-rtti #-O2

.DEFAULT_GOAL = all

all: MDseq.exe MDpar.exe

MDseq.exe: $(SRC)/MD.cpp
	module load gcc/11.2.0;
	$(CC) $(CFLAGS) $(SRC)MD.cpp -lm -Ofast -o MDseq.exe

MDpar.exe: $(SRC)/MD.cpp
	module load gcc/11.2.0;
	$(CC) $(CFLAGS) $(SRC)MD.cpp -fopenmp -lm -o MDpar.exe

clean:
	rm ./MD*.exe

runseq:
	./MDseq.exe < inputdata.txt

runpar:
	./MDpar.exe < inputdata.txt
