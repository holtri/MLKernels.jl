# Kernel Scalar & Vector Operation  ========================================================

function kernel(κ::Kernel{T}, x::T, y::T) where {T<:AbstractFloat}
    kappa(κ, pairwise(pairwisefunction(κ), x, y))
end

function kernel(
        κ::Kernel{T},
        x::AbstractArray{T},
        y::AbstractArray{T}
    ) where {T<:AbstractFloat}
    kappa(κ, pairwise(pairwisefunction(κ), x, y))
end


# Kernel Matrix Calculation ================================================================

function kappamatrix!(κ::Kernel{T}, P::AbstractMatrix{T}) where {T<:AbstractFloat}
    for i in eachindex(P)
        @inbounds P[i] = kappa(κ, P[i])
    end
    P
end

function symmetric_kappamatrix!(
        κ::Kernel{T},
        P::AbstractMatrix{T},
        symmetrize::Bool
    ) where {T<:AbstractFloat}
    if !((n = size(P,1)) == size(P,2))
        throw(DimensionMismatch("Pairwise matrix must be square."))
    end
    for j = 1:n, i = (1:j)
        @inbounds P[i,j] = kappa(κ, P[i,j])
    end
    symmetrize ? LinearAlgebra.copytri!(P, 'U') : P
end

"""
    kernelmatrix!(P::Matrix, σ::Orientation, κ::Kernel, X::Matrix, symmetrize::Bool)

In-place version of `kernelmatrix` where pre-allocated matrix `K` will be overwritten
with the kernel matrix.
"""
function kernelmatrix!(
        σ::Orientation,
        P::Matrix{T},
        κ::Kernel{T},
        X::AbstractMatrix{T},
        symmetrize::Bool
    ) where {T<:AbstractFloat}
    pairwisematrix!(σ, P, pairwisefunction(κ), X, false)
    symmetric_kappamatrix!(κ, P, symmetrize)
end

"""
    kernelmatrix!(K::Matrix, σ::Orientation, κ::Kernel, X::Matrix, Y::Matrix)

In-place version of `kernelmatrix` where pre-allocated matrix `K` will be overwritten with
the kernel matrix.
"""
function kernelmatrix!(
        σ::Orientation,
        P::Matrix{T},
        κ::Kernel{T},
        X::AbstractMatrix{T},
        Y::AbstractMatrix{T}
    ) where {T<:AbstractFloat}
    pairwisematrix!(σ, P, pairwisefunction(κ), X, Y)
    kappamatrix!(κ, P)
end

function kernelmatrix(
        σ::Orientation,
        κ::Kernel{T},
        X::AbstractMatrix{T},
        symmetrize::Bool = true
    ) where {T<:AbstractFloat}
    symmetric_kappamatrix!(κ, pairwisematrix(σ, pairwisefunction(κ), X, false), symmetrize)
end

function kernelmatrix(
        σ::Orientation,
        κ::Kernel{T},
        X::AbstractMatrix{T},
        Y::AbstractMatrix{T}
    ) where {T<:AbstractFloat}
    kappamatrix!(κ, pairwisematrix(σ, pairwisefunction(κ), X, Y))
end


# Convenience Methods ======================================================================

"""
    kernel(κ::Kernel, x, y)

Apply the kernel `κ` to ``x`` and ``y`` where ``x`` and ``y`` are vectors or scalars of
some subtype of ``Real``.
"""
function kernel(κ::Kernel{T}, x::Real, y::Real) where {T}
    kernel(κ, T(x), T(y))
end

function kernel(
        κ::Kernel{T},
        x::AbstractArray{T1},
        y::AbstractArray{T2}
    ) where {T,T1,T2}
    kernel(κ, convert(AbstractArray{T}, x), convert(AbstractArray{T}, y))
end

"""
    kernelmatrix([σ::Orientation,] κ::Kernel, X::Matrix [, symmetrize::Bool])

Calculate the kernel matrix of `X` with respect to kernel `κ`.
"""
function kernelmatrix(
        σ::Orientation,
        κ::Kernel{T},
        X::AbstractMatrix{T1},
        symmetrize::Bool = true
    ) where {T,T1}
    U = convert(AbstractMatrix{T}, X)
    kernelmatrix(σ, κ, U, symmetrize)
end

function kernelmatrix(
        κ::Kernel,
        X::AbstractMatrix,
        symmetrize::Bool = true
    )
    kernelmatrix(Val(:row), κ, X, symmetrize)
end

"""
    kernelmatrix([σ::Orientation,] κ::Kernel, X::Matrix, Y::Matrix)

Calculate the pairwise matrix of `X` and `Y` with respect to kernel `κ`.
"""
function kernelmatrix(
        σ::Orientation,
        κ::Kernel{T},
        X::AbstractMatrix{T1},
        Y::AbstractMatrix{T2}
    ) where {T,T1,T2}
    U = convert(AbstractMatrix{T}, X)
    V = convert(AbstractMatrix{T}, Y)
    kernelmatrix(σ, κ, U, V)
end

function kernelmatrix(
        κ::Kernel,
        X::AbstractMatrix,
        Y::AbstractMatrix
    )
    kernelmatrix(Val(:row), κ, X, Y)
end


# Kernel Centering =========================================================================

@doc raw"""
    centerkernelmatrix(K::Matrix)

Centers the (rectangular) kernel matrix `K` with respect to the implicit Kernel Hilbert
Space according to the following formula:

```math
[\mathbf{K}]_{ij}
= \langle\phi(\mathbf{x}_i) -\mathbf{\mu}_{\phi\mathbf{x}}, \phi(\mathbf{y}_j)
- \mathbf{\mu}_{\phi\mathbf{y}} \rangle
```
Where ``\mathbf{\mu}_{\phi\mathbf{x}}`` and ``\mathbf{\mu}_{\phi\mathbf{x}}`` are given by:

```math
\mathbf{\mu}_{\phi\mathbf{x}}
= \frac{1}{n} \sum_{i=1}^n \phi(\mathbf{x}_i)
\qquad \qquad
\mathbf{\mu}_{\phi\mathbf{y}}
= \frac{1}{m} \sum_{i=1}^m \phi(\mathbf{y}_i)
```
"""
function centerkernelmatrix!(K::Matrix{T}) where {T<:AbstractFloat}
    μx = Statistics.mean(K, dims = 2)
    μy = Statistics.mean(K, dims = 1)
    μ  = Statistics.mean(K)

    K .+= μ .- μx .- μy

    return K
end
centerkernelmatrix(K::Matrix) = centerkernelmatrix!(copy(K))