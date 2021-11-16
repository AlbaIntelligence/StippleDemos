# passing FormComponent object(contruction) for 2-way integration between Julia
# and JavaScript returns {ReactiveModel}
route("/form") do
  Stipple.init(FormComponent()) |> ui
end


