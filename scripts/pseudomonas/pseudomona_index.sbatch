#!/bin/bash
#
#SBATCH --partition=normal
#SBATCH --ntasks=1
#SBATCH --mem 16G
#SBATCH --output=pseudomona_index_%J_stdout.txt
#SBATCH --error=pseudomona_index__index_%J_stderr.txt
#SBATCH --job-name=pseudomona_index__index
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/pseudomonas/pseudomona_index.sh
