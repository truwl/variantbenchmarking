import "bcftools.wdl" as bcftools
import "indelSizeDistribution.wdl" as indelSizeDistribution
import "happy.wdl" as happy


# WORKFLOW DEFINITION
workflow BenchmarkingWorkFlow_hg19_IndelsizeDistributionWith_TPFPFN_usingHappy {

  inputs {
    File queryVCF
    File outputFile_commonPrefix
    File truthCodingExonsVCF
    File truthWholeExomeVCF
    File truthCodingExonsBED
    File truthWholeExomeBED
    File Rscript_indelSize ## Specify the R script indelSizeDistribution_Detailed.R
    File referenceFasta  ## provide md5 hash values for the file in contents
    File referenceFasta_indexed  ## *.fai
    File chrRemovedVCF_fileSuffix
    String codingExonsPrefix
    String WholeExomePrefix
    String consoleOutputPartialFilename
    String indelDistributionSuffix
    String indelSizeDistributionSuffix
    String indelSizeDistributionPlotSuffix
  }

  call happy.vcfComparison_by_Happy_CodingExons {
    input:
      File queryVCF = queryVCF
      String outputFile_commonPrefix =  outputFile_commonPrefix
      File truthCodingExonsVCF = truthCodingExonsVCF
      File truthCodingExonsBED = truthCodingExonsBED
      File referenceFasta = referenceFasta
      File referenceFasta_indexed = referenceFasta_indexed
      String codingExonsPrefix = codingExonsPrefix
      String consoleOutputPartialFilename = consoleOutputPartialFilename
  }

  call happy.vcfComparison_by_Happy_WholeExome as happyexome {
    input:
      File queryVCF = queryVCF
      String outputFile_commonPrefix = outputFile_commonPrefix
      File truthWholeExomeVCF = truthWholeExomeVCF
      File truthWholeExomeBED = truthWholeExomeBED
      File referenceFasta = referenceFasta
      File referenceFasta_indexed = referenceFasta_indexed
      String WholeExomePrefix =  WholeExomePrefix
      String consoleOutputPartialFilename = consoleOutputPartialFilename
  }

  call bcftools.splittingAnnotatedVCF_CodingExons as splitcds {
    String outputFile_commonPrefix = outputFile_commonPrefix =
    String codingExonsPrefix = codingExonsPrefix
    File codingExons_annotated_vcf_gz = happyexome.codingExons_annotated_vcf_gz
  }

  call bcftools.splittingAnnotatedVCF_WholeExome as splitwes {
    String outputFile_commonPrefix = outputFile_commonPrefix
    String WholeExomePrefix = WholeExomePrefix
    File WholeExome_annotated_vcf_gz = happyexome.WholeExome_annotated_vcf_gz
  }


  output {
    File codingExons_annotated_vcf_gz
    File codingExons_annotated_vcf_gz_tbi
    File codingExons_counts_csv
    File codingExons_counts_json
    File codingExons_extended_csv
    File codingExons_metrics_json
    File codingExons_summary_csv
    File codingExons_console_output_txt
    File WholeExome_annotated_vcf_gz
    File WholeExome_annotated_vcf_gz_tbi
    File WholeExome_counts_csv
    File WholeExome_counts_json
    File WholeExome_extended_csv
    File WholeExome_metrics_json
    File WholeExome_summary_csv
    File WholeExome_console_output_txt
    File codingExons_annotated_TPonly_vcf_gz
    File codingExons_annotated_FPonly_vcf_gz
    File codingExons_annotated_FNonly_vcf_gz
    File WholeExome_annotated_TPonly_vcf_gz
    File WholeExome_annotated_FPonly_vcf_gz
    File WholeExome_annotated_FNonly_vcf_gz
    File indelDistribution_CodingExons  ## .txt file
    File indelDistribution_WholeExome  ## .txt file
    File indelSizeDistribution_CodingExons  ## .txt file
    File indelSizeDistribution_WholeExome  ## .txt file
    File indelSizeDistributionPlot_CodingExons  ## .PDF file
    File indelSizeDistributionPlot_WholeExome  ## .PDF file
  }
}