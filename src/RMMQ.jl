module RMMQ

export min_solve, max_solve, both_solve, get_val

abstract type AbstractSolver end

struct MinSolver{T <: Real} <: AbstractSolver
    solver_min::Matrix{T}
    Log::Vector{Int}
end

struct MaxSolver{T <: Real} <: AbstractSolver
    solver_max::Matrix{T}
    Log::Vector{Int}
end

struct BothSolver{T <: Real} <: AbstractSolver
    solver_min::Matrix{T}
    solver_max::Matrix{T}
    Log::Vector{Int}
end

function min_solve(arr::Vector{T}) where T <: Real
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

function max_solve(arr::Vector{T}) where T <: Real
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

function both_solve(arr::Vector{T}) where T <: Real
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

    return BothSolver(spt_min, spt_max, Log)
end

function get_val(S::MinSolver, x::Int, y::Int)
    if x > y
        x, y = y, x
    end

    j = S.Log[y - x + 1]
    return min(S.solver_min[x, j+1], S.solver_min[y - 2^j + 1, j+1])
end

function get_val(S::MaxSolver, x::Int, y::Int)
    if x > y
        x, y = y, x
    end

    j = S.Log[y - x + 1]
    return max(S.solver_max[x, j+1], S.solver_max[y - 2^j + 1, j+1])
end

function get_val(S::BothSolver, x::Int, y::Int)
    if x > y
        x, y = y, x
    end

    j = S.Log[y - x + 1]
    return min(S.solver_min[x, j+1], S.solver_min[y - 2^j + 1, j+1]), max(S.solver_max[x, j+1], S.solver_max[y - 2^j + 1, j+1])
end
end # module end
