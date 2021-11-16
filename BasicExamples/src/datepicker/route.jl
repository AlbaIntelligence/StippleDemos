route("/datepicker") do
  Stipple.init(DatePickers()) |> ui |> html
end
