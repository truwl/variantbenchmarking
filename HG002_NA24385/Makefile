Truth.highconf.WholeExome.vcf.gz:
  bedtools intersect -header -a HG002_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-22_v3.3_highconf.vcf.gz -b HG002_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-22_v3.3_highconf.bed | gzip -c > Truth.highconf.WholeExome.vcf.gz

#https://www.biorxiv.org/content/10.1101/643163v1.full.pdf
HG002_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-22_v3.3_highconf.bed
  wget -c ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/AshkenazimTrio/HG002_NA24385_son/NISTv3.3/HG002_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-22_v3.3_highconf.bed

#UCSC table browser > hg19 > ccdsGene > bed output > just codingexons not genes
codingexons.bed:
  wget -O codingexons.bed "https://genome.ucsc.edu/cgi-bin/hgTables?hgsid=1116036981_vGaSTxzvFTKGluAsa32IRjcoiRg6&boolshad.hgta_printCustomTrackHeaders=0&hgta_ctName=tb_ccdsGene&hgta_ctDesc=table+browser+query+on+ccdsGene&hgta_ctVis=pack&hgta_ctUrl=&fbUpBases=200&fbExonBases=0&fbIntronBases=0&fbQual=cds&fbDownBases=200&hgta_doGetBed=get+BED"

codingexons.nochr.bed: codingexons.bed
 cat codingexons.bed | sed -e 's/chr//' > codingexons.nochr.bed

Truth.highconf.CodingExons.vcf.gz: codingexons.nochr.bed
  bedtools intersect -header -a Truth.highconf.WholeExome.vcf.gz -b codingexons.nochr.bed | gzip -c > Truth.highconf.CodingExons.vcf.gz

#not these?
#bedtools intersect -header -a Truth.highconf.WholeExome.vcf.gz -b codinggenes.nochr.bed | gzip -c > Truth.highconf.CodingGenes.vcf.gz
#cat codinggenes.bed | sed -e 's/chr//' > codinggenes.nochr.bed

#this was mentioned in https://www.nature.com/articles/sdata201625#Sec43
query.vcf:
  wget -O HG002run1_S1.genome.vcf.gz ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG002_NA24385_son/NIST_HiSeq_HG002_Homogeneity-10953946//HG002Run01-11419412/HG002run1_S1.genome.vcf.gz
  gunzip -c HG002run1_S1.genome.vcf.gz  | sed -e 's/chr//' > query.vcf

# see also  https://www.biorxiv.org/content/10.1101/2020.07.24.212712v1.full.pdf