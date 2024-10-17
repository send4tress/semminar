
# Chapter3

# Task1
cd /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/

ls -lath

mkdir unmapped_assembly

cd unmapped_assembly

#pickiung up the unmaped reads, first view sam file 
samtools view /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/ecoli_mapped_namesort_fixmate_sort_markdup.bam | head -n 5

#using flags to collect unmaped reads
samtools view -b -f 12 /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/mapping_to_reference/ecoli_mapped_namesort_fixmate_sort_markdup.bam -o /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/unmapped_assembly/unmapped.bam

#to view first 5 files 
samtools view unmapped.bam | head -n 5

#SRR857279.48    77      *       0       0       *       *       0       0       ATCCGTCCCTCCGCATCGTATACGAGGCGTTTCCAGGGACCGGTGATAATATGTTCAGGCGCATCATCAAGGATGCGCTTTTTCGAACCATTCAGTTCTGCCAGATAATGAATCGCAGCC        ??????B@DDDDDDEBDEFFCFH?>EHHHEHHHHHFHEHHHHH*>EGHHHFFHFGHHHHHHHHHHHHHHHHFDFFHHHHHFFHHDFFFEEEEEEEEEEEEEECEEEEEEEECEEEEEEEE        MQ:i:0  AS:i:0  XS:i:0 ms:i:4486

#converting from bam to fastq (bedtools bamtofastq)
sbatch /home/biol726308/BIOL7263_Genomics/scripts/unmapped/bam_to_fasta.sbatch

# Task2
#checking on the output
grep -c "^@SRR" unmapped_r1.fastq unmapped_r2.fastq 
#unmapped_r1.fastq:56710
#unmapped_r2.fastq:56710
tail -n 4 unmapped_r1.fastq unmapped_r2.fastq

#check unmapped QC (fastqc) (ran on terminal)

mkdir /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/unmapped_assembly/fastqc
cd /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/unmapped_assembly/fastqc
sbatch /home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_fastqc.sbatch

# Task 3
#de novo genome assembly (SPades)
sbatch /home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_spades.sbatch

# Task 4 stadistics of assembly (quast)
sbatch /home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_quast.sbatch

cat /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/unmapped_assembly/spades_assembly/quast/report.txt
#contigs (>= 0 bp)         17

# task 5
did not run blast to not use a lot of resources

# task 6
#had some trouble submiting , done in console and worked
sbatch 	/home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_orf.sbatch

#to blast against the reference sequence 
sbatch 	/home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_blastn.sbatch

#outcome looks like this
#NODE_1_length_46850_cov_69.441152	NC_000913.3	100.000	28	0	0	1	28	392940	392967	2.72e-05	52.8

# task 7 - Using pfam protein database
#pfam database was deleted from the server, got to download it again
sbatch 	/home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_pfam.sbatch

#output:
NODE_1_length_46850_cov_69.441152_12      18    138     17    139 PF01850.26  PIN               Domain     2   119   120     75.0   8.8e-21   1 CL0280   
NODE_1_length_46850_cov_69.441152_54      76    185     75    193 PF01464.25  SLT               Domain     2   108   117     76.7   1.2e-21   1 CL0037   predicted_active_site
NODE_1_length_46850_cov_69.441152_81      89    224     88    226 PF06924.16  DUF1281           Family     2   140   179     90.4   1.6e-25   1 No_clan  
NODE_1_length_46850_cov_69.441152_82      53    126     53    138 PF18406.6   DUF1281_C         Domain     1    74    88     56.5   2.3e-15   1 No_clan  
NODE_1_length_46850_cov_69.441152_86      53    233     53    235 PF01555.23  N6_N4_Mtase       Family     1   219   221    135.1   4.2e-39   1 CL0063   

#after searching PF01464
#https://www.ebi.ac.uk/interpro/entry/pfam/PF01464/

Description
This family is distantly related to Pfam:PF00062. Members are found in phages, type II, type III and type IV secretion systems (reviewed in [1]).