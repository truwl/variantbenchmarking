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
        File jupyter_notebook
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
     papermill ~{jupyter_notebook} -p queryVCF ~{queryVCF} -p freeze ~{freeze} -p subject ~{subject} --stdout-file ~{outputFile_commonPrefix}~{WholeExomePrefix}.ipynb
     jupyter nbconvert ~{outputFile_commonPrefix}~{WholeExomePrefix}.ipynb --to html --output ~{outputFile_commonPrefix}~{WholeExomePrefix}.html
   >>>
}
