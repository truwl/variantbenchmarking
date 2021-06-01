version 1.0

task vcfComparison_by_Happy_CodingExons {
  input {
    File queryVCF
    String outputFile_commonPrefix
    File truthCodingExonsVCF
    File truthCodingExonsBED
    File referenceFasta
    File referenceFasta_indexed  ## *.fai
    String codingExonsPrefix
    String consoleOutputPartialFilename
  }
  output {
    File codingExons_annotated_vcf_gz = "~{outputFile_commonPrefix}~{codingExonsPrefix}.vcf.gz" ##Need this later if doing indel size distribution
    File codingExons_annotated_vcf_gz_tbi = "~{outputFile_commonPrefix}~{codingExonsPrefix}.vcf.gz.tbi"
    File codingExons_counts_csv = "~{outputFile_commonPrefix}~{codingExonsPrefix}.counts.csv"
    File codingExons_counts_json = "~{outputFile_commonPrefix}~{codingExonsPrefix}.counts.json"
    File codingExons_extended_csv = "~{outputFile_commonPrefix}~{codingExonsPrefix}.extended.csv"
    File codingExons_metrics_json = "~{outputFile_commonPrefix}~{codingExonsPrefix}.metrics.json"
    File codingExons_summary_csv = "~{outputFile_commonPrefix}~{codingExonsPrefix}.summary.csv"
    File codingExons_console_output_txt = "~{outputFile_commonPrefix}~{codingExonsPrefix}~{consoleOutputPartialFilename}"
  }
  command <<<
    /opt/hap.py/bin/hap.py -V ~{truthCodingExonsVCF} ~{queryVCF} -f ~{truthCodingExonsBED} -T ~{truthCodingExonsBED} -r ~{referenceFasta} -o ~{outputFile_commonPrefix}~{codingExonsPrefix} > ~{outputFile_commonPrefix}~{codingExonsPrefix}~{consoleOutputPartialFilename}
  >>>
  runtime {
    docker: "paramost/hap.py"
    memory: "8 GB"
    cpu: 1
  }
}

task vcfComparison_by_Happy_WholeExome {
  input {
    File queryVCF
    String outputFile_commonPrefix
    File truthWholeExomeVCF
    File truthWholeExomeBED
    File referenceFasta
    File referenceFasta_indexed  ## *.fai
    String WholeExomePrefix
    String consoleOutputPartialFilename
  }
  output {
    File WholeExome_annotated_vcf_gz = "~{outputFile_commonPrefix}~{WholeExomePrefix}.vcf.gz" ##Need this later if doing indel size distribution
    File WholeExome_annotated_vcf_gz_tbi = "~{outputFile_commonPrefix}~{WholeExomePrefix}.vcf.gz.tbi"
    File WholeExome_counts_csv = "~{outputFile_commonPrefix}~{WholeExomePrefix}.counts.csv"
    File WholeExome_counts_json = "~{outputFile_commonPrefix}~{WholeExomePrefix}.counts.json"
    File WholeExome_extended_csv = "~{outputFile_commonPrefix}~{WholeExomePrefix}.extended.csv"
    File WholeExome_metrics_json = "~{outputFile_commonPrefix}~{WholeExomePrefix}.metrics.json"
    File WholeExome_summary_csv = "~{outputFile_commonPrefix}~{WholeExomePrefix}.summary.csv"
    File WholeExome_console_output_txt = "~{outputFile_commonPrefix}~{WholeExomePrefix}~{consoleOutputPartialFilename}"
  }
  command <<<
    /opt/hap.py/bin/hap.py -V ~{truthWholeExomeVCF} ~{queryVCF} -f ~{truthWholeExomeBED} -T ~{truthWholeExomeBED} -r ~{referenceFasta} -o ~{outputFile_commonPrefix}~{WholeExomePrefix} > ~{outputFile_commonPrefix}~{WholeExomePrefix}~{consoleOutputPartialFilename}
  >>>
  runtime {
    docker: "paramost/hap.py"
    memory: "8 GB"
    cpu: 1
  }
}