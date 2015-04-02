#############################################################
#
#   Program: map1.R
#   Project: IeDEA
# 
#   Biostatistician/Programmer: Meridith Blevins, MS
#   Purpose: Read in IeDEA standard and create maps
#
#   INPUT: ""
#   OUTPUT: ""
#
#   Notes: As long as the working directory structure 
#          matches README.md, such that the countryname table,
#          R-code, and resources may be sourced, 
#          then this code should run smoothly, generating
#          maps as output.
#
#   Dependency: brew, rgdal, latticeExtra and cshapes (which loads addtl
#               dependencies)
#   Created: 25 March 2015
#     
#############################################################
## USER -- PLEASE REVISE or CHANGE THE APPROPRIATE WORKING DIRECTORY USING RSTUDIO
# setwd("/home/blevinml/Projects/CCASAnet/dataviz")

rm(list=ls()) # clear namespace

## Rather than instruct the user to install packages, these calls look for existing packages
##    and install required packages. 
required_packages <- c("cshapes","latticeExtra","brew","rgdal")
install_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(install_packages)) install.packages(install_packages)

## Load the packages required for this script
library(cshapes)
library(latticeExtra)
library(brew)
library(rgdal)

## READ IN UTILITY FUNCTIONS
source("code/utility_functions.R")

specs <- read.csv("input/map1_specs.csv",header=TRUE,stringsAsFactors = FALSE,na.strings=c(NA,""))

for(i in 1:nrow(specs)){
  if(!is.na(specs$specification[i])){
    assign(specs$name[i],specs$specification[i])
  }
}  
## READ IN DATA FILES
readtables <- unique(c(countrytable))
source("code/load_data.R")
countrytable <- get(countrytable)
year <- get(year,countrytable)
country <- get(country,countrytable)
var <- get(var,countrytable)


## LATER MADE USE OF CSHAPES PACKAGE BECAUSE IT IS MOST CURRENT (2012)
cmap <- cshp(date=as.Date("2012-6-30"))
## USING THE ROBINSON PROJECTION AS RECOMMEDED BY COLLEAGUE, PETER REBERIO
# cmap <- spTransform(cmap1, CRS("+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"))



## WRITE MAP FILES -- CREATE OUTPUT DIRECTORY (IF NEEDED)
wd <- getwd(); if(!file.exists("output")){dir.create(file.path(wd,"output"))}
if(!file.exists("output/scroll_images")){dir.create(file.path(wd,"output/scroll_images"))}


var.cut <- function(x, lower = 0, upper, by = 10,
                    sep = "-", above.char = "+") {
  
  labs <- c(paste(seq(lower, upper - by, by = by),
                  seq(lower + by - 1, upper - 1, by = by),
                  sep = sep),
            paste(upper, above.char, sep = ""))
  
  cut(floor(x), breaks = c(seq(lower, upper, by = by), Inf),
      right = FALSE, labels = labs)
}
## change proportions to percentages for maps
if(all(var < 1.01)) varcat <- sapply(var*100,var.cut,upper=floor(max(var)*10)*10)
if(any(var > 1)) varcat <- sapply(var,var.cut,upper=floor(max(var)*10)*10)
varcat <- droplevels(varcat)

## DEFINE COLOR PALETTE
colvec <- colorRampPalette(c("white", "red"), space = "Lab", bias = 0.5)((length(unique(varcat))+1))[-1]
coldf <- data.frame(levels(varcat),colvec)
varcol <- coldf[match(varcat,coldf[,1]),2]

create_map1 <- function(i,m){
  ## SET OUR REGION DATA TOGETHER WITH THE SHP FILE
  ## THIS WOULD BE THE SECTION OF CODE TO INCLUDE COUNTRY 
  ## SPECIFIC INFORMATION IF AVAILABLE (e.g, HIV prevalence)
  uniquecountry <- data.frame(country,varcol,varcat)[year==i,]
  o <- match(cmap$ISO1AL3,uniquecountry[,1])
  uniquecountry <- uniquecountry[o,]
  # row.names(uniquecountry) <- cmap$FEATUREID
  countriesSPDF <- cmap
  countriesSPDF@data <- cbind(uniquecountry,cmap@data)
  countriesSPDF1 <- countriesSPDF[countriesSPDF@data$ISO1AL3 %in% country,]
  p1 <- spplot(countriesSPDF,"country", col.regions=as.character(countriesSPDF@data$varcol[!is.na(countriesSPDF@data$varcol)]), main=list(label=as.expression( bquote( atop(.(i), italic(.(varlabel) ) ) ) ),cex=1.5),colorkey=FALSE)
  p1 <- p1 + layer(panel.key(as.character(coldf[,1]), corner = c(.02,0.15), padding = 2,rectangles = TRUE, space="left",size=2, height=c(1,1), points = FALSE, lines = FALSE, packets = 1,cex=1))

  p2 <- spplot(countriesSPDF1,"country", col.regions=as.character(countriesSPDF1@data$varcol[!is.na(countriesSPDF1@data$varcol)]), main=list(label=as.expression( bquote( atop(.(i), italic(.(varlabel) ) ) ) ),cex=0.8),colorkey=FALSE)
  p2 <- p2 + layer(panel.key(as.character(coldf[,1]), corner = c(.02,0.15), padding = 2,rectangles = TRUE, space="left",size=2, height=c(1,1), points = FALSE, lines = FALSE, packets = 1,cex=1)) 
  
  png(paste0("output/scroll_images/map1_",sprintf("%04d",m),".png"),res=125,width=1200,height=600) 
  print(update(p1, par.settings =  custom.theme(symbol = as.character(colvec), fill = as.character(colvec), lwd=1)))
  dev.off()
  png(paste0("output/scroll_images/map2_",sprintf("%04d",m),".png"),res=125) 
  print(update(p2, par.settings =  custom.theme(symbol = as.character(colvec), fill = as.character(colvec), lwd=1)))
  dev.off()
}
## THIS CODE PRODUCES 1 OF EACH FRAME (WORLD VIEW AND ZOOMED VIEW) PER STILL OBJECT 

m <- 1
k <- length(unique(year))
## MAP 1
for(j in 1:k){ 
  i <- sort(unique(year))[j]
  create_map1(i,m)
  m <- m + 1
}

## COLLATE MAPS IN HTML FILE
panelkey <- "map1_"
maxtime <- m
speed <- 2000
brew('code/scroll.brew', output='output/map1_viewer.html')


## COLLATE MAPS IN HTML FILE
panelkey <- "map2_"
maxtime <- m
speed <- 2000
brew('code/scroll.brew', output='output/map2_viewer.html')

