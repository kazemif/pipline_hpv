#!/usr/bin/env bash

#=============================================================================#
#                             Parse FASTQ insatller                           #
#
#Date of creation: 13th of August 2024
#version: 1.0
#Author: Fauchois A.
#Site: Virology department, AP-HP Pitié-Salpetière, Paris, France
#=============================================================================#

#This script allows to install par_fastq tool

#Define color palette==========================================================
RED="\033[38;5;196m"
YELLOW="\033[38;5;226m"
GREEN="\033[38;5;46m"
RESET="\033[38;5;255m"

#Prompt to start the installation==============================================
echo ""
echo "Welcome in parse fastq ! This tool will allow you to parse and analyse FASTQ file"
echo "Thank for your trusting in our data solution"
echo "Do you to continue ? (Y|N)"

read -r input
input=$(echo $input | tr [:lower:] [:upper:])

if [[ ${input} != "Y" ]]
then
    echo -e "${YELLOW}MESSAGE:${RESET} Installation aborted"
    exit 1
fi

#Check conda===================================================================
if command -v conda &> /dev/null
then
    #Conda check passed
    conda_version=$(conda --version | egrep -o "([0-9]|\.)*")
    echo ""
    echo -e "${GREEN}CHECK:${RESET} Conda is installed (version: ${conda_version})"
else
    echo ""
    echo -e "${RED}ERROR:${RESET} Conda is not installed."
    echo "Please visit the following website to install it: https://docs.anaconda.com/miniconda/"
    exit 1
fi

#Install mamba in base environement============================================
#Get conda fold
conda_fold=$(which conda | sed -r 's/\/bin\/conda//g')

#Activate base environment
source ${conda_fold}/bin/activate base

#Check mamba
if [[ $(conda list | egrep "^mamba" | wc -l) != 1 ]]
then
    echo ""
    echo -e "${YELLOW}MESSAGE:${RESET} Installing Mamba extension"
    conda install -c conda-forge mamba
fi
echo ""
echo -e "${GREEN}CHECK:${RESET} Mamba is installed"

#Install parse fastq environment===============================================
if [[ $(conda env list | egrep "parse_fastq" | wc -l) != 1 ]]
then
    echo ""
    echo -e "${YELLOW}MESSAGE:${RESET} Installing suitable environment"
    mamba env create -f ../../env/parse_fastq.yml
fi
echo ""
echo -e "${GREEN}CHECK:${RESET} parse fastq environment is installed"

#Pip install python tool=======================================================
#Activate base environment
source ${conda_fold}/bin/activate parse_fastq
cd ../
pip install .
echo ""
echo -e "${GREEN}CHECK:${RESET} parse fastq tool is installed"