#!/usr/bin/env bash

#=============================================================================#
#                            Parse variant insatller                          #
#                                                                             #
#Date of creation: 10th of September 2024                                     #
#version: 1.0                                                                 #
#Author: Fauchois A.                                                          #
#Site: Virology department, AP-HP Pitié-Salpetière, Paris, France             #
#=============================================================================#

#This script allows to install parse variant tool

#Define color palette==========================================================
RED="\033[38;5;196m"
YELLOW="\033[38;5;226m"
GREEN="\033[38;5;46m"
RESET="\033[38;5;255m"

#Prompt to start the installation==============================================
echo ""
echo "Welcome in parse variant ! This tool will allow you to parse and analyse variant found from NGS pipeline"
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

#Install parse variant environment=============================================
if [[ $(conda env list | egrep "parse_variant" | wc -l) != 1 ]]
then
    echo ""
    echo -e "${YELLOW}MESSAGE:${RESET} Installing suitable environment"
    mamba env create -f ../../env/parse_variant.yml
fi
echo ""
echo -e "${GREEN}CHECK:${RESET} parse variant environment is installed"

#Pip install python tool=======================================================
#Activate parse variant env
source ${conda_fold}/bin/activate parse_variant
cd ../
pip install .
echo ""
echo -e "${GREEN}CHECK:${RESET} parse variant tool is installed"