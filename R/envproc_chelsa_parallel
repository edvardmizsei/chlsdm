envproc_chelsa_parallel <- function(study_area, file_url_df, out_dir, cores = 12, retries = 2) {
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  sa_vect <- if (inherits(study_area, "sf")) vect(study_area) else vect(study_area)
  
  # worker for one file
  work_one <- function(row) {
    fp  <- row[["full_path"]]
    yr  <- row[["year_range"]]; if (is.na(yr)  || !nzchar(yr))  yr  <- "unknown"
    gcm <- row[["gcm"]];        if (is.na(gcm) || !nzchar(gcm)) gcm <- "global"
    scn <- row[["scenario"]];   if (is.na(scn) || !nzchar(scn)) scn <- "current"
    fn  <- row[["new_filename"]]
    
    out_dir_i <- file.path(out_dir, yr, gcm, scn)
    dir.create(out_dir_i, recursive = TRUE, showWarnings = FALSE)
    out_path <- file.path(out_dir_i, fn)
    
    if (file.exists(out_path)) {
      return(list(ok = TRUE, skipped = TRUE, out = out_path, src = fp))
    }
    
    attempt <- 1L
    repeat {
      ok <- try({
        r  <- rast(fp)                       # GDAL reads https:// directly
        r2 <- mask(crop(r, sa_vect), sa_vect)
        writeRaster(r2, out_path, filetype = "AAIGrid", overwrite = TRUE)
      }, silent = TRUE)
      
      if (!inherits(ok, "try-error")) {
        return(list(ok = TRUE, skipped = FALSE, out = out_path, src = fp))
      }
      if (attempt >= retries) break
      attempt <- attempt + 1L
    }
    list(ok = FALSE, skipped = FALSE, out = out_path, src = fp,
         err = as.character(ok))
  }
  
  # limit cores to available CPUs
  cores <- max(1L, min(cores, parallel::detectCores(logical = TRUE)))
  
  # progress (simple): print every N items
  n <- nrow(file_url_df)
  cat("Processing", n, "files on", cores, "cores...\n")
  
  # mclapply splits by row
  res <- mclapply(
    X = split(file_url_df, seq_len(n)),
    FUN = work_one,
    mc.cores = cores
  )
  
  # tiny summary
  ok_n      <- sum(vapply(res, `[[`, logical(1), "ok"))
  skipped_n <- sum(vapply(res, `[[`, logical(1), "skipped"))
  failed    <- vapply(res, function(x) !isTRUE(x$ok), logical(1))
  cat("Done. OK:", ok_n, " | Skipped (already existed):", skipped_n,
      " | Failed:", sum(failed), "\n")
  
  if (any(failed)) {
    cat("First few failures:\n")
    bad <- which(failed)
    show_n <- min(5, length(bad))
    for (i in bad[seq_len(show_n)]) {
      cat("- ", res[[i]]$src, " -> ", res[[i]]$out, "\n", sep = "")
    }
  }
  
  invisible(res)
}
