# Quick check that R can reach PostgreSQL/PostGIS.
source(here::here("R", "db.R"))
con <- db_connect()
print(DBI::dbGetQuery(con, "SELECT postgis_full_version() AS postgis;"))
print(DBI::dbGetQuery(con, "SELECT schema_name FROM information_schema.schemata
                            WHERE schema_name IN ('raw','staging','mart');"))
DBI::dbDisconnect(con)
