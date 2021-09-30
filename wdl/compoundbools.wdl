version 1.0


struct PopularRegions {
  Boolean Twist_Exome_Target_hg38
  Boolean region_GRCh38_alldifficultregions
  Boolean region_GRCh38_MHC
  Boolean region_HG002_GIAB_highconfidence
}
    
    
struct FunctionalRegions {
  Boolean region_GRCh38_notinrefseq_cds
  Boolean region_GRCh38_refseq_cds
  Boolean region_GRCh38_BadPromoters
}

struct GCcontent {
  Boolean region_GRCh38_gc15_slop50
  Boolean region_GRCh38_gc15to20_slop50
  Boolean region_GRCh38_gc20to25_slop50
  Boolean region_GRCh38_gc25to30_slop50
  Boolean region_GRCh38_gc30to55_slop50
  Boolean region_GRCh38_gc55to60_slop50
  Boolean region_GRCh38_gc60to65_slop50
  Boolean region_GRCh38_gc65to70_slop50
  Boolean region_GRCh38_gc70to75_slop50
  Boolean region_GRCh38_gc75to80_slop50
  Boolean region_GRCh38_gc80to85_slop50
  Boolean region_GRCh38_gc85_slop50
  Boolean region_GRCh38_gclt25orgt65_slop50
  Boolean region_GRCh38_gclt30orgt55_slop50
}

struct GenomeSpecificSon {
  Boolean region_GRCh38_HG002_GIABv41_CNV_CCSandONT_elliptical_outlier
  Boolean region_GRCh38_HG002_GIABv41_CNV_mrcanavarIllumina_CCShighcov_ONThighcov_intersection
  Boolean region_GRCh38_HG002_expanded_150__Tier1plusTier2_v061
  Boolean region_GRCh38_HG002_GIABv322_compoundhet_slop50
  Boolean region_GRCh38_HG002_GIABv322_varswithin50bp
  Boolean region_GRCh38_HG002_GIABv332_comphetindel10bp_slop50
  Boolean region_GRCh38_HG002_GIABv332_comphetsnp10bp_slop50
  Boolean region_GRCh38_HG002_GIABv332_complexandSVs
  Boolean region_GRCh38_HG002_GIABv332_complexandSVs_alldifficultregions
  Boolean region_GRCh38_HG002_GIABv332_complexindel10bp_slop50
  Boolean region_GRCh38_HG002_GIABv332_notin_complexandSVs_alldifficultregions
  Boolean region_GRCh38_HG002_GIABv332_snpswithin10bp_slop50
  Boolean region_GRCh38_HG002_GIABv41_CNVsandSVs
  Boolean region_GRCh38_HG002_GIABv41_comphetindel10bp_slop50
  Boolean region_GRCh38_HG002_GIABv41_comphetsnp10bp_slop50
  Boolean region_GRCh38_HG002_GIABv41_complexandSVs
  Boolean region_GRCh38_HG002_GIABv41_complexandSVs_alldifficultregions
  Boolean region_GRCh38_HG002_GIABv41_complexindel10bp_slop50
  Boolean region_GRCh38_HG002_GIABv41_notin_complexandSVs_alldifficultregions
  Boolean region_GRCh38_HG002_GIABv41_othercomplexwithin10bp_slop50
  Boolean region_GRCh38_HG002_GIABv41_snpswithin10bp_slop50
  Boolean region_GRCh38_HG002_GIABv41_CNV_gt2assemblycontigs_ONTCanu_ONTFlye_CCSCanu
  Boolean region_GRCh38_HG002_GIABv41_inversions_slop25percent
  Boolean region_GRCh38_HG002_Tier1plusTier2_v061
}

struct GenomeSpecificDad {
    Boolean region_GRCh38_HG003_GIABv332_comphetindel10bp_slop50
    Boolean region_GRCh38_HG003_GIABv332_comphetsnp10bp_slop50
    Boolean region_GRCh38_HG003_GIABv332_complexandSVs
    Boolean region_GRCh38_HG003_GIABv332_complexandSVs_alldifficultregions
    Boolean region_GRCh38_HG003_GIABv332_complexindel10bp_slop50
    Boolean region_GRCh38_HG003_GIABv332_notin_complexandSVs_alldifficultregions
    Boolean region_GRCh38_HG003_GIABv332_snpswithin10bp_slop50
}

struct GenomeSpecificMom {
  Boolean region_GRCh38_HG004_GIABv332_comphetindel10bp_slop50
  Boolean region_GRCh38_HG004_GIABv332_comphetsnp10bp_slop50
  Boolean region_GRCh38_HG004_GIABv332_complexandSVs
  Boolean region_GRCh38_HG004_GIABv332_complexandSVs_alldifficultregions
  Boolean region_GRCh38_HG004_GIABv332_complexindel10bp_slop50
  Boolean region_GRCh38_HG004_GIABv332_notin_complexandSVs_alldifficultregions
  Boolean region_GRCh38_HG004_GIABv332_snpswithin10bp_slop50
}

struct GenomeSpecificOther {
  Boolean region_GRCh38_HG001_GIABv322_compoundhet_slop50
  Boolean region_GRCh38_HG001_GIABv322_varswithin50bp
  Boolean region_GRCh38_HG001_GIABv332_comphetindel10bp_slop50
  Boolean region_GRCh38_HG001_GIABv332_comphetsnp10bp_slop50
  Boolean region_GRCh38_HG001_GIABv332_complexandSVs
  Boolean region_GRCh38_HG001_GIABv332_complexindel10bp_slop50
  Boolean region_GRCh38_HG001_GIABv332_RTG_PG_v332_SVs_alldifficultregions
  Boolean region_GRCh38_HG001_GIABv332_RTG_PG_v332_SVs_notin_alldifficultregions
  Boolean region_GRCh38_HG001_GIABv332_snpswithin10bp_slop50
  Boolean region_GRCh38_HG001_PacBio_MetaSV
  Boolean region_GRCh38_HG001_PG2016_10_comphetindel10bp_slop50
  Boolean region_GRCh38_HG001_PG2016_10_comphetsnp10bp_slop50
  Boolean region_GRCh38_HG001_PG2016_10_complexindel10bp_slop50
  Boolean region_GRCh38_HG001_PG2016_10_snpswithin10bp_slop50
  Boolean region_GRCh38_HG001_RTG_3773_comphetindel10bp_slop50
  Boolean region_GRCh38_HG001_RTG_3773_comphetsnp10bp_slop50
  Boolean region_GRCh38_HG001_RTG_3773_complexindel10bp_slop50
  Boolean region_GRCh38_HG001_RTG_3773_snpswithin10bp_slop50
  Boolean region_GRCh38_HG002_HG003_HG004_allsvs
  Boolean region_GRCh38_HG005_GIABv332_comphetindel10bp_slop50
  Boolean region_GRCh38_HG005_GIABv332_comphetsnp10bp_slop50
  Boolean region_GRCh38_HG005_GIABv332_complexandSVs
  Boolean region_GRCh38_HG005_GIABv332_complexandSVs_alldifficultregions
  Boolean region_GRCh38_HG005_GIABv332_complexindel10bp_slop50
  Boolean region_GRCh38_HG005_GIABv332_notin_complexandSVs_alldifficultregions
  Boolean region_GRCh38_HG005_GIABv332_snpswithin10bp_slop50
  Boolean region_GRCh38_HG005_HG006_HG007_MetaSV_allsvs
}
  
  
struct LowComplexity {
  Boolean region_GRCh38_AllHomopolymers_gt6bp_imperfectgt10bp_slop5
  Boolean region_GRCh38_AllTandemRepeats_201to10000bp_slop5
  Boolean region_GRCh38_AllTandemRepeats_51to200bp_slop5
  Boolean region_GRCh38_AllTandemRepeats_gt10000bp_slop5
  Boolean region_GRCh38_AllTandemRepeats_gt100bp_slop5
  Boolean region_GRCh38_AllTandemRepeats_lt51bp_slop5
  Boolean region_GRCh38_AllTandemRepeatsandHomopolymers_slop5
  Boolean region_GRCh38_notinAllHomopolymers_gt6bp_imperfectgt10bp_slop5
  Boolean region_GRCh38_notinAllTandemRepeatsandHomopolymers_slop5
  Boolean region_GRCh38_SimpleRepeat_diTR_11to50_slop5
  Boolean region_GRCh38_SimpleRepeat_diTR_51to200_slop5
  Boolean region_GRCh38_SimpleRepeat_diTR_gt200_slop5
  Boolean region_GRCh38_SimpleRepeat_homopolymer_4to6_slop5
  Boolean region_GRCh38_SimpleRepeat_homopolymer_7to11_slop5
  Boolean region_GRCh38_SimpleRepeat_homopolymer_gt11_slop5
  Boolean region_GRCh38_SimpleRepeat_imperfecthomopolgt10_slop5
  Boolean region_GRCh38_SimpleRepeat_quadTR_20to50_slop5
  Boolean region_GRCh38_SimpleRepeat_quadTR_51to200_slop5
  Boolean region_GRCh38_SimpleRepeat_quadTR_gt200_slop5
  Boolean region_GRCh38_SimpleRepeat_triTR_15to50_slop5
  Boolean region_GRCh38_SimpleRepeat_triTR_51to200_slop5
  Boolean region_GRCh38_SimpleRepeat_triTR_gt200_slop5
}

struct Mappability {
  Boolean region_GRCh38_nonunique_l100_m2_e1
  Boolean region_GRCh38_nonunique_l250_m0_e0
  Boolean region_GRCh38_lowmappabilityall
  Boolean region_GRCh38_notinlowmappabilityall
}

struct OtherDifficult {
  Boolean region_GRCh38_allOtherDifficultregions
  Boolean region_GRCh38_contigs_lt500kb
  Boolean region_GRCh38_gaps_slop15kb
  Boolean region_GRCh38_L1H_gt500
  Boolean region_GRCh38_VDJ
}

struct SegmentalDuplications {
  Boolean region_GRCh38_chainSelf
  Boolean region_GRCh38_chainSelf_gt10kb
  Boolean region_GRCh38_gt5segdups_gt10kb_gt99percidentity
  Boolean region_GRCh38_notinchainSelf
  Boolean region_GRCh38_notinchainSelf_gt10kb
  Boolean region_GRCh38_notinsegdups
  Boolean region_GRCh38_notinsegdups_gt10kb
  Boolean region_GRCh38_segdups
  Boolean region_GRCh38_segdups_gt10kb
}

struct Union {
  Boolean region_GRCh38_alllowmapandsegdupregions
  Boolean region_GRCh38_notinalldifficultregions
  Boolean region_GRCh38_notinalllowmapandsegdupregions
}
