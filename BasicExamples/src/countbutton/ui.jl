function ui(model::CBModel)
  [
  dashboard(
    vm(model),
    class="container",
    title="Buttons demo",

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
