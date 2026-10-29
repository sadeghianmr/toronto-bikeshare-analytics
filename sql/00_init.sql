-- Runs once, on first start of the container.
CREATE EXTENSION IF NOT EXISTS postgis;

-- Layered warehouse: raw (as downloaded) -> staging (cleaned, typed) -> mart (analysis-ready)
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS mart;

COMMENT ON SCHEMA raw     IS 'Source files loaded as-is. Never edited.';
COMMENT ON SCHEMA staging IS 'Cleaned, typed and validated tables.';
COMMENT ON SCHEMA mart    IS 'Analysis-ready tables and KPI views used by R, Quarto and ArcGIS.';
