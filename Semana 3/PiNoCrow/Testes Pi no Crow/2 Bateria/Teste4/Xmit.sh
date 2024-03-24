#!/bin/bash
# 
# script to run Pi with MPI at crow
#
# usage: Xmit.sh TotMPI arguments
#    where:
#    TotMPI:      total number of MPI ranks
#    arguments:   executable arguments
#

#
#
# script arguments
#
export TotMPI=$1
export TotOmp=1
export MPIPerNode=$1
export Args=$2
#
# hadware script arguments
#
BaseRunName=Pi
ExecutableName=Pi
#
# job name 
#
RunName=${BaseRunName}_${TotMPI}M
OutName=${BaseRunName}_${TotMPI}M_2^${Args}.out
#
# directories
# executable full path
#
DirBase=`pwd`
export executable=${DirBase}/${ExecutableName}

#
# starts producing queue script file qsub.sh
#
cat <<EOF0> ${DirBase}/qsub.sh
#!/bin/bash
#PBS -l mppwidth=${TotMPI}
#PBS -l mppdepth=${TotOmp}
#PBS -l mppnppn=${MPIPerNode}
#PBS -N ${RunName}
#PBS -j oe
#PBS -o ${OutName}

export OMP_NUM_THREADS=${TotOmp}

ulimit -s unlimited
ulimit -c unlimited

time aprun -b -ss -n ${TotMPI} -d ${TotOmp} -N ${MPIPerNode} ${executable} ${Args}

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
