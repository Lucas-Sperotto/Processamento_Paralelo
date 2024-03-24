#!/bin/bash
#PBS -l mppwidth=1
#PBS -l mppdepth=8
#PBS -l mppnppn=1
#PBS -N Tempo_8_OMP
#PBS -j oe
#PBS -o Tempo_Esparsa_1.txt_8_Threads.out
cd /home/users/p01280
export OMP_NUM_THREADS=8

ulimit -s unlimited
ulimit -c unlimited

time aprun -b -ss -n 1 -d 8 -N 1 /home/users/p01280/SparseMatrix 8 Esparsa_1.txt 20000

