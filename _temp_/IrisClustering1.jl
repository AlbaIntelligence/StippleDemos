
pwd()
cd("IrisClustering")
pwd()

using Pkg; Pkg.activate(".")

using Revise
using Stipple, StippleUI, StippleCharts

#= Data =#

Base.@kwdef mutable struct IrisModel <: ReactiveModel end

#= Stipple setup =#

model_iris = Stipple.init(IrisModel())


#= UI =#

function ui(model::IrisModel)
  [
    dashboard(
      vm(model),
      class = "container",
      title = "Iris Flowers Clustering",
      head_content = Genie.Assets.favicon_support(),
      [
        heading("Iris data k-means clustering")
        row(
          [
            cell(class = "st-module", [h6("Number of clusters")])
            cell(class = "st-module", [h6("Number of iterations")])
            cell(class = "st-module", [h6("X feature")])
            cell(class = "st-module", [h6("Y feature")])
          ],
        )
        row(
          [
            cell(class = "st-module", [h5("Species clusters")])
            cell(class = "st-module", [h5("k-means clusters")])
          ],
        )
        row([cell(class = "st-module", [h5("Iris data")])])
      ],
    ),
  ]
end


#= routing =#

route("/") do
  ui(model_iris) |> html
end


#= start server =#

up(rand(8400:8700), "localhost"; open_browser=true, async=true)
