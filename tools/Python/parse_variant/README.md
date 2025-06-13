# Parse variant

This tools wrote in Python language can parse an input VCF file. It filter
variant according to desired minimum sequencing depth and a relative variant
depth. It reports an array providing depth of filtered variant.

## Dependencies

### Python modules
- argparse (version 1.4.0)
- numpy (version 2.1.1)
- pyvcf (version 0.6.8)

### Other tools
- samtools (version 1.20)

## Installation

This installation requires to have miniconda or anaconda installed. If you don't
have one of this, please visit the following web site to install it: [conda
installation](https://conda.io/projects/conda/en/latest/user-guide/install/index.html)

### Step 1: Download the repository
Use `git clone` command to download the repository

```
git clone git@github.com:AntFch/parse_variant.git
```

### Step 2: Setup your environment
`src/install` folder contains an `install.sh` bash script that allows to create
automatically suitable environment.

```
cd parse_variant/src/install
bash install.sh
```

## Usage

Activate your conda environment
```
conda activate parse_variant
```

To see the help, run the follwoing command:
```
parse_variant --help
```
You will obtain this output:
```
usage: parse_variant.py [-h] [-b BAM] [-s SAM] [-f REF] [-v VCF] [-t THRESHOLD] [-d MIN_DEPTH] [-c CPU] [-ov OUT_VCF] [-op OUT_PILEUP]

This program allows to extract quality score and mapping status from a sam file.

options:
  -h, --help            show this help message and exit

Input:
  -b BAM, --bam BAM     Path to input BAM file
  -s SAM, --sam SAM     Path to input SAM file
  -f REF, --ref REF     Path to reference fasta file
  -v VCF, --vcf VCF     Path to VCF file

Option:
  -t THRESHOLD, --threshold THRESHOLD
                        Depth threshold value to filter individual variant
  -d MIN_DEPTH, --min_depth MIN_DEPTH
                        Minimimum global depth value
  -c CPU, --cpu CPU     Number of CPU to use. Default: 1

Output:
  -ov OUT_VCF, --out_vcf OUT_VCF
                        Path to output VCF file name.
  -op OUT_PILEUP, --out_pileup OUT_PILEUP
                        Path to output pileup array file name.
```

Now you can test this tool with the provided sample located in `sample` folder.
In the `parse_variant` folder, run the follwoing code:

```
cd ../../
mkdir results
parse_variant -s sample/sample.sam -v sample/sample.vcf -f sample/HSV_1_UL30.fasta \
-t 0.02 -d 50 \
-ov results/sample_filtered.vcf -op results/sample_pileup.txt
```

You will see this output:
```
SYSTEM INFO: os: Linux
SYSTEM INFO: os version: #129~20.04.1-Ubuntu SMP Wed Aug 7 13:07:13 UTC 2024
SYSTEM INFO: CPU: 20
2024-09-10 13:30:08 Converting SAM to BAM file
2024-09-10 13:30:12 Sorting BAM file
2024-09-10 13:30:15 Indexing BAM file
2024-09-10 13:30:16 Building reads pileup
2024-09-10 13:30:29 Sorting VCF file
2024-09-10 13:30:29 Building pileup array
2024-09-10 13:30:29 Skip position 101 due to unpassed quality test
[...]
2024-09-10 13:30:29 Parsing SNP at position 117
[...]
2024-09-10 13:30:30 Writting results
2024-09-10 13:30:30 Running time: 0h:0m:21s::42

```

Now you can use the created files in `results` folder.