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
    import numpy as np
except ImportError as exception:
    sys.exit("ERROR: Pandas module is not installed")

try:
    import pandas as pd
except ImportError as exception:
    sys.exit("ERROR: Pandas module is not installed")

#Define functions==============================================================

#Functiont to combine chunk results--------------------------------------------
def combine_results(chunk_results):
    """
    This functions allows to combine results from parallel processing

    PARAM:
    chunk_results: a list of chunk_attributs object

    RETURN:
    combined_chunk: a list of pandas and numpy combined object
    """

    #Initialiaze empty data-frame
    read_length_df = pd.DataFrame(columns = ['read_length', 'occurence'])
    seq_score_df = pd.DataFrame(columns = ['seq_score', 'occurence'])
    gc_content_df = pd.DataFrame(columns = ['GC_content', 'occurence'])

    #Combine data-frame or array
    for i, chunk_result in enumerate(chunk_results):
        read_length_df = pd.concat([read_length_df, chunk_result.read_length_df], ignore_index = True)
        seq_score_df = pd.concat([seq_score_df, chunk_result.seq_score_df], ignore_index = True)
        gc_content_df = pd.concat([gc_content_df, chunk_result.gc_content_df], ignore_index = True)
        #Combine quantile array
        quantile_list = [np.array(chunk_result.quantile_Q1), np.array(chunk_result.quantile_Med), np.array(chunk_result.quantile_Q3)]
        if i == 0:
            quantile_combined_list = quantile_list
        else:
            for j in range(len(quantile_list)):
                #Pad array
                array_size = max(quantile_list[j].shape[0], quantile_combined_list[j].shape[0])
                array_1 = np.pad(quantile_list[j], (0, array_size - quantile_list[j].shape[0]), "constant")
                if len(quantile_combined_list[j].shape) == 1:
                    array_size = max(quantile_list[j].shape[0], quantile_combined_list[j].shape[0])
                    array_1 = np.pad(quantile_list[j], (0, array_size - quantile_list[j].shape[0]), "constant")
                    array_2 = np.pad(quantile_combined_list[j], (0, array_size - quantile_combined_list[j].shape[0]), "constant")
                else:
                    array_size = max(quantile_list[j].shape[0], quantile_combined_list[j].shape[1])
                    array_1 = np.pad(quantile_list[j], (0, array_size - quantile_list[j].shape[0]), "constant")
                    array_2 = np.pad(quantile_combined_list[j], ((0, 0), (0, array_size - quantile_combined_list[j].shape[1])), "constant")
                quantile_combined_list[j] = np.vstack((array_1, array_2))
    
    combined_chunk = [read_length_df, seq_score_df, gc_content_df, quantile_combined_list]

    return combined_chunk

#Function to summarize chunk result--------------------------------------------    
def summarize_results(combined_chunk):
    """
    This function allows to summarize chunk results

    PARAM:
    combined_chunk: a list of combined chunk result object

    RETURN:
    summarized combined chunk results
    """   
    #Summurise pandas data-frame
    combined_chunk[0] = combined_chunk[0].groupby("read_length").sum().reset_index()
    combined_chunk[1] = combined_chunk[1].groupby("seq_score").sum().reset_index()
    combined_chunk[2] = combined_chunk[2].groupby("GC_content").sum().reset_index()

    #Summurise numpy array
    for i, array in enumerate(combined_chunk[3]):
        array[array == 0] = np.nan
        col_means = np.nanmean(array, axis = 0)
        combined_chunk[3][i] = np.round(col_means, 2)
    return combined_chunk

#Function to write chunk result------------------------------------------------
def write_chunk_results(chunk_results, output_dir, sample_name):
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
    
    #Seq score data-frame
    with open(os.path.join(output_dir, sample_name + "_seq_score.txt"), "w") as seq_score_file:	
        seq_score_file.write(chunk_results[1].to_csv(index = False))
        seq_score_file.write("\n")
    
    #GC content data-frame
    with open(os.path.join(output_dir, sample_name + "_GC_content.txt"), "w") as gc_content_file:	
        gc_content_file.write(chunk_results[2].to_csv(index = False))
        gc_content_file.write("\n")
    
    #Per base sequencing score
    np.savetxt(os.path.join(output_dir, sample_name + "_per_base_seq_score.txt"), chunk_results[3], delimiter = "\t", fmt = '%.2f')