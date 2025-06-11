#!/usr/bin/env python3

import argparse
import subprocess
import os
import sys

#  Vérifie que les fichiers de sortie existent pour chaque barcode
def check_pipeline_outputs(result_dir, barcodes):
    for bc in barcodes:
        path = os.path.join(result_dir, bc, "qc_fastq", f"output_{bc}", f"{bc}_GC_content.txt")
        if not os.path.exists(path):
            print(f" Fichier manquant : {path}")
            return False
    return True

#  Point d'entrée principal
def main():
    parser = argparse.ArgumentParser(description="Lancer le pipeline Nextflow et générer un rapport HTML.")
    parser.add_argument('--input', required=True, help="Chemin vers les données d'entrée (ex: data_test/hbv)")
    parser.add_argument('--result_dir', default='results', help="Dossier où seront stockés les résultats du pipeline")
    parser.add_argument('--rmd', default='src/rapport_final.Rmd', help="Chemin vers le fichier RMarkdown")
    parser.add_argument('--output_dir', default='results/reports', help="Dossier de sortie du rapport HTML")

    args = parser.parse_args()

    #  Conversion des chemins en chemins absolus pour éviter les erreurs
    input_path   = os.path.abspath(args.input)
    result_dir   = os.path.abspath(args.result_dir)
    rmd_path     = os.path.abspath(args.rmd)
    output_dir   = os.path.abspath(args.output_dir)

    #  Déterminer le chemin absolu de main.nf (dans src/)
    main_nf_path = os.path.join(os.path.dirname(__file__), "main.nf")

    # 1️ Exécution du pipeline Nextflow
    print(" Lancement du pipeline Nextflow...")
    try:
        subprocess.run([
            "nextflow", "run", main_nf_path,
            "--input", input_path,
            "--result_dir", result_dir
        ], check=True)
        print(" Pipeline terminé avec succès.\n")
    except subprocess.CalledProcessError:
        print(" Erreur lors de l'exécution du pipeline.")
        sys.exit(1)

    # 2️ Vérification des fichiers produits
    barcodes = [f"barcode{str(i).zfill(2)}" for i in range(1, 17)]
    if not check_pipeline_outputs(result_dir, barcodes):
        print(" Le rapport HTML ne sera pas généré : certains fichiers sont manquants.")
        sys.exit(1)

    # 3️ Définir les variables d'environnement pour RMarkdown
    os.environ['BASE_DIR_RMD'] = result_dir
    os.environ['OUTPUT_DIR_RMD'] = output_dir

    # 4️ Génération du rapport HTML via RMarkdown
    print(" Génération du rapport HTML...")
    try:
        subprocess.run([
            "Rscript", "-e",
            f"rmarkdown::render('{rmd_path}', output_dir='{output_dir}')"
        ], check=True)
        print(" Rapport HTML généré avec succès dans :", output_dir)
    except subprocess.CalledProcessError:
        print(" Une erreur est survenue lors de la génération du rapport HTML.")
        sys.exit(1)

if __name__ == "__main__":
    main()

