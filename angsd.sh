#!/bin/bash
#SBATCH --job-name=angsd.sh
#SBATCH --error=angsd.error
#SBATCH --time=06:00:00 
#SBATCH --nodes=1
#SBATCH --export=ALL
#SBATCH --cpus-per-task=28

export OMP_NUM_THREADS=28
for POP in all
do
srun --export=all -n 1 -c 28 $MYGROUP/software/angsd/angsd -bam $POP.bamlist -ref aspera_mito.fasta -anc aspera_mito.fasta -fold 1 -out $POP \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 -skipTriallelic 1 \
	-minMapQ 10 -minQ 10 -minMaf 0.05 -SNP_pval 1e-6 \
	-GL 1 -doMaf 1 -doIBS 1 -doCov 1 -makeMatrix 1 -doMajorMinor 1 -doGlf 2 -doSaf 1 -doCounts 1 -P 28
done

