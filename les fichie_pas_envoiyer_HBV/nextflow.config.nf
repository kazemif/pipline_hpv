params {
  params.result_dir = params.result_dir ?: "./results"
  adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
  ref_genome = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"  // Reference genomique
  min_len = 150
  max_len = 1200
  min_qual = 10
  cpu = 4
}

