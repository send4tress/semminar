#!/bin/bash
#
#SBATCH --partition=normal
#SBATCH --ntasks=2
#SBATCH --mem 16G
#SBATCH --output=align_de_novo_%J_stdout.txt
#SBATCH --error=align_de_novo_%J_stderr.txt
#SBATCH --job-name=align_de_novo
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/assembly/align_de_novo.sh