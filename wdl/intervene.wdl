version 1.0

task run_intervene {
  input {
  
    #hardcoding this until we can get a system
    Boolean includeDragen
    Boolean includeGatk
    Boolean includeLabcorp
    Boolean includeSentieon
    Boolean includeVQSR
    Boolean includeIsaac
    File dragen
    File gatk
    File labcorp
    File sentieon
    File vqsr
    File isaac
  }

  command <<<
    if ~{includeDragen}; then
     optdragen="~{dragen}"
    else
     optdragen=""
    fi
    if ~{includeGatk}; then
     optgatk="~{gatk}"
    else
     optgatk=""
    fi
    mkdir -p Intervene_results
    mkdir -p Intervene_results/sets
    echo "intervene upset --figtype png --type reentrant -i $optdragen $optgatk --save-overlaps --filenames --bedtools-options header"
    intervene upset --figtype png --type genomic -i $optdragen $optgatk --save-overlaps --filenames --bedtools-options header
  >>>
  
  runtime {
    docker: "truwl/intervene"
    memory: "8 GB"
    cpu: 2
  }
  output {
    File upsetplot = "Intervene_results/Intervene_upset.png"
  }
}
#
# gs://benchmarking-datasets/DRAGEN_HG002-NA24385-50x.vcf.gz
# gs://benchmarking-datasets/GATK_HG002-NA24385.Filtered.Variants.vcf.gz
# gs://benchmarking-datasets/GENALICE_HG002-NA24385.vcf.gz
# gs://benchmarking-datasets/GIAB-HG002-AJSon-CallsIn2Technologies.vcf.gz
# gs://benchmarking-datasets/GRCh37-lite.fa
# gs://benchmarking-datasets/GRCh37-lite.fa.fai
# gs://benchmarking-datasets/HG002-NA24385-pFDA.vcf.gz
# gs://benchmarking-datasets/HG002-multiall-fullcombine.vcf.gz
# gs://benchmarking-datasets/HG002-multiall-fullcombine.vcf.gz.tbi
# gs://benchmarking-datasets/HG002.fermikit.raw.vcf.gz
# gs://benchmarking-datasets/HG002_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-22_v3.3_highconf.bed
# gs://benchmarking-datasets/HG002_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-22_v3.3_highconf.vcf.gz
# gs://benchmarking-datasets/HG002run1_S1.genome.vcf
# gs://benchmarking-datasets/HG002run1_S1.genome.vcf.gz
# gs://benchmarking-datasets/ISAAC_HG002-NA24385_all_passed_variants.vcf.gz
# gs://benchmarking-datasets/LabCorp.fixed.vcf.gz
# gs://benchmarking-datasets/LabCorp.newheader.vcf.gz
# gs://benchmarking-datasets/LabCorp.reheader.vcf.gz
# gs://benchmarking-datasets/LabCorp_HG002.vcf.gz
# gs://benchmarking-datasets/NA12878_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-X_v3.3_highconf.bed
# gs://benchmarking-datasets/SIB-HG002.vcf.gz
# gs://benchmarking-datasets/SIB-MT.vcf.gz
# gs://benchmarking-datasets/Sentieon.fixed.vcf
# gs://benchmarking-datasets/Truth.highconf.CodingExons.vcf.gz
# gs://benchmarking-datasets/Truth.highconf.WholeExome.vcf.gz
# gs://benchmarking-datasets/VQSR_HG002-NA24385.recalibrated_variants.vcf.gz
# gs://benchmarking-datasets/aggregateResults.R
# gs://benchmarking-datasets/codingexons.bed
# gs://benchmarking-datasets/codingexons.nochr.bed
# gs://benchmarking-datasets/indelSizeDistribution_Detailed.R
# gs://benchmarking-datasets/simple_notebook.ipynb