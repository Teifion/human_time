defmodule HumanTime.Mappers do
  
  def remove_time(_) do
    fn value ->
      Timex.set(value, [hour: 0, minute: 0, second: 0])
    end
  end
  
  def apply_time() do
    
  end
  
end