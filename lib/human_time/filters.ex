defmodule HumanTime.Filters do
  @day_map %{
    "monday"    => [1],
    "tuesday"   => [2],
    "wednesday" => [3],
    "thursday"  => [4],
    "friday"    => [5],
    "saturday"  => [6],
    "sunday"    => [7],
    "weekday"   => [1, 2, 3, 4, 5],
    "weekend"   => [6, 7],
    "day"       => [1, 2, 3, 4, 5, 6, 7],
  }
  
  def always_true(_) do
    fn _ ->
      true
    end
  end
  
  def weekday(match) do
    day_numbers = @day_map[match["principle"]]
    
    fn the_date ->
      Timex.weekday(the_date) in day_numbers
    end
  end
end