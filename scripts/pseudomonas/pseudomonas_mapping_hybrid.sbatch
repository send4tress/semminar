#!/bin/bash
#
#SBATCH --partition=normal
#SBATCH --ntasks=6
#SBATCH --mem 32G
#SBATCH --output=pseudomonas_mapping_hybrid_%J_stdout.txt
#SBATCH --error=pseudomonas_mapping_hybrid_%J_stderr.txt
#SBATCH --job-name=pseudomonas_mapping_hybrid
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseudomonas_mapping_hybrid.sh
