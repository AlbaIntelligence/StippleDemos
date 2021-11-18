Base.@kwdef mutable struct CBModel <: ReactiveModel
  clicks::R{Int} = 0
  value::R{Int} = 0
end

model_countbutton = Stipple.init(CBModel(); debounce = 0)

on(model_countbutton.value) do (_...)
  model_countbutton.clicks[] += 1
end

