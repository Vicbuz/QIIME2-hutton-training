# Welcome to the QIIME2 James Hutton Institute Training day

The following instructions are what you need to do **before** the training day. You will need to:  

1. Have access to the HPC
2. Install QIIME2

## Get a HPC account

First, you will need an account on the High Performace Cluster computer at the James Hutton Institue, called Gruffalo or the Crop Diversity Cluster. You may already have an account, if so please skip to the next step of installing QIIME2.

You can request an account by going here https://help.cropdiversity.ac.uk/user-accounts.html  

## Installing QIIME2

Now you are logged in with an account we can install QIIME2 for you to use it on the training day. 

To install QIIME2 you need to login to the HPC using your username and password and open an interactive node. This is important, do not work on the head node (gruffalo). Gruffalo is not for work, it is for managing and monitoring job submissions and does not have the resources to perform the task we will be doing. To get an interactive job node to work on, entering the following into your terminal:
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
wget https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.2-py38-linux-conda.yml
```

Now we will create a conda environment for your new QIIME2 amplicon distribution and tell it what file to use (which is the one we just downloaded). Please be aware this might take a while:

```
conda env create -n qiime2-amplicon-2024.2 --file qiime2-amplicon-2024.2-py38-linux-conda.yml
```

You might be asked to confirm the installation, just press 'y' and enter. Afterwards you can check the installation by activating the environment:
```
conda activate qiime2-amplicon-2024.2
```
and test the install by typing:
```
qiime --help
```
If no errors are reported when running this command, the installation was successful!

