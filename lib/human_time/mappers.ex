defmodule HumanTime.Mappers do
  
  @time_indexes %{
    "noon"    => {12, 0, 0},
    "midday"  => {12, 0, 0},
    "morning" => {8, 0, 0},
  }

  @sector_indexes = %{
    "first"  => 0,
    "second" => 1,
    "third"  => 2,
    "fourth" => 3,
    "last"   => -1,
  }
  
  def remove_time(_) do
    fn value ->
      Timex.set(value, [hour: 0, minute: 0, second: 0])
    end
  end
  
  def apply_time(match) do
    IO.puts ""
    IO.inspect match["applicant"]
    IO.puts ""
    
    opts = [
      hour: 0,
      minute: 0,
      second: 0,
    ]
    
    fn the_date ->
      Timex.set(the_date, opts)
    end
  end
  
end