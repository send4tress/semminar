#!/bin/bash
#
#SBATCH --partition=64gb_24core
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem 54G
#SBATCH --output=pseud_short_%J_stdout.txt
#SBATCH --error=pseud_short_%J_stderr.txt
#SBATCH --job-name=pseud_short
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseud_short_assembly.sh