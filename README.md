# RMMQ.jl
`RMMQ` provides fast way to get a minimum, maximum value by using [`Range minimum query`](https://en.wikipedia.org/wiki/Range_minimum_query)

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

Smin = min_solve(x)
Smax = min_solve(x)
Sboth = both_solve(x)

i, j = 10, 1000

@printf "%f %f\n" get_val(Sboth, i, j)...
println(get_val(Smin, i, j))
println(get_val(Smax, i, j))
```