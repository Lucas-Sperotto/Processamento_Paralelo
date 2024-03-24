#!/bin/bash
#PBS -l mppwidth=8
#PBS -l mppdepth=1
#PBS -l mppnppn=8
#PBS -N Tempo_8_Proc
#PBS -j oe
#PBS -o Tempo_8_Proc.out

export OMP_NUM_THREADS=1

ulimit -s unlimited
ulimit -c unlimited

time aprun -b -ss -n 8 -d 1 -N 8 /home/users/p01280/Tempo

