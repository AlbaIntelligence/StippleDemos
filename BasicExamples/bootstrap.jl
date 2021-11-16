pwd()
cd("BasicExamples")

pwd() == joinpath(@__DIR__, "bin") && cd(@__DIR__) # allow starting app from bin/ dir
pwd()

using Pkg
Pkg.activate(".")

# Use the latest versions of the necessary packages
Pkg.develop("Genie")
Pkg.develop("Stipple")
Pkg.develop("StippleUI")
Pkg.develop("StippleCharts")

using Revise

using Genie, Genie.Renderer.Html
using Stipple
using StippleUI
using StippleCharts

using BasicExamples
push!(Base.modules_warned_for, Base.PkgId(BasicExamples))
BasicExamples.main()


# Create a server presenting the card
# top webpage is a welcome page
# the demo is on /card
BasicExamples_server = create_server(; async = true, verbose=true, open_browser = true)
