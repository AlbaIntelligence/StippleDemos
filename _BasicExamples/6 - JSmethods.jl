using Revise
using Stipple, StippleUI

Base.@kwdef mutable struct JSmethods <: ReactiveModel
  x::R{Int} = 0 # pressing this will update the array of buttons
end

function restart()
  global model_jsm
  model_jsm = Stipple.init(JSmethods(); debounce = 1)
  on(println, model_jsm.x)
end

Stipple.js_methods(::JSmethods) = raw"""
    showNotif () {
    alert("Welcome to JSMethods!") // some blocking javascript. Hit "OK" on alert to proceed with notification
    this.$q.notify({
    message: 'I am notifying you!',
    color: 'purple'
    })
    }
"""

function ui()
  dashboard(
    vm(model_jsm),
    [
      heading("jsmethods"),
      row(cell(class = "st-module", [p(button("Notify me", @click("showNotif()")))])),
    ],
    title = "jsmethods",
  ) |> html
end


route("/", ui)
restart()
