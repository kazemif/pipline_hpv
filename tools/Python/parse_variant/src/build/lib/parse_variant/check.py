#!/usr/bin/env python

"""
Program: check.py

Date of creation: 09th of September 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Import modules================================================================
import logging
import re

#Define function===============================================================

#Function to check CNV---------------------------------------------------------
def check_CNV(cnv, depth, pileup_line, min_depth, depth_threshold):
    """
    This function allows to check a given CNV

    PARAMETERS:
    cnv: the CNV to parse
    depth: the reported total depth at this position
    pileup_line: the pileup line at this position
    min_depth: minimum total depth cutoff
    depth_threshold: relative depth part of the CNV (%)

    RETURN:
    a boolean indicating if the variant pass the control
    """
    #Check global depth
    if depth < min_depth:
        return False
    else:
        #Create regex with CNV
        cnv_regex = re.compile(r"([\.,NATGCatgc\*#]{1}" + cnv + ")")
        #Compute CNV depth
        depth_CNV = len(cnv_regex.findall(pileup_line)) / depth
        if depth_CNV < depth_threshold:
            return False
        else:
            return True

#Function to check SNP---------------------------------------------------------
def check_SNP(depth, snp_depth, min_depth, depth_threshold):
    """
    This function allows to check a given SNP

    PARAMETERS:
    depth: the reported total depth at this position
    snp_depth: the snp depth
    min_depth: minimum total depth cutoff
    depth_threshold: relative depth part of the CNV (%)

    RETURN:
    a boolean indicating if the variant pass the control
    """
    #Check global depth
    if depth < min_depth:
        return False
    else:
        #Compute SNP depth
        if snp_depth < depth_threshold:
            return False
        else:
            return True

#Function to define a deletion-------------------------------------------------
def define_deletion(ref, alt):
    """
    This function allows to define a deletion from reported alt and ref

    PARAMETERS:
    ref: reference nucleic information
    alt: alternative nucleic information

    RETURN:
    target_deletion: a the corresponding deletion
    """
    len_alt = len(alt)
    deletion = ref[len_alt:]
    target_deletion = "-" + str(len(deletion)) + "(" + str(deletion).upper() + "|" + str(deletion).lower() + ")"
    
    return target_deletion

#Function to define an insertion-----------------------------------------------
def define_insertion(alt):
    """
    This function allows to define a deletion from reported alt and ref

    PARAMETERS:
    alt: alternative nucleic information

    RETURN:
    target_insertion: a the corresponding insertion
    """
    len_alt = len(alt)
    target_insertion = "+" + str(len_alt) + "(" + str(alt).upper() + "|" + str(alt).lower() + ")"
    return target_insertion

#Function to check a variant---------------------------------------------------
def check_variant(ref, alt, pos, min_depth, depth_threshold, pileup):
    """
    This function allows to check a variant

    PARAM:
    ref: reference nucleic information
    alt: alternative nucleic information
    pos: mutation position
    min_depth: minimum desired depth
    depth_threshold: variant depth threshold
    pileup: a pileup record object

    RETURN:
    variant_pass: a logical indicating if variant pass depth test
    """
    if len(alt) < len(ref):
        #Deletion case (CNV)
        logging.info(f"Parsing CNV at position {pos}")
        deletion = define_deletion(ref, alt)
        
        #Check variant
        variant_pass = check_CNV(deletion, pileup.depth, pileup.raw_pileup_line, min_depth, depth_threshold)
    
    elif len(alt) > len(ref):
        #Insertion case (CNV)
        logging.info(f"Parsing CNV at position {pos}")
        insertion = define_insertion(alt)
        
        #Check variant
        variant_pass = check_CNV(insertion, pileup.depth, pileup.raw_pileup_line, min_depth, depth_threshold)
    
    else:
        #Case for SNP
        if len(str(ref)) > 1 and len(str(alt)) > 1:
            logging.info(f"Parsing multiple SNP at position {pos}")
            
            #Check when there is a multiple SNP
            variant_pass_list = []

            #Parse each single SNP
            for sub_alt in str(alt):
                SNP_depth = getattr(pileup, str(sub_alt) + "_Depth")
                result = check_SNP(pileup.depth, SNP_depth , min_depth, depth_threshold)
                variant_pass_list.append(result)
                
            #Analyse all flags
            variant_pass = True if all(variant_pass_list) == True else False
        else:
            #Single SNP
            logging.info(f"Parsing SNP at position {pos}")
            SNP_depth = getattr(pileup, str(alt) + "_Depth")
            variant_pass = check_SNP(pileup.depth, SNP_depth , min_depth, depth_threshold)

    return variant_pass