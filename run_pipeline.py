#!/usr/bin/env python3

import sys
import subprocess

# Vérifie les arguments
if len(sys.argv) != 4:
    print("❌ Utilisation : python run_pipeline.py <chemin_input> <ref_genome> <result_dir>")
    print("Exemple : python run_pipeline.py data_test/hbv Ref/sequence.fasta results/")
    sys.exit(1)

# Récupère les arguments
input_path = sys.argv[1]
ref_genome = sys.argv[2]
result_dir = sys.argv[3]

# Crée la commande Nextflow
cmd = [
    "nextflow", "run", "src/main.nf",
    "--input", input_path,
    "--ref_genome", ref_genome,
    "--result_dir", result_dir
]

# Affiche la commande (optionnel)
print("▶️  Exécution de :", " ".join(cmd))

# Exécute la commande
subprocess.run(cmd)
