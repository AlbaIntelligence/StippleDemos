using Revise
using Stipple, StippleUI

Genie.Assets.assets_config!([Genie, Stipple, StippleUI],
                            host = "https://cdn.statically.io/gh/GenieFramework")

Base.@kwdef mutable struct RTModel <: ReactiveModel
  process::R{Bool} = false
  output::R{String} = ""
  input::R{String} = "Stipple"
end

model_rt = Stipple.init(RTModel(); transport = Genie.WebChannels)  # Genie.WebThreads

on(model_rt.process) do _
  if (model_rt.process[])
    model_rt.output[] = model_rt.input[] |> reverse
    model_rt.process[] = false
  end
end

function ui()
  [
  page(
    vm(model_rt), class="container", title="Reverse text", [
      p([
        "Input "
        input("", @bind(:input), @on("keyup.enter", "process = true"))
      ])
      p(
        button("Reverse", @click("process = true"))
      )
      p([
        "Output: "
        span("", @text(:output))
      ])
    ]
  )
  ] |> html
end

route("/", ui)
