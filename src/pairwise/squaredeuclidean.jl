@doc raw"""
    SquaredEuclidean

The squared Euclidean function is defined by:

```math
f(\mathbf{x}, \mathbf{y}) = (\mathbf{x} - \mathbf{y})^{\intercal}(\mathbf{x} - \mathbf{y})
```
"""
struct SquaredEuclidean <: PreMetric end

@inline pairwise_aggregate(::SquaredEuclidean, s::T, x::T, y::T) where {T} = s + (x-y)^2

@inline isstationary(::SquaredEuclidean) = true
@inline isisotropic(::SquaredEuclidean)  = true
