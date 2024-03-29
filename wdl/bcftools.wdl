version 1.0

## Splitting the Coding Exons annotated vcf generated by Happy into TP, FP and FN calls

task  splittingAnnotatedVCF_CodingExons {
  input {
    String outputFile_commonPrefix
    String codingExonsPrefix
    File codingExons_annotated_vcf_gz
  }
  output {
    File codingExons_annotated_TPonly_vcf_gz = "~{outputFile_commonPrefix}~{codingExonsPrefix}_TPonly.vcf.gz"
    File codingExons_annotated_FPonly_vcf_gz = "~{outputFile_commonPrefix}~{codingExonsPrefix}_FPonly.vcf.gz"
    File codingExons_annotated_FNonly_vcf_gz = "~{outputFile_commonPrefix}~{codingExonsPrefix}_FNonly.vcf.gz"
  }
  command <<<
    bcftools view -O z -V snps -i 'FMT/BVT="INDEL" & FMT/BD="TP"' ~{codingExons_annotated_vcf_gz} > ~{outputFile_commonPrefix}~{codingExonsPrefix}_TPonly.vcf.gz;
    bcftools view -O z -V snps -i 'FMT/BVT="INDEL" & FMT/BD="FP"' ~{codingExons_annotated_vcf_gz} > ~{outputFile_commonPrefix}~{codingExonsPrefix}_FPonly.vcf.gz;
    bcftools view -O z -V snps -i 'FMT/BVT="INDEL" & FMT/BD="FN"' ~{codingExons_annotated_vcf_gz} > ~{outputFile_commonPrefix}~{codingExonsPrefix}_FNonly.vcf.gz;
  >>>
  runtime {
    docker: "vandhanak/bcftools:1.3.1"
    memory: "8 GB"
    cpu: 1
  }
}

## Splitting the WholeExome annotated vcf generated by Happy into TP, FP and FN calls

task  splittingAnnotatedVCF_WholeExome {
  input {
    String outputFile_commonPrefix
    String WholeExomePrefix
    File WholeExome_annotated_vcf_gz
  }
  output {
    File WholeExome_annotated_TPonly_vcf_gz = "~{outputFile_commonPrefix}~{WholeExomePrefix}_TPonly.vcf.gz"
    File WholeExome_annotated_FPonly_vcf_gz = "~{outputFile_commonPrefix}~{WholeExomePrefix}_FPonly.vcf.gz"
    File WholeExome_annotated_FNonly_vcf_gz = "~{outputFile_commonPrefix}~{WholeExomePrefix}_FNonly.vcf.gz"
  }
  command <<<
    bcftools view -O z -V snps -i 'FMT/BVT="INDEL" & FMT/BD="TP"' ~{WholeExome_annotated_vcf_gz} > ~{outputFile_commonPrefix}~{WholeExomePrefix}_TPonly.vcf.gz;
    bcftools view -O z -V snps -i 'FMT/BVT="INDEL" & FMT/BD="FP"' ~{WholeExome_annotated_vcf_gz} > ~{outputFile_commonPrefix}~{WholeExomePrefix}_FPonly.vcf.gz;
    bcftools view -O z -V snps -i 'FMT/BVT="INDEL" & FMT/BD="FN"' ~{WholeExome_annotated_vcf_gz} > ~{outputFile_commonPrefix}~{WholeExomePrefix}_FNonly.vcf.gz;
  >>>
  runtime {
    docker: "vandhanak/bcftools:1.3.1"
    memory: "8 GB"
    cpu: 1
  }
}

task bcfstats {
  input {
    File queryVCF
  }

  command <<<
    bcftools stats ~{queryVCF} > bcfstats.txt
  >>>

  output {
    File bcfstatsoutput = "bcfstats.txt"
  }

  runtime {
    docker: "vandhanak/bcftools:1.3.1"
    memory: "8 GB"
    cpu: 1
  }
}