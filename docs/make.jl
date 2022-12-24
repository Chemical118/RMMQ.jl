using Documenter, RMMQ

makedocs(
    sitename = "ProRF.jl",
    authors = "Ryu Hyunwoo",
    # format = Documenter.LaTeX(),
    doctest = true,
    modules = [RMMQ],
    pages = [
        "Introduction" => "index.md",
        "Library" => "library/lib.md",
        "Index" => "library/ind.md",
    ]
)

deploydocs(
    repo = "github.com/Chemical118/ProRF.jl.git",
)