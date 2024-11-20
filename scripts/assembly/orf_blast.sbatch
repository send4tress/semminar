#!/bin/bash
#
#SBATCH --partition=normal
#SBATCH --ntasks=1
#SBATCH --mem 16G
#SBATCH --output=orf_blast_%J_stdout.txt
#SBATCH --error=orf__blast_%J_stderr.txt
#SBATCH --job-name=orf_blast
# 
bash /home/biol726308/BIOL7263_Genomics/scripts/assembly/orf_blast.sh