## Generating the Indel distribution for WholeExome using bcftools, USE TRUTH VCF ! (not Happy's annotated VCF)
task indelDistribution_WholeExome_HappyResults
	input {
		String outputFile_commonPrefix
		String WholeExomePrefix
		File truthWholeExomeVCF
		String indelDistributionSuffix
 	}
	output {
		File indelDistribution_WholeExome
		source:
         filename: "{{outputFile_commonPrefix}}{{WholeExomePrefix}}{{indelDistributionSuffix}}"
																																																		 }
 		command { start=`bcftools stats {{truthWholeExomeVCF}}| awk '/InDel distribution/ {print FNR}'`; end=`bcftools stats {{truthWholeExomeVCF}}| awk '/Substitution types/ {print FNR}'`; end=$((end - 1)); bcftools stats {{truthWholeExomeVCF}}| sed -n "$start,$end p" > {{indelDistribution_WholeExome}}
    runtime {
           docker_image: vandhanak/bcftools:1.3.1
					 memory: "8"
           cores: "1"}

## Generating the Indel distribution for Coding Exons based on size ranges + TP,FP,FN counts for each size range
task indelSizeDistribution_CodingExons_HappyResults
	input {
		String outputFile_commonPrefix
		String codingExonsPrefix
		File indelDistribution_CodingExons
		String indelSizeDistributionSuffix
		String indelSizeDistributionPlotSuffix
		File codingExons_annotated_TPonly_vcf_gz
		File codingExons_annotated_FPonly_vcf_gz
		File codingExons_annotated_FNonly_vcf_gz
		File Rscript_indelSize
	}
	 output {
		File indelSizeDistribution_CodingExons
       source:
         filename: "{{outputFile_commonPrefix}}{{codingExonsPrefix}}{{indelSizeDistributionSuffix}}"
		File indelSizeDistributionPlot_CodingExons
       source:
         filename: "{{outputFile_commonPrefix}}{{codingExonsPrefix}}{{indelSizeDistributionPlotSuffix}}"
 		command { Rscript ~{Rscript_indelSize} ~{indelDistribution_CodingExons} ~{codingExons_annotated_TPonly_vcf_gz} ~{codingExons_annotated_FPonly_vcf_gz} {{codingExons_annotated_FNonly_vcf_gz}} {{indelSizeDistribution_CodingExons}} {{indelSizeDistributionPlot_CodingExons}}
    runtime {
           docker_image: vandhanak/rbase:3.3.2
					memory: "8"
           cores: "1"

## Generating the Indel distribution for WholeExome based on size ranges + TP,FP,FN counts for each size range
task indelSizeDistribution_WholeExome_HappyResults
	input {
		String outputFile_commonPrefix
		String WholeExomePrefix
		File indelDistribution_WholeExome
		String indelSizeDistributionSuffix
		String indelSizeDistributionPlotSuffix
		File WholeExome_annotated_TPonly_vcf_gz
		File WholeExome_annotated_FPonly_vcf_gz
		File WholeExome_annotated_FNonly_vcf_gz
		File Rscript_indelSize
	}
	 output {
		File indelSizeDistribution_WholeExome
       source:
         filename: "{{outputFile_commonPrefix}}{{WholeExomePrefix}}{{indelSizeDistributionSuffix}}"
		File indelSizeDistributionPlot_WholeExome
       source:
         filename:  "{{outputFile_commonPrefix}}{{WholeExomePrefix}}{{indelSizeDistributionPlotSuffix}}"
 		command { Rscript {{Rscript_indelSize}} {{indelDistribution_WholeExome}} {{WholeExome_annotated_TPonly_vcf_gz}} {{WholeExome_annotated_FPonly_vcf_gz}} {{WholeExome_annotated_FNonly_vcf_gz}} {{indelSizeDistribution_WholeExome}} {{indelSizeDistributionPlot_WholeExome}}
    runtime {
           docker_image: vandhanak/rbase:3.3.2
					memory: "8"
           cores: "1"
