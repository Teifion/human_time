defmodule HumanTime.Generators do
  
  def seconds(now), do: Timex.shift(now, seconds: 1)
  def minutes(now), do: Timex.shift(now, minutes: 1)
  def hours(now), do: Timex.shift(now, hours: 1)
  def days(now), do: Timex.shift(now, days: 1)
  
  # def while_function(nil), do: fn _ -> true end
  def while_function(until) do
    fn v -> Timex.compare(v, until) != 1 end
  end
end