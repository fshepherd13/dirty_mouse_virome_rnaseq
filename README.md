## Analysis of metatranscriptomic RNAseq data for pathogen discovery

This repo contains code for a pipeline originally conceived of and written by Keir Balla at the University of Utah for RNAseq analysis for the Langlois-Eide lab dirty mouse virome collaboration, with modifications by me.

### Output
The pipeline works by mapping RNAseq reads to the mouse genome, de novo assembling unmapped reads with Trinity, and assigning taxonomic lineages to the reads with BLASTn. The two main outputs are csv files that show the raw read counts for the taxonomic (1) families and (2) species present in each mouse. 

### Dependencies/versions used
* `STAR` RNAseq read mapper, version 2.7.1a- details [here](https://github.com/alexdobin/STAR)
* `trinity` RNAseq de novo read assembler, version 2.8.5- details [here](https://github.com/trinityrnaseq/trinityrnaseq/wiki) 
* `samtools`, version 1.12- details [here](https://sourceforge.net/projects/samtools/) 
* `salmon` RNAseq transcript quantification, version 1.4.0 details [here](https://github.com/COMBINE-lab/salmon) 
* `blast+` sequence database, version 2.11.0, details [here](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs) 
* `snakemake`, latest version used is 6.5.1, details [here](https://snakemake.readthedocs.io/en/stable/)
* `dib-lab/2018-ncbi-lineages` scripts on [github](https://github.com/dib-lab/2018-ncbi-lineages).
* `faSplit` script for splitting fasta files into subsets for a parallelized BLAST search, executable found [here](http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/)

#### Loading dependencies with conda
Most of the dependencies can be loaded using a conda environment. STAR, Trinity, Samtools, and snakemake are included in the `environment.yaml` file in the base directory, and can be loaded into an environment using `conda env create --file environment.yaml`

#### Loading remaining dependencies

BLAST+ is already compiled on MSI, so the script that uses BLAST (`blastarray.srun`) loads this via module load. Non-MSI users will have to load this elsewhere. 

The `faSplit` executable should be downloaded from the link above and added to your path variable, for example

    cd ~/bin #(or wherever you want to download your local scripts)
    wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/fasplit
    echo $PATH
    #If ~/bin is not included in your path, run:
    $PATH=$PATH:~/bin

#### Lineage assignment scripts
The dib lab scripts for assigning lineages to Trinity contigs were cloned from github. They are included in this repo with the usage licenses, so there is no need to download them yourself unless there is an update in the future to that code. 

### Data
Raw data is not included in this repo, but consists of 2x150 paired end stranded novaseq reads. 

### Running the pipeline
The slurm/bash scripts should be run in the following order:
1. `star_index.srun` <- Downloads the mouse reference genome from [ensembl](https://www.ensembl.org/index.html) and indexes it for mapping with STAR.
2. `map_reads.srun` <- maps raw rnaseq reads to the indexed mouse genome with STAR and output unmapped reads (i.e. pathogen-specific reads).
3. `assemble_reads.srun` <- Extracts unmapped reads from STAR, concatenates, and de novo assembles into transcripts using Trinity.
4. `blastarray.srun` <- Moves the Trinity read files from scratch to local directory, splits into ~100 subsets, and launches a parallel blast search on multiple nodes to find the top 10 best matches in genbank for the transcript.
5. `salmon_lineage_assign.srun` <- re-maps original fastq reads back to the Trinity contigs, quantifies them with salmon, and assigns taxonomy lineages to the Trinity contigs. Produces files that list transcript abundances at the species and family levels for each sample within the `final/<project-id>` directory.
