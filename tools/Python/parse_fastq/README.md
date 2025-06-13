# Parse FASTQ

This tools wrote in Python language can parse an input decompressed FASTQ file
and report several statistics. It return as outpout several file that report the
follwoing elements:
- read length
- per read GC content average
- per read sequencing score average
- per base sequencing score quantiles
For a better memory usage, quabnties are estimated thank to the P2 quantile
estimator algorithm.
> Jain, R., & Chlamtac, I. (1985). The P 2 algorithm for dynamic calculation of
> quantiles and histograms without storing observations. Communications Of The
> ACM, 28(10), 1076‑1085. [https://doi.org/10.1145/4372.4378]

## Dependencies

### Python modules
- argparse (version 1.4.0)
- pandas (version 2.1.2)
- numpy (version 1.26.0)

## Installation

This installation requires to have miniconda or anaconda installed. If you don't one of this please visit the following web site to install it: [conda installation](https://conda.io/projects/conda/en/latest/user-guide/install/index.html)

### Step 1: Download the repository
Use `git clone` command to download the repository

```
git clone git@github.com:AntFch/parse_fastq.git
```

### Step 2: Setup your environment
`src/install` folder contains an `install.sh` bash script that allows to create
automatically suitable environment.

```
cd parse_fastq/src/install
bash install.sh
```

## Usage

Activate your conda environment
```
conda activate parse_fastq
```

To see the help, run the follwoing command:
```
parse_fastq --help
```
You will obtain this output:
```
usage: parse_fastq.py [-h] [-i INPUT] [-o OUTPUT] [-c CPU] [-s SAMPLE]

This program allows to extract read length and sequencing quality score average for each reads

options:
  -h, --help            show this help message and exit

Input/Output:
  -i INPUT, --input INPUT
                        Fastq file to parse.
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
parse_fastq -i sample/sample.fastq -o results -c 10
```

You will see this output:
```
SYSTEM INFO: os: Linux
SYSTEM INFO: os version: #127~20.04.1-Ubuntu SMP Thu Jul 11 15:36:12 UTC 2024
SYSTEM INFO: CPU: 20
INPUT INFO: File size: 119.64 Ko
2024-08-13 11:51:21 Defining chunks
2024-08-13 11:51:21 Process will use 10 CPU and deal arround 10 reads/CPU
2024-08-13 11:51:21 Performing parallel processing
2024-08-13 11:51:21 Combining chunk results
2024-08-13 11:51:21 Summarizing chunk results
2024-08-13 11:51:21 Writting results
2024-08-13 11:51:21 Running time: 0.0h:0.0m:0.0s::25
```

Now you can use the creadted files in `results` folder.