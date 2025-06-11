import os
# se placer dans le dossier du script (la racine de hbv_pipeline)
os.chdir(os.path.dirname(os.path.abspath(__file__)))

import subprocess
subprocess.run([
    "Rscript", "-e",
    "rmarkdown::render('rapport_final.Rmd', output_dir = 'results/reports')"
], check=True)

sys.exit(res.returncode)








