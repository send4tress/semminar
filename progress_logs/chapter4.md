
# Chapter4

mamba activate /home/mbtoomey/.conda/envs/BIOL7263_Genomics


cd /home/biol726308/BIOL7263_Genomics/scripts/assembly/full_spades.sh

re-did chapter 2 trimgalore since files were deleted

cd /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/assembly
quast.py --output-dir quast contigs.fasta

Finished: 2024-11-02 18:30:39
Elapsed time: 0:00:11.496195
NOTICEs: 2; WARNINGs: 0; non-fatal ERRORs: 0
 checking the report
 
 All statistics are based on contigs of size >= 500 bp, unless otherwise noted (e.g., "# contigs (>= 0 bp)" and "Total length (>= 0 bp)" include all contigs).
```
Assembly                    contigs
# contigs (>= 0 bp)         195    
# contigs (>= 1000 bp)      100    
# contigs (>= 5000 bp)      73     
# contigs (>= 10000 bp)     65     
# contigs (>= 25000 bp)     52     
# contigs (>= 50000 bp)     30 
```

## Task 3
```
cd /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/assembly
mkdir mapping_to_assembly
cd mapping_to_assembly
sbatch /home/biol726308/BIOL7263_Genomics/scripts/assembly/align_de_novo.sbatch
samtools flagstat contigs_mapped_sorted.bam #to get statistics from the process

sbatch /home/biol726308/BIOL7263_Genomics/scripts/assembly/qmap_de_novo.sbatch

blastn -subject /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/assembly/contigs.fasta \
-query /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/unmapped_assembly/spades_assembly/contigs.fasta \
-outfmt 6 -out /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/assembly/mapping_to_assembly/check_plasmid.blastn
```
had to re done unmapped assembly to do the blast 

## Task 4 View assembly in IGV

Loaded files on IGV 
color from reads mean 

## Task 5 Annotation of de novo Assembled Contigs

sbatch /home/biol726308/BIOL7263_Genomics/scripts/assembly/orfipy_9.sbatch

- ran the following modified code using "orfs.fa" "
```
hmmpress /scratch/biol726308/BIOL7263_Genomics/db/pfam/Pfam-A.hmm
pfam_scan.pl -fasta /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/assembly/orfs.fa -dir  /scratch/biol726308/BIOL7263_Genomics/db/pfam/ -outfile /scratch/biol726308/BIOL7263_Genomics/sequencing_data/ecoli/assembly/contigs.orf.pfam -cpu 2 -as
```

sbatch /home/biol726308/BIOL7263_Genomics/scripts/assembly/pfam.sbatch

-To perform blast I ran the following:
sbatch /home/biol726308/BIOL7263_Genomics/scripts/assembly/orf_blast.sbatch

-Then downloaded the files orfs.bed and orf_hit.txt, ran the R script and loaded and visualized them on IGV, now ORF are displaying