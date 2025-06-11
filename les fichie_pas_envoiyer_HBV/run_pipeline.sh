#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "❌ Utilisation : $0 <chemin_input> <ref_genome> <result_dir>"
  echo "Exemple : ./run_pipeline.sh data_test/hbv Ref/sequence.fasta results/"
  exit 1
fi

INPUT=$1
REF=$2
OUT=$3

nextflow run src/main.nf \
  --input "$INPUT" \
  --ref_genome "$REF" \
  --result_dir "$OUT"

