#----------------------------------------------------------------------------
# RSuite
# Copyright (c) 2017, WLOG Solutions
#
# This script initializes S3 repository.
#
# This script was generated authomaticaly by RSuite. Do not change it please.
#----------------------------------------------------------------------------

args <- commandArgs()
if (any(grepl("--usage", args))) {
  cat("This script initializes S3 repository.\n")
  cat("Call: Rscript 04_init_s3_repo.R <args>\n")
  cat("\t--verbose          if passed print lots of messages\n")
  cat("\t--usage            print this message and exit\n")
  stop("Noithing else to be done")
}

if (any(grepl("--verbose", args))) {
  logging::setLevel("DEBUG")
}

# Check aws credentials
home_bkp <- Sys.getenv("HOME")

curr_dir <- shortPathName(normalizePath("."))
if (dir.exists(file.path(curr_dir, ".aws"))) {
  message(sprintf("Setting HOME to %s", curr_dir))
  Sys.setenv(HOME=curr_dir)
} else if (!is.null(home_bkp) && !dir.exists(file.path(home_bkp, ".aws"))) {
  message("Unsetting HOME as it does not contain .aws credentials")
  Sys.unsetenv("HOME")
}

tryCatch({
  RSuite::rsuite_register_repo_adapter(
    RSuite::repo_adapter_create_s3("S3.WLOG",
                                   url = "http://wlog-cran.s3.amazonaws.com",
                                   s3_profile = "default"))
  RSuite::repo_reinit_prj_repo("S3.WLOG")
}, finally = {
  Sys.setenv(HOME = home_bkp)
})
