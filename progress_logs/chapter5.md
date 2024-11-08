
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
`sbatch /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseudo_trimm.sh

## Task 4

cd /scratch/biol726308/BIOL7263_Genomics/pseudomonas_gm41/

-assembly Illumina
`sbatch /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseud_short_assembly.sbatch

-Quast
`sbatch /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseud_quast.sbatch