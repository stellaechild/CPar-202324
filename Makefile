CC = gcc
SRC = src/
CFLAGS = -fopenmp -pg -ftree-vectorize -msse4 -mavx -mtune=native -fno-omit-frame-pointer -march=native -Wall -Wextra -Wpedantic -Wfatal-errors -Wshadow -Wcast-align -ffast-math -Ofast # -fno-exceptions -fno-rtti

.DEFAULT_GOAL = all
all: MDseq.exe MDpar.exe

MDseq.exe: $(SRC)/MDseq.cpp
	#module load gcc/11.2.0;
	$(CC) $(CFLAGS) $(SRC)MDseq.cpp -lm -o MDseq.exe

MDpar.exe: $(SRC)/MDpar.cpp
	#module load gcc/11.2.0;
	$(CC) $(CFLAGS) $(SRC)MDpar.cpp -fopenmp -lm -o MDpar.exe

clean:
	rm ./MD*.exe

runseq:
	srun --partition=cpar perf stat -M cpi -e cache-misses,instructions,cycles ./MDseq.exe < inputdata.txt

runpar:
	srun --partition=cpar perf stat -M cpi -e cache-misses,instructions,cycles ./MDpar.exe < inputdata.txt

test_seq:
	sudo perf stat -e cycles,instructions ./MDseq.exe < inputdata.txt

test_par:
	sudo perf stat -e cycles,instructions ./MDpar.exe < inputdata.txt
