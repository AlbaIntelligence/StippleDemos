# Those lines are to visually confirm that the the package/module is in the current path
# pwd()
# cd("BasicExamples")
# pwd()

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




# Confirm to Julia to show any problems when loading the module defining model
# push!(Base.modules_warned_for, Base.PkgId(BasicExamples))

using BasicExamples

# BasicExamples.main()


# Create a server presenting the card
# top webpage is a welcome page
# the demos are on separate addresses given by their respective routes
# BasicExamples_server = BasicExamples.create_server(; async = true, verbose=true, open_browser = true)
