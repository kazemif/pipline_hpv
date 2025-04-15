params {
  params.result_dir = params.result_dir ?: "./results"
  adapter = "./primer/HBV_primer.fasta"
  ref_genome = "./Ref/sequence.fasta"
  min_len = 150
  max_len = 1200
  min_qual = 10
  cpu = 4
}

