# RMMQ.jl
`RMMQ` provides fast way to get a minimum, maximum value by using [`Range minimum query`](https://en.wikipedia.org/wiki/Range_minimum_query).

[![CI](https://github.com/Chemical118/RMMQ.jl/workflows/CI/badge.svg)](https://github.com/Chemical118/RMMQ.jl/actions?query=workflow%3ACI)
[![Codecov](https://codecov.io/gh/Chemical118/RMMQ.jl/branch/master/graph/badge.svg?token=TT6PWZU5OP)](https://codecov.io/gh/Chemical118/RMMQ.jl)
[![Docs Latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://chemical118.github.io/RMMQ.jl/dev/)

## Install
```julia
using Pkg
Pkg.add(url="https://github.com/Chemical118/RMMQ.jl")
```

## Example
```julia
using RMMQ, Printf

n = 1000
x = rand(n)

Smin = MinSolver(x)
Smax = MaxSolver(x)
Sext = ExtreSolver(x)

i, j = 10, 1000

@printf "%f %f\n" extrema(Sext[i:j])...
println(minimum(Smin[i:j]))
println(maximum(Smax[i:j]))
```