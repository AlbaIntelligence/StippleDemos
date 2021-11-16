Base.@kwdef mutable struct ReverseTextModel <: ReactiveModel
  process::R{Bool} = false
  output::R{String} = ""
  input::R{String} = "Stipple"
end


model_rt = Stipple.init(ReverseTextModel(); transport = Genie.WebChannels)

on(model_rt.process) do _
  if (model_rt.process[])
    model_rt.output[] = model_rt.input[] |> reverse
    model_rt.process[] = false
  end
end
