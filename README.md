

# Installation

Install the package from GitHub:

``` r
remotes::install_github("ITSLeeds/opsnap")
```

# Opsnap data

The `opsnap` package provides a function to download and read in data
from the West Yorkshire Police Operation Snap database. The data is
available at the following URL:
https://www.westyorkshire.police.uk/SaferRoadsSubmissions

The data is open acess and looks like this, with names cleaned up by the
package:

``` r
u = "https://www.westyorkshire.police.uk/sites/default/files/2024-01/operation_snap_oct-dec_2023_0.xlsx"
d = opsnap:::download_and_read(u)
```

    New names:
    • `` -> `...9`

``` r
names(d)
```

    [1] "mode"     "make"     "model"    "colour"   "offence"  "district" "disposal"
    [8] "date"     "location"

``` r
# Old names:
#  [1] "REPORTER TRANSPORT MODE" "OFFENDER VEHICLE MAKE"  
#  [3] "OFFENDER VEHICLE MODEL"  "OFFENDER VEHICLE COLOUR"
#  [5] "OFFENCE"                 "DISTRICT"               
#  [7] "DISPOSAL"                "DATE OF SUBMISSION"     
#  [9] "...9"                    "OFF LOCATION"
```

The data looks like this (first 3 rows shown):

``` r
d |>
  head(3) |>
  knitr::kable()
```

| mode              | make       | model | colour | offence | district | disposal | date       | location                                   |
|:------------------|:-----------|:------|:-------|:--------|:---------|:---------|:-----------|:-------------------------------------------|
| Vehicle driver    | Volkswagen | GOLF  | BLACK  | N/A     | BD       | NFA      | 2023-10-01 | A1 Exit Slip onto M62 Eastbound, Wakefield |
| Vehicle passenger | Audi       | A4    | BLACK  | N/A     | unknown  | NFA      | 2023-10-01 | A1 Wentworth, Pontefract                   |
| Vehicle driver    | Volkswagen | Golf  | Red    | N/A     | BD       | NFA      | 2023-10-01 | A120 Leeds Ring Road, Moortown, Leeds      |

``` r
# Function to clean up column names
d_sample = d[1:50, ]
d_sf = opsnap:::op_geocode(d_sample)
mapview::mapview(d_sf)
```

![](README_files/figure-commonmark/unnamed-chunk-6-1.png)

``` r
table(d$offence) |>
  sort()
```

    N/A 
    546 

``` r
d |>
  # Reduce nchar of offence
  mutate(offence = stringr::str_sub(offence, 1, 60)) |>
  group_by(offence) |>
  # Count number of rows in each group
  mutate(n = n()) |>
  filter(n > nrow(d) / 50)|>
  ggplot() +
  geom_bar(aes(offence)) +
  # Make x labels vertical
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
```

![](README_files/figure-commonmark/unnamed-chunk-8-1.png)
