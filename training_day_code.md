# Training day code along 

## Log in and open interactive node

We have an area that has been set aside for us to work in today (Thanks Iain!). Two nodes captainamerica and doctorstrange should be available on the debug queue.

To open an interactive terminal, use the following command:

```
srun --partition=debug --cpus-per-task=1 --mem=4G --pty bash 
```

## Importing your data

The first thing we need to do is import your data into qiime2. The data we are going to practice with is some 16s data located in the directory `/mnt/shared/training/qiime2` head to the directory you made when you installed qiime2: 
```
cd $SCRATCH
```
```
cd qiime2-training
```
Now activate the qiime2 environment that you created when you installed qiime2:

```
conda activate qiime2-amplicon-2023.9
```
Finally, it's now time to get using qiime2! The import command will look like this: 

```
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path /mnt/shared/training/qiime2/my_first_manifest.tsv \
--input-format PairedEndFastqManifestPhred33V2 \
--output-path test_16s_paired_end.qza 
```
Once imported, we want to have a look at our raw data, so we make a visualisation in qiime2, like so:

```
qiime demux summarize \
--i-data test_16s_paired_end.qza \
--o-visualization test_16s_paired_end_viz.qzv
```
Now we can download the visualisation output and head to the [Qiime2 view website](https://view.qiime2.org/) and drag and drop out file to the website to examine our raw data. 


## Filtering and denoising

If you have any samples with a low number of reads you can filter them out here. To run this command, we need to download the per sample read file from the qiime2 viewer that resulted from the import step. 
```
qiime demux filter-samples \
--i-demux test_16s_paired_end.qza \
--m-metadata-file per-sample-fastq-counts.tsv \
--p-where 'CAST([forward sequence count] AS INT) > 10000' \
--o-filtered-demux test_16s_paired_end_filtered.qza
```

Cutadapt can be used to remove the primers from your data. This is very important as for denoising it is important that the primers are removed as reads need to represent only individual sequences, not primer regions that will be the same across all. If they are not removed it can result in losing many reads during the denoising step. 

```
qiime cutadapt trim-paired \
--i-demultiplexed-sequences test_16s_paired_end_filtered.qza \
--p-front-f GTGYCAGCMGCCGCGGTAA \
--p-front-r GGACTACNVGGGTWTCTAAT \
--o-trimmed-sequences test_16s_paired_end_filtered_cutadapt.qza
```

Next, we will use a denoising pipeline, specifically we will use DADA2. This step with our mini dataset can take around 2-3 hours, so we won't run this command. I have done it for you. However, the code looks like this
```
qiime dada2 denoise-paired \
--i-demultiplexed-seqs test_16s_paired_end_filtered_cutadapt.qza \
--p-trunc-len-f 220 \
--p-trunc-len-r 220 \
--o-table test_16s_table.qza \
--o-representative-sequences test_16s_rep-seqs.qza \
--o-denoising-stats test_16s_denoising-stats.qza
```
Then we will have a look at how the denoising went by using a visualisation step
```
qiime metadata tabulate \
--m-input-file /mnt/shared/training/qiime2/test_16s_denoising-stats.qza \
--o-visualization test_16s_denoising-stats.qzv
```
## Clustering ASVs

Qiime2 by default uses ASV's (they call them features). But sometimes you may want to cluster based on similarity (16s often uses 97%, while some people cluster fungi at various values). Just in case you'd like to cluster your data you could use a command like so:
```
qiime vsearch cluster-features-de-novo \
--i-table /mnt/shared/training/qiime2/test_16s_table.qza \
--i-sequences /mnt/shared/training/qiime2/test_16s_rep-seqs.qza \
--p-perc-identity 0.97 \
--o-clustered-table test_16s_table_clustered97.qza \
--o-clustered-sequences test_16s_rep-seqs_clustered97.qza
```
## Assigning taxonomy

Next we can assign taxonomy to the OTU's in our data by using a classifer built from the database GreenGenes2. However this requires a bit more memory that what we have allocated to our node initially. 
So first we will deactivate our conda environment:
```
conda deactivate
```
then close the interactive job:
```
exit
```
Now open a new job with more memory:
```
srun --partition=debug --cpus-per-task=2 --mem=8G --pty bash 
```
reactivate conda:
```
conda activate qiime2-amplicon-2023.9
```
Now we should have enough memory for the machine learning classifier to work. The code below will allow you to assign taxonomy to our now cluster representative sequences.
```
qiime feature-classifier classify-sklearn \
--i-classifier /mnt/shared/training/qiime2/gg_2022_10_backbone.v4.nb.qza \
--i-reads test_16s_rep-seqs_clustered97.qza \
--o-classification test_16s_taxonomy_results.qza 
```
We can look at the results as a table output by using the below code:
```
qiime metadata tabulate \
--m-input-file test_16s_taxonomy_results.qza \
--o-visualization test_16s_taxonomy_results_viz.qzv
```
However, the table format is difficult to look at, so instead we can make a quick bar chart that we can view using qiime2 view, using the code below:
```
qiime taxa barplot \
--m-metadata-file /mnt/shared/training/qiime2/test_16s_metadata.tsv \
--i-table test_16s_table_clustered97.qza \
--i-taxonomy test_16s_taxonomy_results.qza \
--o-visualization test_16s_taxa_bar_plots.qzv
```
This file can be viewed at the qiime2 view website. 

## Abundance table 

To retrive an abundance table that is not collaspsed on taxonomy we will export our abundance table data:
```
qiime tools export \
--input-path test_16s_table_clustered97.qza \
--output-path test_16s_abundance_table
```
 format change the abundance tabel from biom to tsv
```
biom convert -i test_16s_abundance_table/feature-table.biom \
-o test_16s_abundance_table/feature-table.tsv --to-tsv
```
Taxononmy of representative sequences outputs from results
```
qiime metadata tabulate \
--m-input-file test_16s_rep-seqs_clustered97.qza \
--m-input-file test_16s_taxonomy_results.qza \
--o-visualization test_16s_rep_seq_taxa_results_combind.qzv
```
If you would like to combine your taxonomy and feature table you need to drag the `test_16s_rep_seq_taxa_results_combind.qzv` file up to Qiime2 view and then download it as a tab separated values file (TSV file). Then take the `test_16s_rep_seq_taxa_results_combind.tsv` and the `feature-table.tsv` and use then in this custom python code which is called `merge_feature_taxon_tables.py`, the syntax to use the python code is `python <python file> <feature table file> <taxonomy file> <what you'd like to name your outfile>` like so:
	
```bash
python merge_feature_taxon_tables.py feature-table.tsv rep-seq-taxo.tsv my_merged_results.tsv
```
You can then use these to perform your statistics! 
