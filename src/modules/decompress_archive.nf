

process decompress_archive {
    input:
    path archive_file

    output:
    path "decompressed"

    script:
    """
    mkdir -p decompressed
    case "${archive_file}" in
        *.tar.gz) tar -xzf ${archive_file} -C decompressed ;;
        *.zip)    unzip -q ${archive_file} -d decompressed ;;
        *.gz)     gunzip -c ${archive_file} > decompressed/\$(basename ${archive_file} .gz) ;;
        *) echo "❌ Format non supporté : ${archive_file}" ; exit 1 ;;
    esac
    """
}


