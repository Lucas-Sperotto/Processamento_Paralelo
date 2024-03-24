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
export Arg1=$2
export Arg2=$3

#
# job name 
#
RunName=Tempo_${TotOmp}_OMP
OutName=Tempo_${Arg1}_${TotOmp}_Threads.out
#
# directories
# executable full path
#
DirBase=`pwd`
export executable=${DirBase}/SparseMatrix

#
# starts producing queue script file qsub.sh
#
cat <<EOF0> ${DirBase}/qsub.sh
#!/bin/bash
#PBS -l mppwidth=1
#PBS -l mppdepth=${TotOmp}
#PBS -l mppnppn=1
#PBS -N ${RunName}
#PBS -j oe
#PBS -o ${OutName}
cd ${DirBase}
export OMP_NUM_THREADS=${TotOmp}

ulimit -s unlimited
ulimit -c unlimited

time aprun -b -ss -n 1 -d ${TotOmp} -N 1 ${executable} ${TotOmp} ${Arg1} ${Arg2}

EOF0
#
# finishes producing file qsub.sh and moves to executable directory
#
chmod +x ${DirBase}/qsub.sh
cd ${DirBase}
#
# finishes producing file qsub.sh 
#
chmod +x ${DirBase}/qsub.sh
#
# qsub with variable # PEs per node
#
qsub qsub.sh

exit
