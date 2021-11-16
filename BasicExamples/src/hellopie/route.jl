# WHY IS REGISTRATION NECESSARY HERE?
# First parameter is a model structure
Stipple.register_components(HelloPie, StippleCharts.COMPONENTS)

route("/hellopie") do
  model_hp |> ui
end

