version 1.0

task run_intervene {
  input {
  
    #hardcoding this until we can get a system
    
    Boolean includeB1S5A
    Boolean includeWX8VK
    Boolean includeCZA1Y
    Boolean includeEIUT6
    Boolean includeXC97E
    Boolean includeXV7ZN
    Boolean includeIA789
    Boolean includeW607K
    String subject
    String freeze
    File queryVCF
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
# gs://benchmarking-datasets/competitors.csv
# gs://benchmarking-datasets/indelSizeDistribution_Detailed.R
# gs://benchmarking-datasets/precRecallPlot.R
# gs://benchmarking-datasets/simple_notebook.ipynb


  command <<<
    downloadList=("")
    optvcfs=""
    if [ "~{freeze}" = "hg38" ]; then
        if ~{includeB1S5A}; then
         optvcfs="${optvcfs} B1S5A_~{subject}.vcf.gz"
         downloadList+=("gs://truwl-giab/submission_vcfs/B1S5A/B1S5A_~{subject}.vcf.gz")
        fi
        if ~{includeWX8VK}; then
         optvcfs="${optvcfs} WX8VK_~{subject}.vcf.gz"
         downloadList+=("gs://truwl-giab/submission_vcfs/WX8VK/WX8VK_~{subject}.vcf.gz")
        fi
        if ~{includeCZA1Y}; then
         optvcfs="${optvcfs} CZA1Y_~{subject}.vcf.gz"
         downloadList+=("gs://truwl-giab/submission_vcfs/CZA1Y/CZA1Y_~{subject}.vcf.gz")
        fi
        if ~{includeEIUT6}; then
         optvcfs="${optvcfs} EIUT6_~{subject}.vcf.gz"
         downloadList+=("gs://truwl-giab/submission_vcfs/EIUT6/EIUT6_~{subject}.vcf.gz")
        fi
        if ~{includeXC97E}; then
         optvcfs="${optvcfs} XC97E_~{subject}.vcf.gz"
         downloadList+=("gs://truwl-giab/submission_vcfs/XC97E/XC97E_~{subject}.vcf.gz")
        fi
        if ~{includeXV7ZN}; then
         optvcfs="${optvcfs} XV7ZN_~{subject}.vcf.gz"
         downloadList+=("gs://truwl-giab/submission_vcfs/XV7ZN/XV7ZN_~{subject}.vcf.gz")
        fi
        if ~{includeIA789}; then
         optvcfs="${optvcfs} IA789_~{subject}.vcf.gz"
         downloadList+=("gs://truwl-giab/submission_vcfs/IA789/IA789_~{subject}.vcf.gz")
        fi
        if ~{includeW607K}; then
         optvcfs="${optvcfs} W607K_~{subject}.vcf.gz"
         downloadList+=("gs://truwl-giab/submission_vcfs/W607K/W607K_~{subject}.vcf.gz")
        fi
    fi
    
    if [ "~{freeze}" = "hg37" ]; then
        optvcfs="DRAGEN_HG002-NA24385-50x.vcf.gz ISAAC_HG002-NA24385_all_passed_variants.vcf.gz"
        downloadList+=("gs://benchmarking-datasets/DRAGEN_HG002-NA24385-50x.vcf.gz","gs://benchmarking-datasets/ISAAC_HG002-NA24385_all_passed_variants.vcf.gz")
    fi

    for value in "${downloadList[@]}"
    do
         echo $value
         gsutil cp $value .
    done
    
    mkdir -p Intervene_results
    mkdir -p Intervene_results/sets
    echo "intervene upset --figtype png --type reentrant -i ~{queryVCF} $optvcfs --save-overlaps --filenames --bedtools-options header"
    intervene upset --figtype png --type genomic -i ~{queryVCF} $optvcfs --save-overlaps --filenames --bedtools-options header
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
