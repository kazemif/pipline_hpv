#!/usr/bin/env python

"""
Program: parallel_read.py

Date of creation: 14th of August 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Import modules================================================================
import re

#Define class==================================================================
class read_attributs:
    """
    This class define some read attributs
    """
    #Initialization function
    def __init__(self, sam_line):
        """
        This function allows to initiliaze class

        PARAM:
        sam_line: a stripped sam line
        """
        line_split = sam_line.split("\t")
        self.flag = line_split[1]
        self.map_pos = line_split[3]
        self.map_qual = line_split[4]
        self.read_seq = line_split[9]
        self.read_qual = line_split[10]
    
    #Function to detect if a read is mapped on the reference
    def detect_map(self):
        """
        This function allows to detect if a read is mapped on the reference
        """
        #Convert sam flag into 2 base number
        bin_num = bin(int(self.flag))[2:].rjust(16, "0")[::-1]

        #Detect if 2² is equal to 1
        self.mapped = bin_num[2] != "1"
    
    #Function to get read length
    def get_read_length(self):
        """
        This function allows to get read length
        """
        self.read_length = len(self.read_seq)
    
    #Function to get mean of sequencing score
    def get_seq_score(self):
        """
        This function allows to get mean of sequencing socre
        """
        cum_score = 0
        for qual in self.read_qual:
            #Turn ASCII char to int
            phred_qual = ord(qual)
            cum_score += phred_qual
        mean_qual_score = round(cum_score / len(self.read_seq), ndigits = 2)
        self.seq_score = mean_qual_score
    
    #Function to get GC content
    def get_GC_content(self):
        """
        This fucntion allows to get GC content
        """
        regex = re.compile("[GCgc]")
        gc_count = len(regex.findall(self.read_seq))
        gc_content = round(gc_count / len(self.read_seq) * 100, ndigits = 2)
        self.gc_content = gc_content