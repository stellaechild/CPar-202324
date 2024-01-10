GCC = gcc
CUDA = nvcc
SRC = src/
GCC_CFLAGS = -fopenmp -pg -ftree-vectorize -msse4 -mavx -mtune=native -fno-omit-frame-pointer -march=native -Wall -Wextra -Wpedantic -Wfatal-errors -Wshadow -Wcast-align -ffast-math -Ofast # -fno-exceptions -fno-rtti
CUDA_FLAGS = -fopenmp -pg -ftree-vectorize -fno-omit-frame-pointer -march=native -std=c++11 -arch=sm_35 -Wno-deprecated-gpu-targets

.DEFAULT_GOAL = all
all: MDseq.exe MDpar.exe

MDseq.exe: $(SRC)/MDseq.cpp
	module load gcc/11.2.0; \
	$(GCC) $(GCC_CFLAGS) $(SRC)MDseq.cpp -lm -o MDseq.exe

MDpar.exe: $(SRC)/MDpar.cpp
	module load gcc/11.2.0; \
	$(GCC) $(GCC_CFLAGS) $(SRC)MDpar.cpp -lm -o MDpar.exe

MDcuda.exe: $(SRC)/MDcuda.cu
	module load cuda/11.3.1; \
	$(CUDA) $(CUDA_FLAGS) $(SRC)MDcuda.cu -o MDcuda.exe
	
	
clean:
	rm ./MD*.exe

runseq:
	srun --partition=cpar --cpus-per-task=2 perf stat -M cpi -e cache-misses,instructions,cycles ./MDseq.exe < inputdata.txt

runpar:
	srun --partition=cpar perf stat -e instructions,cycles,cache-misses,cache-references ./MDpar.exe < inputdata.txt

#runcuda:

testscript:
	sbatch $(SRC)script.sh

testseqscript:
	sbatch $(SRC)test.sh

#testcudascript: