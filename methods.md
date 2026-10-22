Author: Patricia Q. Tran

# Methods to make the greA viral phylogeny

Take all 76 protein greA sequences

Add the bacterial greA sequence from Uniprot: E. coli (Uniprot P0A6W5) and S. aureus (Uniprot A8Z4E8) Create sequence alignment with MAFFT --\> `greA-78-alignement.fasta` Create phylogeny with IQTREE3 using the command: `iqtree3 -s greA-78-alignement.fasta -alrt 1000 -m MFP -B 1000 -T AUTO`

The file consensus tree with boostrap values (`greA-78-alignement.fasta.contree`) was used in ITOL for data visualization.

The `.txt` files can be uploaded directly to ITOL for data visualization. Refining of the figure was done in Adobe Illustrator.

All IQTREE3 output files are available on Dryad at DOI:

# Methods for the CRISPR analysis in publicly available genomes

Look through all the assigned taxonomies as per Supplementary Table X on GTDB (<https://gtdb.ecogenomic.org>) and export the TSV results files that contains the accessions IDs.

All the TSV files were concatenated into 1 TSV file, and Dupplicate Lines were removed. Only Accessions ID that did NOT failed the genome quality filter and *were* GTDB representative species were kept, with 14 678 accessions IDs remaining.

These accession ID's are available here: `scripts/accessions.txt`

## Download the dataset

This portion of the analysis was performed on CHTC HTC cluster.

We used the Docker image of ncbi-datasets (`staphb/ncbi-datasets:18.35.0`) to estimate the download size:

```         
datasets download genome accession --inputfile accessions.txt \
    --include genome,gff3,protein \
    --filename host_genomes.zip \
    --preview
```

Results:

```         
Collecting 14,678 genome records [================================================] 100% 14678/14678
{"resource_updated_on":"2026-09-16T15:45:00Z","record_count":14665,"estimated_file_size_mb":15672,"included_data_files":{"all_genomic_fasta":{"file_count":14665,"size_mb":11103.802},"genome_gff":{"file_count":6074,"size_mb":1216.5553},"prot_fasta":{"file_count":6074,"size_mb":3360.3198}}}
```

The estimate file size was \~15GB.

## HTCondor Script to download the sequences

ncbi-datasets sometimes fail on very large downloads. Therefore, we split the `accessions.txt` file into chunks of 1000 accessions IDs per list.

We used a paired `scripts/datasets.sub` and `scripts/datasets.sh` to download all +14,000 genomes.

```         
split -l 1000 accessions.txt
ls x* > accessions_list.txt
```

Various copies are available:

`scripts/accessions.txt` : all the \>14,000 accessions `scripts/x*`: the split up accessions list `scripts/accessions_list.txt`: the queue list for the htcondor job

## Intermediate data processing

For the next step, which is running cctyper on all +14,000 genomes, we need to create a new queue file for the HTCondor submit file. The queue file should contain the accessions of the data that was successfully downloaded.

## CCtyper analysis

This was a list of 14 665 accessions IDs (`scripts/accessions2.txt`) The pair of `scripts/cctyper.sh` and `scripts/cctyper.sub` htcondor files are available in this repository. We also had to create an Apptainer container to run cctyper. The definition file used to create the apptainer container is available as well: cctyper.def (`apptainer build cctyper.sif cctyper.sub`)

*Note*: Each cctyper job (1 genome per job) took about 2 minutes to run. 14,000\*2minutes = 28,000 minutes = 466 hours = 19 days! However, running this analysis using HTCondor in a high-throughput manner saved us a lot of time. All the +14,000 jobs completed within less than 10 minutes.

The final cctyper output files, mainly the `cas_operons.tab` files were merged and combined into 1 single file for data visualization in R.

```         
ls **/cas_operons.tab | wc -l

# 1979 files

cat **/cas_operons.tab > all_cas_operons.tab

wc -l all_cas_operons.tab
# 4633 lines
# this includes the repetitive headers, so there are actually fewer rows. See R script for making sure everything is properly merged.
```

This file is in `Data/all_cas_operons.tab`

## R data processing

R script for the data visualization is available at `Host-crispr.rmd`
