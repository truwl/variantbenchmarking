version 1.0
import "compoundbools.wdl" as compoundbools

task generateStratTable {
    input {
    FunctionalRegions fcRegions
    GCcontent gcRegions
    GenomeSpecific gsRegions
    LowComplexity lcRegions
    Mappability mpRegions
    OtherDifficult odRegions
    SegmentalDuplications sdRegions
    Union unRegions
    }
    
    command <<<
        echo "cds\tgs://truwl-giab/genome-stratifications/v2.0/GRCh38/FunctionalRegions/GRCh38_refseq_cds.bed.gz" >> "stratifications.tsv"
    >>>
    output {
        File stratTable = "stratifications.tsv"
    }
}

task happyStratify {
  input {
    File queryVCF
    File truthVCF
    
    File referenceFasta
    File referenceFasta_indexed
    
    File stratTable
    String outputFile_commonPrefix
    String happyPrefix
    String consoleOutputPartialFilename
  }
  
  
# 8H_out.metrics.json.gz
# 8H_out.extended.csv
# 8H_out.summary.csv
# 8H_out.roc.Locations.INDEL.PASS.csv.gz
# 8H_out.roc.Locations.SNP.csv.gz
# 8H_out.roc.Locations.SNP.PASS.csv.gz
# 8H_out.roc.Locations.INDEL.csv.gz
# 8H_out.roc.all.csv.gz
# 8H_out.vcf.gz.tbi
# 8H_out.vcf.gz
# 8H_out.runinfo.json

  
  
  output {
    File annotated_vcf_gz = "~{outputFile_commonPrefix}~{happyPrefix}.vcf.gz"
    File annotated_vcf_gz_tbi = "~{outputFile_commonPrefix}~{happyPrefix}.vcf.gz.tbi"
    File runinfo_json = "~{outputFile_commonPrefix}~{happyPrefix}.runinfo.json"
    File roc_indel_pass = "~{outputFile_commonPrefix}~{happyPrefix}.roc.Locations.INDEL.PASS.csv.gz"
    File roc_indel = "~{outputFile_commonPrefix}~{happyPrefix}.roc.Locations.INDEL.csv.gz"
    File roc_snp_pass = "~{outputFile_commonPrefix}~{happyPrefix}.roc.Locations.SNP.PASS.csv.gz"
    File roc_snp = "~{outputFile_commonPrefix}~{happyPrefix}.roc.Locations.SNP.csv.gz"
    File roc_all = "~{outputFile_commonPrefix}~{happyPrefix}.roc.all.csv.gz"
    File extended_csv = "~{outputFile_commonPrefix}~{happyPrefix}.extended.csv"
    File metrics_json = "~{outputFile_commonPrefix}~{happyPrefix}.metrics.json.gz"
    File summary_csv = "~{outputFile_commonPrefix}~{happyPrefix}.summary.csv"
    File console_output_txt = "~{outputFile_commonPrefix}~{happyPrefix}~{consoleOutputPartialFilename}"
  }
  command <<<
    if [[ ~{referenceFasta} =~ \.gz$ ]]; then
      gunzip -c ~{referenceFasta} > ref.fa
    else
      mv ~{referenceFasta} ref.fa
    fi
    mv ~{referenceFasta_indexed} ref.fa.fai
    export HGREF=ref.fa
    /opt/hap.py/bin/hap.py --write-counts \
    -V ~{truthVCF} ~{queryVCF} \
    --engine=vcfeval --stratification ~{stratTable} \
    -r ref.fa -o ~{outputFile_commonPrefix}~{happyPrefix} > ~{outputFile_commonPrefix}~{happyPrefix}~{consoleOutputPartialFilename} 
  >>>
  runtime {
    docker: "paramost/hap.py"
    memory: "16 GB"
    cpu: 2
    disks: "local-disk 100 HDD"
  }
}
