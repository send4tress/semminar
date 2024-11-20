#!/bin/bash
#
#SBATCH --partition=64gb_24core
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem 62G
#SBATCH --output=pseud_long_%J_stdout.txt
#SBATCH --error=pseud_long_%J_stderr.txt
#SBATCH --job-name=pseud_long
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseud_long_assembly.sh