
# Chapter5

`mamba activate /home/mbtoomey/.conda/envs/BIOL7263_Genomics`


## Task1

-read task 1

## Task 2

-downloaded files

`get the Illumina Data
`wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR491/SRR491287/SRR491287_1.fastq.gz
`wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR491/SRR491287/SRR491287_2.fastq.gz

`get the PacBio data
`wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR104/006/SRR1042836/SRR1042836_subreads.fastq.gz

-Ran fast qc 

`sbatch /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseudo_fastqc.sbatch

-fastqc results of the pacbio data show low quality statistics

## Task 3

-trim galore
`sbatch /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseudo_trimm.sbatch

## Task 4

cd /scratch/biol726308/BIOL7263_Genomics/pseudomonas_gm41/

-assembly Illumina
`sbatch /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseud_short_assembly.sbatch

-Quast
`sbatch /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseud_quast.sbatch

cat /scratch/biol726308/BIOL7263_Genomics/pseudomonas_gm41/assembly/illumina_only/quast/report.txt

my results:

[Assembly                    contigs
# contigs (>= 0 bp)         527
# contigs (>= 1000 bp)      120
# contigs (>= 5000 bp)      102
# contigs (>= 10000 bp)     91
# contigs (>= 25000 bp)     73
# contigs (>= 50000 bp)     50
Total length (>= 0 bp)      6692025
Total length (>= 1000 bp)   6619701
Total length (>= 5000 bp)   6580295
Total length (>= 10000 bp)  6494932
Total length (>= 25000 bp)  6197435
Total length (>= 50000 bp)  5381166
# contigs                   129
Largest contig              248605
Total length                6626398
GC (%)                      59.00
N50                         93187
N75                         64551
L50                         22
L75                         43]
## Task 5

assembly of long reads

`sbatch /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseud_long_assembly.sbatch

Running quast.py

`quast.py --output-dir /scratch/biol726308/BIOL7263_Genomics/pseudomonas_gm41/assembly/hybrid/quast /scratch/biol726308/BIOL7263_Genomics/pseudomonas_gm41/assembly/hybrid/contigs.fasta

cat /scratch/biol726308/BIOL7263_Genomics/pseudomonas_gm41/assembly/illumina_only/quast/report.txt
[
Assembly                    contigs
# contigs (>= 0 bp)         527
# contigs (>= 1000 bp)      120
# contigs (>= 5000 bp)      102
# contigs (>= 10000 bp)     91
# contigs (>= 25000 bp)     73
# contigs (>= 50000 bp)     50
Total length (>= 0 bp)      6692025
Total length (>= 1000 bp)   6619701
Total length (>= 5000 bp)   6580295
Total length (>= 10000 bp)  6494932
Total length (>= 25000 bp)  6197435
Total length (>= 50000 bp)  5381166
# contigs                   129
Largest contig              248605
Total length                6626398
GC (%)                      59.00
N50                         93187
N75                         64551
L50                         22
L75                         43
# N's per 100 kbp           0.00
]
cat /scratch/biol726308/BIOL7263_Genomics/pseudomonas_gm41/assembly/hybrid/quast/report.txt

[
Assembly                    contigs
# contigs (>= 0 bp)         300
# contigs (>= 1000 bp)      32
# contigs (>= 5000 bp)      30
# contigs (>= 10000 bp)     28
# contigs (>= 25000 bp)     25
# contigs (>= 50000 bp)     20
Total length (>= 0 bp)      6725842
Total length (>= 1000 bp)   6677010
Total length (>= 5000 bp)   6672688
Total length (>= 10000 bp)  6656532
Total length (>= 25000 bp)  6595226
Total length (>= 50000 bp)  6437266
# contigs                   34
Largest contig              1292976
Total length                6678398
GC (%)                      58.98
N50                         489830
N75                         355188
L50                         4
L75                         8
# N's per 100 kbp           0.00
]

## Task 6 Align reads back to reference

mkdir /scratch/biol726308/BIOL7263_Genomics/pseudomonas_gm41/mapping_to_assembly/

Used BWA to make a reference index
sbatch pseudomona_index.sbatch
-index was created

Now for  mapping we will generate a sam file, convert it to bam, sort it by genomic coordinates , index it for rapid access ,and finally show statistics of the process done.

pseudomonas_mapping.sbatch

results:
[
35309290 + 0 in total (QC-passed reads + QC-failed reads)
0 + 0 secondary
27786 + 0 supplementary
0 + 0 duplicates
34720534 + 0 mapped (98.33% : N/A)
35281504 + 0 paired in sequencing
17640752 + 0 read1
17640752 + 0 read2
34168130 + 0 properly paired (96.84% : N/A)
34357360 + 0 with itself and mate mapped
335388 + 0 singletons (0.95% : N/A)
150192 + 0 with mate mapped to a different chr
130325 + 0 with mate mapped to a different chr (mapQ>=5)
]

Now mapping using minimap2

pseudomonas_mapping_hybrid.sbatch

Results
[
129847 + 0 in total (QC-passed reads + QC-failed reads)
2764 + 0 secondary
51985 + 0 supplementary
0 + 0 duplicates
105994 + 0 mapped (81.63% : N/A)
0 + 0 paired in sequencing
0 + 0 read1
0 + 0 read2
0 + 0 properly paired (N/A : N/A)
0 + 0 with itself and mate mapped
0 + 0 singletons (N/A : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
]

## Task 7 IGV Illumina vs PacBio

The pac bio reads show many more gaps than the Illumina reads, PacBio also displays a lot of insertions (in purple)
The illumina results apparently have a better quality of data however in areas with low coverage or missing sequences the Pacbio data displays a better coverage of the whole sequence

##Task 8 

no beer for me, many deadlines approach 