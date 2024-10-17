bwa mem -t 4 /scratch/biol726308/BIOL7263_Genomics/reference_sequences/ecoli/GCF_000005845.2_ASM584v2_genomic /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/trimmed_reads_val_1.fq.gz /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/trimmed_reads_val_2.fq.gz | samtools sort -O bam -o /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/ecoli_mapped_sorted_onecommand.bam