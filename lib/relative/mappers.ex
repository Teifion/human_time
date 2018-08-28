defmodule HumanTime.Relative.Mappers do
  
  alias HumanTime.Common.StringLib
  alias HumanTime.Common.TimeLib
  
  def x_days(match, from) do
    amount = match["amount"]
    |> StringLib.convert_amount
    
    {:ok, Timex.shift(from, days: amount)}
  end
  
  def x_hours(match, from) do
    amount = match["amount"]
    |> StringLib.convert_amount
    
    {:ok, Timex.shift(from, hours: amount)}
  end
  
  def x_minutes(match, from) do
    amount = match["amount"]
    |> StringLib.convert_amount
    
    {:ok, Timex.shift(from, minutes: amount)}
  end
  
  # We use the from as a starting point to preserve the timezone information
  def date(match, from) do
    raw = StringLib.convert_date(match)
    result = Timex.set(from, day: raw.day, month: raw.month, year: raw.year, hour: 0, minute: 0, second: 0)
    
    {:ok, result}
  end
  
  def date_and_time(match, from) do
    {time_type, match_result} = match["time"]
    |> TimeLib.match_time
    
    {:ok, the_date} = date(match, from)
    
    result = case time_type do
      :time_12h ->
        period_alteration = if match_result["period"] == "pm", do: 12, else: 0
        
        opts = [
          hour: StringLib.parse_int(match_result["hour12"]) + period_alteration,
          minute: StringLib.parse_int(match_result["minute12"]),
          second: 0,
          microsecond: {0, 0}
        ]
        Timex.set(the_date, opts)
      
      :time_24h ->
        opts = [
          hour: StringLib.parse_int(match_result["hour24"]),
          minute: StringLib.parse_int(match_result["minute24"]),
          second: 0,
          microsecond: {0, 0}
        ]
        Timex.set(the_date, opts)
      
      :time_term ->
        opts = TimeLib.get_time_indexes[match["time"]]
        Timex.set(the_date, opts)
        
      :time_current ->
        the_date
    end
    
    {:ok, result}
  end
  
end