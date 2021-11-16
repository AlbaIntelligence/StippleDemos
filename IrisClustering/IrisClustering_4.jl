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

import RDatasets: dataset
import DataFrames
using Clustering


Genie.Assets.assets_config!(
  [Genie, Stipple, StippleUI, StippleCharts],
  host = "https://cdn.statically.io/gh/GenieFramework",
)

#= Data =#

# load Iris dataset from the RDatasets package and populate the resulting DataFrame
# with an extra column for storing the clusters ids
#=
julia> df = DataFrame(a=1:3)
3×1 DataFrame
 Row │ a
     │ Int64
─────┼───────
   1 │     1
   2 │     2
   3 │     3
julia> insertcols!(df, 1, :b => 'a':'c')
3×2 DataFrame
 Row │ b     a
     │ Char  Int64
─────┼─────────────
   1 │ a         1
   2 │ b         2
   3 │ c         3
=#
data = DataFrames.insertcols!(dataset("datasets", "iris"), :Cluster => zeros(Int, 150))


# definition of the reactive model

Base.@kwdef mutable struct IrisModel_4 <: ReactiveModel
  iris_data::R{DataTable} = DataTable(data)    # iris_data has data -> dataframe defined at line 13
  credit_data_pagination::DataTablePagination = DataTablePagination(rows_per_page = 50)              # DataTable, DataTablePagination are part of StippleUI which helps us set Data Table UI

  # PlotOption is a Julia object defined in StippleCharts
  plot_options::PlotOptions = PlotOptions(
    chart_type = :scatter,
    xaxis_type = :numeric,
    colors = ["#13c2ff", "#e43dff", "#2401e2"],
    grid_row_colors = ["#F8F8F8", "transparent"],
  )

  # PlotSeries is structure used to store data
  iris_plot_data::R{Vector{PlotSeries}} = PlotSeries[]
  cluster_plot_data::R{Vector{PlotSeries}} = PlotSeries[]

  # iris dataset have following columns:
  # https://www.kaggle.com/lalitharajesh/iris-dataset-exploratory-data-analysis/
  datafeatures::R{Vector{String}} =
    ["SepalLength", "SepalWidth", "PetalLength", "PetalWidth"]
  xfeature::R{String} = ""
  yfeature::R{String} = ""

  no_of_clusters::R{Int} = 3
  no_of_iterations::R{Int} = 10

  foo::R{String} = "bar"
end

#= Stipple setup =#

Stipple.register_components(IrisModel_4, StippleCharts.COMPONENTS)


# Instantiating a Stipple's ReactiveModel
const ic_model = Stipple.init(IrisModel_4(), transport = Genie.WebChannels)


#= Event handlers =#

# Observable from stipple ReactiveModel...Calls f on updates to any observable refs in args
#=
onany(x, y) do xval, yval
    println("At ", time()-tstart, ", we have x = ", xval, " and y = ", yval)
end
=#
onany(
  ic_model.xfeature,
  ic_model.yfeature,
  ic_model.no_of_clusters,
  ic_model.no_of_iterations,
) do (_...)
  ic_model.iris_plot_data[] = plot_data(:Species) # plot_data function defined in line 78
  compute_clusters!()
end


#= Computation =#

function plot_data(cluster_column::Symbol)
  result = Vector{PlotSeries}()
  isempty(ic_model.xfeature[]) || isempty(ic_model.yfeature[]) && return result

  dimensions = Dict()
  for s in Array(data[:, cluster_column]) |> unique!
    dimensions[s] = []

    for r in eachrow(data[data[!, cluster_column].==s, :])
      push!(dimensions[s], [r[Symbol(ic_model.xfeature[])], r[Symbol(ic_model.yfeature[])]])
    end

    push!(result, PlotSeries("$s", PlotData(dimensions[s])))
  end

  result
end

function compute_clusters!()
  features = collect(Matrix(data[:, [Symbol(c) for c in ic_model.features[]]])')
  result =
    kmeans(features, ic_model.no_of_clusters[]; maxiter = ic_model.no_of_iterations[])
  data[!, :Cluster] = assignments(result)
  ic_model.iris_data[] = DataTable(data)
  ic_model.cluster_plot_data[] = plot_data(:Cluster)

  nothing
end


#= UI =#

"""
    function ui(model::IrisModel)

The ui function renders the user interface of the Iris Clustering data dashboard.
"""
function ui(model::IrisModel_4)
  page(
    vm(model),
    class = "container",
    title = "Iris Flowers Clustering",
    head_content = Genie.Assets.favicon_support(),
    prepend = style("""
                    tr:nth-child(even) {
                      background: #F8F8F8 !important;
                    }

                    .st-module {
                      background-color: #FFF;
                      border-radius: 2px;
                      box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.04);
                    }

                    .stipple-core .st-module > h5,
                    .stipple-core .st-module > h6 {
                      border-bottom: 0px !important;
                    }
                    """),
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
              slider(10:10:200, @data(:no_of_iterations); label = true)
            ],
          )
          cell(
            class = "st-module",
            [
              h6("X feature")
              Stipple.select(:xfeature; options = :features)
            ],
          )
          cell(
            class = "st-module",
            [
              h6("Y feature")
              Stipple.select(:yfeature; options = :features)
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
  )
end


#= routing =#

route("/") do
  html([ui(ic_model)]) |> html
end

up(9000; async = true, server = Stipple.bootstrap()) # you can set async = true to interact with application in repl
