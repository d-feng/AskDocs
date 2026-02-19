# Technology Focus: 10x Genomics Visium

## Contents

- Loading the data
- Visualise the data

## Overview

This notebook will present a rough overview of the plotting functionalities that `spatialdata` implements for Visium data.

## Loading the Data

Please download the data from [here: Visium dataset](https://spatialdata.scverse.org/) and rename it (eventually using symlinks) to `visium_brain.zarr`.

```python
visium_zarr_path = "./visium_brain.zarr"

import spatialdata as sd
import spatialdata_plot  # noqa: F401

visium_sdata = sd.read_zarr(visium_zarr_path)
visium_sdata
```

Output:
```
SpatialData object, with associated Zarr store: /ictstr01/home/icb/tim.treis/projects/spatialdata/
├── Images
│   ├── 'ST8059048_hires_image': DataArray[cyx] (3, 2000, 1969)
│   ├── 'ST8059048_lowres_image': DataArray[cyx] (3, 600, 591)
│   ├── 'ST8059050_hires_image': DataArray[cyx] (3, 2000, 1968)
│   ├── 'ST8059050_image': DataArray[cyx] (3, 2000, 1968)
│   ├── 'ST8059050_lowres_image': DataArray[cyx] (3, 600, 590)
│   └── 'ST8059052_image': DataArray[cyx] (3, 2000, 1950)
├── Shapes
│   ├── 'ST8059048': GeoDataFrame shape: (2987, 2) (2D shapes)
│   ├── 'ST8059050': GeoDataFrame shape: (3497, 2) (2D shapes)
│   ├── 'ST8059050_shapes': GeoDataFrame shape: (3497, 2) (2D shapes)
│   └── 'ST8059052_shapes': GeoDataFrame shape: (2576, 2) (2D shapes)
└── Tables
    └── 'table': AnnData (6484, 31053)

with coordinate systems:
▸ 'ST8059048', with elements:
    ST8059048_hires_image (Images), ST8059048 (Shapes)
▸ 'ST8059050', with elements:
    ST8059050_hires_image (Images), ST8059050_image (Images), ST8059050 (Shapes), ST8059050_shapes (Shapes)
▸ 'ST8059052', with elements:
    ST8059052_image (Images), ST8059052_shapes (Shapes)

with the following elements in the Zarr store but not in the SpatialData object:
▸ table (Table)
```

## Visualise the Data

We're going to create a naive visualisation of the data, overlaying the Visium spots and the tissue images. For this, we need to load the `spatialdata_plot` library which extends the `sd.SpatialData` object with the `.pl` module.

```python
visium_sdata.pl.render_images().pl.render_shapes().pl.show("ST8059050")
```

Output:
```
INFO Rasterizing image for faster rendering.
INFO Rasterizing image for faster rendering.
```

We can see that the data contains two coordinate systems (`ST8059050` and `ST8059052`) with image and spot information each. In `SpatialData`, these spots are represented as `Shapes`.

When giving no further parameters, one panel is generated per coordinate system with the members that have been specified in the function call. We can see that the spots are aligned to the tissue representation which is also respected by the plotting logic.

However, the spots are all grey since we have not provided any information on what they should encode. Such information can be found in the `Table` attribute (which is an `anndata.AnnData` table) of the `SpatialData` object, either in the data itself or the `obs` attribute.

```python
visium_sdata["table"].to_df().sum(axis=0).sort_values(ascending=False).head(10)
# We will select some of the highly expressed genes for this example
```

Output:
```
mt-Co3     3292649.0
mt-Co1     3061428.0
mt-Atp6    2124067.0
mt-Co2     2110283.0
mt-Cytb    1288126.0
mt-Nd4     1073436.0
mt-Nd1     1073275.0
Ttr         832128.0
Fth1        828627.0
mt-Nd2      755237.0
dtype: float32
```

```python
visium_sdata["table"].obs.head(3)
```

Output:
```
                        in_tissue  array_row  array_col  spot_id     region
AAACAAGTATCTCCCA-1              1         50        102        0  ST8059048
AAACACCAATAACTGC-1              1         59         19        1  ST8059048
AAACAGAGCGACTCCT-1              1         14         94        2  ST8059048
```

### Color the Visium Spots by Gene Expression

To use this information in our plot, we pass the name of the column by which we want to color our expression to `color`. Furthermore, we are going to subset the data to only one coordinate system.

```python
(
    visium_sdata.pl.render_images(elements="ST8059050_hires_image")
    .pl.render_shapes(elements="ST8059050", color="mt-Co3")
    .pl.show()
)
```

Output:
```
INFO Dropping coordinate system 'ST8059052' since it doesn't have relevant elements
INFO Dropping coordinate system 'ST8059048' since it doesn't have relevant elements
INFO Rasterizing image for faster rendering.
```

We can also provide `ax` objects to `spatialdata_plot` for further customisation.

```python
import matplotlib.pyplot as plt

fig, axs = plt.subplots(ncols=3, nrows=1, figsize=(12, 3))

visium_sdata.pl.render_shapes(elements="ST8059050", color="mt-Co1").pl.show(ax=axs[0], title="mt-Co1")
visium_sdata.pl.render_shapes(elements="ST8059050", color="Fth1").pl.show(ax=axs[1], title="Fth1")
visium_sdata.pl.render_shapes(elements="ST8059050", color="Ttr").pl.show(ax=axs[2], title="Ttr")

plt.tight_layout()
```

Output:
```
INFO Dropping coordinate system 'ST8059052' since it doesn't have relevant elements
INFO Dropping coordinate system 'ST8059048' since it doesn't have relevant elements
INFO Dropping coordinate system 'ST8059052' since it doesn't have relevant elements
INFO Dropping coordinate system 'ST8059048' since it doesn't have relevant elements
INFO Dropping coordinate system 'ST8059052' since it doesn't have relevant elements
INFO Dropping coordinate system 'ST8059048' since it doesn't have relevant elements
```

## For Reproducibility

```python
# fmt: off
%load_ext watermark
# fmt: on

%watermark -v -m -p timeit,warnings,dask,datashader,matplotlib,numpy,pandas,scanpy,spatialdata,spatialdata_plot,geopandas,shapely
```

Output:
```
Python implementation: CPython
Python version       : 3.11.10
IPython version      : 8.27.0

timeit            : unknown
warnings          : unknown
dask              : 2024.9.0
datashader        : 0.16.3
matplotlib        : 3.9.2
numpy             : 1.26.4
pandas            : 2.2.3
scanpy            : 1.10.3
spatialdata       : 0.2.2
spatialdata_plot  : 0.2.7
geopandas         : 1.0.1
shapely           : 2.0.6

Compiler    : GCC 13.3.0
OS          : Linux
Release     : 5.14.0-427.35.1.el9_4.x86_64
Machine     : x86_64
Processor   : x86_64
CPU cores   : 96
Architecture: 64bit
```

---

*Latest version*