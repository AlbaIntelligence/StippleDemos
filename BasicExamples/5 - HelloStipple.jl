using Revise
using Stipple, StippleUI

# Stipple's ReactiveModel with name field which is mapped to frontend input
# i.e. julia can access name's data in backend
Base.@kwdef mutable struct Name <: ReactiveModel
  name::R{String} = "Stipple!"
end

# This model is used as a global variable
model_name = Stipple.init(Name())

function ui()
  [
    page(
      vm(model_name), class="container", title="Hello Stipple", partial=true,
      [
        row(
          cell([
            h1([
              "Hello, "
              span("", @text(:name))
            ])

            p([
              "What is your name? "
              input("", placeholder="Type your name", @bind(:name)) # bind is a replacement to vuejs's v-model
            ])
          ])
        )
      ]
    )
  ] |> html
end

route("/", ui)
