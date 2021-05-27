import "bcftools.wdl" as bcftools
import "indel.wdl" as indel
import "happy.wdl" as happy


# WORKFLOW DEFINITION
workflow BenchmarkingWorkFlow_hg19_IndelsizeDistributionWith_TPFPFN_usingHappy {

  input {
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
       queryVCF = queryVCF,
       outputFile_commonPrefix = outputFile_commonPrefix,
       truthCodingExonsVCF = truthCodingExonsVCF,
       truthCodingExonsBED = truthCodingExonsBED,
       referenceFasta = referenceFasta,
       referenceFasta_indexed = referenceFasta_indexed,
       codingExonsPrefix = codingExonsPrefix,
       consoleOutputPartialFilename = consoleOutputPartialFilename
  }

  call happy.vcfComparison_by_Happy_WholeExome as happyexome {
    input:
       queryVCF = queryVCF,
       outputFile_commonPrefix = outputFile_commonPrefix,
       truthWholeExomeVCF = truthWholeExomeVCF,
       truthWholeExomeBED = truthWholeExomeBED,
       referenceFasta = referenceFasta,
       referenceFasta_indexed = referenceFasta_indexed,
       WholeExomePrefix =  WholeExomePrefix,
       consoleOutputPartialFilename = consoleOutputPartialFilename
  }

  call bcftools.splittingAnnotatedVCF_CodingExons as splitcds {
    input:
     outputFile_commonPrefix = outputFile_commonPrefix,
     codingExonsPrefix = codingExonsPrefix,
     codingExons_annotated_vcf_gz = happyexome.codingExons_annotated_vcf_gz
  }

  call bcftools.splittingAnnotatedVCF_WholeExome as splitwes {
    input:
     outputFile_commonPrefix = outputFile_commonPrefix,
     WholeExomePrefix = WholeExomePrefix,
     WholeExome_annotated_vcf_gz = happyexome.WholeExome_annotated_vcf_gz
  }

  call indel.indelDistribution_CodingExons_HappyResults as cdsresults{
    input:
     outputFile_commonPrefix = outputFile_commonPrefix,
     codingExonsPrefix = outputFile_commonPrefix,
     truthCodingExonsVCF = truthCodingExonsVCF,
    indelDistributionSuffix = indelDistributionSuffix
  }

  call indel.indelDistribution_WholeExome_HappyResults  as wesresults {
    input:
    outputFile_commonPrefix = outputFile_commonPrefix,
    WholeExomePrefix = WholeExomePrefix,
     truthWholeExomeVCF = truthWholeExomeVCF,
    indelDistributionSuffix = indelDistributionSuffix
    }

  call indel.indelSizeDistribution_CodingExons_HappyResults as cdssize{
    input:
   outputFile_commonPrefix = outputFile_commonPrefix,
   codingExonsPrefix = codingExonsPrefix,
     indelDistribution_CodingExons = indelDistribution_CodingExons,
   indelSizeDistributionSuffix = indelSizeDistributionSuffix,
   indelSizeDistributionPlotSuffix = indelSizeDistributionPlotSuffix,
     codingExons_annotated_TPonly_vcf_gz = codingExons_annotated_TPonly_vcf_gz,
     codingExons_annotated_FPonly_vcf_gz = codingExons_annotated_FPonly_vcf_gz,
     codingExons_annotated_FNonly_vcf_gz = codingExons_annotated_FNonly_vcf_gz,
     Rscript_indelSize = Rscript_indelSize
  }

  call indel.indelSizeDistribution_WholeExome_HappyResults as wessize {
    input:
   outputFile_commonPrefix = outputFile_commonPrefix,
   WholeExomePrefix = WholeExomePrefix,
     indelDistribution_WholeExome = indelDistribution_WholeExome,
   indelSizeDistributionSuffix = indelSizeDistributionSuffix,
   indelSizeDistributionPlotSuffix = indelSizeDistributionPlotSuffix,
     WholeExome_annotated_TPonly_vcf_gz = WholeExome_annotated_TPonly_vcf_gz,
     WholeExome_annotated_FPonly_vcf_gz = WholeExome_annotated_FPonly_vcf_gz,
     WholeExome_annotated_FNonly_vcf_gz = WholeExome_annotated_FNonly_vcf_gz,
     Rscript_indelSize = Rscript_indelSize
  }

  output {
    File codingExons_annotated_vcf_gz = happyexome.codingExons_annotated_vcf_gz
    File codingExons_annotated_vcf_gz_tbi = happyexome.codingExons_annotated_vcf_gz_tbi
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