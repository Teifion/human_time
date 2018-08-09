defmodule HumanTime.Generators do
  
  def days(now) do
    Timex.shift(now, days: 1)
  end
  
  def while_function(nil), do: fn _ -> true end
  def while_function(until) do
    fn v -> Timex.compare(v, until) != 1 end
  end
end