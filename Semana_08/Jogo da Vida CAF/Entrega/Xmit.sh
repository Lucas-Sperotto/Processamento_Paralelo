#!/bin/bash
# 
# script to run CAF
#
# usage: Xmit.sh TotImages
#    where:
#    TotImages: number of Co-array Fortran Images
#

#
#
# script arguments
#
export TotImages=$1
export CoresPerNode=8
export PerNode=$(( TotImages<CoresPerNode? TotImages : CoresPerNode ))
#
# job name 
#
RunName=Vida_${TotImages}CAF
OutName=OutVida_${TotImages}CAF.out
#
# directories
# executable full path
#
DirBase=`pwd`
export executable=${DirBase}/Vida.exe

#
# starts producing queue script file qsub.sh
#
cat <<EOF0> ${DirBase}/qsub.sh
#!/bin/bash
#PBS -l mppwidth=${TotImages}
#PBS -l mppdepth=1
#PBS -l mppnppn=${PerNode}
#PBS -N ${RunName}
#PBS -j oe
#PBS -o ${OutName}

cd ${DirBase}

export OMP_NUM_THREADS=${OmpMpi}

ulimit -s unlimited
ulimit -c unlimited

time aprun -b -ss -n ${TotImages} -d 1 -N ${PerNode} ${executable}

EOF0
#
# finishes producing file qsub.sh and moves to executable directory
#
chmod +x ${DirBase}/qsub.sh
cd ${DirBase}
#
# qsub with variable # PEs per node
#
qsub qsub.sh

exit
