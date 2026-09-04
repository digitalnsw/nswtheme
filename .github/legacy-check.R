#!/usr/bin/env Rscript

# Runs the test suite against a specific CRAN snapshot.
#
#   Rscript .github/legacy-check.R
#
# NSWTHEME_LEGACY_LIB - build the library somewhere specific.
# NSWTHEME_LEGACY_INSTALL_ONLY=true - only build the library, skipping tests.

snapshot <- "https://packagemanager.posit.co/cran/2024-08-15"

# Suggests needed by the tests and examples, excluding vignette-only deps.
extras <- c(
  "testthat",
  "pkgload",
  "palmerpenguins",
  "reactable",
  "colorBlindness"
)

lib <- Sys.getenv("NSWTHEME_LEGACY_LIB", unset = "")
if (!nzchar(lib)) {
  lib <- file.path(tools::R_user_dir("nswtheme", "cache"), "legacy-lib")
}
dir.create(lib, recursive = TRUE, showWarnings = FALSE)
cat("legacy library:", lib, "\n")

.libPaths(lib)

# Packages from 2024 with compiled code do not necessarily build against a
# current R: intended to run on R 4.4.1.
if (getRversion() < "4.4" || getRversion() >= "4.5") {
  warning(
    "this R is ",
    getRversion(),
    "; expected 4.4.1. Building the ",
    "snapshot library may fail on compiled packages.",
    call. = FALSE,
    immediate. = TRUE
  )
}

hard_deps <- function() {
  declared <- as.vector(read.dcf(
    "DESCRIPTION",
    fields = c("Depends", "Imports")
  ))
  declared <- declared[!is.na(declared)]
  pkgs <- trimws(sub("\\(.*", "", unlist(strsplit(declared, ","))))
  setdiff(pkgs[nzchar(pkgs)], "R")
}

sentinel <- file.path(lib, ".snapshot")
built <- file.exists(sentinel) &&
  identical(readLines(sentinel, n = 1), snapshot)

if (!built) {
  wanted <- unique(c(hard_deps(), extras))
  cat("installing", length(wanted), "packages and their dependencies\n")
  utils::install.packages(wanted, lib = lib, repos = snapshot)
  missing <- Filter(
    function(pkg) !nzchar(system.file(package = pkg, lib.loc = lib)),
    wanted
  )
  if (length(missing)) {
    stop("failed to install: ", paste(missing, collapse = ", "))
  }
  writeLines(snapshot, sentinel)
}

if (identical(tolower(Sys.getenv("NSWTHEME_LEGACY_INSTALL_ONLY")), "true")) {
  cat("library ready\n")
  quit(status = 0)
}

counts <- as.data.frame(testthat::test_local(
  ".",
  reporter = "summary",
  stop_on_failure = FALSE
))
cat(sprintf(
  "\nPASS %d | FAIL %d | WARN %d | SKIP %d\n",
  sum(counts$passed),
  sum(counts$failed),
  sum(counts$warning),
  sum(counts$skipped)
))
if (sum(counts$failed) > 0 || sum(counts$error) > 0) {
  quit(status = 1)
}
