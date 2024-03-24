#!/bin/bash
#PBS -l mppwidth=16
#PBS -l mppdepth=1
#PBS -l mppnppn=8
#PBS -N Vida_16CAF
#PBS -j oe
#PBS -o OutVida_16CAF.out

cd /home/users/p01280

export OMP_NUM_THREADS=

ulimit -s unlimited
ulimit -c unlimited

time aprun -b -ss -n 16 -d 1 -N 8 /home/users/p01280/Vida.exe

