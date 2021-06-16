#Bash script for splitting fasta file into multiple smaller files
#Frances Shepherd, original source: https://help.rc.ufl.edu/doc/Blast_Job_Scripts
#14Jun21

#cd to directory where trinity results are held, for example:
cd ../trinity_results/langlois_project_044/

#make directory to hold split files, for example:
mkdir trinity_unmapped_044-ak03_blast_query_files
cd trinity_unmapped_044-ak03_blast_query_files

#Split file ("big" file is located in parent directory)
faSplit sequence ../trinity_unmapped_044-ak03_all.fasta 100 blast_query_ak03_