process GENERATE_REPORT {
    tag "Rapport HTML"

    input:
    path result_dir
    path report_script

    output:
    path "${result_dir}/rapport_HBV.html"

    script:
    """
    python3 ${report_script}
    """
}


