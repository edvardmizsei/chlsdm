extract_chelsa_metadata <- function(file_paths) {
  paths <- normalize_paths(file_paths)
  split <- strsplit(paths, "/", fixed = TRUE)
  
  rows <- lapply(seq_along(split), function(i){
    comps <- split[[i]]
    filename <- comps[length(comps)]
    
    idx_clim <- which(comps == "climatologies")
    idx_bio  <- which(comps == "bio")
    
    year_range <- gcm <- scenario <- NA_character_
    if (length(idx_clim) == 1) {
      if (length(comps) >= idx_clim + 1) year_range <- comps[idx_clim + 1]
      # future structure: .../climatologies/<year>/<GCM>/<scenario>/bio/...
      if (length(idx_bio) == 1 && idx_bio >= idx_clim + 4) {
        gcm      <- comps[idx_clim + 2]
        scenario <- comps[idx_clim + 3]
      } else {
        scenario <- "current"
      }
    }
    
    # filename pieces
    base <- sub("^CHELSA_", "", filename)
    yr_pat <- if (!is.na(year_range)) gsub("-", "\\\\-", year_range) else ""
    # varname is everything up to _<year_range>_
    if (nzchar(yr_pat)) {
      m <- regexpr(paste0("_", yr_pat, "_"), base, perl = TRUE)
      var_part <- if (m[1] > 0) substr(base, 1, m[1] - 1) else base
      # optional vartype after year (e.g., rsds_1981-2010_mean)
      tm <- regexpr(paste0(yr_pat, "_(max|min|mean|range|sum|sd)"), base, perl = TRUE)
      vartype <- if (tm[1] > 0) sub(paste0("^", yr_pat, "_"), "", regmatches(base, tm)) else NA_character_
    } else {
      var_part <- sub("_[0-9]{4}-[0-9]{4}_.*$", "", base)  # fallback
      vartype <- NA_character_
    }
    
    suffix <- sub(".*_(V[^.]*)\\..*$", "\\1", filename)
    new_filename <- paste0(var_part, ifelse(is.na(vartype), "", paste0("_", vartype)), ".asc")
    
    data.frame(
      full_path    = paths[i],
      filename     = filename,
      varname      = var_part,
      vartype      = vartype,
      var_full     = ifelse(is.na(vartype), var_part, paste(var_part, vartype, sep = "_")),
      year_range   = year_range,
      gcm          = gcm,
      scenario     = scenario,
      suffix       = suffix,
      new_filename = new_filename,
      stringsAsFactors = FALSE
    )
  })
  
  do.call(rbind, rows)
}
