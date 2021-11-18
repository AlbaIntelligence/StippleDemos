route("/countbutton") do
  model_countbutton |> ui |> html
end

println("""
        Countbutton routes:
        $(Genie.Router.named_routes())
        -----------------------------------------------------------
        """)

