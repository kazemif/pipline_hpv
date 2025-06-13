#!/usr/bin/env python

#=============================================================================#
#                                  Parse FASTQ                                #
#
#Date of creation: 09th of August 2024
#version: 1.0
#Author: Fauchois A.
#Site: Virology department, AP-HP Pitié-Salpetière, Paris, France
#=============================================================================#

#This script allows to parse FASTQ in order to report several metrics for
#seqeuncing reporting

#Import modules================================================================
import logging
import os
import sys
import time
import warnings

try:
    import parse_fastq.init
    import parse_fastq.parallel_read
    import parse_fastq.edit_result
except ImportError as exception:
    sys.exit("ERROR: Fatal error !! Please reinstall the tool")

#Define functions==============================================================

def main():
    """
    This function allows to excute the whole script

    PARAM:
    None

    RETURN:
    None
    """
    warnings.filterwarnings('ignore')

    #Extract command line arguments
    args = parse_fastq.init.get_arguments()

    #Parse command line arguments
    parse_fastq.init.parse_arguments(args)

    logging.basicConfig(level = logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt = '%Y-%m-%d %H:%M:%S')

    #Display system information
    parse_fastq.init.get_system_info()

    #Display file size
    parse_fastq.init.get_file_size(args.input)

    #Record start time
    start_time = time.time()

    #Get chunk arguments
    logging.info("Defining chunks")
    chunk_args = parse_fastq.parallel_read.compute_chunk_position(args.input, args.cpu)

    #Get chunk results
    logging.info("Performing parallel processing")
    chunk_results = parse_fastq.parallel_read.parallel_reading(chunk_args, args.cpu)

    #Combine chunk results
    logging.info("Combining chunk results")
    chunk_results = parse_fastq.edit_result.combine_results(chunk_results)

    #Summarize chunk results
    logging.info("Summarizing chunk results")
    chunk_results = parse_fastq.edit_result.summarize_results(chunk_results)

    #Write reuslts
    logging.info("Writting results")
    filename = args.input.split("/")[-1].split(".")[0]
    sample_name = args.sample if args.sample is not None else filename
    parse_fastq.edit_result.write_chunk_results(chunk_results, args.output, sample_name)

    #Record end time
    end_time = time.time()

    #Get and Print running time
    hour, min, sec, centisec = parse_fastq.init.compute_running_time(start_time, end_time)
    logging.info(f"Running time: {hour}h:{min}m:{sec}s::{centisec}")


#Main program==================================================================
if __name__ == "__main__":
    main()
