#!/usr/bin/env python

"""
Program: chubk_process.py

Date of creation: 09th of August 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Import modules================================================================
import mmap
import sys
try:
    import pandas as pd
except ImportError as exception:
    sys.exit("ERROR: Pandas module is not installed")
try:
    import numpy as np
except ImportError as exception:
    sys.exit("ERROR: Numpy module is not installed")
try: 
    import parse_fastq.read_process
    import parse_fastq.quantile_estimator
except ImportError as exception:
    sys.exit("EROR: Fatal erorr ! Please reinstall the tool")

#Define class==================================================================

class chunk_attributs:
    """
    This class define some chunk attributs
    """

    #Function to initialize class
    def __init__(self):
        """
        This function allows to initalize class
        """
        self.read_length_df = pd.DataFrame(columns = ["read_length", "occurence"])
        self.seq_score_df = pd.DataFrame(columns = ['seq_score', 'occurence'])
        self.gc_content_df = pd.DataFrame(columns = ['GC_content', 'occurence'])
        
        #Array for P2 qauntile estimators algorithm
        self.markers_values = np.full((5, 100), np.nan)
        self.markers_count = np.full(100, 0)
        self.quantile_estimator_Q1 = [0] * 100
        self.quantile_estimator_Med = [0] * 100
        self.quantile_estimator_Q3 = [0] * 100
        self.markers_count.astype(int)
    
    #Function to complete read length data-frame
    def add_read_length(self, read_length):
        """
        This function allows to add read length record in the data-frame.
        """
        if read_length in list(self.read_length_df["read_length"]):
            index = list(self.read_length_df.index[self.read_length_df["read_length"] == read_length])
            index = int(index[0])
            self.read_length_df.loc[index, ["occurence"]] += 1
        else:
            to_add = [read_length, 1]
            self.read_length_df.loc[len(self.read_length_df)] =  to_add

    #Function to complete sequencing score data-frame
    def add_seq_score(self, seq_score):
        """
        This function allows to add sequencing quality score average
        """
        if seq_score in list(self.seq_score_df["seq_score"]):
            index = list(self.seq_score_df.index[self.seq_score_df["seq_score"] == seq_score])
            index = int(index[0])
            self.seq_score_df.loc[index, ["occurence"]] += 1
        else:
            to_add = [seq_score, 1]
            self.seq_score_df.loc[len(self.seq_score_df)] =  to_add
    
    #Function to complete GC content data-frame
    def add_GC_content(self, GC_content):
        """
        This function allows to add GC content 
        """
        if GC_content in list(self.gc_content_df["GC_content"]):
            index = list(self.gc_content_df.index[self.gc_content_df["GC_content"] == GC_content])
            index = int(index[0])
            self.gc_content_df.loc[index, ["occurence"]] += 1
        else:
            to_add = [GC_content, 1]
            self.gc_content_df.loc[len(self.gc_content_df)] =  to_add
    
    #Function to add per base seq scores
    def add_per_base_seq_score(self, seq_scores):
        """
        This function allows to add per read sequencing scores
        """
        #Reshape array if seq_scores > array size
        if len(seq_scores) > self.markers_values.shape[1]:
            diff_len = len(seq_scores) - self.markers_values.shape[1]
            self.markers_values = np.hstack((self.markers_values, np.full((5, diff_len), np.nan)))
            self.markers_count = np.hstack((self.markers_count, np.full(diff_len, 0)))
            self.quantile_estimator_Q1 = self.quantile_estimator_Q1 + [0] * diff_len
            self.quantile_estimator_Med = self.quantile_estimator_Med + [0] * diff_len
            self.quantile_estimator_Q3 = self.quantile_estimator_Q3 + [0] * diff_len
        
        #Add observed values if for each column count < 5
        index = np.where(self.markers_count < 5)
        sub_index = np.where(index[0] < len(seq_scores))
        index = index[0][sub_index]
        if index.shape[0] > 0:
            ##define line index and column index
            line_index = self.markers_count[index] - 1
            column_index = index
            #Replace values in markers array
            seq_scores = np.array(seq_scores)
            self.markers_values[line_index, column_index] = seq_scores[index]
            #Update count array
            self.markers_count[column_index] += 1
        
        #Fill quantile_estimator list
        index_1 = np.where(np.array(self.quantile_estimator_Med) == 0)[0]
        index_2 = np.where(self.markers_count == 5)[0]
        if index_1.shape[0] > 0 and index_2.shape[0] > 0:
            #Extract common indexes
            common_index = np.intersect1d(index_1, index_2)
            if common_index.shape[0] > 0:
                #Add quantile estimator object
                for index in common_index:
                    observed = self.markers_values[:,index]
                    self.quantile_estimator_Q1[index] = parse_fastq.quantile_estimator.P2QuantileEstimator(p = 0.25, x = observed)
                    self.quantile_estimator_Med[index] = parse_fastq.quantile_estimator.P2QuantileEstimator(p = 0.50, x = observed)
                    self.quantile_estimator_Q3[index] = parse_fastq.quantile_estimator.P2QuantileEstimator(p = 0.75, x = observed)
        else:
            common_index = None
        
        #Add new values
        if common_index is not None:
            sub_index = np.setdiff1d(index_2, common_index)
            for index in sub_index:
                if index < len(seq_scores):
                    self.quantile_estimator_Q1[index].add_value(seq_scores[index])
                    self.quantile_estimator_Med[index].add_value(seq_scores[index])
                    self.quantile_estimator_Q3[index].add_value(seq_scores[index])
    
    #Functiont to get quantile array
    def get_quantile_array(self):
        """
        This function allows to get quantile array after adding values
        """
        self.quantile_Q1 = []
        self.quantile_Med = []
        self.quantile_Q3 = []
        #add quantile values from quantile estimator object
        for i in range(len(self.quantile_estimator_Med)):
            #Q1 quantile
            to_add = 0 if self.quantile_estimator_Q1[i] == 0 else self.quantile_estimator_Q1[i].get_quantile()
            to_add = float(to_add)
            to_add = round(to_add, ndigits = 2)
            self.quantile_Q1.append(to_add)
            #Median
            to_add = 0 if self.quantile_estimator_Med[i] == 0 else self.quantile_estimator_Med[i].get_quantile()
            to_add = float(to_add)
            to_add = round(to_add, ndigits = 2)
            self.quantile_Med.append(to_add)
            #Q3 quantile
            to_add = 0 if self.quantile_estimator_Q3[i] == 0 else self.quantile_estimator_Q3[i].get_quantile()
            to_add = float(to_add)
            to_add = round(to_add, ndigits = 2)
            self.quantile_Q3.append(to_add)


#Define functions==============================================================

#Function to process a record
def process_record(mmap_object, chunk_start):
    """
    This function allows to process a FASTQ record

    PARAM:
    mmap_objet: an opened file with mmap
    chunk_start: chunk start position

    RETURN:
    read: a read entry with it attributs
    chunk_start: updated chunk start position
    """
    #Go to chunk start position
    mmap_object.seek(chunk_start)

    #A record contains 4 lines
    for index in range(4):
        line = mmap_object.readline().decode()
        #Update chunk start
        chunk_start += len(line)
        #Get sequence
        if index == 1:
            sequence = line.strip()
        #Get quality score
        if index == 3:
            qual = line.strip()
    
    #Extract reads parameters
    read = parse_fastq.read_process.read_attributs(sequence, qual)
    read.get_read_length()
    read.get_seq_score()
    read.get_GC_content()

    return read, chunk_start


#Function to process a chunk
def process_chunk(file_path, chunk_start, chunk_end):
    """
    This function allows to process a chunk

    PARAM:
    file_path: path to the file
    chunk_start: chunk start position
    chunk_end: chunk end position

    RETURN:
    chunk_result: a chunk attribut class object
    """

    #Initialize chunk attributs
    chunk_result = chunk_attributs()

    #Read the file
    with open(file_path, "r") as input_file:
        with mmap.mmap(input_file.fileno(), length = 0, access = mmap.ACCESS_READ) as mmap_input:
            while chunk_start < chunk_end:
                #Process a record
                read, chunk_start = process_record(mmap_object = mmap_input, chunk_start = chunk_start)

                #Add chunk attributs
                chunk_result.add_read_length(read.read_length)
                chunk_result.add_seq_score(read.seq_score)
                chunk_result.add_GC_content(read.gc_content)
                chunk_result.add_per_base_seq_score(read.seq_scores)
    
    #Extract quantile array from chunk reuslt
    chunk_result.get_quantile_array()
    
    return chunk_result
