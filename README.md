# chlsdm
Species distribution modelling pipeline of the Conservation Herpetology Lab.

# Installation
library(devtools)

install_github("edvardmizsei/chlsdm")

# Use

## Process presence point data

pres <- read.csv("") # WGS84 x=lon, y=lat

pres2 <- spatbalsample(pres,0.1,100) # spatially balanced resampling of your points

pres3 <- remoutlier(pres2,4326,90) # remove outlier points based on density estimation

## Process environmental raster data

study_area <- st_read("") # polygon of your study area

envproc(study_area,env_dir,"asc",out_dir) # crop & mask, save ratsers

env <- loadenv(env_dir) # load rasters prepared by envproc

envs_selected <- envselect(pres,env,10,0.7) # select environmental variables based onf correlation, explanatory power and VIF

env <- subset(env,envs_selected)

## Fit species distribution models

mysdm <- chlsdm(pres,env,temporary_dir,"My species",c("GLM",ANN"),panum=4,cvrep=4,cores=4) # runs BIOMOD2 distribution modelling framework

plot(mysdm)
