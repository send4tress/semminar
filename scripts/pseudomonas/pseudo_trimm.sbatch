#!/bin/bash
#
#SBATCH --partition=normal
#SBATCH --ntasks=4
#SBATCH --mem 8G
#SBATCH --output=pseud_trim_%J_stdout.txt
#SBATCH --error=pseud_trim_%J_stderr.txt
#SBATCH --job-name=pseud_trim
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseudo_trimm.sh