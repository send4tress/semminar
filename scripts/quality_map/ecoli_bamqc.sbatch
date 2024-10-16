#!/bin/bash
#
#SBATCH --partition=normal
#SBATCH --ntasks=1
#SBATCH --mem 16G
#SBATCH --output=ecoli_bamqc_%J_stdout.txt
#SBATCH --error=ecoli_bamqc_%J_stderr.txt
#SBATCH --job-name=ecoli_bamqc
# 

bash /home/biol726308/BIOL7263_Genomics/scripts/quality_map/ecoli_bamqc.sh