defmodule HumanTime.Relative.Mappers do
  
  alias HumanTime.Common.StringLib
  
  def x_days(regex, from) do
    amount = regex["amount"]
    |> StringLib.convert_amount
    
    Timex.shift(from, days: amount)
  end
  
  
end