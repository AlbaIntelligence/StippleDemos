#
# The demos are to be run in their own directory from the REPL
#

# To check you are at the right place
pwd()
cd("IrisClustering")
pwd()

# Use the local Project.toml
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


#= Data =#

# Definition of a model (something that does or will contain reactive values (i.e.
# Observables) as concrete type of `ReactiveModel`

Base.@kwdef mutable struct IrisModel_1 <: ReactiveModel end


#= Stipple setup =#

# Utility function for adding Vue components that need to be registered with the Vue.js
# app. This is usually needed for registering components provided by StippleCharts plugins.
# Stipple.register_components(IrisModel_1, StippleCharts.COMPONENTS)
model_iris_1 = Stipple.init(IrisModel_1())


#= UI =#

function ui(model::IrisModel_1)
  [
    StippleUI.dashboard(
      Stipple.vm(model),
      class = "container",
      title = "Iris Flowers Clustering",
      head_content = Genie.Assets.favicon_support(),

      # The components of the dashboard are presented as a list
      [
        # Page top heading
        StippleUI.heading("Iris data k-means clustering")

        # First row
        Stipple.row(
          [
            Stipple.cell(
              class = "st-module",
              [Genie.Renderer.Html.h6("Number of clusters")],
            )
            Stipple.cell(
              class = "st-module",
              [Genie.Renderer.Html.h6("Number of iterations")],
            )
            Stipple.cell(class = "st-module", [Genie.Renderer.Html.h6("X feature")])
            Stipple.cell(class = "st-module", [Genie.Renderer.Html.h6("Y feature")])
          ],
        )

        # Second row
        Stipple.row(
          [
            Stipple.cell(class = "st-module", [Genie.Renderer.Html.h5("Species clusters")])
            Stipple.cell(class = "st-module", [Genie.Renderer.Html.h5("k-means clusters")])
          ],
        )

        # Third row
        Stipple.row([
          Stipple.cell(class = "st-module", [Genie.Renderer.Html.h5("Iris data")]),
        ])
      ],
    ),
  ]
end


#= routing =#

Genie.Router.route("/") do
  model_iris_1 |> ui |> Genie.Renderer.Html.html
end


#= start server =#

# Starts a server with a random port between 8400 and 8700
# This avoids conflicts with other commonly used ports such as 8000, 8080, 9000+
up(rand(8400:8700), "localhost"; open_browser = true, async = true)
