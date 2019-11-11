#!/bin/bash

#SBATCH --job-name=sequencer
#SBATCH --partition=defq
#SBATCH --time=03:00:00
#SBATCH --output=res_%j.txt

module load python/3.7.3
source ~/npr/bin/activate

export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk
export D4J_HOME=/mnt/nfs/work1/phaas/pboddavarama/cs682/defects4j
export PATH=/usr/lib/jvm/java-1.8.0-openjdk/bin/:/mnt/nfs/work1/phaas/pboddavarama/cs682/defects4j/framework/bin/:/mnt/nfs/work1/phaas/pboddavarama/cs682/git-lfs-exec/:$PATH
export LD_LIBRARY_PATH=/cm/shared/apps/python/3.7.3/lib/

bash npr_$1_baseline.sh
