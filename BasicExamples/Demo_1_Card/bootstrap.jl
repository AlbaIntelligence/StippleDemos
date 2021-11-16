pwd() == joinpath(@__DIR__, "bin") && cd(@__DIR__) # allow starting app from bin/ dir

cd("BasicExamples/Demo_1_Card")
pwd()

using Pkg
Pkg.activate(".")

# Use the latest versions of the necessary packages
Pkg.develop("Genie")
Pkg.develop("Stipple")
Pkg.develop("StippleUI")
# Pkg.develop("StippleCharts")

using Revise

using Genie, Genie.Renderer.Html
using Stipple
using StippleUI
# using StippleCharts

# Note that the use of the packages is fully qualified in the code below to be explicit
# where the functions come from. The qualifications are not necessary otherwise.


using Demo1Card
push!(Base.modules_warned_for, Base.PkgId(Demo1Card))
Demo1Card.main()


using Genie, Genie.Renderer.Html
using .Demo1Card

# routes
include("routes.jl")

Genie.up(rand(8400:8700), "localhost"; open_browser = true, async = true)
