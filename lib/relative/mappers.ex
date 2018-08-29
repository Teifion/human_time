defmodule HumanTime.Relative.Mappers do
  
  alias HumanTime.Common.StringLib
  alias HumanTime.Common.TimeLib
  
  def x_minutes(match, from) do
    amount = match["amount"]
    |> StringLib.convert_amount
    
    {:ok, Timex.shift(from, minutes: amount)}
  end
  
  def x_hours(match, from) do
    amount = match["amount"]
    |> StringLib.convert_amount
    
    {:ok, Timex.shift(from, hours: amount)}
  end
  
  def x_days(match, from) do
    amount = match["amount"]
    |> StringLib.convert_amount
    
    {:ok, Timex.shift(from, days: amount)}
  end
  
  def x_weeks(match, from) do
    amount = match["amount"]
    |> StringLib.convert_amount
    
    {:ok, Timex.shift(from, weeks: amount)}
  end
  
  # We use the from as a starting point to preserve the timezone information
  def set_value(match, from) do
    raw = StringLib.convert_date(match)
    the_date = Timex.set(from, day: raw.day, month: raw.month, year: raw.year, hour: 0, minute: 0, second: 0)
    
    result = TimeLib.apply_time(the_date, match["time"])
    
    {:ok, result}
  end
  
end