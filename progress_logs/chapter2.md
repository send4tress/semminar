# Chapter 2

#Quality of Illumina data
cd /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli

ls -lath
ln -s SRR857279_1.fastq.gz read_1.fastq.gz
ln -s SRR857279_2.fastq.gz read_2.fastq.gz

zcat read_1.fastq.gz | head | grep @SRR #to read header of reads
zcat read_2.fastq.gz | head | grep @SRR

zcat read_1.fastq.gz | tail | grep @SRR
zcat read_2.fastq.gz | tail | grep @SRR

mkdir -p /home/biol726308/BIOL7263_Genomics/scripts/fastqc

#to run the script
sbatch /home/biol726308/BIOL7263_Genomics/scripts/fastqc/ecoli_fastqc.sbatch

#check status
squeue -u biol726308


# TASK 2


mkdir -p /home/biol726308/BIOL7263_Genomics/scripts/trim_galore
#run trim galore 
sbatch /home/biol726308/BIOL7263_Genomics/scripts/trim_galore/ecoli_trim.sbatch

#after running we count lines again
zcat trimmed_reads_val_1.fq.gz | wc -l
zcat trimmed_reads_val_2.fq.gz | wc -l


# TASK 3

seqtk sample -s 1234 trimmed_reads_val_1.fq.gz 0.1 > trimmed_reads_val_1_subsample_three.fq

seqtk sample -s 5678 trimmed_reads_val_1.fq.gz 0.1 > trimmed_reads_val_1_subsample_four.fq

head trimmed_reads_val_1_subsample_three.fq

head trimmed_reads_val_1_subsample_four.fq

rm *.fq

seqtk sample -s 628 trimmed_reads_val_1.fq.gz 0.5 > trimmed_reads_val_1_subsampled.fq

seqtk sample -s 628 trimmed_reads_val_2.fq.gz 0.5 > trimmed_reads_val_2_subsampled.fq


pigz *.fq # to compress files

#digital normalization


# TASK 4
done

# TASK 5

#indexing with BWA
mkdir /home/biol726308/BIOL7263_Genomics/scripts/BWA/

sbatch /home/biol726308/BIOL7263_Genomics/scripts/BWA/ecoli_index.sbatch


# Task 6 read mapping

#mapping: generates SAM files
sbatch /home/biol726308/BIOL7263_Genomics/scripts/BWA/ecoli_bwa_mem.sbatch


# Task 7

#SAM to BAM 
sbatch /home/biol726308/BIOL7263_Genomics/scripts/BWA/ecoli_samtools_view.sbatch

#sorting: by chromosomal coordinates
sbatch /home/biol726308/BIOL7263_Genomics/scripts/BWA/ecoli_map_sort.sbatch


# task 8 

#Removal of PCR duplicates (samtools fixmate and samtools markdup)
sbatch /home/biol726308/BIOL7263_Genomics/scripts/BWA/ecoli_markdup.sbatch

#make index
sbatch /home/biol726308/BIOL7263_Genomics/scripts/BWA/ecoli_samindex.sbatch 


# Task9


#mapping stats
samtools flagstat /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/ecoli_mapped_namesort_fixmate_sort_markdup.bam \
> /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/mappingstats.txt
#cleanup of unnecesary files
rm /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/ecoli_mapped.bam
rm /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/ecoli_mapped.sam
rm /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/ecoli_mapped_namesort.bam
rm /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/ecoli_mapped_namesort_fixmate.bam
rm /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/ecoli_mapped_namesort_fixmate_sort.bam
rm /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/ecoli_mapped_sorted.bam


# task 10


#Create a quality map
sbatch /home/biol726308/BIOL7263_Genomics/scripts/quality_map/ecoli_bamqc.sbatch 


# Task 11 IGV

#imported ecoli reference genome (.fna)
#imported e coli annotation (.gff)
#loaded bam alignment file
#ran IGV tools and created a .tdf file

# Task 12
#identified regions without any read mapping

#SNP identification
bcftools mpileup
sbatch /home/biol726308/BIOL7263_Genomics/scripts/bcf/ecoli_vcf.sbatch 
#vcf file was created
#call variant sites
sbatch /home/biol726308/BIOL7263_Genomics/scripts/bcf/ecoli_call.sbatch
grep -v -c  "^#" /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/var.called.vcf
# I got 179 variant sites
#to retain alleles with >90% frequency (vcftools)
sbatch /home/biol726308/BIOL7263_Genomics/scripts/bcf/ecoli_filt.sbatch
#visualize on IGV



# Task 13
#identified SNPs, indels 

NC_000913.3:1,189,605-1,217,811
NC_000913.3:1,291,997-1,295,522
NC_000913.3:4,296,249-4,296,510

# Task 14

#SNP identification
bcftools mpileup
sbatch /home/biol726308/BIOL7263_Genomics/scripts/bcf/ecoli_vcf.sbatch 
#vcf file was created
#call variant sites
sbatch /home/biol726308/BIOL7263_Genomics/scripts/bcf/ecoli_call.sbatch
grep -v -c  "^#" /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/var.called.vcf
#I got 179 variant sites


#to retain alleles with >90% frequency (vcftools)
sbatch /home/biol726308/BIOL7263_Genomics/scripts/bcf/ecoli_filt.sbatch
#visualized on IGV

# Task 15


#Locate missing genes compared to reference (bedtools)
sbatch /home/biol726308/BIOL7263_Genomics/scripts/bcf/ecoli_cover.sbatch
#we got a file with this info
#NC_000913.3	RefSeq	region	1	4641652	.	+	.	ID=NC_000913.3:1..4641652;Dbxref=taxon:511145;Is_circular=true;Name=ANONYMOUS;gbkey=Src;genome=chromosome;mol_type=genomic DNA;strain=K-12;substrain=MG1655	5531224	4576513	4641652	0.9859664
#sorting by the 13th (last) column
sort -t $'\t' -g -k 13 /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/gene_coverage.txt | less -S
sort -t $'\t' -g -k 13 /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/gene_coverage.txt | cut -f1-8,10-13 | less -S
