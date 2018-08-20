defmodule HumanTime.Generators do
  @moduledoc false
  
  @spec seconds(DateTime.t) :: DateTime.t
  def seconds(now), do: Timex.shift(now, seconds: 1)
  
  @spec minutes(DateTime.t) :: DateTime.t
  def minutes(now), do: Timex.shift(now, minutes: 1)
  
  @spec hours(DateTime.t) :: DateTime.t
  def hours(now), do: Timex.shift(now, hours: 1)
  
  @spec days(DateTime.t) :: DateTime.t
  def days(now), do: Timex.shift(now, days: 1)
  
  # def while_function(nil), do: fn _ -> true end
  @spec while_function(DateTime.t) :: fun
  def while_function(until) do
    fn v -> Timex.compare(v, until) != 1 end
  end
end