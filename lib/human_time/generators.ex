defmodule HumanTime.Generators do
  
  def days(now) do
    Timex.shift(now, days: 1)
  end
end