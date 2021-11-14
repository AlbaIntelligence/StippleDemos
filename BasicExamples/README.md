# UI Components usage using [Stipple](https://github.com/GenieFramework/Stipple.jl), [StippleUI](https://github.com/GenieFramework/StippleUI.jl), [StippleCharts](https://github.com/GenieFramework/StippleCharts.jl) and [Genie](https://github.com/GenieFramework/Genie.jl) from Stipple Ecosystem

## Run Demo
```julia
julia> julia --project
julia> #enter package mode with ]
(@v1.x) pkg> activate .
(@v1.x) pkg> instantiate
(@v1.x) pkg> #exit package mode with <backspace key>
julia> include("Form.jl")
julia> up(rand(8400:8700), open_browser=true)  # should open your default browser and fire up Genie server at port between `8000:9000`. add `async=true` for an async server.
julia> down() # stop the running async instance of Genie Server
```

> If you want to change code and want JULIA to automatically reflect changes in Web Page use `Revise`. `Revise` is already included in `Project.toml`. Change `your code` hit save in editor and refresh browser should reflect your changes
### How  to use Revise?
```julia
---- same as above -----
(@v1.x) pkg> add Revise
(@v1.x) pkg> #exit package mode with <backspace key>
julia> using Revise
julia> include("Form.jl")  # notice we are using **includet** from revise instead of include
julia> up(rand((8000:9000)), open_browser=true)  # should open your default browser and fire up Genie server at port between `8000:9000`
julia> down() # stop the running async instance of Genie Server
```

### Form Component

| Components              | Demo                               |
|-------------------------|------------------------------------|
| **Card Component**      | ![Form](docs/content/img/Card.png)  |
| **DatePicker Component**| ![Form](docs/content/img/DatePickers.png) |
| **Form Component**      | ![Form](docs/content/img/Form.png) |
| **Hello Pie**           | ![Form](docs/content/img/HelloPie.png)  |
| **Hello Stipple**       | ![Form](docs/content/img/HelloStipple.png) |

