#!/usr/bin/env Rscript
library(dplyr)
library(tidyr)
##USAGE: Rscript aggregateExtended.R job_id workflow_instance_identifier workflow_identifier extended.csv outputfile


#args = commandArgs(trailingOnly=TRUE)
args = commandArgs(TRUE)
if (length(args)<5)
  stop("Expecting job inst work [files]")

job_id<-args[1]
workflow_inst<-args[2]
workflow_id<-args[3]

wes<-args[4]

outputfile <- args[5]

read.csv(wes,header=TRUE) %>% dplyr::mutate(WorkflowId=workflow_id,
                                            WorkflowInstanceID=workflow_inst,
                                            JobRunID=job_id) %>%
                                            dplyr::rename(Region=Subset) %>%
                                            dplyr::filter(Subtype=='*') %>%
                                            dplyr::filter(Genotype=='*') %>%
  gather(key = "variable", value="value", -WorkflowInstanceID, -WorkflowId, -JobRunID, -Type, -Filter, -Region, -Subtype, -Genotype) %>%
  write.table(row.names=FALSE,sep="\t",file=outputfile,quote=FALSE)


#rbind(temp1,temp2) %>% reshape2::melt(.id.vars=c('WorkflowInstanceID','WorkflowId','JobRunID','Sample','Type,','Filter')) %>% write.table(row.names=FALSE,sep="\t",file="",quote=FALSE)


#Subsets: hap.py v0.3.7+ writes subsets TS_contained and TS_boundary by default, corresponding to truth variants well contained or at the boundary of confident regions. In some truthsets, those in TS_boundary will show worse performance metrics due to issues with variant representation or a partial haplotype description.

#Subtypes: Insertion subtypes are of the form: [IDC]length_range where the first letter indicates the variant classification: I insertion; D deletion; and C complex. Hap.py bins the lengths of these records into ranges by ALT allele length in basepairs: 1_5, 6_15 and 16_PLUS.

