# Stipple's ReactiveModel with name field which is mapped to frontend input
# i.e. julia can access name's data in backend
Base.@kwdef mutable struct Name <: ReactiveModel
  name::R{String} = "Stipple!"
end

