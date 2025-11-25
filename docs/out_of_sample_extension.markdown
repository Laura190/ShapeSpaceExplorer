---
layout: default
title: Out of Sample Extension
permalink: /out_of_sample_extension/
nav_order: 9
---

# Out of Sample Extension

First, create a folder for the extension sample, we'll call it OoSE folder and prepare the data:
- Run <code>1-ImageSegmentationFull > Run_CellSegmentation.m</code> and select the OoSE folder as your Analysis folder
- Either correct data manually, using <code>Inspect Data</code> for all <code>ImageStacksXXX.mat</code> and run 
<code>1-ImageSegmentationFull > MakeBigStructs.m</code> or continue without inspection and run
<code>1-ImageSegmentationFull > MakeBigStructsWithoutManual.m</code>.

Secondly, run <code>6-OoSE > generate_OoSe_distMatrix_new</code>. Choose Analysis and OoSE folders. Choose one of the embedding methods: [K Nearest Neighbours](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm) or [Laplacian Pyramids](https://doi.org/10.1137/1.9781611972825.17). If using K nearest neighbours enter the value of K in the box below. This value is ignored for the Laplacian Pyramids method. Click <code>Start OOSE</code>. 
<img align="center" width=500px src="./img/oose_config1.png">

After correctly finishing, there will be new files in the OOSE folder:
- Dist_mat.mat
- OoSE_embedding.mat
- LP_trained.mat (if the Laplacian Pyramids method was used)

To compare the OOSE sample within the shape parameters and cluster parameters of say the control sample, run <code>6-OoSE > createBargraphs.m</code>. Before running this step you must have previously run <code>5-Extended_Affinity_Propagation > Run_Affinity_Propagation.m</code> for the reference sample (Analysis folder) \
<img align="center" width=500px src="./img/oose_config3.png">

For clusters, select the best numbers from the reference (Analysis) sample. The new subset will be plotted in shape space using the two most distinctive features for x- and y-axis from the larger sample in Analysis. The sample in the Analysis folder is used as ‘reference’ clusters and compared to the extension sample. \
<img align="center" width=500px src="./img/abs_clusters.png"> 

Bar graphs for clusters with absolute numbers \
<img align="center" width=500px src="./img/shape_space_ref_grey.png"> 

Shape space with reference dots in grey and sample extension in colour \
<img align="center" width=500px src="./img/shape_space_ref_empty.png"> 

Extension shapes in full circles and reference shapes in empty circles.

Note: All Figures are saved within a Figures folder in the in OoSE folder and the values for the bar graphs are written to CSV files.
