#!/usr/bin/env python

"""
Program: parse_vcf.py

Date of creation: 09th of September 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Import modules================================================================
import logging
import subprocess
import sys

try:
    import vcf
except ImportError as exception:
    sys.exit("ERROR: VCF module is not installed")
try:
    import numpy as np
except ImportError as exception:
    sys.exit("ERROR: Numpy module is not installed")

try:
    import parse_variant.check
    import parse_variant.pileup
except ImportError as exception:
    sys.exit("ERROR: Fatal error ! Please resinstall the tool")

#Define functions==============================================================

#Function to sort a VCF file---------------------------------------------------
def sort_vcf(in_vcf, out_vcf):
    """
    This function allows to sort a VCF file using shell command line

    PARAM:
    in_vcf: input VCF file name
    out_vcf: output VCF file name

    RETURN:
    None
    """
    out_process = subprocess.run(f"touch {out_vcf}", 
                                 shell = True, capture_output = True)
    
    out_process = subprocess.run(f'cat {in_vcf} | egrep "^#" >> {out_vcf}', 
                                 shell = True, capture_output = True)
    
    out_process = subprocess.run(f'sort -k1,1V -k2,2n {in_vcf} | \
                                 egrep -v "^#" >> {out_vcf}',
                                 shell = True, capture_output = True)

#Function to filter VCF file---------------------------------------------------
def filter_vcf(vcf_path,
               pileup_path,
               variant_threshold,
               depth_threshold):
    """
    This is the core function of this program.

    PARAMETERS:
    vcf_path: a path to a VCF file
    pileup_path: a path to a pileup file
    variant_threshold: variant depth threshold
    depth_threshold: Minimum desired depth

    RETURN:
    pileup_array: a completed pileup array with variant information
    """
    with open(vcf_path, "r") as in_vcf, open(pileup_path, "r") as in_pileup:
        #Use a VCF reader
        vcf_reader = vcf.Reader(in_vcf)

        #Browse found variant
        for record in vcf_reader:
            pos = record.POS
            ref = record.REF
            alts = record.ALT
            filter = record.FILTER
            
            if filter is None or len(filter) == 0:
                #PASS filter or filter status is Unknow
                for alt in alts:
                    #Extract pileup line
                    pileup_line = parse_variant.pileup.browse_pileup(in_pileup, pos)
                    
                    #Create a pileup record object and compute parameters
                    pileup_record = parse_variant.pileup.pileup_record(pileup_line, ref, alt)
                    pileup_record.clean_alignement_flag()
                    pileup_record.parse_insertions()
                    pileup_record.parse_deletions()
                    pileup_record.parse_SNP()
                    pileup_record.parse_match()
                    pileup_record.parse_null_base()

                    #Check variant
                    variant_pass = parse_variant.check.check_variant(ref, alt, pos, 
                                                       depth_threshold, 
                                                       variant_threshold, 
                                                       pileup_record)
                    
                    #Complete pileup array
                    if variant_pass:
                        to_add = pileup_record.get_writable_record()
                        if not "pileup_array" in locals():
                            pileup_array = np.array(to_add)
                        else:
                            pileup_array = np.vstack((pileup_array, to_add))
                    else:
                        logging.info(f"Skip position {pos} due to unpassed quality test")
            else:
                logging.info(f"Skip position {pos} due to unpassed quality test")
    
    #Create an empty pileup array after the loop if none variant had been retained
    if not 'pileup_array' in locals():
        pileup_array = np.array([])
        logging.warning("WARNING: None variant had been retained during the filtration process.")
    
    return pileup_array