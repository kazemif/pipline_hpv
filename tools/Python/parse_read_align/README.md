# Parse read align

This tools wrote in Python language can parse an input SAM/BAM file and report
several statistics. It return as output several files that report the following
elements:
- read length
- per read GC content average
- per read sequencing score average
- per read mapping score
- mapped and unmapped reads count
All of them are reported depending on mapped status

## Dependencies

### Python modules
- argparse (version 1.4.0)
- pandas (version 2.1.2)
- samtools (version 1.20)

## Installation

This installation requires to have miniconda or anaconda installed. If you don't one of this please visit the following web site to install it: [conda installation](https://conda.io/projects/conda/en/latest/user-guide/install/index.html)

### Step 1: Download the repository
Use `git clone` command to download the repository

```
git clone git@github.com:AntFch/parse_read_align.git
```

### Step 2: Setup your environment
`src/install` folder contains an `install.sh` bash script that allows to create
automatically suitable environment.

```
cd parse_read_align/src/install
bash install.sh
```

## Usage

Activate your conda environment
```
conda activate parse_read_align
```

To see the help, run the follwoing command:
```
parse_read_align --help
```
You will obtain this output:
```
usage: parse_read_align.py [-h] [-i INPUT] [-o OUTPUT] [-c CPU] [-s SAMPLE]

This program allows to extract statistics from SAM/BAM file

options:
  -h, --help            show this help message and exit

Input/Output:
  -i INPUT, --input INPUT
                        SAM/BAM file to parse.
  -o OUTPUT, --output OUTPUT
                        Output directorie. Four files will be created inside it.

Option:
  -c CPU, --cpu CPU     Number of CPU to use. (Default 1)
  -s SAMPLE, --sample SAMPLE
                        Desired sample name. Default will be file name.
```

Now you can test this tool with the provided sample located in `sample` folder.
In the `parse_fastq` folder, run the follwoing code:

```
cd ../../
mkdir results
parse_read_align -i sample/sample.bam -o results -c 10
```

You will see this output:
```
SYSTEM INFO: os: Linux
SYSTEM INFO: os version: #127~20.04.1-Ubuntu SMP Thu Jul 11 15:36:12 UTC 2024
SYSTEM INFO: CPU: 20
INPUT INFO: File size: 485.96 Ko
2024-08-14 11:46:56 Converting BAM file in SAM one
2024-08-14 11:46:56 Defining chunks
2024-08-14 11:46:56 Process will use 10 CPU and deal arround 99 reads/CPU
2024-08-14 11:46:56 Performing parallel processing
2024-08-14 11:46:56 Combining chunk results
2024-08-14 11:46:56 Summarizing chunk results
2024-08-14 11:46:56 Writting results
2024-08-14 11:46:56 Running time: 0.0h:0.0m:0.0s::64
```
An other sample in SAM format is also provided.
Now you can use the creadted files in `results` folder.
