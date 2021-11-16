# passing CardDemo object(contruction) for 2-way integration between Julia and JavaScript
route("/card") do
  Stipple.init(CardDemo()) |> ui |> html
end

