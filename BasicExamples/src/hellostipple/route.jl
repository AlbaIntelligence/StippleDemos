route("/name") do
  Stipple.init(Name()) |> ui
end
