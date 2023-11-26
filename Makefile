CC = gcc
SRC = src/
CFLAGS = -fopenmp -pg -ftree-vectorize -msse4 -mavx -mtune=native -fno-omit-frame-pointer -Ofast -march=native -Wall -Wextra -Wpedantic -Wfatal-errors -Wshadow -Wcast-align -ffast-math -O3 -fno-exceptions -fno-rtti #-O2

.DEFAULT_GOAL = all
#module load gcc/11.2.0;
all: MDseq.exe MDpar.exe

MDseq.exe: $(SRC)/MDseq.cpp
	$(CC) $(CFLAGS) $(SRC)MDseq.cpp -lm -o MDseq.exe

MDpar.exe: $(SRC)/MDpar.cpp
	$(CC) $(CFLAGS) $(SRC)MDpar.cpp -fopenmp -lm -o MDpar.exe

clean:
	rm ./MD*.exe

runseq:
	srun --partition=cpar perf stat -M cpi -e cache-misses,instructions,cycles ./MDseq.exe < inputdata.txt

runpar:
	srun --partition=cpar perf stat -M cpi -e cache-misses,instructions,cycles ./MDpar.exe < inputdata.txt

run:
	./MDpar.exe <inputdata.txt