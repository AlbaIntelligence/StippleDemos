# passing CardDemo object(contruction) for 2-way integration between Julia and JavaScript
route("/card") do
  model_card |> ui |> html
end

println("""
        Card routes:
        $(Genie.Router.named_routes())
        -----------------------------------------------------------
        """)

