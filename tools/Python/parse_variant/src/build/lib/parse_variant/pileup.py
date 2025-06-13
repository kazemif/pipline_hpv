#!/usr/bin/env python

"""
Program: pileup.py

Date of creation: 09th of September 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Import mdoules================================================================
import re

#Define class==================================================================
class pileup_record:
    """
    This class allows to define a pileup line object and extract needed
    information
    """
    #Initialization
    def __init__(self, pileup_line, ref = None, alt = None):
        """
        This function allows to initialize a pileup_record class

        PARAM:
        pileup_line : a pileup line to analyze
        ref: reference nucleic information found
        alt: alternative nucleic information found

        RETURN:
        None
        """
        #Add raw pileup line
        self.raw_pileup_line = pileup_line

        pileup_line = pileup_line.split("\t")

        #Add sequence position, refence base and depth
        self.pos = int(pileup_line[1])
        self.base_ref = ref
        self.base_alt = alt
        self.depth = int(pileup_line[3])
        self.pileup = pileup_line[4]
    
    #Function to clean flag
    def clean_alignement_flag(self):
        """
        This function allows to clean flags from align pileup part

        PARAM:
        None

        RETURN:
        None
        """
        #Define regex
        start_read = re.compile(r"\^[ -~]{1}")
        end_read = re.compile(r"\$")

        for regex in [start_read, end_read]:
            if regex.search(self.pileup):
                self.pileup = "".join(regex.split(self.pileup))
    
    #Function to parse insertion
    def parse_insertions(self):
        """
        This function allows to parse insertions

        PARAM:
        None

        RETURN:
        None
        """
        #Extract the different type of detected insertion
        insertion_init = re.compile(r"\+[0-9]{1,2}")
        insert_list = insertion_init.findall(self.pileup)
        insert_list = list(set(insert_list))
        
        #Define insertion count variable
        self.insert_count = 0
        
        #Loop for each type of insertion
        if len(insert_list) > 0:
            for insert in insert_list:
                #Create specific regex
                insertion_regex = "[\\.,NATGCatgc\\*#]{1}\\" + insert + "[NATGCatgc\\*]{" + insert[1] + "}"
                #Catch insertions
                insertion_regex = re.compile(insertion_regex)
                insertions = insertion_regex.findall(self.pileup)
                #Add to counter the insertions
                self.insert_count += len(insertions)
                #Deduplicate list
                insertions = list(set(insertions))
                #clean pielup with found insertions
                for insertion in insertions:
                    self.pileup = "".join(self.pileup.split(insertion))
        #Compute insertion depth
        self.insert_depth = round(self.insert_count / self.depth, ndigits = 3) if self.depth != 0 else 0
    
    #Function to parse deletion
    def parse_deletions(self):
        """
        This function allows to parse deletion from a pileup line
        
        PARAM:
        None

        RETURN:
        None
        """
        #Define a deletion counter
        self.delet_count = 0
        
        #Parse individual deletion
        for delet in ["\\*/#", "\\*"]: 
            deletion_regex = re.compile(delet)
            deletions = deletion_regex.findall(self.pileup)
            self.delet_count += len(deletions)
            #Clean pileup
            if len(deletions) > 0:
                self.pileup = "".join(self.pileup.split(deletions[0]))
    
        #Parse multiple deletions
        deletion_init = re.compile("-[0-9]{1,2}")
        delet_list = deletion_init.findall(self.pileup)
        delet_list = list(set(delet_list))
        #Make loop for each type of insertion
        if len(delet_list) > 0:
            for delet in delet_list:
                #Create specific regex
                deletion_regex = "[\\.,NATGCatgc\\*#]{1}" + delet + "[NATGCatgc\\*]{" + delet[1] + "}"
                
                #Catch deletions
                deletion_regex = re.compile(deletion_regex)
                deletions = deletion_regex.findall(self.pileup)
                #Add to counter the deletion
                self.delet_count += len(deletions)
                #Deduplicate list
                deletions = list(set(deletions))
                #clean pielup with found deletion
                for deletion in deletions:
                    self.pileup = "".join(self.pileup.split(deletion))
        #Compute deletion depth
        self.delet_depth = round(self.delet_count / self.depth, ndigits = 3) if self.depth != 0 else 0
    
    #Function to parse SNP
    def parse_SNP(self):
        """
        THis function allows to parse SNP

        PARAM:
        None

        RETURN:
        None
        """
        for base in ["A", "T", "G", "C"]:
            #Count in Forward and reverse
            forward_count = self.pileup.count(base)
            reverse_count = self.pileup.count(base.lower())
            base_depth = round((forward_count + reverse_count) / self.depth, ndigits = 3) if self.depth != 0 else 0

            #Add attribut
            setattr(self, base + "_Fwd", forward_count)
            setattr(self, base + "_Rev", reverse_count)
            setattr(self, base + "_Depth", base_depth)

    
    #Function to parse match
    def parse_match(self):
        """
        This function allows to parse match

        PARAM:
        None

        RETURN:
        None
        """
        forward_match_count = self.pileup.count(".")
        reverse_match_count = self.pileup.count(",")
        match_depth = round((forward_match_count + reverse_match_count) / self.depth, ndigits = 3) if self.depth != 0 else 0

        #Add attribut
        setattr(self, "Match_Fwd", forward_match_count)
        setattr(self, "Match_Rev", reverse_match_count)
        setattr(self, "Match_Depth", match_depth)
    
    #Function to parse Null base
    def parse_null_base(self):
        """
        This function allows to parse Null base

        PARAM:
        None

        RETURN:
        None
        """
        null_base_count = self.pileup.count("<") + self.pileup.count(">")
        null_base_depth = round(null_base_count / self.depth, ndigits = 3) if self.depth != 0 else 0

        setattr(self, "Null", null_base_count)
        setattr(self, "Null_Depth", null_base_depth)
    
    #Function to create writable record
    def get_writable_record(self):
        """
        This function allows to get a writtable record

        PARAM:
        None

        RETURN:
        result: a list of writtable pileup attribut
        """
        #Create a list of attributs
        tempo = [self.pos, self.base_ref, self.base_alt, self.depth, 
                  self.insert_count, self.insert_depth,
                  self.delet_count, self.delet_depth,
                  self.A_Fwd, self.A_Rev, self.A_Depth,
                  self.T_Fwd, self.T_Rev, self.T_Depth,
                  self.G_Fwd, self.G_Rev, self.G_Depth,
                  self.C_Fwd, self.C_Rev, self.C_Depth,
                  self.Match_Fwd, self.Match_Rev, self.Match_Depth,
                  self.Null, self.Null_Depth]
        
        result = [str(element) for element in tempo]

        return result

#Define function===============================================================

#Function to get the previous pileup line--------------------------------------
def read_previous_line(in_pileup):
    """
    This function allows to redefine the text pointer position
    to the previous line

    PARAMETERS:
    in_pileup: a TextIOWrapper object corresponding to the pileup file

    RETURN:
    None
    """
    #Define line return count
    count_line_return = 0
    #Define start pointer position
    start_position = in_pileup.tell()

    #Browse position one by one to seek the previous line
    i = 0
    while count_line_return < 2:
        if start_position - i == 0:
            in_pileup.seek(0)
            break
        else:
            in_pileup.seek(start_position - i)
            value = in_pileup.read(1)
            if value == "\n":
                count_line_return += 1
            i += 1

#Function to browse pileup line------------------------------------------------
def browse_pileup(in_pileup, position):
    """
    This function allows to browse a pileup file to extract
    the line whose contains the desired position.

    PARAMETERS:
    in_pileup: a TextIOWrapper object corresponding to the pileup file
    position: a integer giving the desired position

    RETURN:
    line: the pileup whise fit with the desired position
    """
    #Looking for the previous position
    read_previous_line(in_pileup)

    #extract the position of the current line
    line = in_pileup.readline()
    #extract position
    pos_pileup = int(line.split("\t")[1])
    while pos_pileup != position:
        line = in_pileup.readline()
        if len(line) != 0:
            pos_pileup = int(line.split("\t")[1])
            if pos_pileup > position:
                return None
        else:
            return None
    return line