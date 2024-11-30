chlsdm <- function(pres, env, dir, sp="species name", models=c("GLM","GAM","ANN","RF"),panum = 4, cvrep = 4, cores = 4) {
  library(biomod2)
  library(chlsdm)
  library(terra)
  library(sf)

  setwd(dir)

  # Convert presence data to SpatVector
  pr <- vect(st_as_sf(pres[, c("x", "y")], coords = c("x", "y"), crs = 4326))

  # Create pseudo-absence datasets using BIOMOD_FormatingData
  pa.datasets <- BIOMOD_FormatingData(resp.name = sp,
                                      resp.var = pr,
                                      expl.var = env,
                                      PA.nb.rep = panum,
                                      PA.nb.absences = nrow(pr) * 100,
                                      PA.strategy = 'random',
                                      na.rm = TRUE)

  # Set modeling options
  myBiomodOption <- BIOMOD_ModelingOptions()

  # Run modeling
  sdmi <- BIOMOD_Modeling(bm.format = pa.datasets,
                          models = models,
                          CV.nb.rep = cvrep,
                          CV.perc = 0.8,
                          nb.cpu = cores)

  # Project the models to the environment
  sdmp <- BIOMOD_Projection(bm.mod = sdmi,
                            new.env = env,
                            proj.name = "chlsdm")

  # Create ensemble models
  sdme <- BIOMOD_EnsembleModeling(bm.mod = sdmi,
                                  em.algo = c('EMmean', 'EMca'),
                                  metric.select = c('TSS'),
                                  metric.select.thresh = c(0.7),
                                  metric.eval = c('TSS'))

  # Create ensemble forecast
  sdmef <- BIOMOD_EnsembleForecasting(bm.me = sdme,
                                      bm.proj = sdmp,
                                      output.format = ".tif")

  # Load and average ensemble predictions
  sdmout <- rast(paste0(dir,sp, "/proj_chlsdm/proj_chlsdm_", 
                      sp, "_ensemble.tif"))
  unlink(paste0(getwd(), "/", sp), recursive = TRUE, force = TRUE)
  unlink(paste0(getwd(), "/", sp), recursive = TRUE, force = TRUE)

  outbin <- subset(sdmout,names(sdmout)[grepl("EMcaBy",names(sdmout))])
  outbin <- mean(outbin)
  outbin[outbin<1] <- 0

  outmeano <- subset(sdmout,names(sdmout)[grepl("EMmeanBy",names(sdmout))])
  outmean <- mean(outmeano)/1000

  outcv <- stdev(outmeano)/mean(outmeano)

  out <- c(outmean,outbin,outcv)
  names(out) <- paste0(sp,"_",c("mean","binary","coeffvar"))

  return(out)
}

# Example usage for chlsdm
# The following code demonstrates how to use chlsdm to run a full species distribution modeling workflow.
# pres <- read.csv("testdata/tesmar.csv")
# env <- loadenv("c:/Users/edvar/Dropbox/sdm/envprep/", "asc")
# result <- chlsdm(pres, env, sp = "MySpecies", envselect = envselect, panum = 4, cvrep = 4, cores = 4)
# plot(result)
