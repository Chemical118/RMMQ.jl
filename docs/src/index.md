# RMMQ.jl Documentation
## Overview
`RMMQ` provides fast way to get a minimum, maximum value by using [`Range minimum query`](https://en.wikipedia.org/wiki/Range_minimum_query).

[![codecov](https://codecov.io/gh/Chemical118/RMMQ.jl/branch/master/graph/badge.svg?token=TT6PWZU5OP)](https://codecov.io/gh/Chemical118/RMMQ.jl)

## Install
```julia
using Pkg
Pkg.add(url="https://github.com/Chemical118/RMMQ.jl")
```

## Example
You can convert a solver from the array and use the sliced solver in the basic function.
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