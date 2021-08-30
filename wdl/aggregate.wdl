version 1.0

task melt {
  input {
      String job_id
      String workflow_instance_identifier
      String workflow_identifier
      File codingExons_summary_csv
      File WholeExome_summary_csv
      File Rscript_aggregate
  }
  output {
    File talltable = "truwlbenchmarks.txt"
  }
  command <<<
    Rscript ~{Rscript_aggregate} ~{job_id} ~{workflow_instance_identifier} ~{workflow_identifier} ~{WholeExome_summary_csv} ~{codingExons_summary_csv} truwlbenchmarks.txt
  >>>
  runtime {
    docker: "rocker/tidyverse:4.1.0"
    memory: "1 GB"
    cpu: 1
  }
}

task precRecall {
    input {
        File Rscript_precrecall
        File staticcompetitors
        File truwlbenchmarks
        String samplename
        String outputplotname
    }
    output {
        File precrecallplot = "~{outputplotname}"
    }
    command <<<
      Rscript ~{Rscript_precrecall} ~{samplename} ~{truwlbenchmarks} ~{staticcompetitors} ~{outputplotname}
    >>>
    runtime {
        docker: "rocker/tidyverse:4.1.0"
        memory: "1 GB"
        cpu: 1
    }
}

task finalReport {
    input {
        File queryVCF
        String freeze
        String subject
        String outputFile_commonPrefix
        String WholeExomePrefix
        File upset_plot
        File prec_recall_plot
        File jupyter_notebook
        
        
        File indelDistribution_CodingExons
        File indelDistribution_WholeExome
        File indelSizeDistribution_CodingExons
        File indelSizeDistribution_WholeExome
        File indelSizeDistributionPlot_CodingExons
        File indelSizeDistributionPlot_WholeExome
     }
   output {
       File annoreport = "~{outputFile_commonPrefix}~{WholeExomePrefix}.ipynb"
       File annohtml = "~{outputFile_commonPrefix}~{WholeExomePrefix}.html"
   }
   runtime {
       docker: "truwl/happyrpapermill"
       memory: "1 GB"
       cpu: 1
   }
   command <<<
     mkdir -p /home/jovyan/.cache/black/21.7b0/
     papermill ~{jupyter_notebook} -p queryVCF ~{queryVCF} -p freeze ~{freeze} -p subject ~{subject} -p upset_plot ~{upset_plot} -p ~{prec_recall_plot} -p ~{indelSizeDistributionPlot_CodingExons} -p ~{indelSizeDistributionPlot_WholeExome} ~{outputFile_commonPrefix}~{WholeExomePrefix}.ipynb
     jupyter nbconvert ~{outputFile_commonPrefix}~{WholeExomePrefix}.ipynb --to html --output ~{outputFile_commonPrefix}~{WholeExomePrefix}.html
   >>>
}
