using RMMQ, Test

n = 100000
x = rand(n)

mi = MinSolver(x)
ma = MaxSolver(x)
ex = ExtreSolver(x)

@testset "Solver struct exception test" begin
    @test_throws ErrorException minimum(ma)
    @test_throws ErrorException minimum(ma[1:n])
    @test_throws ErrorException maximum(mi)
    @test_throws ErrorException maximum(mi[1:n])
    @test_throws ErrorException extrema(mi)
    @test_throws ErrorException extrema(mi[1:n])
    @test_throws ErrorException extrema(ma)
    @test_throws ErrorException extrema(ma[1:n])
end

@testset "Solver index exception test" begin
    @test_throws ErrorException minimum(mi[n:1])
    @test_throws ErrorException maximum(ma[n:1])
    @test_throws ErrorException minimum(ex[n:1])
    @test_throws ErrorException maximum(ex[n:1])
    @test_throws ErrorException extrema(ex[n:1])
end

@testset "Solver partial value test" begin
    for ind in 1:1000
        i, j = rand(1:n), rand(1:n)
        ti, tj = i > j ? (j, i) : (i, j)


        rmin, rmax = extrema(@view x[ti:tj])

        pmin = minimum(mi[ti:tj])
        pmax = maximum(ma[ti:tj])
        pmin1, pmax1 = extrema(ex[ti:tj])
        pmin2, pmax2 = minimum(ex[ti:tj]), maximum(ex[ti:tj])

        @test (pmin, pmax) == (pmin1, pmax1)
        @test (pmin, pmax) == (pmin2, pmax2)
        @test pmin == rmin
        @test pmax == rmax
    end
end

@testset "Solver value test" begin
    rmin, rmax = extrema(x)

    pmin = minimum(mi)
    pmax = maximum(ma)
    pmin1, pmax1 = extrema(ex)
    pmin2, pmax2 = minimum(ex), maximum(ex)

    @test (pmin, pmax) == (pmin1, pmax1)
    @test (pmin, pmax) == (pmin2, pmax2)
    @test pmin == rmin
    @test pmax == rmax
end