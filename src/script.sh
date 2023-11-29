#!/bin/bash
#SBATCH --ntasks=40
#SBATCH --nodes=2
#SBATCH --time=00:10:00
#SBATCH --partition=cpar
#SBATCH --exclusive


threads=(4 8 12 14 18 22 24 26 30 34 36 40)


for nthreads in "${threads[@]}"
do
    export OMP_NUM_THREADS=${nthreads}
    echo ${OMP_NUM_THREADS}
    time `./MDpar.exe <inputdata.txt >lixo`
done