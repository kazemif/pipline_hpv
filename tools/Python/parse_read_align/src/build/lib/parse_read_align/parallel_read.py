#!/usr/bin/env python

"""
Program: parallel_read.py

Date of creation: 13th of August 2024 
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
	import parse_read_align.chunk_process
except ImportError as exception:
	sys.exit("ERROR: Fatal error ! Please reinstall the tool")

#Define fucntions==============================================================

#Function to calibrate needed cpu----------------------------------------------
def correct_cpu(file_to_read, nb_cpu):
	"""
	This function define the number of needed CPU among allocated

	PARAMETERS:
	file_to_read: SAM file to parse
	nb_cpu: number of allocated CPU

	RETURN:
	read_number, nb_cpu: a tuple giving the number of reads and needed CPU number
	"""
	lines_count = 0
	with open(file_to_read, "r") as input_file:
		with mmap.mmap(input_file.fileno(), length = 0, access = mmap.ACCESS_READ) as mmap_input: 
			while mmap_input.readline() :
				lines_count += 1
	read_number = lines_count
	while read_number // nb_cpu == 0:
		nb_cpu -= 1
		if nb_cpu == 0:
			sys.exit("ERROR: fastq file contains some mistake")
	
	logging.info(f"Process will use {nb_cpu} CPU and deal arround {read_number // nb_cpu} reads/CPU")
	return read_number, nb_cpu

#Function to check new line----------------------------------------------------
def new_line_verify(mmap_object, position):
	"""
	This function verify if a position is after a \\n
	
	PARAMETERS
	mmap_object: mmap object corresponding to the file
	position: position to look
	
	RETURN
	boolean: boolean corresponding to the test
	"""
	if position == 0:
		return True
	else:
		mmap_object.seek(position)
		char = mmap_object.read(1)	
		return char.decode() == '\n'

#Function to get the next line-------------------------------------------------
def get_next_line_position(mmap_object, position):
	"""
	This function gets position of the next line
	
	PARAMETERS
	mmap_object: a mmap object
	position: position to look
	
	RETURN
	position: position of the next line
	"""
	mmap_object.seek(position)
	mmap_object.readline()
	return mmap_object.tell()

#Function to compute chunk position--------------------------------------------
def compute_chunk_position(file_path, cpu):
	"""
	This function allows to define chunk position

	PARAM:
	file_path: path to the file
	cpu;: number of desired CPU

	RETURN:
	chunk_args: a list of chunk position
	"""
	#Extract size and cpu information
	file_size = os.path.getsize(file_path)
	
	#Get number of PCU to use and read number
	read_number, cpu = correct_cpu(file_path, cpu)

	#Compute chunk size
	chunk_size = file_size // read_number * (read_number // cpu)

	#Create an empty chunk arguments list
	chunk_args = []

	#Compute chunk position
	with open(file_path, "r") as file_input:
		with mmap.mmap(file_input.fileno(), length = 0, access = mmap.ACCESS_READ) as mmap_input:
		
			#Define position of the first chunk
			chunk_start = 0
			
			while chunk_start < file_size:
				chunk_end = min(chunk_start + chunk_size, file_size)

				#verify if chunk ends at the end of a line
				while not new_line_verify(mmap_input, chunk_end):
					#withdraw 1 up to reach a "\n"
					chunk_end -= 1
					#Case chunk_end has decrease until chunk_start
					if chunk_start == chunk_end:
						chunk_end = get_next_line_position(mmap_input, chunk_end)
						break	

				args = (file_path, chunk_start, chunk_end)
				chunk_args.append(args)
				chunk_start = chunk_end + 1
	return chunk_args

#Function to perfrom a parallel reading----------------------------------------
def parallel_reading(chunk_args, cpu):
	"""
	This function allows to perform a parallel SAM file reading

	PARAM:
	chunk_args: chunk arguments for process a chunk function
	cpu: number fo cpu to use
	"""
	with mp.Pool(cpu) as p:
		chunk_results = p.starmap(parse_read_align.chunk_process.process_chunk, chunk_args)
	return chunk_results
