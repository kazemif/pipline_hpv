#!/bin/bash -ue
mkdir -p data_extracted
if [[ "download_2025-03-31_10-45-55.zip" == *.tar.gz || "download_2025-03-31_10-45-55.zip" == *.tgz ]]; then
    tar -xzf download_2025-03-31_10-45-55.zip -C data_extracted || true
elif [[ "download_2025-03-31_10-45-55.zip" == *.tar ]]; then
    tar -xf download_2025-03-31_10-45-55.zip -C data_extracted || true
elif [[ "download_2025-03-31_10-45-55.zip" == *.zip ]]; then
    unzip -q download_2025-03-31_10-45-55.zip -d data_extracted || true
elif [[ "download_2025-03-31_10-45-55.zip" == *.gz ]]; then
    gunzip -c download_2025-03-31_10-45-55.zip > data_extracted/$(basename download_2025-03-31_10-45-55.zip .gz) || true
fi
