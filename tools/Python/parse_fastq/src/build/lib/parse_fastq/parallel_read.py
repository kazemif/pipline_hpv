#!/usr/bin/env python

"""
Program: chubk_process.py

Date of creation: 09th of August 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Import modules================================================================
import logging
import mmap
import multiprocessing as mp
import os
import sys
try:
    import parse_fastq.chunk_process
except ImportError as exception:
    sys.exit("ERROR: Fatal error ! Please reinstall the tool")

#Define function===============================================================

#Function to claibrate needed CPU----------------------------------------------
def correct_cpu(file_path, cpu):
    """
    This function define the number of needed CPU among allocated

    PARAMETERS:
    file_path: Path to the FASTQ file to process
    cpu: CPU number to use

    RETURN:
    read_number: the total number of reads to process
    cpu: the corrected CPU number to use 
    """
    lines_count = 0
    #Count line in FASTQ file
    with open(file_path, "r") as input_file:
        with mmap.mmap(input_file.fileno(), length = 0, access = mmap.ACCESS_READ) as mmap_input:
            while mmap_input.readline():
                lines_count += 1

    #Check line count and define needed CPU
    if lines_count % 4 != 0:
        sys.exit("ERROR: fastq file contains missing data")
    
    read_number = lines_count // 4
    while read_number // cpu == 0:
        cpu -= 1
        if cpu == 0:
            sys.exit("ERROR: fastq file contains some mistake")

    logging.info(f"Process will use {cpu} CPU and deal arround {read_number // cpu} reads/CPU")

    return read_number, cpu

#Function to check new record--------------------------------------------------
def verify_new_read(mmap_object, position):
	"""
	This function verify if a position is at the start of a new read
	
	PARAMETERS:
	mmap_object: a mmap object from a mmap file reading
	position: the position to check

	RETURN:
	a boolean idnicating whether a new read start
	"""
	if position == 0:
		return True
	else:
		mmap_object.seek(position)
		char = mmap_object.read(2).decode()
		return char == "\n@"

#Function to get next read-----------------------------------------------------
def get_next_read(mmap_object, position):
	"""
	This function give the position of the next read

	PARAMETERS:
	mmap_object: a mmap object from a mmap file reading
	position: the psoition to check
	"""
	for i in range(4):
		mmap_object.readline()
	position = mmap_object.tell()
	return position

#Function to compute chunk position--------------------------------------------
def compute_chunk_position(file_path, cpu):
    """
    This function allows to compute chunk position

    PARAM:
    file_path: path to file
    cpu: number of CPU to use

    RETURN:
    chunk_args: a list of chunk position
    """
    
    #Get file size
    file_size = os.path.getsize(file_path)
	
    #Get number of cpu to use and read number
    read_number, cpu = correct_cpu(file_path, cpu)

    #Compute chunk size
    chunk_size = file_size // read_number * (read_number // cpu) 
	
    #Create an empty chunk arguments list
    chunk_args = []
	
    #Compute chunk position
    with open(file_path, "r") as input_file:
        with mmap.mmap(input_file.fileno(), length = 0, access = mmap.ACCESS_READ) as mmap_input:
            chunk_start = 0
            while chunk_start < file_size:
                chunk_end = min(chunk_start + chunk_size, file_size)
                while not verify_new_read(mmap_input, chunk_end):
                    chunk_end -= 1
                    if chunk_end == chunk_start:
                        chunk_end = get_next_read(mmap_input, chunk_end)
                        break		
                args = (file_path, chunk_start, chunk_end)
                chunk_args.append(args)
                chunk_start = chunk_end + 1
    return chunk_args

#Function to perform parallel reading------------------------------------------
def parallel_reading(chunk_args, cpu):
    """
    This function allows to perform a parallel FASTQ file reading

    PARAM:
    chunk_args: chunk arguments fro process chunk function
    cpu: number of CPU to use
    """
    with mp.Pool(cpu) as p:
        chunk_results = p.starmap(parse_fastq.chunk_process.process_chunk, chunk_args)
    return chunk_results