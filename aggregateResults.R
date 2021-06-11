#!/usr/bin/env Rscript
library(dplyr)
library(tidyr)
##USAGE: Rscript aggregateResults.R job_id workflow_instance_identifier workflow_identifier [files]


#args = commandArgs(trailingOnly=TRUE)
args = commandArgs(TRUE)
if (length(args)<5)
  stop("Expecting job inst work [files]")

job_id<-args[1]
workflow_inst<-args[2]
workflow_id<-args[3]

wes<-args[4]
cds<-args[5]

outputfile <- args[6]
read.csv(wes,header=TRUE) %>% dplyr::mutate(WorkflowId=workflow_id,
                                            WorkflowInstanceID=workflow_inst,
                                            JobRunID=job_id,
                                            Type='WholeExome') -> temp1

read.csv(wes,header=TRUE) %>% dplyr::mutate(WorkflowId=workflow_id,
                                            WorkflowInstanceID=workflow_inst,
                                            JobRunID=job_id,
                                            Type='CodingSequence') -> temp2

#rbind(temp1,temp2) %>% reshape2::melt(.id.vars=c('WorkflowInstanceID','WorkflowId','JobRunID','Sample','Type,','Filter')) %>% write.table(row.names=FALSE,sep="\t",file="",quote=FALSE)

rbind(temp1,temp2) %>% gather(key = "variable", value="value", -WorkflowInstanceID, -WorkflowId, -JobRunID, -Type, -Filter) %>% write.table(row.names=FALSE,sep="\t",file=outputfile,quote=FALSE)