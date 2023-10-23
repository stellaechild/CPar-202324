CC = gcc
SRC = src/
CFLAGS = -O3 -pg -fno-omit-frame-pointer -ftree-vectorize -msse4 -mavx

.DEFAULT_GOAL = MD.exe

MD.exe: $(SRC)/MD.cpp
	$(CC) $(CFLAGS) $(SRC)MD.cpp -lm -o MD.exe

clean:
	rm ./MD.exe cp_* gmon.out main.gprof outputDiagram.png

run:
	srun --partition=cpar perf stat -M cpi -e cache-misses,instructions,cycles ./MD.exe < inputdata.txt

status:
	gprof ./MD.exe > main.gprof
	gprof ./MD.exe | /home/tomas/.local/lib/python3.10/site-packages/gprof2dot.py | dot -Tpng -o outputDiagram.png