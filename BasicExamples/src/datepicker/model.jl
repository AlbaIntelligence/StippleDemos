
Base.@kwdef mutable struct DatePickers <: ReactiveModel
  proxydate::R{Date} = today()
  inputdate::R{Date} = today()

  date::R{Date} = today() + Day(30)
  dates::R{Vector{Date}} = Date[today()+Day(10), today()+Day(20), today()+Day(30)]
  daterange::R{DateRange} = DateRange(today(), (today() + Day(3)))
  dateranges::R{Vector{DateRange}} = [
    DateRange(today(), (today() + Day(3))),
    DateRange(today() + Day(7), (today() + Day(10))),
    DateRange(today() + Day(14), (today() + Day(17))),
  ]
end

model_date_picker = Stipple.init(DatePickers())
