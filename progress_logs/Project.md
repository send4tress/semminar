# Daniel Naranjo Project Script


# Background

- The fungal plant pathogen Macrophomina phaseolina causes diseases that impact the economic yield of soybean production. Finding biological methods of control could help mitigate the severity of the disease, for this reason, the exploration of the viral population found infecting the fungus could help researchers understand the virus-fungus interactions and possibly find mycoviruses exerting suppressing effects in the severity of the fungus.
- The objective of this project was to screen M. phaseolina RNA-seq data in order to find mycoviral signatures by using bioinformatic tools
- FASTQ files were processed and short reads were assembled into contigs, then two different alignment processes were used to compare the sequences against a protein database and a nucleotide database, contigs showing acceptable similarities to mycoviruses led to the conclusion that the original sample contains a mycovirus (mycovirus positive)

# Data sources

- The data was generated using the Illumina platform, samples were processed in Dr. Ali's lab and sent to a service provider (OSU)
- A total of 17 samples were used in this project from the fungal isolates: MP95, MP,98, MP108, MP115, MP117, MP119, MP128, MP130, MP131, MP138, MP140, MP146, MP157, MP261, MP266, MP279, MP336


# Activating the environment / Frequently used commands
>`cd /home/biol726308/BIOL7263_Genomics/project/blast

>`mamba activate /home/mbtoomey/.conda/envs/BIOL7263_Genomics

>`cd /scratch/biol726308/project

>`squeue -u biol726308

# Setting up files 

### Downloaded Reference Genome of the fungus (macrophomina phaseolina)

Reference genome found in: https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_020875535.1/

>`wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/020/875/535/GCA_020875535.1_ASM2087553v1/GCA_020875535.1_ASM2087553v1_genomic.fna.gz

>`wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/020/875/535/GCA_020875535.1_ASM2087553v1/GCA_020875535.1_ASM2087553v1_genomic.gbff.gz

- unzip files 
>`gunzip *.gz

### Project Raw Data

The fastq files generated from Illumina sequencing were not able to be found and are presumed to be lost, however the fasta files derived from each sample were used in this project (for the diamond blast analysis). For the next steps which involve processing fasq files, trimming, quality check and assembly, two fastq files (paired data) were used and the commands listed here could be used to processs further sequencing rounds (planed for Jan 2025) 

### Making simbolic links for the sequencing paired data 

>`ln -s AR009-B_S17_R1_001.fastq.gz read_1.fastq.gz   
>`ln -s AR009-B_S17_R2_001.fastq.gz read_2.fastq.gz

### observing my gziped data
>`zcat read_2.fastq.gz | head
@LH00260:14:22CKNNLT3:3:1101:4181:1032 2:N:0:GATCAGATCT+AGATCTCGGT
NCAACAGCAACAGCAACAGCAACATTTGGCGAAGCAAACATTGCAGCAAGCTCAGCTGCTCTTCCCTTACATGCAGGCTCAATTTCCCCATTCAACTAGCACTGCCACTGCTTCGCCTTCACATTCAAGAGATCGGAAGAGCGTCGTGTAG


### counting reads with zcat

>`zcat read_1.fastq.gz | grep @LH | wc -l

11357466

>`zcat read_2.fastq.gz | grep @LH | wc -l

11357466


##  Quality check with fastqc
>`mkdir -p /scratch/biol726308/project/fastqc_output
>`fastqc /scratch/biol726308/project/raw_data/read_1.fastq.gz -o /scratch/biol726308/project/fastqc_output/
>`fastqc /scratch/biol726308/project/raw_data/read_2.fastq.gz -o /scratch/biol726308/project/fastqc_output/



## Trimmed the fasqc files using trim galore
- Trimmed the reads to a length of 100 to remove areas of low quality

>`trim_galore --paired --fastqc --gzip --cores 4 --length 100 /scratch/biol726308/project/raw_data/read_1.fastq.gz //scratch/biol726308/project/raw_data/read_2.fastq.gz --basename trimmed_reads -o /scratch/biol726308/project/trim


### Counting lines after trimming 

>`zcat trimmed_reads_val_1.fq.gz | wc -l

-42369340

>`zcat trimmed_reads_val_2.fq.gz | wc -l

-42369340



## Mapping to a reference genome (activating HISAT)
- To activate the library this was used:
>`ml HISAT2/2.2.1-gompi-2022a


>/scratch/biol726308/project/raw_data/mphaseolina

### make reference genome index
>`hisat2-build -p 4 GCF_002806865.2_ASM280686v2_genomic.fna mphaseolina_index

## Extracting and sorting data of interest from the mapped file 

### Extract unaligned_reads from sam file
>`samtools view -f 12 -h aligned_reads.sam > unaligned_reads.sam

### Converting sam to bam (binary) and sorting by name

>`samtools view -Sb /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads.sam > /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads.bam
`samtools sort -n /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads.bam -o /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads_sorted_by_name.bam

### Correct mate information in paired-end reads using samtools fixmate 

>`samtools fixmate -m /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads_sorted_by_name.bam /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads_fixed.bam

### Sorting again 

>`samtools sort /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads_fixed.bam -o /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads_sorted_fixed.bam

### Marking duplicates and removed them

>`samtools markdup -r /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads_sorted_fixed.bam /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads_no_duplicates.bam

### Making an index of the file 

>`samtools index /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads_no_duplicates.bam

### Retrieving flagstats

>`samtools flagstat /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads_no_duplicates.bam


### Converting to fastq 

>`bedtools bamtofastq -i /scratch/biol726308/project/raw_data/mphaseolina/unaligned_reads_no_duplicates.bam -fq unmapped_r1.fastq -fq2 unmapped_r2.fastq

### Quality check of the new file

>`fastqc /scratch/biol726308/project/raw_data/mphaseolina/unmapped_r1.fastq \
        /scratch/biol726308/project/raw_data/mphaseolina/unmapped_r2.fastq \
        -o /scratch/biol726308/project/raw_data/mphaseolina/fastqc_output
# RNA-seq De-novo assembly

- SPades program was used using the parameter -rna (paremeter -careful may also be used in the future)

>`spades.py --rna -1 /scratch/biol726308/project/raw_data/mphaseolina/unmapped_r1.fastq \
          -2 /scratch/biol726308/project/raw_data/mphaseolina/unmapped_r2.fastq \
          -t 8 -o /scratch/biol726308/project/assembly_output/

### Statistics on the assembly

>quast.py -o /scratch/biol726308/project/quast_output/ \
>          -t 8 \
>          /scratch/biol726308/project/assembly_output/transcripts.fasta
/home/mbtoomey/.conda/envs/BIOL7263_Genomics/bin/quast.py -o /scratch/biol726308/project/quast_output/ -t 8 /scratch/biol726308/project/assembly_output/transcripts.fasta


### Retrieving all the generated fasta files automatically
>`find "/mnt/c/Users/send4/OneDrive/Escritorio/mproject" -type f -name "*.fa" -exec cp {} "/mnt/c/Users/send4/OneDrive/Escritorio/mproject/All MP fasta" \;

# "BLASTX" using diamond

-To download the virus database from UniprotKB

>`wget "https://rest.uniprot.org/uniprotkb/stream?compressed=true&format=fasta&query=taxonomy_id:10239" -O uniprot_virus_database.fasta.gz

Now we need to transform the file into a database using diamond

>`sbatch diamond_mkdb_virus.sbatch

Now I ran diamond as blastx analysis 

### Creating Batch files for diamond analysis
I created the batch files for all my samples using the following logic

`#!/bin/bash

- Define directories
>`INPUT_DIR="/home/biol726308/BIOL7263_Genomics/project/all_fasta"
`OUTPUT_DIR="/home/biol726308/BIOL7263_Genomics/project/blast/results_protein"
`DATABASE="virus_database.dmnd"

- List sample files 
>`samples=(
` "MP117.fa" "MP115.fa" "MP95.fa" "MP108.fa" "MP98.fa" 
`  "MP336.fa" "MP279.fa" "MP266.fa" "MP261.fa" "MP157.fa"
`  "MP146.fa" "MP140.fa" "MP138.fa" "MP131.fa" "MP130.fa"
`  "MP128.fa" "MP119.fa"
`)

- Loop through each sample and create the corresponding .sh and .sbatch files
>`for sample in "${samples[@]}"; do
- Get the base name (without the .fa extension)
`  base_name=$(basename ${sample} .fa)
  
- Create .sh file (DIAMOND command)
>`  cat > ${base_name}.sh <<EOL

- DIAMOND blastx command for sample ${base_name}
>`diamond blastx \
`  --threads 8 \
`  --outfmt 6 qseqid sseqid length pident evalue stitle \
`  -k 1 \
`  -d ${DATABASE} \
`  -q ${INPUT_DIR}/${sample} \
`  -o ${OUTPUT_DIR}/${base_name}.tsv
>`EOL

- Create .sbatch file (to submit the job to SLURM)
>`  cat > ${base_name}.sbatch <<EOL
`#!/bin/bash
`#SBATCH --partition=normal
`#SBATCH --ntasks=1
`#SBATCH --cpus-per-task=8
`#SBATCH --mem=16G
`#SBATCH --output=${base_name}_%j_stdout.txt
`#SBATCH --error=${base_name}_%j_stderr.txt
>`#SBATCH --job-name=${base_name}

- Run the DIAMOND command for sample ${base_name}
>`bash ${base_name}.sh
`EOL
>`done

>`echo "Generated .sh and .sbatch files for all samples."

- Then I submited the work for each of my samples: sbatch MP117.sbatch, sbatch MP115.sbatch, etc


### Combining diamond results 

- To work with only one file the following code was used to combine all the .tsv result files into one

>for file in *.tsv; do
    if [[ "$file" != "combined_diamond_results.tsv" ]]; then
        sample_name=$(basename "$file" .tsv)
        awk -v sample="$sample_name" '{print sample "\t" $0}' "$file"
    fi
done > combined_diamond_results.tsv


### filtering by lenght >100 , pident > 35% and removing sequences that have the word phage
>`awk -F'\t' '($4 >= 100 && $5 >= 35 && tolower($7) !~ /phage/)' combined_diamond_results.tsv > filtered_combined_diamond_results.tsv

- resulted in 45392 matches

- Adding some column headers to my file
>`echo -e "sample_name\tqseqid\tsseqid\tlength\tpident\tevalue\tstitle" > final_filtered_combined_diamond_results.tsv
`cat filtered_combined_diamond_results.tsv >> final_filtered_combined_diamond_results.tsv

- Finally formated the .tsv file oppening it in Excel the file to have a good looking interface color coded and with conditional formating

Link to results [Results Diamond (blastx).xls](https://github.com/send4tress/semminar/blob/main/results/2024_all_mp_filtered_diamond_results_formated.xlsx)

# BLASTN

- Downloading virus nucleotide database

`update_blastdb.pl --decompress nt_viruses

>`blastn -db /scratch/biol726308/project/virus_database -query /home/biol726308/BIOL7263_Genomics/project/all_fasta/MP108.fa -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore" -num_threads 20 -num_alignments 1 > /home/biol726308/BIOL7263_Genomics/project/blastn/results/MP108_blast.tsv

- Ran blastn for sample 108 (test)
`sbatch 108_blast.sbatch

- ran blast for the 17 isolates

- combined the tsv files into 1 

- filtered using the following commands 

- Input file (BLASTn results)
>`input_file="blastn_results_with_headers.tsv"
`output_file="filtered_blast_results.tsv"

- Apply filters: E-value ≤ 1e-5, alignment length ≥ 200
>`awk -F'\t' '$8 <= 1e-5 && $12 >= 200' $input_file > $output_file

- After the filtering the file went from 3472 to 1505 matches

### organizing the data 


- Added the description row with proper tab-separated values
>`echo -e "Isolate name\tQuery sequence ID\tSubject sequence ID\tSubject title\tSubject scientific name\tBit score\tQuery coverage\tE-value\tPercent identity\tSubject sequence length\tSubject accession\tAlignment length\tQuery sequence length\tQuery start position\tQuery end position\tSubject start position\tSubject end position\tStrand of alignment\tGap openings\tSubject taxonomy ID\tMismatched bases" > blastn_results_with_headers.tsv

- Append the original BLASTn results
>`cat your_blastn_results.tsv >> blastn_results_with_headers.tsv

- filtered out the word "phage" since its not relevant for our results

- file went from  1505 to 1071

- formatted in excel the file to have a good looking interface color coded and with conditional formatting

 Link to results [Results Blastn.xls](https://github.com/send4tress/semminar/blob/main/results/2024_all_mp_filtered_blast_results_formated.xlsx)
 
# Results 
 
 Both analysis (diamond/blastx, blastn) generated hundreds of viral matches for each isolate.
 
 It was observed that a single isolate was infected with more than one mycovirus (outstanding example seen in **MP146**) and that the same mycovirus could be found across many isolates.
 
 Manually inspecting the files, the most relevant matches were selected and are listed below.
 
 In the excel file, contigs matching to the same mycovirus were color coded,which helped to better understand the viral population inside each isolate, this can be visualized here [Color coded results](https://github.com/send4tress/semminar/blob/main/results/2024_project_results_colorcoded.xlsx).
 
 It was noted that some of the alignment scores for both nucleotide and protein analysis showed fair similarity (~50%  for protein and ~70% for nucleotide) in some matches, this might represent novel viruses and require further processing.
 
- **Macrophomina phaseolina hypovirus 2**  
- **Macrophomina phaseolina tobamo-like virus**  
- **Macrophomina phaseolina mycobunyavirus 1**  
- **Macrophomina phaseolina umbra-like virus 1**  
- **Macrophomina phaseolina fusagravirus 5**  
- **Macrophomina phaseolina single-stranded RNA virus 1**  
- **Rhizoctonia solani mitovirus 10**  
- **Macrophomina phaseolina victorivirus 1**  
- **Macrophomina phaseolina ourmia-like virus 3**  
- **Macrophomina phaseolina mitovirus 4**  
- **Macrophomina phaseolina endornavirus 1**  
- **MAG: Riboviria sp.** H1_Rhizo_25_scaffold_783 RNA-dependent RNA polymerase (H1Rhizo25783_000001) 
- **Macrophomina phaseolina double-stranded RNA virus 2**  
- **Macrophomina phaseolina poty-like virus**  
- **Diplodia seriata narnavirus 1**  
- **MAG: Riboviria sp.** H3_Bulk_42_scaffold_3696 RNA-dependent RNA polymerase (H3Bulk423696_000001)
 
 
 
# Conclusions

- Successfully processed NGS data and performed a comparative analysis to both a nucleotide database (blastn) and a protein database (diamond)
- Viral sequences showing conserved regions like the coding sequence for the RdRp or the capsid proteins are present in the data, presumably this viruses are present in our fungal isolates
- This pipeline is of great use and will be further polished for our regular use in the lab
- It is recommended to change the threshold for the blastn search to be below 70% (P.ident) to allow for more divergent sequences to be included in our analysts, also to only display 1 result per search to avoid generating too much data