route("/") do
  serve_static_file("welcome.html")
end

println("""
        Welcome route:
        $(Genie.Router.named_routes())
        -----------------------------------------------------------
        """)

