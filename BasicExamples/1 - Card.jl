#
# The demos are to be run in their own directory from the REPL
#

# To check you are at the right place
pwd()
cd("BasicExamples")
pwd()

# Use the local Project.toml
using Pkg
Pkg.activate(".")

# Use the latest versions of the necessary packages
Pkg.develop("Genie")
Pkg.develop("Stipple")
Pkg.develop("StippleUI")
# Pkg.develop("StippleCharts")

using Revise

using Genie, Genie.Renderer.Html
using Stipple
using StippleUI
# using StippleCharts

# Note that the use of the packages is fully qualified in the code below to be explicit
# where the functions come from. The qualifications are not necessary otherwise.


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

route("/", ui)

route("/hello") do
  "Welcome"
end

#= start server =#

# Starts a server with a random port between 8400 and 8700
# This avoids conflicts with other commonly used ports such as 8000, 8080, 9000+
up(rand(8400:8700), "localhost"; open_browser = true, async = true)
