#!/bin/bash
#$ -S /bin/sh
#$ -N Run_Vida
#$ -j y
#$ -o Vida_16_64.out
#$ -q tesla.q
#$ -pe mpifu 1
#$ -cwd

time ./../../bin/linux/release/Vida 16 64

echo "DONE"
