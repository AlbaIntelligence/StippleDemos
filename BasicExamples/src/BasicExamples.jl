module BasicExamples

# export create_server

using Logging, LoggingExtras

using Genie, Genie.Router
using Stipple, StippleUI, StippleCharts


# NOTE:
# The order of the includes is something to be aware of.
# The routes are added incrementally. When determining how to dispatch a particular route,
# Genie pattern-matches in reverse order of addition

# Default top page
include("welcome_route.jl")

#= Card demo =#
include("card/model.jl")
include("card/ui.jl")
include("card/route.jl")

#= Date Picker demo =#
include("datepicker/model.jl")
include("datepicker/ui.jl")
include("datepicker/route.jl")

#= Form demo =#
include("form/model.jl")
include("form/ui.jl")
include("form/route.jl")

#= Hello Pie demo =#
include("hellopie/model.jl")
include("hellopie/ui.jl")
include("hellopie/route.jl")

#= Hello Stipple demo =#
include("hellostipple/model.jl")
include("hellostipple/ui.jl")
include("hellostipple/route.jl")

#= Reverse Text demo =#
include("reversetext/model.jl")
include("reversetext/ui.jl")
include("reversetext/route.jl")

#= Count Button demo =#
include("countbutton/model.jl")
include("countbutton/ui.jl")
include("countbutton/route.jl")


function main()
  Core.eval(Main, :(const UserApp = $(@__MODULE__)))

  Genie.genie(; context = @__MODULE__)

  Core.eval(Main, :(const Genie = UserApp.Genie))
  Core.eval(Main, :(using Genie))
end

#= Create server =#

function create_server(;
  port = rand(8400:8700),
  host = "127.0.0.1",
  async::Bool = false,
  verbose::Bool = false,
  open_browser::Bool = false,
)

  # up requires a numerical address.
  host_numeric = host == "localhost" ? "127.0.0.1" : host

  # up is an exported shortcut for startup
  # up is created with a `context` defined as the current module
  return up(
    port,
    host_numeric;
    async = async,
    verbose = verbose,
    open_browser = open_browser
  )
end

# main()
export BasicExamples_server
BasicExamples_server = create_server(; async = true, verbose=true, open_browser = true)


end # module
