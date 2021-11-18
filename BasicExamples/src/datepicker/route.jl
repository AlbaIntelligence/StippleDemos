route("/datepicker") do
  model_date_picker |> ui |> html
end

println("""
        Date picker routes:
        $(Genie.Router.named_routes())
        -----------------------------------------------------------
        """)

