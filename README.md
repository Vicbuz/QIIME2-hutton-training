# Welcome to the QIIME2 James Hutton Institute Training day

The following instructions are what you need to do **before** the training day. You will need to:  

1. Have access to the HPC
2. Install QIIME2

## Get a HPC account

First, you will need an account on the High Performace Cluster computer at the James Hutton Institue, called Gruffalo or the Crop Diversity Cluster. You may already have an account, if so please skip to the next step of installing QIIME2. The crop diversity HPC help documents are a very useful resource so please make sure you check out the website : https://help.cropdiversity.ac.uk/ 

You can request an account by going here https://help.cropdiversity.ac.uk/user-accounts.html  

There are several ways to connect to the HPC, I recommend you use MobaXterm which you can download from the Software Center, for help see the HPC help website section called Getting Connected https://help.cropdiversity.ac.uk/ssh.html



## Installing QIIME2

Now you are logged in with an account we can install QIIME2 for you to use it on the training day. 

Initially, if you don't already have bioconda set up (i.e. you have a new HPC account and have never installed conda previously) you wiil need to install the package manager conda that will facilitate you installing QIIME2. Login to the HPC using your username and password. Then while logged onto the HPC cluster head node, called gruffalo where your prompt would look something like this `[jsmith@gruffalo ~]$` type the following instruction:

```
install-bioconda
```
To check this has worked type:

```
conda --version
```
This should report the version of conda you have. You may need to log out and back in again to get this to work, additionally this can take a while so be patient. 

The next step is to install QIIME2 using conda. To do this you need open an interactive node. ***This is important, do not work on the head node (gruffalo)***. Gruffalo is not for work, it is for managing and monitoring job submissions and does not have the resources to perform the task we will be doing. To get an interactive job node to work on, entering the following into your terminal:
```
srun --partition=short --cpus-per-task=1 --mem=4G --pty bash 
```
You should ensure your jobs only write to scratch space while running. So navigate to your scratch area using:
```
cd $SCRATCH
```
Now we will make a new directory (folder) for us to place everything in by using the `mkdir` command :

```
mkdir qiime2-training
```
Now navigate inside the new directory with `cd` (change directory):
```
cd qiime2-training
```
Then we need to download a file from the internet that tells our installer what is needed to install QIIME2. You can download this by using a command called `wget`:

```
wget https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2023.9-py38-linux-conda.yml
```

We need to edit this file to remove the conda defaults channel :

```
sed -i '/- defaults/d' qiime2-amplicon-2023.9-py38-linux-conda.yml
```

Now we will create a conda environment for your new QIIME2 amplicon distribution and tell it what file to use (which is the one we just downloaded and edited). Please be aware this might take a while:

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

To close your conda environment type:
```
conda deactivate
```
then to exit your interactive node type:
```
exit
```


