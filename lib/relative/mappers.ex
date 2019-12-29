defmodule HumanTime.Relative.Mappers do
  @moduledoc false
  
  alias HumanTime.Common.Consts
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
  
  def relative_by_name(match, from) do
    day_name = match["day_name"]
    
    the_date = TimeLib.apply_time(from, match["time"])
    
    case day_name do
      "yesterday" -> {:ok, Timex.shift(the_date, days: -1)}
      "today" -> {:ok, the_date}
      "tomorrow" -> {:ok, Timex.shift(the_date, days: 1)}
      _ -> {:error, "No adjuster in relative_by_name for #{day_name}"}
    end
  end
  
  def relative_by_date(match, from) do
    # Start by getting the nearest instance of that day (forward search only)
    day_numbers = Consts.get_day_map()[match["day_name"]]
    
    start_date = 0..6
    |> Enum.map(fn i -> Timex.shift(from, days: i) end)
    |> Enum.filter(fn the_date -> Timex.weekday(the_date) in day_numbers end)
    |> hd
    |> TimeLib.apply_time(match["time"])
    
    adjuster = match["adjuster"]
    |> String.trim
    
    case adjuster do
      "this" -> {:ok, start_date}
      "next" -> {:ok, Timex.shift(start_date, weeks: 1)}
      "week" -> {:ok, Timex.shift(start_date, weeks: 1)}
      "week this" -> {:ok, Timex.shift(start_date, weeks: 1)}
      "week next" -> {:ok, Timex.shift(start_date, weeks: 2)}
      _ -> {:error, "No adjuster in relative_by_date for #{adjuster}"}
    end
  end
  
end