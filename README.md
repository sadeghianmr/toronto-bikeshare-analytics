# Toronto Bike Share: What Drives Ridership, and Do New Bike Lanes Work?

An end-to-end analytics project on Bike Share Toronto trip data. It asks what drives daily and station-level demand,
whether new cycling infrastructure increases ridership at nearby stations, and what demand the system should plan for.

**Stack:** PostgreSQL/PostGIS · R · Quarto · ArcGIS Online · Docker · GitHub

## Questions
1. **Drivers of demand:** How do weather, season and day of week shape daily ridership?
2. **Station performance:** What makes a station busy (nearby population, employment, transit access, bike-lane access)?
3. **Impact evaluation:** Did stations near newly installed bike lanes gain riders compared with similar stations
   without new lanes?
4. **Forecasting:** What ridership should the system expect in the coming months?

## Data
| Source | Publisher | Use |
|---|---|---|
| Bike Share Toronto Ridership Data | City of Toronto Open Data | Trip records (start/end station, time, duration, user type) |
| Station information (GBFS feed) | Bike Share Toronto | Station locations and capacity |
| Cycling Network | City of Toronto Open Data | Bike lanes, infrastructure type and installation year |
| Historical daily weather | Environment and Climate Change Canada (`weathercan`) | Temperature, precipitation, snow |
| 2021 Census of Population | Statistics Canada (`cancensus`) | Population and employment around stations |

All sources are published under open licences (Open Government Licence – Toronto; Open Government Licence – Canada).

## Architecture
```
Raw CSV / GeoJSON / API data
        │  SQL COPY + R ingestion
        ▼
PostgreSQL + PostGIS (Docker)
   raw      → source data as delivered
   staging  → cleaned, typed, validated
   mart     → daily and station-level KPIs, spatial joins
        │  dbplyr
        ▼
R  → statistical models, impact evaluation, forecasts, maps
        │                       │
        ▼                       ▼
Quarto technical report    ArcGIS Online web map + dashboard
```

## Methods
| Component | Approach | Tools |
|---|---|---|
| Data warehouse | Layered schemas (raw / staging / mart), bulk loading with `COPY`, validation checks (trip durations, unknown stations, duplicates), in-database data dictionary via `COMMENT ON` | PostgreSQL, PostGIS |
| Spatial features | Station buffers, distance to bike lanes and rapid transit, spatial joins to census tracts | PostGIS, `sf` |
| Demand drivers | Generalized additive / negative binomial models of daily trips on weather, season and calendar effects | `mgcv`, `MASS` |
| Station demand | Mixed-effects model of station-level ridership with neighbourhood covariates | `lme4` |
| Impact evaluation | Staggered difference-in-differences: stations near lanes installed in a given year vs. not-yet- and never-treated stations; event-study estimates | `did`, `fixest` |
| Forecasting | Seasonal time-series models with weather regressors, evaluated on hold-out periods | `fable`, `tsibble` |
| Mapping & reporting | Station and neighbourhood maps; KPI layer published to ArcGIS Online | `tmap`, `arcgislayers`, Quarto |

## Repository structure
```
├── docker-compose.yml     PostgreSQL 16 + PostGIS 3.4
├── sql/                   Schema, load, staging and mart scripts (run in order)
├── R/                     Ingestion, modeling and publishing scripts
├── report/                Quarto technical report
├── outputs/               Figures and ArcGIS exports
├── docs/                  Data dictionary and methodology notes
└── data/                  Raw and processed data (not committed; see Data)
```

## Reproduce
```bash
git clone https://github.com/sadeghianmr/toronto-bikeshare-analytics.git
cd toronto-bikeshare-analytics
cp .env.example .env              # set a password
docker compose up -d              # PostgreSQL 16 + PostGIS 3.4 on port 55433
Rscript R/00_packages.R           # install R dependencies
Rscript R/01_test_connection.R    # check the database connection
```
Download the ridership files and the Cycling Network layer from the City of Toronto Open Data portal into
`data/raw/ridership/` and `data/raw/cycling_network/`. Weather, station and census data are retrieved from their APIs
by the R scripts.

## Data notes
- Column names in the ridership files differ between years; the loading scripts harmonize them into one schema.
- The station feed lists current stations only; trips at retired stations are kept but have no coordinates.
- Bike-lane installation dates are recorded by year, so the impact evaluation uses annual treatment cohorts.

## Author
**Mo Sadeghian** · [LinkedIn](https://www.linkedin.com/in/sadeghianmr) · [Portfolio](https://sadeghianmr.github.io/)
