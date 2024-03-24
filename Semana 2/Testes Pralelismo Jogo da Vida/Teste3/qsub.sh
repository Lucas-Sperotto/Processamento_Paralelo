#!/bin/bash
#PBS -l mppwidth=1
#PBS -l mppdepth=1
#PBS -l mppnppn=1
#PBS -N Tempo_1_OMP
#PBS -j oe
#PBS -o Tempo_1_Threads.out

export OMP_NUM_THREADS=1

ulimit -s unlimited
ulimit -c unlimited

time aprun -b -ss -n 1 -d 1 -N 1 /home/users/p01280/Tempo

