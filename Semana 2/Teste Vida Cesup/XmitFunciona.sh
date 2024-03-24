#!/bin/bash
# 
# script to run OMP at newton.cesup.ufrgs.br
#
# usage: Xmit.sh TotOmp
#    where:
#    TotOmp:  total number of OpenMP threads (valid range: 1..8)
#

#
#
# script arguments
#
export TotOmp=$1
#
# job name 
#
RunName=Func_${TotOmp}_OMP
OutName=Funciona_${TotOmp}_Threads.out
#
# directories
# executable full path
#
DirBase=`pwd`
export executable=${DirBase}/Funciona

#
# starts producing queue script file qsub.sh
#
cat <<EOF0> ${DirBase}/qsub.sh
#!/bin/bash
#$ -S /bin/sh
#$ -N ${RunName}
#$ -j y
#$ -o ${OutName}
#$ -q p_thin_small.q
#$ -pe omp8 -8
#$ -cwd

export OMP_NUM_THREADS=${TotOmp}

ulimit -s unlimited
ulimit -c unlimited

time ${executable}

EOF0
#
# finishes producing file qsub.sh 
#
chmod +x ${DirBase}/qsub.sh
#
# qsub with variable # PEs per node
#
qsub qsub.sh

exit
