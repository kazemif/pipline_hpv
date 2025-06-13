#!/usr/bin/env python

"""
Program: init.py

Date of creation: 09th of September 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Immport needed modules========================================================

import os
import platform
import sys
try:
    import argparse
except ImportError as exception:
    sys.exit("ERROR: argparse module is not installed")

#Define functions==============================================================

#Function to extract given command line argument-------------------------------
def extract_arguments():
    """
    This fucntion allows to extract given command line arguments

    PARAMETERS:
    None

    RETURN:
    args: an args object
    """
    #Define parser
    parser = argparse.ArgumentParser(prog = "parse_variant.py",
    description = "This program allows to extract quality score and mapping status from a sam file.")
    
    #Add input arguments
    input_group = parser.add_argument_group("Input")
    input_group.add_argument("-b", "--bam", 
                             type = str, 
                             help = "Path to input BAM file")
    input_group.add_argument("-s", "--sam", 
                             type = str, 
                             help = "Path to input SAM file")
    input_group.add_argument("-f", "--ref", 
                             type = str, 
                             help = "Path to reference fasta file")
    input_group.add_argument("-v", "--vcf", 
                             type = str, 
                             help = "Path to VCF file")
    
    #Add option argument
    option_group = parser.add_argument_group("Option")
    option_group.add_argument("-t", "--threshold", 
                              type = float, 
                              help = "Depth threshold value to filter individual variant", 
                              default = 0.2)
    option_group.add_argument("-d", "--min_depth", 
                              help = "Minimimum global depth value", 
                              type = int,
                              default = 50)
    option_group.add_argument("-c", "--cpu", 
                              type = int, 
                              help = "Number of CPU to use. Default: 1",
                              default = 1)
    
    #Add output argument
    output_group = parser.add_argument_group("Output")
    output_group.add_argument("-ov", "--out_vcf",
                              type = str,
                              help = "Path to output VCF file name.")
    output_group.add_argument("-op", "--out_pileup",
                              type = str,
                              help = "Path to output pileup array file name.")

    #Collect arguments
    args = parser.parse_args()
    return args

#Function to parse arguments-----------------------------------------------------------------------
def parse_arguments(args):
    """
    This function allows to parse given command line
    arguments

    PARAMATERS:
    args: an argument object

    RETURN:
    None
    """
    #Empty bam and sam argument
    if args.bam is None and args.sam is None:
        sys.exit("ERROR: You need to provide oat least one of the following arguments: bam/sam.")
    
    #Empty ref argument
    if args.ref is None:
        sys.exit("ERROR: reference argument is empty.")

    #Empty vcf argument
    if args.vcf is None:
        sys.exit("ERROR: vcf argument is empty.")
    
    #Empty ouptut argument
    if args.out_vcf is None:
        sys.exit("ERROR: output VCF argument is empty.")
    if args.out_pileup is None:
        sys.exit("ERROR: output pileup argument is empty.")

    #Incorrect requested CPU
    if args.cpu > os.cpu_count():
        sys.exit(f"ERROR: requested CPU number is greater than available one's {os.cpu_count()}")
    
    #No existing BAM file
    if args.bam is not None:
        if not os.path.exists(args.bam):
            sys.exit("ERROR: BAM file not found or doesn't exist.")
    
    #No existing SAM file
    if args.sam is not None:
        if not os.path.exists(args.sam):
            sys.exit("ERROR: SAM file not found or doesn't exist.")

    #No existing reference file
    if not os.path.exists(args.ref):
        sys.exit("ERROR: Reference file not found or doesn't exist.")

    #No existing path to output file
    if args.out_vcf.find("/") >= 0:
        ouptut_path = "/".join(args.out_vcf.split("/")[:-1])
        if not os.path.exists(ouptut_path):
            sys.exit("ERROR: output path to VCF file not found or doesn't exist.")
    
    if args.out_pileup.find("/") >= 0:
        ouptut_path = "/".join(args.out_pileup.split("/")[:-1])
        if not os.path.exists(ouptut_path):
            sys.exit("ERROR: output path to pileup array file not found or doesn't exist.")
    
    #Incorrect threshold value
    if not 0 <= args.threshold <= 1:
        sys.exit("ERROR: Threshold value must be between 0 and 1.")

#Function to get system information---------------------------------------------
def get_system_info():
    """
    This function allows to get and display system information

    PARAM:
    None

    RETURN:
    None 
    """
    #Extract os information
    os_info = platform.uname()

    print(f"SYSTEM INFO: os: {os_info.system}")
    print(f"SYSTEM INFO: os version: {os_info.version}")
    print(f"SYSTEM INFO: CPU: {os.cpu_count()}")

#Function to compute running time----------------------------------------------
def compute_running_time(start_time, end_time):
    """
    This function allows to compute start time and end time

    PARAM:
    start_time: the start time of the process
    end_time: the end time of the process
    
    RETURN:
    process_time: the running time of the process
    """
    #Compute difference time
    diff_time = end_time - start_time

    #Compute hour, min, sec and centisec
    hour = int(diff_time // 3600)
    min = int((diff_time - hour * 3600) // 60)
    sec = int((diff_time - (hour * 3600) - (min * 60)) // 1)
    centisec = round((diff_time - (hour * 3600) - (min * 60) - sec) * 100)

    #Combine results into a tuple
    process_time = (hour, min, sec, centisec)
    return process_time