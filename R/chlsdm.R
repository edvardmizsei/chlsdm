chlsdm <- function(pres, env, dir, sp="species name", models=c("GLM","GAM","ANN","RF"),panum = 4, cvrep = 4, cores = 4) {
  library(biomod2)
  library(chlsdm)
  library(terra)
  library(sf)

  if (!dir.exists(dir)){
  dir.create(dir)
  }
  setwd(dir)
  
  envnames <- names(env)
  names(env) <- paste0("env",1:length(names(env)))


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
  # myBiomodOption <- BIOMOD_ModelingOptions()
  opt.d <- bm_ModelingOptions(data.type = 'binary',
                            models = c('ANN','CTA','FDA','GAM','GBM','GLM','MARS','MAXNET','RF','SRE','XGBOOST'),
                            strategy = 'default')
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
                                  models.chosen="all",
                                  em.by="all")

  # Create ensemble forecast
  sdmef <- BIOMOD_EnsembleForecasting(bm.em = sdme,
                                      bm.proj = sdmp,
                                      output.format = ".tif")

  # Load and average ensemble predictions
  sdmout <- rast(sdmef@proj.out@link)
  
  out <- terra::mean(sdmout)/1000
  names(out) <- sp

  writeRaster(out,paste0(sp,"_sdm_out.asc"),filetype = "AAIGrid",overwrite = T)
  
  return(out)
}

# Example usage for chlsdm
# The following code demonstrates how to use chlsdm to run a full species distribution modeling workflow.
# pres <- read.csv("testdata/tesmar.csv")
# env <- loadenv("c:/Users/edvar/Dropbox/sdm/envprep/", "asc")
# result <- chlsdm(pres, env, sp = "MySpecies", envselect = envselect, panum = 4, cvrep = 4, cores = 4)
# plot(result)
