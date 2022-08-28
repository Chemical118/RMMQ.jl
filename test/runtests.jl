using RMMQ, Test

n = 100000
x = rand(n)

Si = min_solve(x)
Sa = max_solve(x)
Sb = both_solve(x)


for ind in 1:1000
    i, j = rand(1:n), rand(1:n)
    ti, tj = i > j ? (j, i) : (i, j)


    rmin, rmax = extrema(@view x[ti:tj])

    pmin = get_val(Si, i, j)
    pmax = get_val(Sa, i, j)
    pmin1, pmax1 = get_val(Sb, i, j)

    @test (pmin, pmax) == (pmin1, pmax1)
    @test pmin == rmin
    @test pmax == rmax
end