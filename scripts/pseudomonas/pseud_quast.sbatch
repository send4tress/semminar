#!/bin/bash
#
#SBATCH --partition=debug
#SBATCH --ntasks=1
#SBATCH --mem 16G
#SBATCH --output=pseud_quast_%J_stdout.txt
#SBATCH --error=pseud_quast_%J_stderr.txt
#SBATCH --job-name=pseud_quast
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseud_quast.sh