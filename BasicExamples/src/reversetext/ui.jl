function ui(model::ReverseTextModel)
  [
    page(
      vm(model),
      class = "container",
      title = "Reverse text",
      [
        p([
          "Input "
          input("", @bind(:input), @on("keyup.enter", "process = true"))
        ])
        p(button("Reverse", @click("process = true")))
        p([
          "Output: "
          span("", @text(:output))
        ])
      ],
    ),
  ] |> html
end
