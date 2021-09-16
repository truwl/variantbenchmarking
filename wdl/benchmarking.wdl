version 1.0

import "./structs.wdl" as structs
import "./bcftools.wdl" as bcftools
import "./indel.wdl" as indel
import "./happy.wdl" as happy
import "./intervene.wdl" as intervene
import "./aggregate.wdl" as aggregate
import "./multiqc.wdl" as multiqc


# WORKFLOW DEFINITION


workflow GermlineVariantCallBenchmark {

  input {
    File queryVCF
    String freeze
    #HG002 (child), HG003 (dad), HG004 (mom)
    String subject

    Map[String,Map[String,File]] truthVCF = {
      "HG002": {
        "hg37": "gs://truwl-giab/AshkenazimTrio/HG002_NA24385_son/NISTv4.2.1/GRCh37/HG002_GRCh37_1_22_v4.2.1_benchmark.vcf.gz",
        "hg38": "gs://truwl-giab/AshkenazimTrio/HG002_NA24385_son/NISTv4.2.1/GRCh38/HG002_GRCh38_1_22_v4.2.1_benchmark.vcf.gz"
      },
      "HG003": {
        "hg37": "gs://truwl-giab/AshkenazimTrio/HG003_NA24159_father/NISTv4.2.1/GRCh37/HG003_GRCh37_1_22_v4.2.1_benchmark.vcf.gz",
        "hg38": "gs://truwl-giab/AshkenazimTrio/HG003_NA24159_father/NISTv4.2.1/GRCh38/HG003_GRCh38_1_22_v4.2.1_benchmark.vcf.gz"
      },
      "HG004": {
        "hg37": "gs://truwl-giab/AshkenazimTrio/HG004_NA24143_mother/NISTv4.2.1/GRCh37/HG004_GRCh37_1_22_v4.2.1_benchmark.vcf.gz",
        "hg38": "gs://truwl-giab/AshkenazimTrio/HG004_NA24143_mother/NISTv4.2.1/GRCh38/HG004_GRCh38_1_22_v4.2.1_benchmark.vcf.gz"
      }
    }
    
    Map[String,File] truthCodingExonsBED = {"hg37":"gs://benchmarking-datasets/codingexons.nochr.bed","hg38":"gs://truwl-giab/genome-stratifications/v2.0/GRCh38/FunctionalRegions/GRCh38_refseq_cds.bed.gz"}
    Map[String,File] truthWholeExomeBED = {"hg37":"gs://benchmarking-datasets/HG002_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-22_v3.3_highconf.bed","hg38":"gs://truwl-giab/genome-stratifications/v2.0/GRCh38/exome/Twist_Exome_Target_hg38.bed"}
    
    
    File Rscript_indelSize = "gs://benchmarking-datasets/indelSizeDistribution_Detailed.R"  ## Specify the R script indelSizeDistribution_Detailed.R
    File Rscript_aggregate = "gs://benchmarking-datasets/aggregateResults.R"
    File Rscript_precrecall = "gs://benchmarking-datasets/precRecallPlot.R"
    File Jupyter_report = "gs://benchmarking-datasets/report.ipynb"

    Map[String,File] referenceFasta = {"hg37":"gs://truwl-giab/references/GRCh37-lite.fa", "hg38":"gs://truwl-giab/references/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions.fasta.gz"}
    Map[String,File] referenceFasta_indexed = {"hg37":"gs://truwl-giab/GRCh37-lite.fa.fai", "hg38":"gs://truwl-giab/references/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set_maskedGRC_exclusions.fasta.gz.fai"}

    String chrRemovedVCF_fileSuffix = "_chrRemoved.vcf.gz"
    String outputFile_commonPrefix = "results"
    String codingExonsPrefix = "cds"
    String happyPrefix = "hap"
    String consoleOutputPartialFilename = "_ConsoleOutput.txt"
    String indelDistributionSuffix = "_indelDistribution_Frombcftools.txt"
    String indelSizeDistributionSuffix = "_indelSizeDistribution.txt"
    String indelSizeDistributionPlotSuffix = "_indelSizeDistributionPlot.png"

    Boolean includeB1S5A = true
    Boolean includeWX8VK = true
    Boolean includeCZA1Y = true
    Boolean includeEIUT6 = true
    Boolean includeXC97E = true
    Boolean includeXV7ZN = true
    Boolean includeIA789 = true
    Boolean includeW607K = true

    FunctionalRegions fcRegions
    GCcontent gcRegions
    GenomeSpecific gsRegions
    LowComplexity lcRegions
    Mappability mpRegions
    OtherDifficult odRegions
    SegmentalDuplications sdRegions
    Union unRegions

    String job_id
    String workflow_instance_identifier
    String workflow_identifier
  }
  
  parameter_meta {
    subject: {
                description: 'Member of Ashkenazi trio used in the query VCF',
                group: 'query',
                choices: ['HG002', 'HG003', 'HG004'],
                example: 'HG002'
            }
    freeze: {
                description: 'Genome freeze. hg37 is no-chr',
                group: 'query',
                choices: ['hg37', 'hg38'],
                example: 'HG002'
            }
  }

  call bcftools.bcfstats as bcfstatstask {
    input:
      queryVCF = queryVCF
  }

  Array[File] qualityReports = [bcfstatstask.bcfstatsoutput]

  call multiqc.MultiQC as multiqcTask {
    input:
        reports = qualityReports,
        outDir = "multiqc"
  }

  call happy.generateStratTable as makeStrat {
      input: 
        fcRegions = fcRegions,
        gcRegions = gcRegions,
        gsRegions = gsRegions,
        lcRegions = lcRegions,
        mpRegions = mpRegions,
        odRegions = odRegions,
        sdRegions = sdRegions,
        unRegions = unRegions
  }

  call happy.happyStratify as happystrat {
    input:
      queryVCF = queryVCF,
      truthVCF = truthVCF[subject][freeze],
    
      referenceFasta = referenceFasta[freeze],
      referenceFasta_indexed = referenceFasta_indexed[freeze],
    
      stratTable = makeStrat.stratTable,
      happyPrefix =  happyPrefix,
      outputFile_commonPrefix = outputFile_commonPrefix,
      consoleOutputPartialFilename = consoleOutputPartialFilename
  }

  call intervene.run_intervene as myintervene {
      input:
          includeB1S5A = includeB1S5A,
          includeWX8VK = includeWX8VK,
          includeCZA1Y = includeCZA1Y,
          includeEIUT6 = includeEIUT6,
          includeXC97E = includeXC97E,
          includeXV7ZN = includeXV7ZN,
          includeIA789 = includeIA789,
          includeW607K = includeW607K,
          subject = subject,
          queryVCF = queryVCF,
          freeze = freeze
  }

  call aggregate.melt as aggmelt {
    input:
      job_id = job_id,
      workflow_instance_identifier = workflow_instance_identifier,
      workflow_identifier = workflow_identifier,
      extended_csv = happystrat.extended_csv,
      Rscript_aggregate = Rscript_aggregate
  }
  
  call aggregate.precRecall as aggprecRecall {
    input:
     Rscript_precrecall = Rscript_precrecall,
     staticcompetitors = "gs://benchmarking-datasets/competitors.csv",
     truwlbenchmarks = aggmelt.talltable,
     samplename = job_id,
     outputplotname = "precRecall.png"
  }

  call aggregate.finalReport as aggfinal {
    input:
      outputFile_commonPrefix = outputFile_commonPrefix,
      happyPrefix = happyPrefix,
      queryVCF = queryVCF,
      freeze = freeze,
      subject = subject,
      jupyter_notebook = Jupyter_report,
      upset_plot = myintervene.upsetplot,
      prec_recall_plot = aggprecRecall.precrecallplot
  }
  
  output {
        # File upsetPlot = myintervene.upsetplot
        # File talltable = aggmelt.talltable
        # File bcfstatsoutput = bcfstatstask.bcfstatsoutput
        # File precrecallplot = aggprecRecall.precrecallplot
        
        
        
        File multiqcReport = multiqcTask.multiqcReport
        File finalreport = aggfinal.annohtml
  }
}