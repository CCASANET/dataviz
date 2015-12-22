#############################################################
#
#   Program: add_cd4_base.R
#  
#   Project: Leverage DES for interactive graphics
#
#   Biostatisticians: Meridith Blevins, MS**
#                     Bryan E Shepherd, PhD
#   ** contact programmer: meridith.blevins at vanderbilt.edu
#
#   Purpose: This short program estimates CD4 count within 90
#            days of baseline date and merges this information
#            onto tblBASIC for use in panel2_graphic example.
#
#   Notes: 
#          
#   Published: 4 March 2015
#	  
#   Revisions: 
#   
#
#############################################################
# setwd("~/Projects/CCASAnet/dataviz")
rm(list=ls()) # SHOULD BE FIRST LINE IN ALL R PROGRAMS - CLEARS NAMESPACE

set.seed(2)

## READ IN UTILITY FUNCTIONS
source("code/utility_functions.R")

## READ IN DATA FILES
readtables <- c("basic_sim","lab_cd4_sim")
source("code/load_data.R")

lab_cd4_sim <- merge(lab_cd4_sim,basic_sim[c("patient","baseline_d")],all.x=TRUE)
lab_cd4_sim <- lab_cd4_sim[!is.na(lab_cd4_sim$cd4_v) & !is.na(lab_cd4_sim$cd4_d),]
lab_cd4_sim <- lab_cd4_sim[!duplicated(paste(lab_cd4_sim$patient,lab_cd4_sim$cd4_d)),]
cd4_baseline <- getbaseline(baseline_d,cd4_d,patient,value=cd4_v,before=90,after=90,type="closest",data=lab_cd4_sim,dateformat="%Y-%m-%d")
basic_cd4 <- merge(basic_sim,cd4_baseline,by.x="patient",by.y="id")

write.csv(basic_cd4,"input/basic_cd4_sim.csv",na="",row.names=FALSE)
