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

using Clustering
import RDatasets: dataset
import DataFrames


#= Data =#

data = DataFrames.insertcols!(dataset("datasets", "iris"), :Cluster => zeros(Int, 150))

Base.@kwdef mutable struct IrisModel_2 <: ReactiveModel
  iris_data::R{DataTable} = DataTable(data)
  credit_data_pagination::DataTablePagination = DataTablePagination(rows_per_page = 50)

  plot_options::PlotOptions = PlotOptions(chart_type = :scatter, xaxis_type = :numeric)
  iris_plot_data::R{Vector{PlotSeries}} = PlotSeries[]
  cluster_plot_data::R{Vector{PlotSeries}} = PlotSeries[]

  features::R{Vector{String}} = ["SepalLength", "SepalWidth", "PetalLength", "PetalWidth"]
  xfeature::R{String} = ""
  yfeature::R{String} = ""

  no_of_clusters::R{Int} = 3
  no_of_iterations::R{Int} = 10
end


#= Stipple setup =#

Stipple.register_components(IrisModel_2, StippleCharts.COMPONENTS)
model_ir2 = Stipple.init(IrisModel_2())

#= UI =#

function ui(model::IrisModel_2)
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
            cell(
              class = "st-module",
              [
                h6("Number of clusters")
                slider(1:1:20, @data(:no_of_clusters); label = true)
              ],
            )
            cell(
              class = "st-module",
              [
                h6("Number of iterations")
                slider(
                  10:10:200,
                  @data(:no_of_iterations);
                  label = true,
                  color = "red",
                  label__color = "green",
                )
              ],
            )
            cell(
              class = "st-module",
              [
                h6("X feature")
                select(:xfeature; options = :features)
              ],
            )
            cell(
              class = "st-module",
              [
                h6("Y feature")
                select(:yfeature; options = :features)
              ],
            )
          ],
        )
        row(
          [
            cell(
              class = "st-module",
              [
                h5("Species clusters")
                plot(:iris_plot_data; options = :plot_options)
              ],
            )
            cell(
              class = "st-module",
              [
                h5("k-means clusters")
                plot(:cluster_plot_data; options = :plot_options)
              ],
            )
          ],
        )
        row([
          cell(
            class = "st-module",
            [
              h5("Iris data")
              table(
                :iris_data;
                pagination = :credit_data_pagination,
                dense = true,
                flat = true,
                style = "height: 350px;",
              )
            ],
          ),
        ])
      ],
    ),
  ]
end

#= routing =#

route("/") do
  ui(ic_model) |> Genie.Renderer.Html.html
end

#= start server =#

up(rand((8000:9000)), open_browser = true)
