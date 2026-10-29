# Database connection helper. Reads credentials from the project .env file.
readRenviron(here::here(".env"))

db_connect <- function() {
  DBI::dbConnect(
    RPostgres::Postgres(),
    host     = Sys.getenv("PGHOST"),
    port     = as.integer(Sys.getenv("PGPORT")),
    dbname   = Sys.getenv("PGDATABASE"),
    user     = Sys.getenv("PGUSER"),
    password = Sys.getenv("PGPASSWORD")
  )
}
