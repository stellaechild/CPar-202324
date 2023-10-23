CC = gcc
SRC = src/
CFLAGS = -O3 -pg -fno-omit-frame-pointer -ftree-vectorize -msse4 -mavx

.DEFAULT_GOAL = MD.exe

MD.exe: $(SRC)/MD.cpp
	$(CC) $(CFLAGS) $(SRC)MD.cpp -lm -o MD.exe

clean:
	rm ./MD.exe gmon.out main.gprof *_average.txt *_output.txt *_traj.xyz

run:
	perf stat -M cpi -e cache-misses,instructions,cycles ./MD.exe

status:
	gprof ./MD.exe > main.gprof