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
#            days of baseline date and aggregates this information
#            across country for use in map1 example.
#
#   Notes: 
#          
#   Published: 25 March 2015
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

lab_cd4_sim <- merge(lab_cd4_sim,basic_sim[c("patient","hivdiagnosis_d")],all.x=TRUE)
lab_cd4_sim <- lab_cd4_sim[!is.na(lab_cd4_sim$cd4_v) & !is.na(lab_cd4_sim$cd4_d),]
lab_cd4_sim <- lab_cd4_sim[!duplicated(paste(lab_cd4_sim$patient,lab_cd4_sim$cd4_d)),]
cd4_baseline <- getbaseline(hivdiagnosis_d,cd4_d,patient,value=cd4_v,before=90,after=90,type="closest",data=lab_cd4_sim,dateformat="%Y-%m-%d")
basic_cd4 <- merge(basic_sim,cd4_baseline,by.x="patient",by.y="id")

library(countrycode)
basic_cd4$country <- countrycode(basic_cd4$site,"country.name","iso3c")
basic_cd4$eventtime <- format(convertdate(hivdiagnosis_d,basic_cd4),"%Y")

## GET PROPORTION WITH CD4 < 200 by COUNTRY AND YEAR
agg1 <- with(basic_cd4[!is.na(basic_cd4$cd4_v_cmp),],aggregate(cd4_v_cmp<200,by=list(country,eventtime),FUN="mean",na.rm=TRUE))
names(agg1) <- c("country","year","var1_prop")
## GET COUNT AT BASELINE 
basic_cd4$ones <- 1
agg2 <- with(basic_cd4[!is.na(basic_cd4$cd4_v_cmp),],aggregate(ones,by=list(country,eventtime),FUN="sum",na.rm=TRUE))
names(agg2) <- c("country","year","diagnum")
data <- merge(agg1,agg2)
data <- data[data$diagnum>20,]
# data <- merge(merge(agg1,agg2),center[c("country","geocode_lat","geocode_lon")]

write.csv(data,"input/basic_cd4_country.csv",na="",row.names=FALSE)
