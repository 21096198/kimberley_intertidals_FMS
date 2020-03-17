#!/bin/bash
#USAGE: bash batch-bowtie2-fq-paired.sh b2index 1 *_1.txt.gz
#if you don't have a bwa index, build it with "bwa index.prefix reference.fasta'
#also load modules samtools, java, bwa, nano
CHUNK=$2
COUNTER=0
FQ="${@:3}"

for i in $FQ; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH --ntasks=1\n#SBATCH --cpus-per-task=3\n#SBATCH -t 24:00:00\n#SBATCH --mem 24000" > TEMPBATCH.sbatch; fi
    BASE=$( basename $i _1.txt.gz )
    echo "module load bwa" >> TEMPBATCH.sbatch
    echo "bwa mem $1 ${BASE}_1.txt.gz ${BASE}_2.txt.gz > ${BASE}.sam" >> TEMPBATCH.sbatch
    echo "module load samtools" >> TEMPBATCH.sbatch
    echo "samtools view -bSq 10 ${BASE}.sam > ${BASE}_BTVS-UNSORTED.bam" >> TEMPBATCH.sbatch
    echo "samtools sort ${BASE}_BTVS-UNSORTED.bam > ${BASE}_UNDEDUP.bam" >> TEMPBATCH.sbatch
    echo "module load java" >> TEMPBATCH.sbatch
    echo "java -Xmx4g -jar $MYGROUP/software/picard.jar MarkDuplicates REMOVE_DUPLICATES=true INPUT=${BASE}_UNDEDUP.bam OUTPUT=${BASE}.bam METRICS_FILE=${BASE}-metrics.txt VALIDATION_STRINGENCY=LENIENT" >> TEMPBATCH.sbatch 
    echo "samtools index ${BASE}.bam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}.sam" >> TEMPBATCH.sbatch    
    echo "rm ${BASE}_BTVS-UNSORTED.bam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}_UNDEDUP.bam" >> TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi
done
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi 
