# Install the packages this project uses (run once).
cran <- c(
  # data + database
  "tidyverse", "DBI", "RPostgres", "dbplyr", "janitor", "here", "jsonlite", "pointblank",
  # spatial
  "sf", "tmap", "cancensus",
  # modeling + impact evaluation
  "mgcv", "lme4", "fixest", "did", "broom",
  # time series / forecasting
  "tsibble", "fable", "feasts",
  # reporting + ArcGIS
  "quarto", "renv", "arcgis"
)
missing <- setdiff(cran, rownames(installed.packages()))
if (length(missing)) install.packages(missing)

# weathercan (Environment Canada historical weather) is distributed via rOpenSci
if (!requireNamespace("weathercan", quietly = TRUE)) {
  install.packages("weathercan",
                   repos = c("https://ropensci.r-universe.dev", "https://cloud.r-project.org"))
}
message("All packages installed: ",
        all(c(cran, "weathercan") %in% rownames(installed.packages())))
