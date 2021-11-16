module Demo1Card

using Logging, LoggingExtras
using Genie, Stipple, StippleUI


function main()
  Core.eval(Main, :(const UserApp = $(@__MODULE__)))

  Genie.genie(; context = @__MODULE__)

  Core.eval(Main, :(const Genie = UserApp.Genie))
  Core.eval(Main, :(using Genie))
end


#= Data =#

# CardDemo definition inheriting from ReactiveModel
# Base.@kwdef: that defines keyword based contructor of mutable struct
Base.@kwdef mutable struct CardDemo <: Stipple.ReactiveModel end

# passing CardDemo object(contruction) for 2-way integration between Julia and JavaScript
# returns {ReactiveModel}
model_cd = Stipple.init(CardDemo())

function ui()
  [
    # page generates HTML code for Single Page Application
    Stipple.page(
      vm(model_cd),
      class = "container",
      title = "Card Demo",
      partial = true,
      [
        # row takes a tuple of cells. Creates a `div` HTML element with a CSS class named `row`.
        Stipple.row(
          Stipple.cell([Genie.Renderer.Html.h1("Card Component example")]),
        )
        Stipple.row(
          Stipple.cell([
            StippleUI.card(
              class = "text-white",
              style = "background: radial-gradient(circle, #35a2ff 0%, #014a88 100%); width: 30%",
              StippleUI.card_section(
                """
                Lorem Ipsum is simply dummy text of the printing and typesetting industry.

                Lorem Ipsum has been the industry's standard dummy text ever since the
                1500s, when an unknown printer took a galley of type and scrambled it to
                make a type specimen book. It has survived not only five centuries, but
                also the leap into electronic typesetting, remaining essentially unchanged.
                It was popularised in the 1960s with the release of Letraset sheets
                containing Lorem Ipsum passages, and more recently with desktop publishing
                software like Aldus PageMaker including versions of Lorem Ipsumem
                """),
            ),
          ]),
        )
      ],
    ),
  ]
end


end # module




