#!/bin/bash
#SBATCH --job-name=depth_coverage.sh
#SBATCH --error=depth_coverage.error
#SBATCH --time=24:00:00

#this script uses samtools to calucalte coverage per sample in each population, then sums total for each pop at each site, then calcualtes overall average. This info can be used in ANGSD for setting min/max depth

module load samtools

for POP in all
do
samtools depth -a -f $POP.bamlist > $POP.coverage.txt
#output from samtools starts counts in 3rd collumn, hence 'i=3'
awk '{sum=0; for (i=3; i<=NF; i++) { sum+= $i } print sum}' $POP.coverage.txt > $POP.coverage.sum.txt
#then use the following command to calculate average
awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' $POP.coverage.sum.txt > $POP.coverage.average.txt
done
