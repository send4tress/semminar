
#Chapter3
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

#checking on the output
grep -c "^@SRR" unmapped_r1.fastq unmapped_r2.fastq 
#unmapped_r1.fastq:56710
#unmapped_r2.fastq:56710
tail -n 4 unmapped_r1.fastq unmapped_r2.fastq

# check unmapped QC (fastqc) (did not run , ran on terminal instead)

mkdir /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/unmapped_assembly/fastqc
cd /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/unmapped_assembly/fastqc
sbatch /home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_fastqc.sbatch

#de novo genome assembly (SPades)
sbatch /home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_spades.sbatch

#task 4 stadistics of assembly (quast)
sbatch /home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_quast.sbatch

cat /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/unmapped_assembly/spades_assembly/quast/report.txt
# contigs (>= 0 bp)         17

#task 5
did not run blast to not use a lot of resources

#task 6
#had some trouble submiting , done in console and worked
sbatch 	/home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_orf.sbatch

#to blast against the reference sequence 
sbatch 	/home/biol726308/BIOL7263_Genomics/scripts/unmapped/unmapped_blastn.sbatch

#outcome looks like this
#NODE_1_length_46850_cov_69.441152	NC_000913.3	100.000	28	0	0	1	28	392940	392967	2.72e-05	52.8

#task 7