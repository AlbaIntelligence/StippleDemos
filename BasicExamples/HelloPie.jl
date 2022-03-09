using Stipple
using StippleCharts

@reactive mutable struct HelloPie <: ReactiveModel
  plot_options::R{PlotOptions} = PlotOptions(chart_type=:pie, chart_width=380, chart_animations_enabled=true,
                                            stroke_show = false, labels=["Slice A", "Slice B"])
  piechart_::R{Vector} = Any[44, 55]
  values::R{String} = join(piechart_, ",")
end

Stipple.register_components(HelloPie, StippleCharts.COMPONENTS)

hs_model = Stipple.init(HelloPie())

on(hs_model.values) do _
  hs_model.piechart_[] = Any[tryparse(Int, strip(x)) for x in split(hs_model.values[], ',')]

  po = hs_model.plot_options[]
  po.labels = ["Slice $x" for x in ( collect('A':'Z')[1:length(hs_model.piechart_[])] )]

  while length(hs_model.piechart_[]) > length(po.colors)
    push!(po.colors, string('#', random_color(), random_color(), random_color()))
  end

  hs_model.plot_options[] = po
end

function random_color() :: String
  string(rand(0:255), base = 16) |> uppercase
end

function ui()
  [
    page(
      vm(hs_model), class="container", title="Hello Pie", partial=true,
      [
        row(
          cell([
            h1([
              "Your pie has the following slices: "
              span("", @text(:values))
            ])

            p([
              "Share your pie? (comma separated list of values) "
              input("", placeholder="Share your pie", @bind(:values))
            ])
          ])
        )
        row(
          cell(class="st-module", [
            plot(@data(:piechart_), options! = "plot_options")
          ])
        )
      ]
    )
  ] |> html
end

route("/", ui)