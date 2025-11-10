# Dealing with ITS data
### Overview
This is a tutorial for JHI staff, we are not affiliated with QIIME2, DADA2 or ITSexpress. 

When processing ITS data, there are several quality assurance and marker-specific steps that can improve your results. This is because the ITS region is highly variable in length among different species—and even among strains—so certain trimming methods may need to be adjusted. \
The main workflow differences for ITS data involve the use of ITSxpress followed by DADA2. A detailed tutorial for ITSxpress is available [here](https://forum.qiime2.org/t/q2-itsxpress-a-tutorial-on-a-qiime-2-plugin-to-trim-its-sequences/5780). \

### Install ITSxpress

Install by using this pipeline:

get on an interactive node:

`srsh --mem=6G`

activate your qiime2 environment:

`conda activate qiime2-amplicon-2025.7`

While inside the environment, install the ITSxpress program into the same environment you already have.

`conda install -c bioconda itsxpress`

refresh the environment so it can reboot:

`qiime dev refresh-cache`

test the installation by trying to 'call' itspress itself

`qiime itsxpress`

close the environment

`conda deactiavte qiime2-amplicon-2025.7`

### Denoising pipeline 

Once the raw data have been imported, using the same procedure as described for the 16S example in the original tutorial, the adjusted denoising step can be performed.

The Cutadapt step will remove the primers, this is nessasry to allow denoising to be performed accuratly. During the ITSxpress step, you’ll need to specify both the region and the target taxa. ITSxpress removes the conserved regions around the ITS results in more accurate taxonomic classification. \ 
In the ITSxpress step we will not perform clustering so that DADA2 can be applied to the unmerged, unclustered output. \
We have trimmed the primers and the conserved regions, so when we use Dada2 but with no extra trimming, but due to the variable length in the marker. An example of this pipline is below:
```
qiime cutadapt trim-paired \
--i-demultiplexed-sequences ITS_paired_end.qza \
--p-front-f GTGARTCATCGAATCTTTG \
--p-front-r TCCTCCGCTTATTGATATGC \
--verbose \
--o-trimmed-sequences ITS_paired_end_cutadapt.qza

qiime itsxpress trim-pair-output-unmerged \
--i-per-sample-sequences ITS_paired_end_cutadapt.qza \
--p-region ITS2 \
--p-taxa F \
--p-cluster-id 1.0 \
--o-trimmed ITS_paired_end_cutadapt_itsexpress.qza

qiime dada2 denoise-paired \
--i-demultiplexed-seqs ITS_paired_end_cutadapt_itsexpress.qza \
--p-trunc-len-f 0 \
--p-trunc-len-r 0 \
--o-table ITS_paired_end_cutadapt_itsexpress_dada2_table.qza \
--o-representative-sequences ITS_paired_end_cutadapt_itsexpress_dada2_rep_seq.qza \
--o-denoising-stats ITS_paired_end_cutadapt_itsexpress_dada2_denoise.qza
```




