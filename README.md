## QIIME2 instructions

# Installing QIIME2

Before attending the one day QIIME2 course you will need two things. First, you will need an account on the High Performace Cluster computer at the James Hutton Institue, called  and Gruffalo or the Crop Diversity Cluster. Secondly, you will need to install QIIME2 in it's own environment. 

You can request an account by going here https://help.cropdiversity.ac.uk/user-accounts.html

To install QIIME2 you need to login to the HPC and open an interactive node to work on by entering the following into your terminal:
```
srun --partition=short --cpus-per-task=2 --mem=2G --pty bash 
```
You should ensure your jobs only write to scratch space while running. So navigate to your scratch area using:
```
cd $SCRATCH
```
Now we will make a new directory (folder) for us to place everything in by using the mkdir command and navigate inside the new directory with cd (change directory):

```
mkdir qiime2-training
cd qiime2-training
```
Then we need to download a file from the internet that tells our installer what is needed to install QIIME2. You can download this by using a command called wget:

```
wget https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2023.9-py38-linux-conda.yml
```

Now we will create a conda environment for your new QIIME2 amplicon distribution and tell it what file to use (which is the one we just downloaded). Please be aware this might take a while:

```
conda env create -n qiime2-amplicon-2023.9 --file qiime2-amplicon-2023.9-py38-linux-conda.yml
```

You might be asked to confirm the installation, just press 'y' and enter. Afterwards you can check the installation by activating the environment:
```
conda activate qiime2-amplicon-2023.9
```
and test the install by typing:
```
qiime --help
```
If no errors are reported when running this command, the installation was successful!

