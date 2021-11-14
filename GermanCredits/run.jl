using Pkg

# Check Directory
pwd()
cd("GermanCredits")
pwd()

Pkg.activate(".")

using Revise
using Genie
include("src/GermanCredits.jl")

up(8765, "localhost"; async=true)
