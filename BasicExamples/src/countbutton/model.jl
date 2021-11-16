Base.@kwdef mutable struct CBModel <: ReactiveModel
  clicks::R{Int} = 0
  value::R{Int} = 0
end

model_cb = Stipple.init(CBModel(); debounce = 0)

on(model_cb.value) do (_...)
  model_cb.clicks[] += 1
end

