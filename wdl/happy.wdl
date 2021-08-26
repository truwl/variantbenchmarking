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
#    File codingExons_counts_csv = "~{outputFile_commonPrefix}~{codingExonsPrefix}.counts.csv" i don't think these are really a thing
#    File codingExons_counts_json = "~{outputFile_commonPrefix}~{codingExonsPrefix}.counts.json"
    File codingExons_runinfo_json = "~{outputFile_commonPrefix}~{codingExonsPrefix}.runinfo.json"
    File codingExons_roc_indel_pass = "~{outputFile_commonPrefix}~{codingExonsPrefix}.roc.Locations.INDEL.PASS.csv.gz"
    File codingExons_roc_indel = "~{outputFile_commonPrefix}~{codingExonsPrefix}.roc.Locations.INDEL.csv.gz"
    File codingExons_roc_snp_pass = "~{outputFile_commonPrefix}~{codingExonsPrefix}.roc.Locations.SNP.PASS.csv.gz"
    File codingExons_roc_snp = "~{outputFile_commonPrefix}~{codingExonsPrefix}.roc.Locations.SNP.csv.gz"
    File codingExons_roc_all = "~{outputFile_commonPrefix}~{codingExonsPrefix}.roc.all.csv.gz"
    File codingExons_extended_csv = "~{outputFile_commonPrefix}~{codingExonsPrefix}.extended.csv"
    File codingExons_metrics_json = "~{outputFile_commonPrefix}~{codingExonsPrefix}.metrics.json.gz"
    File codingExons_summary_csv = "~{outputFile_commonPrefix}~{codingExonsPrefix}.summary.csv"
    File codingExons_console_output_txt = "~{outputFile_commonPrefix}~{codingExonsPrefix}~{consoleOutputPartialFilename}"
  }
  command <<<
    /opt/hap.py/bin/hap.py --write-counts -V ~{truthCodingExonsVCF} ~{queryVCF} -f ~{truthCodingExonsBED} -T ~{truthCodingExonsBED} -r ~{referenceFasta} -o ~{outputFile_commonPrefix}~{codingExonsPrefix} > ~{outputFile_commonPrefix}~{codingExonsPrefix}~{consoleOutputPartialFilename}
  >>>
  runtime {
    docker: "paramost/hap.py"
    memory: "8 GB"
    cpu: 2
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
#    File WholeExome_counts_csv = "~{outputFile_commonPrefix}~{WholeExomePrefix}.counts.csv"
#    File WholeExome_counts_json = "~{outputFile_commonPrefix}~{WholeExomePrefix}.counts.json"
    File WholeExome_runinfo_json = "~{outputFile_commonPrefix}~{WholeExomePrefix}.runinfo.json"
    File WholeExome_roc_indel_pass = "~{outputFile_commonPrefix}~{WholeExomePrefix}.roc.Locations.INDEL.PASS.csv.gz"
    File WholeExome_roc_indel = "~{outputFile_commonPrefix}~{WholeExomePrefix}.roc.Locations.INDEL.csv.gz"
    File WholeExome_roc_snp_pass = "~{outputFile_commonPrefix}~{WholeExomePrefix}.roc.Locations.SNP.PASS.csv.gz"
    File WholeExome_roc_snp = "~{outputFile_commonPrefix}~{WholeExomePrefix}.roc.Locations.SNP.csv.gz"
    File WholeExome_roc_all = "~{outputFile_commonPrefix}~{WholeExomePrefix}.roc.all.csv.gz"
    File WholeExome_extended_csv = "~{outputFile_commonPrefix}~{WholeExomePrefix}.extended.csv"
    File WholeExome_metrics_json = "~{outputFile_commonPrefix}~{WholeExomePrefix}.metrics.json.gz"
    File WholeExome_summary_csv = "~{outputFile_commonPrefix}~{WholeExomePrefix}.summary.csv"
    File WholeExome_console_output_txt = "~{outputFile_commonPrefix}~{WholeExomePrefix}~{consoleOutputPartialFilename}"
  }
  command <<<
    /opt/hap.py/bin/hap.py  --write-counts -V ~{truthWholeExomeVCF} ~{queryVCF} -f ~{truthWholeExomeBED} -T ~{truthWholeExomeBED} -r ~{referenceFasta} -o ~{outputFile_commonPrefix}~{WholeExomePrefix} > ~{outputFile_commonPrefix}~{WholeExomePrefix}~{consoleOutputPartialFilename}
  >>>
  runtime {
    docker: "paramost/hap.py"
    memory: "16 GB"
    cpu: 2
    disks: "local-disk 100 HDD"
  }
}


task finalReport {

    input {
       String job_id
       String group_id
       String replicate_id
       String outputFile_commonPrefix
       String WholeExomePrefix
       String happy_prefix
       File jupyter_notebook
     }
   output {
       File annoreport = "~{outputFile_commonPrefix}~{WholeExomePrefix}.ipynb"
   }
   runtime {
       docker: "truwl/happyrpapermill"
       memory: "1 GB"
       cpu: 1
   }
   command <<<
     papermill ~{jupyter_notebook} -p group_id ~{group_id} -p replicate_id ~{replicate_id} -p happy_prefix ~{happy_prefix} --stdout-file ~{outputFile_commonPrefix}~{WholeExomePrefix}.ipynb
   >>>
}
