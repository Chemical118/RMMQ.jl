module RMMQ

export MinSolver, MaxSolver, ExtreSolver

"""
Supertype for [`MinSolver`](@ref), [`MaxSolver`](@ref), [`ExtreSolver`](@ref).
"""
abstract type AbstractSolver end

"""
Supertype for [`MinSolverData`](@ref), [`MaxSolverData`](@ref), [`ExtreSolverData`](@ref).
"""
abstract type AbstractSolverData end

"""
    MinSolver(arr::Vector{T}) where T <: Real

solver struct for minimum value.
"""
struct MinSolver{T <: Real} <: AbstractSolver
    solver_min::Matrix{T}
    Log::Vector{Int}
end

"""
    MaxSolver(arr::Vector{T}) where T <: Real

solver struct for maximum value.
"""
struct MaxSolver{T <: Real} <: AbstractSolver
    solver_max::Matrix{T}
    Log::Vector{Int}
end

"""
    ExtreSolver(arr::Vector{T}) where T <: Real

solver struct for minimum, maximum value.
"""
struct ExtreSolver{T <: Real} <: AbstractSolver
    solver_min::Matrix{T}
    solver_max::Matrix{T}
    Log::Vector{Int}
end

"""
data struct for [`MinSolver`](@ref) and index
"""
struct MinSolverData <: AbstractSolverData
    S::MinSolver
    I::UnitRange{Int}
end

"""
data struct for [`MaxSolver`](@ref) and index
"""
struct MaxSolverData <: AbstractSolverData
    S::MaxSolver
    I::UnitRange{Int}
end

"""
data struct for [`ExtreSolver`](@ref) and index
"""
struct ExtreSolverData <: AbstractSolverData
    S::ExtreSolver
    I::UnitRange{Int}
end

function MinSolver(arr::Vector{T}) where T <: Real
    N = length(arr)
    
    Log = Array{Int}(undef, N)
    Log[1] = 0
    for i in 2:N
        Log[i] = Log[floor(Int, i/2)] + 1
    end

    K = Log[N]
    spt = Array{T}(undef, N, K+1)

    for i in 1:N
        spt[i, 1] = arr[i]
    end

    for j in 2:K+1 
        for i in 1:N+1
            if i + 2^(j-1) > N+1
                break
            end
            spt[i, j] = min(spt[i, j-1], spt[i + 2^(j-2), j-1])
        end
    end

    return MinSolver(spt, Log)
end

function MaxSolver(arr::Vector{T}) where T <: Real
    N = length(arr)
    
    Log = Array{Int}(undef, N)
    Log[1] = 0
    for i in 2:N
        Log[i] = Log[floor(Int, i/2)] + 1
    end

    K = Log[N]
    spt = Array{T}(undef, N, K+1)

    for i in 1:N
        spt[i, 1] = arr[i]
    end

    for j in 2:K+1 
        for i in 1:N+1
            if i + 2^(j-1) > N+1
                break
            end
            spt[i, j] = max(spt[i, j-1], spt[i + 2^(j-2), j-1])
        end
    end

    return MaxSolver(spt, Log)
end

function ExtreSolver(arr::Vector{T}) where T <: Real
    N = length(arr)
    
    Log = Array{Int}(undef, N)
    Log[1] = 0
    for i in 2:N
        Log[i] = Log[floor(Int, i/2)] + 1
    end

    K = Log[N]
    spt_min = Array{T}(undef, N, K+1)
    spt_max = Array{T}(undef, N, K+1)

    for i in 1:N
        spt_max[i, 1] = spt_min[i, 1] = arr[i]
    end

    for j in 2:K+1 
        for i in 1:N+1
            if i + 2^(j-1) > N+1
                break
            end
            spt_min[i, j] = min(spt_min[i, j-1], spt_min[i + 2^(j-2), j-1])
            spt_max[i, j] = max(spt_max[i, j-1], spt_max[i + 2^(j-2), j-1])
        end
    end

    return ExtreSolver(spt_min, spt_max, Log)
end

"""
    Base.getindex(S::AbstractSolver, I::UnitRange{Int})

return data with solver and index.
"""
function Base.getindex(S::AbstractSolver, I::UnitRange{Int})
    if S isa MinSolver
        return MinSolverData(S, I)
    elseif S isa MaxSolver
        return MaxSolverData(S, I)
    elseif S isa ExtreSolver
        return ExtreSolverData(S, I)
    else
        error("Undefined solver struct!")
    end
end

"""
    Base.minimum(D::AbstractSolverData)
"""
function Base.minimum(D::AbstractSolverData)
    if D isa MaxSolverData
        error(split(split(string(typeof(D.S)), '.')[end], '{')[1] * " can't get minimum value.")
    else
        return _get_minimum(D.S, D.I.start, D.I.stop)
    end
end

"""
    Base.minimum(S::AbstractSolver)
"""
function Base.minimum(S::AbstractSolver)
    if S isa MaxSolver
        error(split(split(string(typeof(S)), '.')[end], '{')[1] * " can't get minimum value.")
    else
        return _get_minimum(S, 1, size(S.solver_min, 1))
    end
end

"""
    Base.maximum(D::AbstractSolverData)
"""
function Base.maximum(D::AbstractSolverData)
    if D isa MinSolverData
        error(split(split(string(typeof(D.S)), '.')[end], '{')[1] * " can't get maximum value.")
    else
        return _get_maximum(D.S, D.I.start, D.I.stop)
    end
end

"""
    Base.maximum(S::AbstractSolver)
"""
function Base.maximum(S::AbstractSolver)
    if S isa MinSolver
        error(split(split(string(typeof(S)), '.')[end], '{')[1] * " can't get maximum value.")
    else
        return _get_maximum(S, 1, size(S.solver_max, 1))
    end
end

"""
    Base.extrema(D::AbstractSolverData)
"""
function Base.extrema(D::AbstractSolverData)
    if D isa ExtreSolverData
        return _get_extrema(D.S, D.I.start, D.I.stop)
    else
        error(split(split(string(typeof(D.S)), '.')[end], '{')[1] * " can't get extrema value.")
    end
end

"""
    Base.extrema(S::AbstractSolver)
"""
function Base.extrema(S::AbstractSolver)
    if S isa ExtreSolver
        return _get_extrema(S, 1, size(S.solver_min, 1))
    else
        error(split(split(string(typeof(S)), '.')[end], '{')[1] * " can't get extrema value.")
    end
end

function _get_minimum(S::MinSolver, x::Int, y::Int)
    if x > y
        x, y = y, x
    end

    j = S.Log[y - x + 1]
    return min(S.solver_min[x, j+1], S.solver_min[y - 2^j + 1, j+1])
end

function _get_minimum(S::ExtreSolver, x::Int, y::Int)
    if x > y
        x, y = y, x
    end

    j = S.Log[y - x + 1]
    return min(S.solver_min[x, j+1], S.solver_min[y - 2^j + 1, j+1])
end

function _get_maximum(S::MaxSolver, x::Int, y::Int)
    if x > y
        x, y = y, x
    end

    j = S.Log[y - x + 1]
    return max(S.solver_max[x, j+1], S.solver_max[y - 2^j + 1, j+1])
end

function _get_maximum(S::ExtreSolver, x::Int, y::Int)
    if x > y
        x, y = y, x
    end

    j = S.Log[y - x + 1]
    return max(S.solver_max[x, j+1], S.solver_max[y - 2^j + 1, j+1])
end

function _get_extrema(S::ExtreSolver, x::Int, y::Int)
    if x > y
        x, y = y, x
    end

    j = S.Log[y - x + 1]
    return min(S.solver_min[x, j+1], S.solver_min[y - 2^j + 1, j+1]), max(S.solver_max[x, j+1], S.solver_max[y - 2^j + 1, j+1])
end
end # module end
