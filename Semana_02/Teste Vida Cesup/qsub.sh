#!/bin/bash
#$ -S /bin/sh
#$ -N Tempo_8_OMP
#$ -j y
#$ -o Tempo_8_Threads.out
#$ -q p_thin_small.q
#$ -pe omp8 -8
#$ -cwd

export OMP_NUM_THREADS=8

ulimit -s unlimited
ulimit -c unlimited

time /home/u/treinamento/ita21/Tempo

