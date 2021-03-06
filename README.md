# Machine Learning Kernels

[![Documentation Status](https://readthedocs.org/projects/mlkernels/badge/?version=latest)](http://mlkernels.readthedocs.org/en/latest/?badge=latest)
[![Build Status](https://travis-ci.org/trthatcher/MLKernels.jl.svg?branch=master)](https://travis-ci.org/trthatcher/MLKernels.jl)
[![Coverage Status](https://coveralls.io/repos/trthatcher/MLKernels.jl/badge.svg)](https://coveralls.io/r/trthatcher/MLKernels.jl)

#### Summary

**MLKernels.jl** is a Julia package for Mercer kernel functions (or the
covariance functions used in Gaussian processes) that are used in the kernel
methods of machine learning. This package provides a flexible datatype for
representing and constructing machine learning kernels as well as an efficient
set of methods to compute or approximate kernel matrices. The package has no
dependencies beyond base Julia.

#### Documentation

Full [documentation](http://mlkernels.readthedocs.org/en/latest/) is available
on **Read the Docs**.

#### Visualization

Through the use of kernel functions, kernel-based methods may operate in a high
(potentially infinite) dimensional implicit feature space without explicitly
mapping data from the original feature space to the new feature space.
Non-linearly separable data may be linearly separable in the transformed space.
For example, the following data set is not linearly separable:

<p align="center"><img alt="Feature Space" src="docs/images/featurespace.png"  /></p>

Using a Polynomial Kernel of degree 2, the points are mapped to a 3-dimensional
space where a plane can be used to linearly separate the data:

<p align="center"><img alt="Transformed Data" src="docs/images/hilbertspace.png"  /></p>

Explicitly, the Polynomial Kernel of degree 2 maps the data to a cone in
3-dimensional space. The intersecting hyperplane forms a conic section with the
cone:

<p align="center"><img alt="Transformed Data" src="docs/images/kernelgeometry.png"  /></p>

When translated back to the original feature space, the conic section
corresponds to a circle which can be used to perfectly separate the data:

<p align="center"><img alt="Separating Hyperplane" src="docs/images/featurespaceseparated.png"  /></p>

The above plots were generated using
[PyPlot.jl](https://github.com/stevengj/PyPlot.jl).
