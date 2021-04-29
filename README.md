## Analysis of non-polyA-enriched RNAseq data

This repo contains code for a pipeline originally conceived of and written by Keir Balla at the University of Utah for RNAseq analysis for the Langlois-Eide lab dirty mouse virome collaboration. I modified the code to work for our HPC cluster at the University of Minnesota. 

### Dependencies/versions used
* `STAR` RNAseq read mapper, version 2.7.1a- details [here](https://github.com/alexdobin/STAR)
* `trinity` RNAseq de novo read assembler, version 2.8.5- details [here](https://github.com/trinityrnaseq/trinityrnaseq/wiki) 
* `samtools`, version 1.12- details [here](https://sourceforge.net/projects/samtools/) 
* `salmon` RNAseq transcript quantification, version 1.4.0 details [here](https://github.com/COMBINE-lab/salmon) 
* `blast` sequence database, version 2.11.0, details [here](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs) 
* `hmmer` hidden markov model-based database search version 3.3.2, details [here](http://hmmer.org/)

The dependencies can be downloaded using a conda environment by running `conda env create --file environment.yaml` with the `environment.yaml` file supplied in this repo.

### Data
Raw data is not included in this repo, but consists of 2x150 paired end novaseq reads. 

### Running
The slurm/bash scripts should be run in the following order:
1. `star_index.srun` <- Downloads the mouse reference genome from [ensembl](https://www.ensembl.org/index.html) and indexes it for mapping with STAR
2. `map_reads.srun` <- maps raw rnaseq reads to the indexed mouse genome with STAR and output unmapped reads (i.e. pathogen-specific reads)
