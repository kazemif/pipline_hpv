#!/usr/bin/env python3

import argparse
import subprocess
import os
import sys

def main():
    parser = argparse.ArgumentParser(description="Exécute un fichier RMarkdown avec des arguments.")
    parser.add_argument('--rmd', required=True, help="Chemin vers le fichier .Rmd (ex: src/rapport_final.Rmd)")
    parser.add_argument('--base_dir', required=True, help="Chemin vers le dossier contenant les barcodes")
    parser.add_argument('--output_dir', default='results/reports', help="Dossier de sortie du fichier HTML")

    args = parser.parse_args()

    # On passe les chemins à R via des variables d’environnement
    os.environ['BASE_DIR_RMD'] = args.base_dir
    os.environ['OUTPUT_DIR_RMD'] = args.output_dir

    try:
        subprocess.run([
            "Rscript", "-e",
            f"rmarkdown::render('{args.rmd}', output_dir='{args.output_dir}')"
        ], check=True)
        print(" Rapport HTML généré avec succès.")
    except subprocess.CalledProcessError as e:
        print(" Une erreur est survenue lors de la génération du rapport RMarkdown.")
        sys.exit(1)

if __name__ == "__main__":
    main()


