#!/usr/bin/env python

#=============================================================================#
#                                    Parse SAM                                #
#
#Date of creation: 13th of August 2024
#version: 1.0
#Author: Fauchois A.
#Site: Virology department, AP-HP Pitié-Salpetière, Paris, France
#=============================================================================#

#THis script allows to parse SAM:BAM file file in order to report several
#metrics for sequencing reporting

#Import modules================================================================
import logging
import os
import sys
import time
import warnings

try:
    import parse_read_align.init
    import parse_read_align.parallel_read
    import parse_read_align.edit_result
except ImportError as exception:
    sys.exit("ERROR: Fatal error !! Please reinstall the tool")

#Define function===============================================================

def main():
    """
    This function allows to execute the whole script

    PARAM:
    None

    RETURN:
    None
    """
    #Setting
    warnings.filterwarnings("ignore")
    logging.basicConfig(level = logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt = '%Y-%m-%d %H:%M:%S')

    #Extract command line arguments
    args = parse_read_align.init.get_arguments()

    #Parse provided command line arguments
    parse_read_align.init.parse_arguments(args)

    #Display system information
    parse_read_align.init.get_system_info()

    #Display file size
    parse_read_align.init.get_file_size(args.input)

    #Record start time
    start_time = time.time()

    #Get sample name
    filename = args.input.split("/")[-1].split(".")[0]
    sample_name = args.sample if args.sample is not None else filename

    #Convert bam file to sam
    file_extension = parse_read_align.init.get_file_extension(args.input)
    if file_extension == "bam":
        logging.info("Converting BAM file in SAM one")
        parse_read_align.init.convert_bam_to_sam(args.input, args.cpu)
        args.input = "tempo.sam"

    #Get chunk arguments
    logging.info("Defining chunks")
    chunk_args = parse_read_align.parallel_read.compute_chunk_position(args.input, args.cpu)

    #Get chunk results
    logging.info("Performing parallel processing")
    chunk_results = parse_read_align.parallel_read.parallel_reading(chunk_args, args.cpu)

    #Combine chunk result
    logging.info("Combining chunk results")
    chunk_results = parse_read_align.edit_result.combine_chunk_result(chunk_results)

    #Summurize chunk results
    logging.info("Summarizing chunk results")
    chunk_results = parse_read_align.edit_result.summarize_results(chunk_results)

    #Write result
    logging.info("Writting results")
    parse_read_align.edit_result.write_chunk_result(chunk_results, args.output, sample_name)

    #Remove tempo file
    if file_extension == "bam":
        os.remove("tempo.sam")

    #Record end time
    end_time = time.time()

    #Get and print running time
    hour, min, sec, centisec = parse_read_align.init.compute_running_time(start_time, end_time)
    logging.info(f"Running time: {hour}h:{min}m:{sec}s::{centisec}")


#Main program==================================================================
if __name__ == "__main__":
    main()