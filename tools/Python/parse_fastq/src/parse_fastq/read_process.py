#!/usr/bin/env python

"""
Program: read_process.py

Date of creation: 09th of August 2024 
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
    
    #Initialization
    def __init__(self, sequence, quality):
        """
        This function allows to initialize a read_process class
        sequence: a string of the read sequence
        quality: a string of corresponding Phred score quality 
        """
        self.seq = sequence
        self.qual = quality
    
    #Function to get read length
    def get_read_length(self):
        """
        This function allows to return read length
        """
        self.read_length = len(self.seq)

    #Function to get mean of sequencing score
    def get_seq_score(self):
        """
        This function allows to get mean of sequencing score and
        get per base sequencing score
        """
        self.seq_scores = []
        cum_score = 0
        for qual in self.qual:
            #Turn ASCII character to int
            phred_qual = ord(qual)
            cum_score += phred_qual
            self.seq_scores.append(phred_qual)
        mean_qual_score = round(cum_score / len(self.seq), ndigits = 2)
        self.seq_score = mean_qual_score

    #Function to get GC content
    def get_GC_content(self):
        """
        This function allows to get mean of GC score
        """
        regex = re.compile("[GCgc]")
        gc_count = len(regex.findall(self.seq))
        gc_content = round(gc_count / len(self.seq) * 100, ndigits = 2)
        self.gc_content = gc_content

