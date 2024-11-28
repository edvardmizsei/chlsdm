chlsdm <- function(pres, env, sp="species name", envselect, models=c("GLM","GAM","ANN","RF"),panum = 4, cvrep = 4, cores = 4) {
  library(biomod2)
  library(chlsdm)
  library(terra)
  library(sf)
  library(sp)

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
                          CV.perc = 0.5,
                          nb.cpu = cores)

  # Project the models to the environment
  sdmp <- BIOMOD_Projection(modeling.output = sdmi,
                            new.env = env,
                            proj.name = "chlsdm")

  # Create ensemble models
  sdme <- BIOMOD_EnsembleModeling(modeling.output = sdmi)

  # Create ensemble forecast
  sdmef <- BIOMOD_EnsembleForecasting(ensemble.output = sdme,
                                      projection.output = sdmp,
                                      output.format = ".tif")

  # Load and average ensemble predictions
  sdmout <- rast(paste0(sp, "/proj_current/proj_chlsdm_", sp, "_ensemble.tif"))
  unlink(paste0(getwd(), "/", sp), recursive = TRUE, force = TRUE)
  unlink(paste0(getwd(), "/", sp), recursive = TRUE, force = TRUE)
  sdmoutm <- mean(sdmout) / 1000

  return(sdmoutm)
}

# Example usage for chlsdm
# The following code demonstrates how to use chlsdm to run a full species distribution modeling workflow.
# pres <- read.csv("testdata/tesmar.csv")
# env <- loadenv("c:/Users/edvar/Dropbox/sdm/envprep/", "asc")
# result <- chlsdm(pres, env, sp = "MySpecies", envselect = envselect, panum = 4, cvrep = 4, cores = 4)
# plot(result)
