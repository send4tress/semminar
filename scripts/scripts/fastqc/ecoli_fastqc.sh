mkdir -p /scratch/biol726308/BIOL7263_Genomics/fastqc_output

fastqc /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/read_1.fastq.gz -o /scratch/biol726308/BIOL7263_Genomics/fastqc_output/
fastqc /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/read_2.fastq.gz -o /scratch/biol726308/BIOL7263_Genomics/fastqc_output/