function ui(model::Name)
  [
    page(
      vm(model), class="container", title="Hello Stipple", partial=true,
      [
        row(
          cell([
            h1([
              "Hello, "
              span("", @text(:name))
            ])

            # bind is a replacement to vuejs's v-model
            p([
              "What is your name? "
              input("", placeholder="Type your name", @bind(:name))
            ])
          ])
        )
      ]
    )
  ] |> html
end
