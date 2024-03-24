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
#PBS -l mppwidth=1
#PBS -l mppdepth=${TotOmp}
#PBS -l mppnppn=1
#PBS -N ${RunName}
#PBS -j oe
#PBS -o ${OutName}

export OMP_NUM_THREADS=${TotOmp}

ulimit -s unlimited
ulimit -c unlimited

time aprun -b -ss -n 1 -d ${TotOmp} -N 1 ${executable}

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
