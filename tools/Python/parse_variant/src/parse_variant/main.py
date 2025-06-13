#=============================================================================#
###                             parse_variant.py                            ###
#                                                                             #
#Date of creation: 09th of September 2024                                     #
#Author: FAUCHOIS Antoine, Bioinformatician engineer                          #
#Site: AP-HP, La Pitié-Salpêtrière, FRANCE                                    #
#Last release: First release                                                  #
#=============================================================================#

#This program allows to parse variant to catch depth

#Import modules================================================================
import logging
import os
import sys
import time
try:
    import parse_variant.init
    import parse_variant.parse_vcf
    import parse_variant.samtools
    import parse_variant.write
except ImportError as exception:
    sys.exit("ERROR: Fatal error ! Please resinstall the tool")


#Define functions==============================================================

#Define function to run main program-------------------------------------------
def main():
    """
    This function allows to run main program

    PARAM:
    None

    RETURN:
    None
    """
     #Configuration
    logging.basicConfig(level = logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt = '%Y-%m-%d %H:%M:%S')

    #Extract command line arguments
    args = parse_variant.init.extract_arguments()

    #Parse command line arguments
    parse_variant.init.parse_arguments(args)

    #Display system information
    parse_variant.init.get_system_info()

    #Record start time
    start_time = time.time()

    #Case when only SAM file is provided
    if args.sam is not None and args.bam is None:
        
        #Convert SAM to BAM
        logging.info("Converting SAM to BAM file")
        bam = parse_variant.samtools.convert_sam(args.sam, args.cpu)

        #Sort BAM file
        logging.info("Sorting BAM file")
        bam_sort = parse_variant.samtools.sort_bam(bam, args.cpu)
    
    #Other case
    else:
        if args.sam is not None and args.bam is not None:
            logging.warning("WARNING: Both SAM and BAM arguments are provided. Priority to BAM file")
        
        #Sort BAM file
        logging.info("Sorting BAM file")
        bam_sort = parse_variant.samtools.sort_bam(args.bam, args.cpu)

    #Index BAM file
    logging.info("Indexing BAM file")
    bam_index = parse_variant.samtools.index_bam(bam_sort, args.cpu)

    #Perform pileup
    logging.info("Building reads pileup")
    in_pileup = parse_variant.samtools.pileup_reads(bam_sort, args.ref)

    #Sort VCF file
    logging.info("Sorting VCF file")
    
    if os.path.exists("_tempo_.vcf"):
        os.remove("_tempo_.vcf")
    parse_variant.parse_vcf.sort_vcf(args.vcf, "_tempo_.vcf")

    #Build pileup array
    logging.info("Building pileup array")
    pileup_array = parse_variant.parse_vcf.filter_vcf(vcf_path = "_tempo_.vcf",
                                                      pileup_path = in_pileup,
                                                      variant_threshold = args.threshold,
                                                      depth_threshold = args.min_depth)
    
    #Write filtered VCF file and pileup array
    logging.info("Writting results")
    parse_variant.write.write_vcf("_tempo_.vcf", args.out_vcf, pileup_array)
    parse_variant.write.write_pileup_array(args.out_pileup, pileup_array)

    #Remove intermediate files
    os.remove("_tempo_.vcf")
    os.remove(in_pileup)
    if args.bam is None:
        os.remove(bam_sort)
        os.remove(bam_index)
    else:
        os.remove(bam_index)
    
    #Record start time
    end_time = time.time()

    hour, min, sec, centisec = parse_variant.init.compute_running_time(start_time, end_time)
    logging.info(f"Running time: {hour}h:{min}m:{sec}s::{centisec}")

#Main program==================================================================
if __name__ == "__main__":
   main()