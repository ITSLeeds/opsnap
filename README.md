

<!-- badges: start -->

[![R-CMD-check](https://github.com/ITSLeeds/opsnap/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ITSLeeds/opsnap/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# Installation

Install the package from GitHub:

# Opsnap data

The `opsnap` package provides a function to download and read in data
from the West Yorkshire Police Operation Snap database. The data is
available at the following URL:
https://www.westyorkshire.police.uk/SaferRoadsSubmissions

Data for the following years are provided:

| file_names                             |
|:---------------------------------------|
| operation_snap_jan-march_2024.xlsx     |
| operation_snap_oct-dec_2023_0.xlsx     |
| operation_snap_july-sept_2023.xlsx     |
| operation_snap_apr-jun_2023_data.xlsx  |
| operation_snap_jan-mar_2023_data.xlsx  |
| operation_snap_oct-dec_2022_data.xlsx  |
| operation_snap_jul-sept_2022_data.xlsx |
| operation_snap_apr-jun_2022_data.xlsx  |
| operation_snap_jan-mar_2022_data.xlsx  |
| operation_snap_2021_data.xlsx          |

The data is open acess and looks like this, with names cleaned up by the
package:

``` r
u = "https://www.westyorkshire.police.uk/sites/default/files/2024-01/operation_snap_oct-dec_2023_0.xlsx"
d = opsnap:::download_and_read(u)
names(d_with_location)
# Old names:
#  [1] "REPORTER TRANSPORT MODE" "OFFENDER VEHICLE MAKE"  
#  [3] "OFFENDER VEHICLE MODEL"  "OFFENDER VEHICLE COLOUR"
#  [5] "OFFENCE"                 "DISTRICT"               
#  [7] "DISPOSAL"                "DATE OF SUBMISSION"     
#  [9] "...9"                    "OFF LOCATION"
# New names:
# [1] "mode"     "make"     "model"    "colour"   "offence"  "district" "disposal"
# [8] "date"     "location"
```

<!-- The data looks like this (first 3 rows shown): -->

| mode | make | model | colour | offence | district | disposal | date | location |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| cyclist | honda | jazz | blue | rt88576 drive without reasonable consideration to others | bd | educational course | 2023-10-01 | a650 sir fred hoyle way, bingley |
| cyclist | citroen | ds3 | white | rt88576 drive without reasonable consideration to others | bd | educational course | 2023-10-01 | dalton bank road, huddersfield |
| vehicle driver | audi | s3 | black | rt88760 fail to comply with solid white lines | ld | educational course | 2023-10-01 | a1 north wetherby, leeds |

# Preliminary analysis

There are 18363 records in the data, with increasing numbers of records
over time (average n. records per month shown below):

<img src="man/figures/README-unnamed-chunk-9-1.png"
style="width:100.0%" />

As shown in the graph above not all (69.6%) records have values for the
‘location’ column.

The breakdown of all records by mode of transport (of the observer) is
shown below:

| mode              |    n | percent_records |
|:------------------|-----:|:----------------|
| vehicle driver    | 9167 | 49.9%           |
| cyclist           | 6312 | 34.4%           |
| pedestrian        | 1352 | 7.4%            |
| vehicle passenger |  579 | 3.2%            |
| unknown           |  497 | 2.7%            |
| horse rider       |  407 | 2.2%            |
| motorcyclist      |   48 | 0.3%            |
| NA                |    1 | 0.0%            |

The offence text strings are quite long, with the most common offences
shown below:

| offence | n | percent_records |
|:---|---:|:---|
| n/a | 5706 | 31.1% |
| rt88576 drive without reasonable consideration to others | 4992 | 27.2% |
| rt88575 drive without due care and attention | 2917 | 15.9% |
| rt88975 drive motor vehicle fail to comply with red / green arrow / lane closure traffic light signals | 1364 | 7.4% |
| rt88971 fail to comply with red traffic light | 679 | 3.7% |
| rt88966 motor vehicle fail to comply with endorsable s36 traffic sign | 411 | 2.2% |
| rv86019 use a handheld phone / device whilst driving a motor vehicle on a road | 357 | 1.9% |
| rt88760 fail to comply with solid white lines | 265 | 1.4% |
| rt88751 contravene give way sign | 264 | 1.4% |
| suspected contravene weight restriction. | 213 | 1.2% |

The equivalent table excluding records with missing location data is
shown below:

| offence | n | percent_records |
|:---|---:|:---|
| rt88576 drive without reasonable consideration to others | 4992 | 39.1% |
| rt88575 drive without due care and attention | 2917 | 22.8% |
| rt88975 drive motor vehicle fail to comply with red / green arrow / lane closure traffic light signals | 1364 | 10.7% |
| rt88971 fail to comply with red traffic light | 679 | 5.3% |
| rt88966 motor vehicle fail to comply with endorsable s36 traffic sign | 411 | 3.2% |
| rv86019 use a handheld phone / device whilst driving a motor vehicle on a road | 357 | 2.8% |
| rt88760 fail to comply with solid white lines | 265 | 2.1% |
| rt88751 contravene give way sign | 264 | 2.1% |
| suspected contravene weight restriction. | 213 | 1.7% |
| rt88751 contravene mandatory direction arrows | 212 | 1.7% |

The equivalent for cyclists, with location present and the least common
offences categorised as ‘other’, is shown below:

| offence | n | % of total |
|:---|---:|:---|
| rt88576 drive without reasonable consideration to others | 3713 | 78.7% |
| rt88575 drive without due care and attention | 517 | 11.0% |
| rv86019 use a handheld phone / device whilst driving a motor vehicle on a road | 174 | 3.7% |
| rt88975 drive motor vehicle fail to comply with red / green arrow / lane closure traffic light signals | 109 | 2.3% |
| rt88971 fail to comply with red traffic light | 56 | 1.2% |
| rt88751 contravene give way sign | 27 | 0.6% |
| other | 122 | 2.6% |

In terms ‘disposal’, the most common values are shown below:

| disposal           |    n | percent_records |
|:-------------------|-----:|:----------------|
| educational course | 9806 | 53.4%           |
| nfa                | 5697 | 31.0%           |
| conditional offer  | 2326 | 12.7%           |
| court              |  307 | 1.7%            |
| dsit investigation |  202 | 1.1%            |
| rpu investigation  |   23 | 0.1%            |
| fine               |    1 | 0.0%            |
| NA                 |    1 | 0.0%            |

There are 8073 unique location text strings (addresses) in the data,
with the most common locations shown below:

| location                                       |   n | percent_records |
|:-----------------------------------------------|----:|:----------------|
| meanwood road, leeds                           |  73 | 0.6%            |
| dewsbury road, ossett                          |  56 | 0.4%            |
| park square west, leeds                        |  54 | 0.4%            |
| chapeltown road, leeds                         |  43 | 0.3%            |
| tongue lane, leeds                             |  38 | 0.3%            |
| westgate j/w park square west, leeds           |  38 | 0.3%            |
| hollingwood lane, bradford                     |  34 | 0.3%            |
| westgate junction with park square west, leeds |  33 | 0.3%            |
| clayton road, bradford                         |  32 | 0.3%            |
| highgate road, bradford                        |  32 | 0.3%            |

# Geocoding

We provide a function to geocode the records:

``` r
d_sample = d_with_location[1:5, ]
d_sf = opsnap:::op_geocode(d_sample)
mapview::mapview(d_sf)
```

After geocoding all records we kept only those within the boundary of
West Yorkshire, which removed another 3% of records.

# Location of incidents

Due to inaccuracy in the geocoding, we only know the locations of the
records to within around 500m of each crash (although we can link to
specific roads). We’ll present the geographic distribution of crashes
using a 500m grid:

<img src="man/figures/README-unnamed-chunk-20-1.png"
style="width:100.0%" />

The map above represents 8607 incidents in West Yorkshire with an
offence that could be geocoded.

<!-- The results show there is one outlier with a very high number of crashes. We can remove this and plot the data again: -->
<!-- You can query the data downloaded with `opsnap` functions, e.g. as follows (results not shown): -->
<!-- Let's make a plot of the data: -->
