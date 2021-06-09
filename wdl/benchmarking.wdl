version 1.0

import "./bcftools.wdl" as bcftools
import "./indel.wdl" as indel
import "./happy.wdl" as happy
import "./aggregate.wdl" as aggregate

# WORKFLOW DEFINITION

workflow GermlineVariantCallBenchmark {

  input {
    File queryVCF
    File truthCodingExonsVCF
    File truthWholeExomeVCF
    File truthCodingExonsBED
    File truthWholeExomeBED
    File Rscript_indelSize ## Specify the R script indelSizeDistribution_Detailed.R
    File Rscript_aggregate
    File referenceFasta  ## provide md5 hash values for the file in contents
    File referenceFasta_indexed  ## *.fai
    String chrRemovedVCF_fileSuffix
    String outputFile_commonPrefix
    String codingExonsPrefix
    String WholeExomePrefix
    String consoleOutputPartialFilename
    String indelDistributionSuffix
    String indelSizeDistributionSuffix
    String indelSizeDistributionPlotSuffix
    String truwl.job_id
    String truwl.workflow_instance_identifier
    String truwl.workflow_identifier
  }

  call happy.vcfComparison_by_Happy_CodingExons as happyexons {
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
      codingExons_annotated_vcf_gz = happyexons.codingExons_annotated_vcf_gz
  }

  call bcftools.splittingAnnotatedVCF_WholeExome as splitwes {
    input:
      outputFile_commonPrefix = outputFile_commonPrefix,
      WholeExomePrefix = WholeExomePrefix,
      WholeExome_annotated_vcf_gz = happyexome.WholeExome_annotated_vcf_gz
  }

  call indel.indelDistribution_CodingExons_HappyResults as cdsresults {
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

  call indel.indelSizeDistribution_CodingExons_HappyResults as cdssize {
    input:
      outputFile_commonPrefix = outputFile_commonPrefix,
      codingExonsPrefix = codingExonsPrefix,
      indelDistribution_CodingExons = cdsresults.indelDistribution_CodingExons,
      indelSizeDistributionSuffix = indelSizeDistributionSuffix,
      indelSizeDistributionPlotSuffix = indelSizeDistributionPlotSuffix,
      codingExons_annotated_TPonly_vcf_gz = splitcds.codingExons_annotated_TPonly_vcf_gz,
      codingExons_annotated_FPonly_vcf_gz = splitcds.codingExons_annotated_FPonly_vcf_gz,
      codingExons_annotated_FNonly_vcf_gz = splitcds.codingExons_annotated_FNonly_vcf_gz,
      Rscript_indelSize = Rscript_indelSize
  }

  call indel.indelSizeDistribution_WholeExome_HappyResults as wessize {
    input:
      outputFile_commonPrefix = outputFile_commonPrefix,
      WholeExomePrefix = WholeExomePrefix,
      indelDistribution_WholeExome = wesresults.indelDistribution_WholeExome,
      indelSizeDistributionSuffix = indelSizeDistributionSuffix,
      indelSizeDistributionPlotSuffix = indelSizeDistributionPlotSuffix,
      WholeExome_annotated_TPonly_vcf_gz = splitwes.WholeExome_annotated_TPonly_vcf_gz,
      WholeExome_annotated_FPonly_vcf_gz = splitwes.WholeExome_annotated_FPonly_vcf_gz,
      WholeExome_annotated_FNonly_vcf_gz = splitwes.WholeExome_annotated_FNonly_vcf_gz,
      Rscript_indelSize = Rscript_indelSize
  }

  call aggregate.melt as aggmelt {
    input:
      job_id = job_id,
      workflow_instance_identifier = workflow_instance_identifier,
      workflow_identifier = workflow_identifier,
      codingExons_summary_csv = happyexons.codingExons_summary_csv,
      WholeExome_summary_csv = happyexome.WholeExome_summary_csv,
      Rscript_aggregate = Rscript_aggregate
  }

  output {
    File codingExons_annotated_vcf_gz = happyexons.codingExons_annotated_vcf_gz
    File codingExons_annotated_vcf_gz_tbi = happyexons.codingExons_annotated_vcf_gz_tbi
#    File codingExons_counts_csv = happyexons.codingExons_counts_csv
#    File codingExons_counts_json = happyexons.codingExons_counts_json
    File codingExons_runinfo_json = happyexons.codingExons_runinfo_json
    File codingExons_roc_indel_pass = happyexons.codingExons_roc_indel_pass
    File codingExons_roc_indel = happyexons.codingExons_roc_indel
    File codingExons_roc_snp_pass = happyexons.codingExons_roc_snp_pass
    File codingExons_roc_snp = happyexons.codingExons_roc_snp
    File codingExons_roc_all = happyexons.codingExons_roc_all
    File codingExons_extended_csv = happyexons.codingExons_extended_csv
    File codingExons_metrics_json = happyexons.codingExons_metrics_json
    File codingExons_summary_csv = happyexons.codingExons_summary_csv
    File codingExons_console_output_txt = happyexons.codingExons_console_output_txt


    File WholeExome_annotated_vcf_gz = happyexome.WholeExome_annotated_vcf_gz
    File  WholeExome_annotated_vcf_gz_tbi = happyexome.WholeExome_annotated_vcf_gz_tbi
#    File  WholeExome_counts_csv = happyexome.WholeExome_counts_csv
#    File  WholeExome_counts_json = happyexome.WholeExome_counts_json
    File WholeExome_runinfo_json = happyexome.WholeExome_runinfo_json
    File WholeExome_roc_indel_pass = happyexome.WholeExome_roc_indel_pass
    File WholeExome_roc_indel = happyexome.WholeExome_roc_indel
    File WholeExome_roc_snp_pass = happyexome.WholeExome_roc_snp_pass
    File WholeExome_roc_snp = happyexome.WholeExome_roc_snp
    File WholeExome_roc_all = happyexome.WholeExome_roc_all
    File  WholeExome_extended_csv = happyexome.WholeExome_extended_csv
    File  WholeExome_metrics_json = happyexome.WholeExome_metrics_json
    File  WholeExome_summary_csv = happyexome.WholeExome_summary_csv
    File  WholeExome_console_output_txt = happyexome.WholeExome_console_output_txt
    File  codingExons_annotated_TPonly_vcf_gz = splitcds.codingExons_annotated_TPonly_vcf_gz
    File  codingExons_annotated_FPonly_vcf_gz = splitcds.codingExons_annotated_FPonly_vcf_gz
    File  codingExons_annotated_FNonly_vcf_gz = splitcds.codingExons_annotated_FNonly_vcf_gz
    File  WholeExome_annotated_TPonly_vcf_gz = splitwes.WholeExome_annotated_TPonly_vcf_gz
    File  WholeExome_annotated_FPonly_vcf_gz = splitwes.WholeExome_annotated_FPonly_vcf_gz
    File  WholeExome_annotated_FNonly_vcf_gz = splitwes.WholeExome_annotated_FNonly_vcf_gz
    File indelDistribution_CodingExons = cdsresults.indelDistribution_CodingExons
    File indelDistribution_WholeExome = wesresults.indelDistribution_WholeExome
    File indelSizeDistribution_CodingExons = cdssize.indelSizeDistribution_CodingExons
    File indelSizeDistribution_WholeExome = wessize.indelSizeDistribution_WholeExome
    File indelSizeDistributionPlot_CodingExons = cdssize.indelSizeDistributionPlot_CodingExons
    File indelSizeDistributionPlot_WholeExome = wessize.indelSizeDistributionPlot_WholeExome
    File talltable = aggmelt.talltable
  }
}