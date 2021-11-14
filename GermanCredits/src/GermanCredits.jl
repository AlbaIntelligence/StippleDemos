using CSV, DataFrames, Dates

using Stipple, StippleUI, StippleCharts


# configuration
data_opts = DataTableOptions(
  columns = [
    Column("Good_Rating"),
    Column("Amount", align = :right),
    Column("Age", align = :right),
    Column("Duration", align = :right),
  ],
)

plot_colors = ["#72C8A9", "#BD5631"]

# PlotOption is a Julia object defined in StippleCharts
bubble_plot_opts = PlotOptions(
  data_labels_enabled = false,
  fill_opacity = 0.8,
  xaxis_tick_amount = 10,
  chart_animations_enabled = false,
  xaxis_min = 17,
  xaxis_max = 80,
  yaxis_min = 0,
  yaxis_max = 20_000,
  chart_type = :bubble,
  colors = plot_colors,
  plot_options_bubble_min_bubble_radius = 4,
  chart_font_family = "Lato, Helvetica, Arial, sans-serif",
)

bar_plot_opts = PlotOptions(
  xaxis_tick_amount = 10,
  xaxis_max = 350,
  chart_type = :bar,
  plot_options_bar_data_labels_position = :top,
  plot_options_bar_horizontal = true,
  chart_height = 200,
  colors = plot_colors,
  chart_animations_enabled = false,
  xaxis_categories = ["20-30", "30-40", "40-50", "50-60", "60-70", "70-80"],
  chart_toolbar_show = false,
  chart_font_family = "Lato, Helvetica, Arial, sans-serif",
  stroke_show = false,
)


# reading data from CSV file and construcing data frame
cd(@__DIR__)
data = CSV.File("../data/german_credit.csv") |> DataFrame


# Defining a Stipple ReactiveModel of type observable
Base.@kwdef mutable struct gc_Dashboard <: ReactiveModel
  credit_data::R{DataTable} = DataTable()
  credit_data_pagination::DataTablePagination = DataTablePagination(rows_per_page = 100)
  credit_data_loading::R{Bool} = false

  range_data::R{RangeData{Int}} = RangeData(15:80)

  big_numbers_count_good_credits::R{Int} = 0
  big_numbers_count_bad_credits::R{Int} = 0
  big_numbers_amount_good_credits::R{Int} = 0
  big_numbers_amount_bad_credits::R{Int} = 0

  bar_plot_options::PlotOptions = bar_plot_opts
  bar_plot_data::R{Vector{PlotSeries}} = []

  bubble_plot_options::PlotOptions = bubble_plot_opts
  bubble_plot_data::R{Vector{PlotSeries}} = []
end


# functions
function creditdata!(data::DataFrame, model::M) where {M<:Stipple.ReactiveModel}
  # credit_data propertly of type StippleUI.DataTable is assigned to data from CSV
  model.credit_data[] = DataTable(data, data_opts)

  # data_opts data_opts = DataTableOptions(columns = [Column("Good_Rating"), Column("Amount", align = :right), Column("Age", align = :right), Column("Duration", align = :right)])
end

function bignumbers!(data::DataFrame, model::M) where {M<:ReactiveModel}

  # Good_Rating from CSV
  model.big_numbers_count_good_credits[] =
    data[data.Good_Rating.==true, [:Good_Rating]] |> nrow
  model.big_numbers_count_bad_credits[] =
    data[data.Good_Rating.==false, [:Good_Rating]] |> nrow

  # Amount field from CSV
  model.big_numbers_amount_good_credits[] =
    data[data.Good_Rating.==true, [:Amount]] |> Array |> sum
  model.big_numbers_amount_bad_credits[] =
    data[data.Good_Rating.==false, [:Amount]] |> Array |> sum
end

function barstats!(data::DataFrame, model::M) where {M<:Stipple.ReactiveModel}
  age_stats = Dict{Symbol,Vector{Int}}(:good_credit => Int[], :bad_credit => Int[])

  for x = 20:10:70
    push!(
      age_stats[:good_credit],
      data[(data.Age.∈[x:x+10]).&(data.Good_Rating.==true), [:Good_Rating]] |> nrow,
    )
    push!(
      age_stats[:bad_credit],
      data[(data.Age.∈[x:x+10]).&(data.Good_Rating.==false), [:Good_Rating]] |> nrow,
    )
  end

  model.bar_plot_data[] = [
    PlotSeries("Good credit", PlotData(age_stats[:good_credit])),
    PlotSeries("Bad credit", PlotData(age_stats[:bad_credit])),
  ]
end

function bubblestats!(data::DataFrame, model::M) where {M<:ReactiveModel}
  selected_columns = [:Age, :Amount, :Duration]
  credit_stats = Dict{Symbol,DataFrame}()

  credit_stats[:good_credit] = data[data.Good_Rating.==true, selected_columns]
  credit_stats[:bad_credit] = data[data.Good_Rating.==false, selected_columns]

  model.bubble_plot_data[] = [
    PlotSeries("Good credit", PlotData(credit_stats[:good_credit])),
    PlotSeries("Bad credit", PlotData(credit_stats[:bad_credit])),
  ]
end

function setmodel!(data::DataFrame, model::M)::M where {M<:ReactiveModel}
  creditdata!(data, model)
  bignumbers!(data, model)

  barstats!(data, model)
  bubblestats!(data, model)

  model
end


### setting up vuejs and stipple connection with ReactiveModel
Stipple.register_components(gc_Dashboard, StippleCharts.COMPONENTS)

# Instantiating Reactive Model isntantace
gc_model = setmodel!(data, gc_Dashboard()) |> Stipple.init

function filterdata!(model::gc_Dashboard)
  model.credit_data_loading[] = true
  model = setmodel!(
    data[
      (model.range_data[].range.start.<=data[!, :Age].<=model.range_data[].range.stop),
      :,
    ],
    model,
  )
  model.credit_data_loading[] = false

  return nothing
end


# Note:
#   - Symbols refer to fields stored in the model, which is a concrete version of
#     ReactiveModel
function ui(model)
  [
    # The entire UI is presented as a dashboard
    dashboard(
      vm(model),

      # Page window title
      title = "German Credits",
      head_content = Genie.Assets.favicon_support(),
      partial = false,
      [
        StippleUI.heading("German Credits by Age")
        Stipple.row([
          Stipple.cell(
            class = "st-module",
            [
              Stipple.row(
                [
                  Stipple.cell(
                    class = "st-br",
                    [
                      StippleUI.bignumber(
                        "Bad credits",
                        :big_numbers_count_bad_credits,
                        icon = "format_list_numbered",
                        color = "negative",
                      ),
                    ],
                  )
                  Stipple.cell(
                    class = "st-br",
                    [
                      StippleUI.bignumber(
                        "Good credits",
                        :big_numbers_count_good_credits,
                        icon = "format_list_numbered",
                        color = "positive",
                      ),
                    ],
                  )
                  Stipple.cell(
                    class = "st-br",
                    [
                      StippleUI.bignumber(
                        "Bad credits total amount",
                        R"big_numbers_amount_bad_credits | numberformat",
                        icon = "euro_symbol",
                        color = "negative",
                      ),
                    ],
                  )
                  Stipple.cell(
                    class = "st-br",
                    [
                      StippleUI.bignumber(
                        "Good credits total amount",
                        R"big_numbers_amount_good_credits | numberformat",
                        icon = "euro_symbol",
                        color = "positive",
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ])
        Stipple.row([
          Stipple.cell(
            [
              Stipple.h4("Age interval filter")
              StippleUI.range(
                18:1:90,
                :range_data;
                label = true,
                labelalways = true,
                labelvalueleft = Symbol("'Min age: ' + range_data.min"),
                labelvalueright = Symbol("'Max age: ' + range_data.max"),
              )
            ],
          ),
        ])
        Stipple.row(
          [
            Stipple.cell(
              class = "st-module",
              [
                Stipple.h4("Credits data")
                Stipple.table(
                  :credit_data;
                  style = "height: 400px;",
                  pagination = :credit_data_pagination,
                  loading = :credit_data_loading,
                )
              ],
            )
            Stipple.cell(
              class = "st-module",
              [
                Stipple.h4("Credits by age")
                StippleCharts.plot(:bar_plot_data; options = :bar_plot_options)
              ],
            )
          ],
        )
        Stipple.row([
          Stipple.cell(
            class = "st-module",
            [
              Stipple.h4("Credits by age, amount and duration")
              StippleCharts.plot(:bubble_plot_data; options = :bubble_plot_options)
            ],
          ),
        ])
        Stipple.footer(
          class = "st-footer q-pa-md",
          [Stipple.cell([span("Stipple &copy; $(year(now()))")])],
        )
      ],
    ),
  ]
end

# handlers
on(gc_model.range_data) do _
  filterdata!(gc_model)
end

# serving on localhost
route("/") do
  ui(gc_model) |> html
end

# In case you want to check the existing routes:
# using Genie.Router
# Genie.Router.named_routes()
#
# This is (for the moment) just a getter to print the global variable Genie.Router._routes
