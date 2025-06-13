#!/usr/bin/env python

"""
Program: write.py

Date of creation: 09th of September 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Define functions==============================================================

#Function to write the filtered VCF file---------------------------------------
def write_vcf(in_vcf, 
              out_vcf, 
              pileup_array):
    """
    This function allows to write a filtered VCF according to
    pileup array

    PARAMETERS:
    in_vcf: input VCF file
    out_vcf: output VCF file
    pileup_array: the pileup array

    RETURN:
    None
    """
    #Case when pileup array is not empty
    if pileup_array.shape[0] != 0:    
        #Extract the first column from pileup_array = position list
        positions = [row[0] for row in pileup_array]
    
        #Loop over files
        with open(in_vcf, "r") as vcf_input, open(out_vcf, "w") as vcf_output:
            for line in vcf_input:
                if line.startswith("#"):
                    vcf_output.write(line)
                else:
                    #extract position
                    position = line.split("\t")[1]
                    if position in positions:
                        vcf_output.write(line)
    else:
        #In this case, only write the header
        with open(in_vcf, "r") as vcf_input, open(out_vcf, "w") as vcf_output:
            for line in vcf_input:
                if line.startswith("#"):
                    vcf_output.write(line)

#Function to write pileup array------------------------------------------------
def write_pileup_array(out_pileup_path, pileup_array):
    """
    This function allows to write a pileup array

    PARAMATERS:
    pileup_array: the pileup array to write
    out_pileup_path: path to ouput pileup array file

    RETURN:
    None
    """
    with open(out_pileup_path, "w") as out_pileup:
        
        #Create header
        out_pileup.write("Pos\tRef\tAlt\tDepth\tIns\tIns_Depth\tDel\tDel_Depth\t\
                         A_Fwd\tA_Rev\tA_Depth\t\
                         T_Fwd\tT_Rev\tT_Depth\t\
                         G_Fwd\tG_Rev\tG_Depth\t\
                         C_Fwd\tC_Rev\tC_Depth\t\
                         Match_Fwd\tMat_Rev\tMat_Depth\t\
                         N\tN_Depth\n")
        
        if len(pileup_array.shape) == 1:
            out_pileup.write("\t".join(list(pileup_array)) + "\n")
        else:
            for row in pileup_array:
                out_pileup.write("\t".join(row) + "\n")