#!/bin/bash -ue
mkdir -p ../results/reports
python3 generate_report.py
mv ../results/reports/rapport_final.html .
