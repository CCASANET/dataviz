#############################################################
#
#   Program: panel_graphic2.R
#  
#   Project: Leverage DES for interactive graphics
#
#   Biostatisticians: Meridith Blevins, MS**
#                     Bryan E Shepherd, PhD
#   ** contact programmer: meridith.blevins at vanderbilt.edu
#
#   Purpose: Reproducible research.
#
#   Notes: 
#          
#   Shared to GitHub: 6 February 2015
#	  
#   Revisions: 
#   
#
#############################################################
# setwd("~/Projects/CCASAnet/dataviz")
rm(list=ls()) # SHOULD BE FIRST LINE IN ALL R PROGRAMS - CLEARS NAMESPACE

## Rather than instruct the user to install packages, these calls look for existing packages
##    and install required packages. 
required_packages <- c("scales","RColorBrewer","brew")
install_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(install_packages)) install.packages(install_packages)
set.seed(2)

## READ IN UTILITY FUNCTIONS
source("~/Projects/IeDEAS/qa-checks-r/code/utility_functions.R")

specs <- read.csv("input/panel2_specs.csv",header=TRUE,stringsAsFactors = FALSE,na.strings=c(NA,""))

for(i in 1:nrow(specs)){
  if(!is.na(specs$specification[i])){
     assign(specs$name[i],specs$specification[i])
  }
  if(is.na(specs$specification[i])){
     if(specs$name[i] %in% c('id','longtablename','longvar','longvardate','eventtablename','event','enddate',
                             'grouptablename','group','starttablename','startdate')){
        stop(paste("Mandatory variable has not been specified:",specs$name[i]))
     }
  }
}  
## READ IN DATA FILES
readtables <- unique(c(vartable))
source("code/load_data.R")

## EVALUATE ASSIGNED VARIABLES
vartable <- get(vartable)
if(exists("var1")){var1 <- eval(parse(text=var1))}
if(exists("var2")){var2 <- eval(parse(text=var2))}
if(exists("vartablesubset")){
  vartablesubset <- eval(parse(text=vartablesubset))
  vartable <- vartable[vartablesubset,]
  var1 <- var1[vartablesubset]
  var2 <- var2[vartablesubset]
}
eventdate <- get(eventdate,vartable)
group <- get(group,vartable)

## FILL IN DEFAULTS
if(!exists("minnum")){minnum <- 10}
if(!exists("var1label1")){var1label1 <- "Variable 1 Attribute"}
if(!exists("var1label0")){var1label0 <- "Non-var 1 Attribute"}
if(!exists("var1label")){var1label <- "Proportion with variable 1 attribute"}
if(!exists("var2label1")){var2label1 <- "Variable 2 Attribute"}
if(!exists("var2label0")){var2label0 <- "Non-var 2 Attribute"}
if(!exists("var2label")){var2label <- "Proportion with variable 2 attribute"}
if(!exists("eventperiod")){eventperiod <- "year"}


## DEFAULT IS YEAR
if(eventperiod=="year"){
   eventtime <- format(convertdate(eventdate),"%Y")
}
if(eventperiod=="month"){
   eventtime <- format(convertdate(eventdate),"%m-%Y")
}
if(eventperiod=="quarter"){
   monthtime <- as.numeric(format(convertdate(eventdate),"%m"))
    f <- function(m) {
	if (m %in% c(1,2,3)) { return(1) }
	else if (m %in% c(4,5,6)) { return(2) }
	else if (m %in% c(7,8,9)) { return(3) }
	else if (m %in% c(10,11,12)) { return(4) }
    }
   quartertime <- sapply(monthtime,f,simplify=TRUE)
   eventtime <- paste(format(convertdate(eventdate),"%Y"),"-","Q",quartertime,sep="")
}
if(!is.na(eventperiod) & !(eventperiod %in% c("","month","quarter","year"))){stop("Unexpected value for eventperiod; allowable values are <missing>, year, month, quarter.")}
vartable <- droplevels(vartable)

## GET PROPORTION WITH VAR1 ATTRIBUTE
agg1 <- aggregate(var1,by=list(group,eventtime),FUN="mean",na.rm=TRUE)
names(agg1) <- c("group","year","var1_prop")
## GET PROPORTION WITH VAR2 ATTRIBUTE
agg2 <- aggregate(var2,by=list(group,eventtime),FUN="mean",na.rm=TRUE)
names(agg2) <- c("group","year","var2_prop")
## GET COUNT AT DIAGNOSIS 
agg3 <- aggregate(rep(1,length(group)),by=list(group,eventtime),FUN="sum",na.rm=TRUE)
names(agg3) <- c("group","year","diagnum")
data <- merge(merge(agg1,agg2),agg3)
data <- data[data$diagnum >= minnum,]
## DETERMINE SIZE OF CIRCLES
data$radius<-sqrt(data$diagnum/(pi))
data$radius <- data$radius/(4*max(data$radius))
## ASSIGN COLOR PALETTE
library(RColorBrewer)
mypalette <- data.frame(brewer.pal(length(unique(data$group)), "Set1"),unique(data$group))
data$mypalette <- mypalette[match(data$group,mypalette[,2]),1]

library(scales)

ngroup <- length(unique(data$group))
nx <- ceiling(sqrt(ngroup))
ny <- floor(sqrt(ngroup))
gridx <- seq(0,1,length.out=nx+1)
gridy <- seq(0,0.5,length.out=ny+1)
figspace <- cbind(gridx[-(nx+1)],gridx[-1],gridy[1],gridy[2])
for(ni in 2:ny){
  figspace <- rbind(figspace,cbind(gridx[-4],gridx[-1],gridy[ni],gridy[ni+1]))
}


agg1a <- aggregate(var1 & var2,by=list(group,eventtime),FUN="mean",na.rm=TRUE)
names(agg1a) <- c("group","year","var1_var2_dist") ## var1_nonvar2
agg1a$x <- 1.5
agg1a$y <- 0.5
agg1b <- aggregate(var1 & !var2,by=list(group,eventtime),FUN="mean",na.rm=TRUE)
names(agg1b) <- c("group","year","var1_var2_dist") ## var1_var2
agg1b$x <- 1.5
agg1b$y <- 1.5
agg1c <- aggregate(!var1 & var2,by=list(group,eventtime),FUN="mean",na.rm=TRUE)
names(agg1c) <- c("group","year","var1_var2_dist") ## non_var1_nonvar2
agg1c$x <- 0.5
agg1c$y <- 0.5
agg1d <- aggregate(!var1 & !var2,by=list(group,eventtime),FUN="mean",na.rm=TRUE)
names(agg1d) <- c("group","year","var1_var2_dist")  ## non_var1_var2
agg1d$x <- 0.5
agg1d$y <- 1.5
cdata <- rbind(agg1a,agg1b,agg1c,agg1d)
cdata$mypalette <- mypalette[match(cdata$group,mypalette[,2]),1]
cdata$radius<-sqrt(cdata$var1_var2_dist/pi)
cdata$radius <- cdata$radius/(2*max(cdata$radius))

create_panel2 <- function(i,m){
  png(paste0("output/scroll_images/panel_graphic2_",sprintf("%04d",m),".png"),res=100,width=500,height=800) 
    par(mar=c(3.5,3,1.2,.7),mgp=c(2.2,1,0))
    ## TOP PANEL 
    par(fig=c(0,1,0.5,1))
    symbols(data$var1_prop[data$year==i],data$var2_prop[data$year==i],
            circles=data$radius[data$year==i],fg=1,bg=alpha(data$mypalette[data$year==i],.5),
            xlim=c(0,max(data$var1_prop)+0.05),ylim=c(0,max(data$var2_prop)+0.05),lwd=2,xlab=var1label,ylab=var2label,main=i,inches=FALSE)
    text(data$var1_prop[data$year==i],data$var2_prop[data$year==i], data$group[data$year==i], cex=1,font=2)
ngroup <- length(data$group[data$year==i])
for(r in 1:ngroup){
  k <- data$group[data$year==i][r]
  par(fig=c(figspace[r,]), new=TRUE) 
  symbols(cdata$x[cdata$year==i & cdata$group==k],cdata$y[cdata$year==i & cdata$group==k],
            circles=cdata$radius[cdata$year==i & cdata$group==k],fg=1,bg=alpha(cdata$mypalette[cdata$year==i & cdata$group==k],.5),
            xlim=c(0,2),ylim=c(0,2),lwd=2,ylab="",xlab="",main=paste(k,i),axes=FALSE,inches=FALSE, xaxs="i", yaxs="i",cex.main=0.9)
  abline(h=1)
  abline(v=1)
  axis(1,at=c(0.5,1.5),label=c(var1label0,var1label1),cex.axis=0.65)
  axis(2,at=c(0.5,1.5),label=c(var2label0,var2label1),cex.axis=0.65)
  box()
  }
  dev.off()
}
## THIS CODE PRODUCES 1 FRAME PER STILL OBJECT 

m <- 1
k <- length(unique(data$year))
for(j in 1:k){ 
     i <- sort(unique(data$year))[j]
     create_panel2(i,m)
     m <- m + 1
}

panelkey <- "panel_graphic2_"
maxtime <- m
speed <- 2000
library(brew)
brew('code/scroll.brew', output='output/panel2_viewer.html')

