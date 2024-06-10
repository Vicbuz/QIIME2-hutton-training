#!/bin/bash

#SBATCH --partition=short
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --job-name="denoise"
#SBATCH --mail-user=Victoria.Buswell@hutton.ac.uk
#SBATCH --mail-type=END,FAIL

#make sure you place and run this in the directory /mnt/shared/scratch/vbuswell/qiime2-training/

source activate qiime2-amplicon-2023.9

#filter samples:

qiime demux filter-samples \
--i-demux test_16s_paired_end.qza \
--m-metadata-file per-sample-fastq-counts.tsv \
--p-where 'CAST([forward sequence count] AS INT) > 10000' \
--o-filtered-demux test_16s_paired_end_filtered.qza

### trim primers:

qiime cutadapt trim-paired \
--i-demultiplexed-sequences test_16s_paired_end_filtered.qza \
--p-front-f GTGYCAGCMGCCGCGGTAA \
--p-front-r GGACTACNVGGGTWTCTAAT \
--o-trimmed-sequences test_16s_paired_end_filtered_cutadapt.qza

#denoise

qiime dada2 denoise-paired \
--i-demultiplexed-seqs test_16s_paired_end_filtered_cutadapt.qza \
--p-trunc-len-f 220 \
--p-trunc-len-r 220 \
--o-table test_16s_table.qza \
--o-representative-sequences test_16s_rep-seqs.qza \
--o-denoising-stats test_16s_denoising-stats.qza

#denoise viz

qiime metadata tabulate \
--m-input-file /mnt/shared/training/qiime2/test_16s_denoising-stats.qza \
--o-visualization test_16s_denoising-stats.qzv