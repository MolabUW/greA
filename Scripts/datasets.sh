#!/bin/bash
set -e 

ls

ACC="$1"
echo ${ACC}

datasets download genome accession --inputfile ${ACC} \
	--include genome,gff3,protein \
	--filename host_genomes_${ACC}.zip \
	--preview

#datasets download genome accession --inputfile ${ACC} \
#	--include genome,gff3,protein \
#	--filename host_genomes_${ACC}.zip

# RUN THIS IF IT FAILED PREVIOUSLY #
datasets download genome accession --inputfile ${ACC} \
        --include genome,gff3,protein \
        --filename host_genomes_${ACC}.zip --dehydrated

unzip host_genomes_${ACC}.zip -d ncbi_datasets_${ACC}

datasets rehydrate --directory ncbi_datasets_${ACC}

mv ncbi_datasets_${ACC}/ncbi_dataset/data/* /staging/p/ptran5/data/ncbi_dataset/data/.
#mv ncbi_datasets_${ACC} /staging/p/ptran5/data/.



echo "Done"
