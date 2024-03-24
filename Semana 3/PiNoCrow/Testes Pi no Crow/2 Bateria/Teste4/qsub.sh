#!/bin/bash
#PBS -l mppwidth=8
#PBS -l mppdepth=1
#PBS -l mppnppn=8
#PBS -N Pi_8M
#PBS -j oe
#PBS -o Pi_8M_2^30.out

export OMP_NUM_THREADS=1

ulimit -s unlimited
ulimit -c unlimited

time aprun -b -ss -n 8 -d 1 -N 8 /home/users/p01280/Pi 30

