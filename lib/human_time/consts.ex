defmodule HumanTime.Consts do
  # Regex.compile
  @selector_names "first|1st|second|2nd|third|3rd|fourth|4th|last"
  @day_names "monday|tuesday|wednesday|thursday|friday|saturday|sunday"
  @all_day_names @day_names <> "|weekday|day|weekend"
  @month_names "january|february|march|april|may|june|july|august|september|october|november|december"
  
  def create_pattern(patten_string) do
    patten_string
    |> String.replace("#ALL_DAY_NAMES#", @all_day_names)
    |> Regex.compile!
  end
end