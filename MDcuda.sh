#!/bin/bash
#SBATCH --ntasks=40
#SBATCH --nodes=2
#SBATCH --time=00:10:00
#SBATCH --partition=cpar
#SBATCH --exclusive


threads=(4 6 8 10 12 14 18 24 30 32 34 38 40)


for nthreads in "${threads[@]}"
do
    export OMP_NUM_THREADS=${nthreads}
    echo ${OMP_NUM_THREADS}
    time `./MDcuda.exe <inputdata.txt >lixo`
done