# name, age are type Observable
Stipple.@kwdef mutable struct FormComponent <: ReactiveModel
  name::R{String} = ""
  age::R{Int} = 0
  objects::R{Vector{String}} = ["Dog", "Cat", "Beer"]
  warin::R{Bool} = true
end

