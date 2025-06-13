#!/usr/bin/env python

"""
Program: chunk_process.py

Date of creation: 14th of August 2024 
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
    sys.exit("ERROR: pandas module is not installed")
try:
    import parse_read_align.read_process
except ImportError as exception:
    sys.exit("ERROR: Fatal error ! Please reinstall the tool")

#Define class==================================================================

class chunk_attributs:
    """
    This class define some chunk attributs
    """

    #Function to initialize class
    def __init__(self):
        """
        This function
        """
        #Initialize data-frame
        self.read_length_df = pd.DataFrame(columns = ["read_length", "mapped", "occurence"])
        self.seq_score_df = pd.DataFrame(columns = ["seq_score", "mapped", "occurence"])
        self.map_score_df = pd.DataFrame(columns = ["map_score", "mapped", "occurence"])
        self.gc_content_df = pd.DataFrame(columns = ["GC_content", "mapped", "occurence"])

        #Initialize counter
        self.read_count = 0
        self.mapped_read_count = 0
    
    #Function to complete read length data-frame
    def add_read_length(self, read_length, mapped):
        """
        This function allows to add read length record in the data-frame

        PARAM:
        read_length: read length
        mapped: a logical indicating whether the read is mapped
        """
        #Convert mapped value
        mapped = 1 if mapped else 0

        #Extract line index
        index = self.read_length_df[(self.read_length_df["read_length"] == read_length) &
                                     (self.read_length_df["mapped"] == mapped)].index
        
        #Add record to read length df
        if len(index) > 0:
            index = int(index[0])
            self.read_length_df.loc[index, ["occurence"]] += 1
        else:
            to_add = [read_length, mapped, 1]
            self.read_length_df.loc[len(self.read_length_df)] =  to_add
    
    #Function to complete map-score data-frame
    def add_map_score(self, map_score, mapped):
        """
        This function allows to add read length record in the data-frame

        PARAM:
        map_score: mapping score
        mapped: a logical indicating whether the read is mapped
        """
        #Convert mapped value
        mapped = 1 if mapped else 0

        #Extract line index
        index = self.map_score_df[(self.map_score_df["map_score"] == map_score) &
                                     (self.map_score_df["mapped"] == mapped)].index
        
        #Add record to read length df
        if len(index) > 0:
            index = int(index[0])
            self.map_score_df.loc[index, ["occurence"]] += 1
        else:
            to_add = [map_score, mapped, 1]
            self.map_score_df.loc[len(self.map_score_df)] =  to_add
    
    #Function to complete sequencing score data-frame
    def add_seq_score(self, seq_score, mapped):
        """
        This function allows to add read length record in the data-frame

        PARAM:
        seq_score: mapping score
        mapped: a logical indicating whether the read is mapped
        """
        #Convert mapped value
        mapped = 1 if mapped else 0

        #Extract line index
        index = self.seq_score_df[(self.seq_score_df["seq_score"] == seq_score) &
                                     (self.seq_score_df["mapped"] == mapped)].index
        
        #Add record to read length df
        if len(index) > 0:
            index = int(index[0])
            self.seq_score_df.loc[index, ["occurence"]] += 1
        else:
            to_add = [seq_score, mapped, 1]
            self.seq_score_df.loc[len(self.seq_score_df)] =  to_add

    #Function to complete GC content data-frame
    def add_gc_content(self, gc_content, mapped):
        """
        This function allows to add read length record in the data-frame

        PARAM:
        gc_content: mapping score
        mapped: a logical indicating whether the read is mapped
        """
        #Convert mapped value
        mapped = 1 if mapped else 0

        #Extract line index
        index = self.gc_content_df[(self.gc_content_df["GC_content"] == gc_content) &
                                     (self.gc_content_df["mapped"] == mapped)].index
        
        #Add record to read length df
        if len(index) > 0:
            index = int(index[0])
            self.gc_content_df.loc[index, ["occurence"]] += 1
        else:
            to_add = [gc_content, mapped, 1]
            self.gc_content_df.loc[len(self.gc_content_df)] =  to_add

    #Function to update counter
    def update_count(self, mapped):
        """
        This function allows to update counter

        PARAM:
        mapped: a logical indicating whether the read is mapped
        """
        if mapped:
            self.mapped_read_count += 1
        self.read_count += 1

#Define fucntions==============================================================

#Functio to process a record---------------------------------------------------
def process_record(mmap_object, chunk_start):
    """
    This file allows to process a SAM record

    PARAM:
    mmap_object: an open mmap object
    chunk_start: chunk start position
    """
    #Go to chunk start position
    mmap_object.seek(chunk_start)

    #Extract line
    sam_line = mmap_object.readline().decode()
    
    #Update chunk start
    chunk_start += len(sam_line)

    if not sam_line.startswith("@"):
        #Extract record parameters
        sam_line = sam_line.strip()

        sam_record = parse_read_align.read_process.read_attributs(sam_line)
        sam_record.detect_map()
        sam_record.get_read_length()
        sam_record.get_GC_content()
        sam_record.get_seq_score()
    else:
        sam_record = None

    return sam_record, chunk_start

#Fucntion to process a chunk---------------------------------------------------
def process_chunk(file_path, chunk_start, chunk_end):
    """
    This function allows to process chunk

    PARAM:
    file_path: path to the SAM file
    chunk_start: chunk start position
    chunk_end: chunk end position

    RETURN:
    chunk_result: a chunk attribut class object
    """
    #Initialiaze chunk attributs
    chunk_result = chunk_attributs()

    #Read the file
    with open(file_path, "r") as input_file:
        with mmap.mmap(input_file.fileno(), length = 0, access = mmap.ACCESS_READ) as mmap_input:
            while chunk_start < chunk_end:
                #Process a record
                sam_record, chunk_start = process_record(mmap_input, chunk_start)

                #Add chunk attributs
                if sam_record is not None:
                    chunk_result.add_read_length(sam_record.read_length, sam_record.mapped)
                    chunk_result.add_map_score(sam_record.map_qual, sam_record.mapped)
                    chunk_result.add_seq_score(sam_record.seq_score, sam_record.mapped)
                    chunk_result.add_gc_content(sam_record.gc_content, sam_record.mapped)
                    chunk_result.update_count(sam_record.mapped)
    
    return chunk_result