using Revise
using Stipple, StippleUI

Base.@kwdef mutable struct CBModel <: ReactiveModel
  clicks::R{Int} = 0
  value::R{Int} = 0
end

model_cb = Stipple.init(CBModel(), debounce = 0)

on(model_cb.value) do (_...)
  model_cb.clicks[] += 1
end

function ui(model::CBModel)
  [
  dashboard(
    vm(model), class="container", title="Buttons demo",
    [
      heading("Buttons")

      row([
        cell([
          btn("Less! ", @click("value -= 1"))
        ])
        cell([
          p([
              "Clicks: "
              span(model.clicks, @text(:clicks))
          ])
          p([
            "Value: "
            span(model.value, @text(:value))
          ])
        ])
        cell([
          btn("More! ", @click("value += 1"))
        ])
      ])
    ]
  )
  ]
end

route("/") do
  ui(model_cb) |> html
end
