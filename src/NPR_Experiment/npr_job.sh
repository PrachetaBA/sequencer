#! /bin/bash

#SBATCH --job-name=d4j_test
#SBATCH --partition=titanx-short
#SBATCH --output=slurm_jobs/res_%j.out
#SBATCH --mem=10GB

export LD_LIBRARY_PATH="/home/mmotwani/anaconda3/envs/npr-py36/lib/:$LD_LIBRARY_PATH"
export JAVA_HOME="/home/mmotwani/anaconda3/envs/npr/x86_64-conda_cos6-linux-gnu/sysroot/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.131.x86_64"
export PATH="~/myworkdir/defects4j/framework/bin/:/home/mmotwani/myworkdir/git-lfs-exec/:$PATH"
export PERL5LIB="/home/mmotwani/anaconda3/pkgs/perl-dbi-1.642-pl526_0/lib/site_perl/5.26.2/x86_64-linux-thread-multi/DBI.PM:$PERL5LIB"

bash npr_expt.sh $1 $2 $3 $4
