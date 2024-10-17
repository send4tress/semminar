
# CHAPTER 1

#we activate environment

mamba activate /home/mbtoomey/.conda/envs/BIOL7263_Genomics
cd scatch/biol726308
mkdir BIOL7263_Genomics
cd BIOL7263_Genomics
mkdir -p sequencing_data/ecoli 
cd sequencing_data/ecoli

#dowloading sequences

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR857/SRR857279/SRR857279_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR857/SRR857279/SRR857279_2.fastq.gz
chmod 444 *.gz
cd ../..
mkdir pseudomonas_gm41 
cd pseudomonas_gm41

#get the Illumina Data

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR491/SRR491287/SRR491287_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR491/SRR491287/SRR491287_2.fastq.gz

#get the PacBio data

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR104/006/SRR1042836/SRR1042836_subreads.fastq.gz
chmod 444 *.gz

#reference data

cd ..
mkdir reference_sequences
cd reference_sequences
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.gff.gz
mkdir ecoli 
mv *.gz ecoli
gunzip ecoli/*.gz
chmod -R 444 ecoli/*.fna
chmod -R 444 ecoli/*.gff

#original names

#read_2.fastq.gz -> SRR857279_2.fastq.gz
#read_1.fastq.gz -> SRR857279_1.fastq.gz

#databases

cd ../..
mkdir -p db/pfam && cd db/pfam
wget http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
wget http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.dat.gz
wget http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/active_site.dat.gz
gunzip *.gz