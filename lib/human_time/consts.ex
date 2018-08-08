defmodule HumanTime.Consts do
  # Regex.compile
  @selector_names "first|1st|second|2nd|third|3rd|fourth|4th|last"
  @day_names "monday|tuesday|wednesday|thursday|friday|saturday|sunday"
  @all_day_names @day_names <> "|weekday|day|weekend"
  @month_names "january|february|march|april|may|june|july|august|september|october|november|december"
  
  @time_term "(noon|midday|morning)"
  @time_current "(this|current) time"
  @time_12h "(?P<hour>[0-9]|1[0-2])(:(?P<minute>[0-5][0-9]))?(?P<period>am|pm)"
  @time_24h "([01]?[0-9]|2[0-3]):?([0-5][0-9])"
  @time_all "(?:#{@time_12h}|#{@time_24h}|#{@time_term}|#{@time_current})"
  
  def create_pattern(patten_string) do
    patten_string
    |> String.replace("#ALL_DAY_NAMES#", @all_day_names)
    |> String.replace("#TIME_ALL#", @time_all)
    |> Regex.compile!
  end
end