version 1.0

task run_intervene {
  input {
  
    #hardcoding this until we can get a system
    
    # Technology    challenge_cat    ID    Participant    Submission_Name
    # PACBIO    All Benchmark Regions    B1S5A    The Genomics Team in Google Health    DeepVariant PacBio
    # ILLUMINAPACBIOONT    "All Benchmark Regions, MHC"    WX8VK    Sentieon    "Combination of Illumina, PacBio HIFI, and Oxford Nanopore submission"
    # ILLUMINAPACBIOONT    MHC    CZA1Y    Sentieon    "Combination of Illumina, PacBio HIFI, and Oxford Nanopore submission Model2"
    # PACBIO    "MHC, Difficult-to-Map Regions"    EIUT6    Sentieon    PacBio HIFI only submission
    # ONT    "All Benchmark Regions, Difficult-to-Map Regions"    XC97E    The UCSC CGL and Google Health    PEPPER-DeepVariant (ONT_9to6)
    # ONT        XC97E    The UCSC CGL and Google Health    PEPPER-DeepVariant (ONT_9to6)
    # ONT    MHC    XV7ZN    Wang Genomics Lab    ONT NanoCaller Clair Medaka Ensemble
    # ILLUMINAPACBIOONT    Difficult-to-Map Regions    IA789    Roche Sequencing Solutions    RN-Illumina-PacBio-ONT
    # ILLUMINA    MHC    4HL0B    Seven Bridges Genomics    Seven Bridges GRAF - Illumina
    # ILLUMINA    "All Benchmark Regions, Difficult-to-Map Regions"    W607K    DRAG
    
    Boolean includeB1S5A
    Boolean includeWX8VK
    Boolean includeCZA1Y
    Boolean includeEIUT6
    Boolean includeXC97E
    Boolean includeXV7ZN
    Boolean includeIA789
    Boolean includeW607K

    #HG002 (child), HG003 (dad), HG004 (mom)
    String subject 
  }



  command <<<
    downloadList=("")
    optvcfs=""
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
    
    for value in "${downloadList[@]}"
    do
         echo $value
         gsutil cp $value .
    done
    
    mkdir -p Intervene_results
    mkdir -p Intervene_results/sets
    echo "intervene upset --figtype png --type reentrant -i $optvcfs --save-overlaps --filenames --bedtools-options header"
    intervene upset --figtype png --type genomic -i $optvcfs --save-overlaps --filenames --bedtools-options header
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
