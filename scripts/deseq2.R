library('DESeq2')
library('tximport')

################Read in relevant dataframes################
#Read in dataframe that contains the trinity ID's linked to lineage information
df <- read.csv(snakemake@input[["lineages"]], header=TRUE)
#Read in files of from salmon quantification
files <- list.files(snakemake@input[["salmon_dir"]], pattern="quant.sf", recursive=TRUE, full.names=TRUE)
#Import table with sample metadata
sample_table <- read.csv("samples.csv")[,1:2]
#Link sample ID info to the name of each salmon quant file
names(files) <- sapply(strsplit(dirname(files), "/"), `[`, 4)

#Perform data analysis for accession level lineage assignments:
#Link salmon quant files to the transcript lineage info
txi_sp <- tximport(files, type = "salmon", tx2gen = df, ignoreTxVersion = FALSE)
dds_sp <- DESeqDataSetFromTximport(txi_sp, sample_table, ~Condition)
keep <- rowSums(counts(dds_sp)) >= 10
write.csv(as.data.frame(txi_sp$counts), file=file.path(snakemake@output[["species_counts"]]))

#Perform data analysis for family level lineage assignments:
txi_fam <- tximport(files, type = "salmon", tx2gen = df[c("trinity_id", "family")], ignoreTxVersion = FALSE)
dds_fam <- DESeqDataSetFromTximport(txi_fam, sample_table, ~Condition)
keep <- rowSums(counts(dds_fam)) >= 10
write.csv(as.data.frame(txi_fam$counts), file=file.path(snakemake@output[["family_counts"]]))