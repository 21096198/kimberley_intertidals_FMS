#!/bin/bash
#SBATCH --job-name=angsd.NGSadmix.sh
#SBATCH --error=angsd.NGSadmix.error
#SBATCH --time=12:00:00
#SBATCH --export=NONE
#SBATCH --nodes=1
#SBATCH --cpus-per-task=28

export OMP_NUM_THREADS=28
$MYGROUP/software/NGSadmix -likes $1 -minMaf 0.05 -K 2 -o $1.NGSadmix.k2.out -P 28

