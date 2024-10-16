#!/bin/bash
#
#SBATCH --partition=normal
#SBATCH --ntasks=1
#SBATCH --mem 16G
#SBATCH --output=ecoli_samindex_%J_stdout.txt
#SBATCH --error=ecoli_samindex_%J_stderr.txt
#SBATCH --job-name=ecoli_samindex
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/BWA/ecoli_samindex.sh