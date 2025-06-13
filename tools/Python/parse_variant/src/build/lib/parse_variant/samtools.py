#!/usr/bin/env python

"""
Program: samtools.py

Date of creation: 09th of September 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Import modules================================================================
import os
import subprocess

#Define function===============================================================

#Function to convert a SAM file in BAM-----------------------------------------
def convert_sam(in_sam, nb_cpu):
    """
    This function allows to convert a sam file in bam file for mpileup phase

    PARAM:
    in_sam: path to sam file to parse
    nb_cpu: CPU number requested for the process

    RETURN:
    file_name: the name of created file
    """
    #Define bam output file name
    if in_sam.find("/") >= 0:
        file_name = "".join(in_sam.split("/")[-1])
    else:
        file_name = in_sam
    file_name = file_name.split(".sam")[0] + ".bam"

    #Run samtools view command
    process_output = subprocess.run(f"samtools view -b -@ {nb_cpu} {in_sam} > {file_name}",
                                    shell = True, 
                                    capture_output = True)

    return file_name

#Function to sort a BAM file---------------------------------------------------
def sort_bam(in_bam, nb_cpu):
    """
    This function allows to sort a given bam file

    PARAMETERS:
    in_bam: path to input bam file
    nb_cpu: number of requested CPU

    RETURN:
    file_name: the of created file
    """
    #Define bam output file name
    if in_bam.find("/") >= 0:
        file_name = "".join(in_bam.split("/")[-1])
    else:
        file_name = in_bam

    #Run samtools command
    process_output = subprocess.run(f"samtools sort -@ {nb_cpu} {in_bam} -o {file_name}",
                                    shell = True, capture_output = True)

    return file_name

#Function to index BAM file----------------------------------------------------
def index_bam(in_bam, nb_cpu):
    """
    This function allows to index a bam file.

    PARAMETERS:
    in_bam: path to input BAM file
    nb_cpu: number of requested CPU

    RETURN:
    file_name: name of created file
    """
    if in_bam.find("/") >= 0:
        file_name = "".join(in_bam.split("/")[-1])
    else:
        file_name = in_bam
    file_name = file_name + ".bai"

    #run samtools command
    if not os.path.exists(file_name):
        process_output = subprocess.run(f"samtools index -b -@ {nb_cpu} {in_bam} -o {file_name}",
                                        shell = True, capture_output = True)

    return file_name

#Function launch samtools mpileup----------------------------------------------
def pileup_reads(in_bam, in_ref):
    """
    This function allows to perform a reads pileup from SAM/BAM
    input via samtools package

    PARAMETERS:
    in_bam: path to input bam file
    in_ref: path to reference fasta file

    RETURN:
    file_name: the name of created file
    """
    #Define pileup output file name
    if in_bam.find("/") >= 0:
        file_name = "".join(in_bam.split("/")[-1])
    else:
        file_name = in_bam
    file_name = file_name.split(".bam")[0] + ".pileup"

    #Lauch samtools mpileup
    ##max detph is set to 0 to probe all reads
    process_output = subprocess.run(f"samtools mpileup -d 0 -f {in_ref} {in_bam} -o {file_name}",
                                    shell = True, capture_output = True)

    return file_name