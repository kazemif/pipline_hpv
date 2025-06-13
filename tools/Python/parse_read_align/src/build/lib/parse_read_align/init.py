#!/usr/bin/env python

"""
Program: init.py

Date of creation: 13th of August 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Import modules================================================================
import os
import platform
import subprocess
import sys
try:
    import argparse
except ImportError as exception:
    sys.exit("ERROR: argparse module is not installed")

#Define functions==============================================================

#Function to extract provided command line arguments---------------------------
def get_arguments():
    """
    This function allows to extract provided command line arguments

    PARAM:
    None

    Return:
    None
    """
    #Define parser
    parser = argparse.ArgumentParser(prog = "parse_sam.py",
                                     description = "This program allows to extract statistics from SAM/BAM file")
    
    #Add Input/Output arguments
    inout_group = parser.add_argument_group("Input/Output")
    inout_group.add_argument("-i", "--input", 
                             help = "SAM/BAM file to parse.", 
                             type = str)
    inout_group.add_argument("-o", "--output", 
                             help = "Output directorie. Four files will be created inside it.",
                             type = str)

    #Add Option group
    option_group = parser.add_argument_group("Option")
    option_group.add_argument("-c", "--cpu", 
                              help = "Number of CPU to use. (Default 1)", 
                              default = 1, 
                              type = int)
    option_group.add_argument("-s", "--sample", 
                              help = "Desired sample name. Default will be file name.",
                              type = str)
    
    #Collect arguments
    args = parser.parse_args()

    return(args)

#Function to parse command line arguments--------------------------------------
def parse_arguments(args):
    """
    This function allows to parse provided command line arguments

    PARAMETERS:
    arg: an argument object

    RETURN:
    """
    #Looking for empty arguments
    if args.input is None:
        sys.exit("ERROR: You must provide a SAM/BAM input file")
    
    if args.output is None:
         print("WARNING: output directorie is missing. Output file will be created on your current working directorie")
	
	#Looking file or folder existence
    if not os.path.exists(args.input):
        sys.exit("ERROR: Input file not found or doesn't exist.")
    
    if args.output is not None and not os.path.exists(args.output):
         sys.exit("ERROR: Output directorie doesn't exist or not found")
    
    #Looking file extension
    file_extension = get_file_extension(args.input)
    if file_extension not in ["sam", "bam"]:
        sys.exit("ERROR: Input file is not a fastq file")
    
    #Lokking asked cpu
    cpu_count = os.cpu_count()
    if args.cpu > cpu_count:
        sys.exit(f"ERROR: You have requisionned more CPU than available ({cpu_count})")

#Function to catch filextension------------------------------------------------
def get_file_extension(file_path):
    """
    This function allows to get file extension

    PARAM:
    file_path

    RETURN:
    file_extension: file extension
    """
    file_name = file_path.split("/")[-1]
    file_extension = ".".join(file_name.split(".")[1:])

    return file_extension

#Function to get system information--------------------------------------------
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
    hour = diff_time // 3600
    min = (diff_time - hour * 3600) // 60
    sec = (diff_time - (hour * 3600) - (min * 60)) // 1
    centisec = round((diff_time - (hour * 3600) - (min * 60) - sec) * 100)

    #Combine results into a tuple
    process_time = (hour, min, sec, centisec)
    return process_time

#Function to convert file size-------------------------------------------------
def get_file_size(file_path):
    """
    This function computes file's size

    PARAMETERS:
    file_path: the fastq file to process

    RETURN:
    file_size_formated: file size
    units: the size file unit, either Ko, Mo or Go
    """
    #Define unit list
    units = [(1e3, "Ko"), (1e6, "Mo"), (1e9, "Go")]

    #Get file size
    file_size = os.path.getsize(file_path)

    #Fit best unit size
    for i in range(len(units)):
        file_size_formated = file_size / units[i][0]
        if file_size_formated < 1e3:
            break
    file_size_formated = round(file_size_formated, 2)
    print(f"INPUT INFO: File size: {file_size_formated} {units[i][1]}")

#Function to convert a bam file to sam file------------------------------------
def convert_bam_to_sam(file_path, cpu):
    """
    This function allows to convert a BAM file in SAM file
    """
    #Compute thread number
    thread = cpu * 2

    #Create shell command
    command = f"samtools view -@ {thread} {file_path} > tempo.sam"

    #run command
    subprocess.run(command, shell = True)