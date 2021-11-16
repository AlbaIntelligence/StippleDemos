# Define a pie chart, initialised with defaults of 2 slices of 44 and 55.
Base.@kwdef mutable struct HelloPie <: ReactiveModel
  # Values as a numeric list that reactively reflect the `values` string
  # Defines default values
  piechart_values::R{Vector} = Any[44, 55]

  # Values that are input in the text field (string)
  input_values::R{String} = join(piechart_values, ",")

  # Parameters of the plot from the piechart_values
  plot_options::R{StippleCharts.Charts.PlotOptions} = StippleCharts.Charts.PlotOptions(
    chart_type = :pie,
    chart_width = 380,
    chart_animations_enabled = true,
    stroke_show = false,
    labels = ["Slice A", "Slice B"], # Defaults for 2 slices
  )
end


model_hp = Stipple.init(HelloPie())

# On changes of values, a brand new numeric list is parsed and created
# (brand new like React??)
on(model_hp.input_values) do _
  model_hp.piechart_values[] =
    Any[tryparse(Int, strip(x)) for x in split(model_hp.input_values[], ',')]

  plotoptions = model_hp.plot_options[]
  plotoptions.labels =
    ["Slice $x" for x in (collect('A':'Z')[1:length(model_hp.piechart_values[])])]

  while length(model_hp.piechart_values[]) > length(plotoptions.colors)
    push!(plotoptions.colors, string('#', random_color(), random_color(), random_color()))
  end

  model_hp.plot_options[] = plotoptions
end

