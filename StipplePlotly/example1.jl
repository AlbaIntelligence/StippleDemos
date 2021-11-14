using Revise
using Plotly
using Stipple, StippleUI, StipplePlotly

#=== config ==#

# for m in [Genie, Stipple, StippleUI, StipplePlotly]
#   m.assets_config.host = "https://cdn.statically.io/gh/GenieFramework"
# end

# WEB_TRANSPORT = Genie.WebChannels #Genie.WebThreads #


#== data ==#

pd(name) = StipplePlotly.PlotData(
  x = [
    "Jan2019",
    "Feb2019",
    "Mar2019",
    "Apr2019",
    "May2019",
    "Jun2019",
    "Jul2019",
    "Aug2019",
    "Sep2019",
    "Oct2019",
    "Nov2019",
    "Dec2019",
  ],
  y = Int[rand(1:100_000) for x = 1:12],
  plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
  name = name,
)

#== reactive model ==#
Base.@kwdef mutable struct Model_Ex1 <: ReactiveModel
  data::R{Vector{StipplePlotly.PlotData}} = [pd("Random 1"), pd("Random 2")]
  layout::R{StipplePlotly.PlotLayout} = StipplePlotly.PlotLayout(
    plot_bgcolor = "#333",
    title = StipplePlotly.PlotLayoutTitle(text = "Random numbers", font = Font(24)),
  )
  config::R{StipplePlotly.PlotConfig} = StipplePlotly.PlotConfig()
end

model_ex1 = Stipple.init(Model_Ex1())

#== ui ==#

function ui(model)
  page(
    vm(model),
    class = "container",
    [
      heading("Plotly example")
      row([
        cell(
          class = "st-module",
          [
            h6("Plot of random values")
            StipplePlotly.plot(:data, layout = :layout, config = :config)
          ],
        ),
      ])
    ],
  )
end

#== server ==#

route("/") do
  ui(model_ex1) |> html
end

# up(port = rand(8500:8700), host = "localhost", server = Stipple.bootstrap())
