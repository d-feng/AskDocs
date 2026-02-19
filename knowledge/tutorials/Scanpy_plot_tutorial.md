# Core Plotting Functions

**Author:** Fidel Ramírez

## Contents

- Scatter plots for embeddings
- Identification of clusters based on known marker genes
- Combining plots in subplots
- Heatmaps
- Tracksplot
- Visualization of marker genes
- Comparison of marker genes using split violin plots
- Dendrogram options
- Plot correlation

## Overview

This tutorial explores the visualization possibilities of scanpy and is divided into three sections:

1. Scatter plots for embeddings (e.g., UMAP, t-SNE)
2. Identification of clusters using known marker genes
3. Visualization of differentially expressed genes

In this tutorial, we will use a dataset from 10x containing 68k cells from PBMC. Scanpy includes in its distribution a reduced sample of this dataset consisting of only 700 cells and 765 highly variable genes. This dataset has been already preprocessed and UMAP computed.

### Literature Markers Used

- **B-cell:** CD79A, MS4A1
- **Plasma:** IGJ (JCHAIN)
- **T-cell:** CD3D
- **NK:** GNLY, NKG7
- **Myeloid:** CST3, LYZ
- **Monocytes:** FCGR3A
- **Dendritic:** FCER1A

## Scatter Plots for Embeddings

With scanpy, scatter plots for tSNE, UMAP and several other embeddings are readily available using the `sc.pl.tsne`, `sc.pl.umap` etc. functions. See [here](https://scanpy.readthedocs.io/en/stable/api.html#plotting) the list of options.

Those functions access the data stored in `adata.obsm`. For example `sc.pl.umap` uses the information stored in `adata.obsm['X_umap']`. For more flexibility, any key stored in `adata.obsm` can be used with the generic function `sc.pl.embedding`.

### Load PBMC Dataset

```python
import scanpy as sc
from matplotlib.pyplot import rc_context

sc.set_figure_params(dpi=100, color_map="viridis_r")
sc.settings.verbosity = 0
sc.logging.print_header()
```

Output:
```
scanpy==1.10.0rc2.dev6+g14555ba4.d20240226 anndata==0.11.0.dev78+g64ab900 umap==0.5.5
```

```python
pbmc = sc.datasets.pbmc68k_reduced()

# inspect pbmc contents
pbmc
```

Output:
```
AnnData object with n_obs × n_vars = 700 × 765
    obs: 'bulk_labels', 'n_genes', 'percent_mito', 'n_counts', 'S_score', 'G2M_score'
    var: 'n_counts', 'means', 'dispersions', 'dispersions_norm', 'highly_variable'
    uns: 'bulk_labels_colors', 'louvain', 'louvain_colors', 'neighbors', 'pca', 'rank_genes_groups'
    obsm: 'X_pca', 'X_umap'
    varm: 'PCs'
    obsp: 'distances', 'connectivities'
```

### Visualization of Gene Expression and Other Variables

For the scatter plots, the value to plot is given as the `color` argument. This can be any gene or any column in `.obs`, where `.obs` is a DataFrame containing the annotations per observation/cell, see [AnnData](https://anndata.readthedocs.io/) for more information.

Multiple values can be given to `color`. In the following example we will plot 6 genes: 'CD79A', 'MS4A1', 'IGJ', CD3D', 'FCER1A', and 'FCGR3A' to get an idea on where those marker genes are being expressed.

```python
# rc_context is used for the figure size, in this case 4x4
with rc_context({"figure.figsize": (4, 4)}):
    sc.pl.umap(pbmc, color="CD79A")
```

Also, we will plot two other values: `n_counts` which is the number of UMI counts per cell (stored in `.obs`), and `bulk_labels` which is a categorical value containing the original labelling of the cells from 10X.

The number of plots per row is controlled using the `ncols` parameter. The maximum value plotted can be adjusted using `vmax` (similarly `vmin` can be used for the minimum value). In this case we use `p99`, which means to use as max value the 99 percentile. The max value can be a number or a list of numbers if the vmax wants to be set for multiple plots individually.

Also, we are using `frameon=False` to remove the boxes around the plots and `s=50` to set the dot size.

```python
color_vars = [
    "CD79A",
    "MS4A1",
    "IGJ",
    "CD3D",
    "FCER1A",
    "FCGR3A",
    "n_counts",
    "bulk_labels",
]

with rc_context({"figure.figsize": (3, 3)}):
    sc.pl.umap(pbmc, color=color_vars, s=50, frameon=False, ncols=4, vmax="p99")
```

In this plot we can see the groups of cells that express the marker genes and the agreement with the original cell labels.

The functions for scatterplots have many options that allow fine tuning of the images. For example, we can look at the clustering as follows:

```python
# compute clusters using the leiden method and store the results with the name `clusters`
sc.tl.leiden(
    pbmc,
    key_added="clusters",
    resolution=0.5,
    n_iterations=2,
    flavor="igraph",
    directed=False,
)
```

```python
with rc_context({"figure.figsize": (5, 5)}):
    sc.pl.umap(
        pbmc,
        color="clusters",
        add_outline=True,
        legend_loc="on data",
        legend_fontsize=12,
        legend_fontoutline=2,
        frameon=False,
        title="clustering of cells",
        palette="Set1",
    )
```

## Identification of Clusters Based on Known Marker Genes

Frequently, clusters need to be labelled using well known marker genes. Using scatter plots we can see the expression of a gene and perhaps associate it with a cluster. Here, we will show other visual ways to associate marker genes to clusters using dotplots, violin plots, heatmaps and something that we call 'tracksplot'. All of these visualizations summarize the same information, expression split by cluster, and the selection of the best results is left to the investigator to decide.

First, we set up a dictionary with the marker genes, as this will allow scanpy to automatically label the groups of genes:

```python
marker_genes_dict = {
    "B-cell": ["CD79A", "MS4A1"],
    "Dendritic": ["FCER1A", "CST3"],
    "Monocytes": ["FCGR3A"],
    "NK": ["GNLY", "NKG7"],
    "Other": ["IGLL1"],
    "Plasma": ["IGJ"],
    "T-cell": ["CD3D"],
}
```

### Dotplot

A quick way to check the expression of these genes per cluster is to using a dotplot. This type of plot summarizes two types of information: the color represents the mean expression within each of the categories (in this case in each cluster) and the dot size indicates the fraction of cells in the categories expressing a gene.

Also, it is useful to add a dendrogram to the graph to bring together similar clusters. The hierarchical clustering is computed automatically using the correlation of the PCA components between the clusters.

```python
sc.pl.dotplot(pbmc, marker_genes_dict, "clusters", dendrogram=True)
```

Using this plot, we can see that cluster 4 corresponds to B-cells, cluster 2 is T-cells etc. This information can be used to manually annotate the cells as follows:

```python
# create a dictionary to map cluster to annotation label
cluster2annotation = {
    "0": "Monocytes",
    "1": "NK",
    "2": "T-cell",
    "3": "Dendritic",
    "4": "Dendritic",
    "5": "Plasma",
    "6": "B-cell",
    "7": "Dendritic",
    "8": "Other",
}

# add a new `.obs` column called `cell type` by mapping clusters to annotation using pandas map
pbmc.obs["cell type"] = pbmc.obs["clusters"].map(cluster2annotation).astype("category")
```

```python
sc.pl.dotplot(pbmc, marker_genes_dict, "cell type", dendrogram=True)
```

```python
sc.pl.umap(
    pbmc,
    color="cell type",
    legend_loc="on data",
    frameon=False,
    legend_fontsize=10,
    legend_fontoutline=2,
)
```

### Violin Plot

A different way to explore the markers is with violin plots. Here we can see the expression of CD79A in clusters 5 and 8, and MS4A1 in cluster 5. Compared to a dotplot, the violin plot gives us an idea of the distribution of gene expression values across cells.

> **Note:** Violin plots can also be used to plot any numerical value stored in `.obs`. For example, here violin plots are used to compare the number of genes and the percentage of mitochondrial genes between the different clusters.

```python
with rc_context({"figure.figsize": (4.5, 3)}):
    sc.pl.violin(pbmc, ["CD79A", "MS4A1"], groupby="clusters")
```

```python
with rc_context({"figure.figsize": (4.5, 3)}):
    sc.pl.violin(
        pbmc,
        ["n_genes", "percent_mito"],
        groupby="clusters",
        stripplot=False,  # remove the internal dots
        inner="box",  # adds a boxplot inside violins
    )
```

### Stacked-Violin Plot

To simultaneously look at the violin plots for all marker genes we use `sc.pl.stacked_violin`. As previously, a dendrogram was added to group similar clusters.

```python
ax = sc.pl.stacked_violin(
    pbmc, marker_genes_dict, groupby="clusters", swap_axes=False, dendrogram=True
)
```

### Matrixplot

A simple way to visualize the expression of genes is with a `matrix plot`. This is a heatmap of the mean expression values per gene grouped by categories. This type plot basically shows the same information as the color in the dotplots.

Here, we scale the expression of the genes from 0 to 1, being 1 the maximum mean expression and 0 the minimum.

```python
sc.pl.matrixplot(
    pbmc,
    marker_genes_dict,
    "clusters",
    dendrogram=True,
    cmap="Blues",
    standard_scale="var",
    colorbar_title="column scaled\nexpression",
)
```

Another useful option is to normalize the gene expression using `sc.pp.scale`. Here we store this information under the `scale` layer. Afterwards we adjust the plot min and max and use a diverging color map (in this case `RdBu_r` where `_r` means reversed).

```python
# scale and store results in layer
pbmc.layers["scaled"] = sc.pp.scale(pbmc, copy=True).X

sc.pl.matrixplot(
    pbmc,
    marker_genes_dict,
    "clusters",
    dendrogram=True,
    colorbar_title="mean z-score",
    layer="scaled",
    vmin=-2,
    vmax=2,
    cmap="RdBu_r",
)
```

## Combining Plots in Subplots

An `axis` can be passed to a plot to combine multiple outputs as in the following example:

```python
import matplotlib.pyplot as plt

fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(20, 4), gridspec_kw={"wspace": 0.9})

ax1_dict = sc.pl.dotplot(
    pbmc, marker_genes_dict, groupby="bulk_labels", ax=ax1, show=False
)

ax2_dict = sc.pl.stacked_violin(
    pbmc, marker_genes_dict, groupby="bulk_labels", ax=ax2, show=False
)

ax3_dict = sc.pl.matrixplot(
    pbmc, marker_genes_dict, groupby="bulk_labels", ax=ax3, show=False, cmap="viridis"
)
```

## Heatmaps

Heatmaps do not collapse cells as in previous plots. Instead, each cell is shown in a row (or column if `swap_axes=True`). The groupby information can be added and is shown using the same color code found for `sc.pl.umap` or any other embedding.

```python
ax = sc.pl.heatmap(
    pbmc, marker_genes_dict, groupby="clusters", cmap="viridis", dendrogram=True
)
```

The heatmap can also be plotted on scaled data. In the next image, similar to the previous matrixplot, the min and max had been adjusted and a divergent color map is used.

```python
ax = sc.pl.heatmap(
    pbmc,
    marker_genes_dict,
    groupby="clusters",
    layer="scaled",
    vmin=-2,
    vmax=2,
    cmap="RdBu_r",
    dendrogram=True,
    swap_axes=True,
    figsize=(11, 4),
)
```

## Tracksplot

The track plot shows the same information as the heatmap, but instead of a color scale, the gene expression is represented by height.

```python
ax = sc.pl.tracksplot(pbmc, marker_genes_dict, groupby="clusters", dendrogram=True)
```

## Visualization of Marker Genes

Instead of characterizing clusters by known gene markers as previously, we can identify genes that are differentially expressed in the clusters or groups.

To identify differentially expressed genes we run `sc.tl.rank_genes_groups`. This function will take each group of cells and compare the distribution of each gene in a group against the distribution in all other cells not in the group. Here, we will use the original cell labels given by 10x to identify marker genes for those cell types.

### Visualize Marker Genes Using Dotplot

The dotplot visualization is useful to get an overview of the genes that show differential expression. To make the resulting image more compact we will use `n_genes=4` to show only the top 4 scoring genes.

```python
sc.tl.rank_genes_groups(pbmc, groupby="clusters", method="wilcoxon")
sc.pl.rank_genes_groups_dotplot(pbmc, n_genes=4)
```

In order to get a better representation we can plot log fold changes instead of gene expression. Also, we want to focus on genes that have a log fold change >= 3 between the cell type expression and the rest of cells.

In this case we set `values_to_plot='logfoldchanges'` and `min_logfoldchange=3`.

Because log fold change is a divergent scale we also adjust the min and max to be plotted and use a divergent color map. Notice in the following plot that it is rather difficult to distinguish between T-cell populations.

```python
sc.pl.rank_genes_groups_dotplot(
    pbmc,
    n_genes=4,
    values_to_plot="logfoldchanges",
    min_logfoldchange=3,
    vmax=7,
    vmin=-7,
    cmap="bwr",
)
```

#### Focusing on Particular Groups

Next, we use a dotplot focusing only on two groups (the groups option is also available for violin, heatmap and matrix plots). Here, we set `n_genes=30` as in this case it will show all the genes that have a `min_logfoldchange=4` up to 30.

```python
sc.pl.rank_genes_groups_dotplot(
    pbmc,
    n_genes=30,
    values_to_plot="logfoldchanges",
    min_logfoldchange=4,
    vmax=7,
    vmin=-7,
    cmap="bwr",
    groups=["3", "7"],
)
```

### Visualize Marker Genes Using Matrixplot

For the following plot we use the previously computed 'scaled' values (stored in layer `scaled`) and use a divergent color map.

```python
sc.pl.rank_genes_groups_matrixplot(
    pbmc, n_genes=3, use_raw=False, vmin=-3, vmax=3, cmap="bwr", layer="scaled"
)
```

### Visualize Marker Genes Using Stacked Violin Plots

```python
sc.pl.rank_genes_groups_stacked_violin(pbmc, n_genes=3, cmap="viridis_r")
```

### Visualize Marker Genes Using Heatmap

```python
sc.pl.rank_genes_groups_heatmap(
    pbmc,
    n_genes=3,
    use_raw=False,
    swap_axes=True,
    vmin=-3,
    vmax=3,
    cmap="bwr",
    layer="scaled",
    figsize=(10, 7),
    show=False,
)
```

Showing 10 genes per category, turning the gene labels off and swapping the axes. Notice that when the image is swapped, a color code for the categories appears instead of the 'brackets'.

```python
sc.pl.rank_genes_groups_heatmap(
    pbmc,
    n_genes=10,
    use_raw=False,
    swap_axes=True,
    show_gene_labels=False,
    vmin=-3,
    vmax=3,
    cmap="bwr",
)
```

### Visualize Marker Genes Using Tracksplot

```python
sc.pl.rank_genes_groups_tracksplot(pbmc, n_genes=3)
```

## Comparison of Marker Genes Using Split Violin Plots

In scanpy, it is very easy to compare marker genes using split violin plots for all groups at once.

```python
with rc_context({"figure.figsize": (9, 1.5)}):
    sc.pl.rank_genes_groups_violin(pbmc, n_genes=20, jitter=False)
```

## Dendrogram Options

Most of the visualizations can arrange the categories using a dendrogram. However, the dendrogram can also be plotted independently as follows:

```python
# compute hierarchical clustering using PCs (several distance metrics and linkage methods available)
sc.tl.dendrogram(pbmc, "bulk_labels")
ax = sc.pl.dendrogram(pbmc, "bulk_labels")
```

## Plot Correlation

Together with the dendrogram it is possible to plot the correlation (by default 'pearson') of the categories.

```python
ax = sc.pl.correlation_matrix(pbmc, "bulk_labels", figsize=(5, 3.5))
```

---

*Version: scanpy 1.10.x*