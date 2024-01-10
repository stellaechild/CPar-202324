GCC = gcc
CUDA = nvcc
SRC = src/
GCC_CFLAGS = -fopenmp -pg -ftree-vectorize -msse4 -mavx -mtune=native -fno-omit-frame-pointer -march=native -Wall -Wextra -Wpedantic -Wfatal-errors -Wshadow -Wcast-align -ffast-math -Ofast # -fno-exceptions -fno-rtti
CUDA_FLAGS = -pg -std=c++11 -arch=sm_35 -Wno-deprecated-gpu-targets -O2

.DEFAULT_GOAL = all
all: MDseq.exe MDpar.exe MDcuda.exe

MDseq.exe: $(SRC)/MDseq.cpp
	module load gcc/11.2.0; \
	$(GCC) $(GCC_CFLAGS) $(SRC)MDseq.cpp -lm -o MDseq.exe

MDpar.exe: $(SRC)/MDpar.cpp
	module load gcc/11.2.0; \
	$(GCC) $(GCC_CFLAGS) $(SRC)MDpar.cpp -lm -o MDpar.exe

MDcuda.exe: $(SRC)/MDcuda.cu
	module load gcc/7.2.0; \
	module load cuda/11.3.1; \
	$(CUDA) $(CUDA_FLAGS) $(SRC)MDcuda.cu -o MDcuda.exe
	
clean:
	rm ./MD*.exe

runseq:
	srun --partition=cpar --cpus-per-task=2 perf stat -M cpi -e cache-misses,instructions,cycles ./MDseq.exe < inputdata.txt

runpar:
	srun --partition=cpar perf stat -e instructions,cycles,cache-misses,cache-references ./MDpar.exe < inputdata.txt

runcuda:
	srun --partition=cpar -e instructions,cyclesm,cache_misses,cache-references ./MDcuda.exe < inputdata.txt

test_seq_script:
	sbatch $(SRC)MDseq.sh

test_par_script:
	sbatch $(SRC)MDpar.sh

test_cuda_script:
	sbatch $(SRC)MDcuda.sh