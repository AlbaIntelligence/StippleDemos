function ui(model::HelloPie)
  [
    Stipple.page(
      Stipple.vm(model),
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
            [StippleCharts.Charts.plot(@data(:piechart_values), options! = "plot_options")],
          ),
        )
      ],
    ),
  ] |> html
end

function random_color()::String
  string(rand(0:255), base = 16) |> uppercase
end

