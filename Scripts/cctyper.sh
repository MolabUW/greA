#!/bin/bash

source activate
conda activate cctyper

which blastn
which cctyper

ACCESSION="$1"
echo $ACCESSION

cp /staging/p/ptran5/data/ncbi_dataset/data/${ACCESSION}/* .

FNA_FILE=(*.fna)
echo $FNA_FILE

ls 

cctyper $FNA_FILE \
	my_output_$FNA_FILE \
	--gff genomic.gff \
	--prot protein.faa \
	--db /staging/p/ptran5/db/cctyper/data

ls my_output*    

tar czvf my_output.tar.gz my_output_$FNA_FILE/
