#!/bin/bash
# 
# script to execute Vida on GPU 
# single argument is problem size (tabul)
#


#
# directories
# executable full path
#
DirBase=`pwd`
export tamBlk=$1
export nBlk=$2


ExecName=Vida
#
# job name 
#
RunName=Run_${ExecName}
OutName=${ExecName}_${tamBlk}_${nBlk}.out


#
# starts producing queue script file qsub.sh
#
cat <<EOF0> ${DirBase}/qsub.sh
#!/bin/bash
#$ -S /bin/sh
#$ -N ${RunName}
#$ -j y
#$ -o ${OutName}
#$ -q tesla.q
#$ -pe mpifu 1
#$ -cwd

time ./../../bin/linux/release/${ExecName} ${tamBlk} ${nBlk}

echo "DONE"
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
