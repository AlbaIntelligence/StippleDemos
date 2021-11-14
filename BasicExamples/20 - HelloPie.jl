using Revise
using Genie, Stipple, StippleCharts

# Define a pie chart, initialised with defaults of 2 slices of 44 and 55.
Base.@kwdef mutable struct HelloPie <: ReactiveModel
  # Values that are input in the text field (string)
  input_values::R{String} = join(piechart_, ",")

  # Values as a numeric list that reactively reflect the `values` string
  # Defines default values
  piechart_values::R{Vector} = Any[44, 55]

  # Parameters of the plot from the piechart_values
  plot_options::R{StippleCharts.Charts.PlotOptions} = StippleCharts.Charts.PlotOptions(
    chart_type = :pie,
    chart_width = 380,
    chart_animations_enabled = true,
    stroke_show = false,
    labels = ["Slice A", "Slice B"], # Defaults for 2 slices
  )

end

# WHY IS REGISTRATION NECESSARY HERE?
# First parameter is a model structure
Stipple.register_components(HelloPie, StippleCharts.COMPONENTS)

model_hp = Stipple.init(HelloPie())

# On changes of values, a brand new numeric list is parsed and created
# (brand new like React??)
on(model_hp.values) do _
  model_hp.piechart_[] = Any[tryparse(Int, strip(x)) for x in split(model_hp.values[], ',')]

  plotoptions = model_hp.plot_options[]
  plotoptions.labels =
    ["Slice $x" for x in (collect('A':'Z')[1:length(model_hp.piechart_[])])]

  while length(model_hp.piechart_[]) > length(plotoptions.colors)
    push!(plotoptions.colors, string('#', random_color(), random_color(), random_color()))
  end

  model_hp.plot_options[] = plotoptions
end

function random_color()::String
  string(rand(0:255), base = 16) |> uppercase
end

function ui()
  [
    Stipple.page(
      Stipple.vm(model_hp),
      class = "container",
      title = "Hello Pie",
      partial = true,
      [
        Stipple.row(
          Stipple.cell(
            [
              Genie.Renderer.Html.h1(
                [
                  "Your pie has the following slices: "
                  Genie.Renderer.Html.span("", @text(:values))
                ],
              )
              p(
                [
                  "Share your pie? (comma separated list of values) "
                  Genie.Renderer.Html.input(
                    "",
                    placeholder = "Share your pie",
                    @bind(:values) # References the values field of the hs_model structure)
                  )
                ],
              )
            ],
          ),
        )
        Stipple.row(
          Stipple.cell(
            class = "st-module",
            [StippleCharts.Charts.plot(@data(:piechart_), options! = "plot_options")],
          ),
        )
      ],
    ),
  ] |> html
end

route("/", ui)


