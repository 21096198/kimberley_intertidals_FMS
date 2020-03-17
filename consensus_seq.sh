#!/bin/bash
#SBATCH --job-name=consensus
#SBATCH --error=consensus.error
#SBATCH --time=6:00:00

module load bcftools
module load samtools
for i in *.bam
do
bcftools mpileup -Ou -f aspera_mito.fasta $i | bcftools call -mv -Oz -o $i.vcf.gz
bcftools index $i.vcf.gz
cat aspera_mito.fasta | bcftools consensus $i.vcf.gz > $i.consensus.fa
done
