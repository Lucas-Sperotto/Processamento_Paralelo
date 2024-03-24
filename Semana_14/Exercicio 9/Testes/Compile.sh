#!/bin/bash
# 
# script to compile cuda code
# invoke with no arguments
#
BaseRunName=Compile
ExecutableName=Compile
#
# job name 
#
RunName=${BaseRunName}
OutName=${BaseRunName}.out
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
#$ -S /bin/sh
#$ -N ${RunName}
#$ -j y
#$ -o ${OutName}
#$ -q tesla.q
#$ -pe mpifu 1
#$ -cwd

echo "WILL make; CURRENT DIRECTORY IS "
pwd

make 

echo "DONE WITH make"
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
