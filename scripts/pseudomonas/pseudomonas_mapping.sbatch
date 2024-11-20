#!/bin/bash
#
#SBATCH --partition=normal
#SBATCH --ntasks=6
#SBATCH --mem 32G
#SBATCH --output=pseudomonas_mapping_%J_stdout.txt
#SBATCH --error=pseudomonas_mapping_%J_stderr.txt
#SBATCH --job-name=pseudomonas_mapping
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseudomonas_mapping.sh
