---
layout: default
title: Shape Manifold Embedding
permalink: /shape_manifold_embedding/
nav_order: 4
---

# Shape Manifold Embedding

Run <code>2-ShapeManifoldEmbedding > RunShapeManifoldEmbedding.m</code>, which asks for the Analysis folder as input and gives the user the option of using sparse decomposition. The number of new dimensions to be calculated can also be entered, the default is 5.
<img align="center" width=500px src="./img/ShapeManifoldEmbeddingDialog.png">

Once correctly completed, a file called <code>CellShapeData.mat</code> is created in the Analysis folder

This process is relatively slow: for a set of 4000 shapes, it takes about 8 minutes, while for 37818 shapes, the calculations require about 31 hours, approximately 1.5 to 2 days. The sparse implementation is much faster, requiring only 5 hours for 37818 shapes. It uses MATLAB's [eigs](https://uk.mathworks.com/help/matlab/ref/eigs.html) function rather than [eig](https://uk.mathworks.com/help/matlab/ref/eig.html). It is correct up to a +/- sign. This effects how the data is viewed in shape space but does not effect any subsequent measurements.
