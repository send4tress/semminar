#!/bin/bash
#
#SBATCH --partition=normal
#SBATCH --ntasks=1
#SBATCH --mem 8G
#SBATCH --output=pseudo_fastqc_%J_stdout.txt
#SBATCH --error=pseudo_fastqc_%J_stderr.txt
#SBATCH --job-name=pseudo_fastqc
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseudo_fastqc.sh