#!/bin/bash
#SBATCH --job-name=angsd.pca.sh
#SBATCH --error=angsd.pca.error
#SBATCH --time=0:30:00 
#SBATCH --export=NONE
#SBATCH --nodes=1
#SBATCH --cpus-per-task=28

##NOTE: ran once with all samples n-85 to ID outliers, then re-ran angsd.all.sh with outliers removed and then called angsd.pca.sh with all.rowleys.bamlist2
export OMP_NUM_THREADS=28
module load python
module load pkgconfig
module load pip
module load cython
module load numpy
module load scipy

export OMP_NUM_THREADS=28
srun --export=all -n 1 -c 28 python $MYGROUP/software/pcangsd/pcangsd.py -beagle $1 -minMaf 0.05 -o $1.pca.outfile 
