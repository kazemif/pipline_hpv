#!/usr/bin/env python

"""
Program: edit_result.py

Date of creation: 13th of August 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Import modules================================================================
import os
import sys

try:
    import pandas as pd
except ImportError as exception:
    sys.exit("ERROR: pandas module is not installed")

#Define functions==============================================================

#Function to combine chunk result----------------------------------------------
def combine_chunk_result(chunk_results):
    """
    This fucntion allows to combine chunk results from parallel reading

    PARAM:
    chunk_results: chunk results

    RETURN:
    combined_chunk: a list of pandas comined object
    """
    #Initialiaze empty data-frame
    read_length_df = pd.DataFrame(columns = ["read_length", "mapped", "occurence"])
    map_score_df = pd.DataFrame(columns = ["map_score", "mapped", "occurence"])
    seq_score_df = pd.DataFrame(columns = ["seq_score", "mapped", "occurence"])
    gc_content_df = pd.DataFrame(columns = ["GC_content", "mapped", "occurence"])
    
    #Initialize counter
    mapped_read = 0
    read = 0

    #Combine data-frame and sum counter
    for i, chunk_result in enumerate(chunk_results):
        read_length_df = pd.concat([read_length_df, chunk_result.read_length_df], ignore_index = True)
        map_score_df = pd.concat([map_score_df, chunk_result.map_score_df], ignore_index = True)
        seq_score_df = pd.concat([seq_score_df, chunk_result.seq_score_df], ignore_index = True)
        gc_content_df = pd.concat([gc_content_df, chunk_result.gc_content_df], ignore_index = True)
        mapped_read += chunk_result.mapped_read_count
        read += chunk_result.read_count
    
    combined_chunk = [read_length_df, map_score_df, seq_score_df, gc_content_df, read, mapped_read]
    
    return combined_chunk

#Function to summarize chunk reuslts-------------------------------------------
def summarize_results(combined_chunk):
    """
    This function allows to summarize chunk results

    PARAM:
    combined_chunk: a list of combined chunk result object

    RETURN:
    summarized combined chunk results
    """
    #Summurise pandas data-frame
    combined_chunk[0] = combined_chunk[0].groupby(["read_length", "mapped"]).sum().reset_index()
    combined_chunk[1] = combined_chunk[1].groupby(["map_score", "mapped"]).sum().reset_index()
    combined_chunk[2] = combined_chunk[2].groupby(["seq_score", "mapped"]).sum().reset_index()
    combined_chunk[3] = combined_chunk[3].groupby(["GC_content", "mapped"]).sum().reset_index()

    return combined_chunk

#Function to write chunk result------------------------------------------------
def write_chunk_result(chunk_results, output_dir, sample_name):
    """
    This function allows to write chunk results

    PARAM:
    chunk_results: a list of combined and summurised ckunk results
    output_dir: output directorie where to save results
    sample_name: sample name
    """
    #Read length data-frame
    with open(os.path.join(output_dir, sample_name + "_read_length.txt"), "w") as read_length_file:
        read_length_file.write(chunk_results[0].to_csv(index = False))
        read_length_file.write("\n")
    
    #Map score data-frame
    with open(os.path.join(output_dir, sample_name + "_map_score.txt"), "w") as map_score_file:
        map_score_file.write(chunk_results[1].to_csv(index = False))
        map_score_file.write("\n")

    #Seq score data-frame
    with open(os.path.join(output_dir, sample_name + "_seq_score.txt"), "w") as seq_score_file:	
        seq_score_file.write(chunk_results[2].to_csv(index = False))
        seq_score_file.write("\n")
    
    #GC content data-frame
    with open(os.path.join(output_dir, sample_name + "_GC_content.txt"), "w") as gc_content_file:	
        gc_content_file.write(chunk_results[3].to_csv(index = False))
        gc_content_file.write("\n")
    
    #Read count
    with open(os.path.join(output_dir, sample_name + "_read_count.txt"), "w") as map_file:
        map_file.write("read\toccurence\n")
        map_file.write(f"Mapped\t{chunk_results[5]}\n")
        map_file.write(f"No mapped\t{chunk_results[4] - chunk_results[5]}\n")
        map_file.write(f"total\t{chunk_results[4]}\n")