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

  @sector_indexes %{
    "first"  => 0,
    "second" => 1,
    "third"  => 2,
    "fourth" => 3,
    "last"   => -1,
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
  
  def identifier_in_month(match) do
    selector  = match["selector"]
    the_day   = match["principle"]
    
    acceptable_days = @day_map[the_day]
    selector_index = @sector_indexes[selector]
    
    fn the_date ->
      if Timex.weekday(the_date) in acceptable_days do
        the_date = Timex.to_date(the_date)
        
        xs_in_month = get_xs_in_month(the_day, the_date)
        
        Enum.at(xs_in_month, selector_index) == the_date
      end
    end
  end
  
  def identifier_in_month_after(match) do
    fn the_date -> true end
  end
  
  def day_number_in_month(match) do
    day_number = match["selector"]
    |> String.to_integer
    
    fn the_date ->
      Timex.to_date(the_date).day == day_number
    end
  end
  
  def end_of_month(_match) do
    fn the_date ->
      Timex.to_date(the_date) == Timex.end_of_month(the_date) |> Timex.to_date
    end
  end
  
  
  # Used to get all Xs from a month where X is something like tuesday
  defp get_xs_in_month(x, the_date) do
    # We shift the end of the month by one day to include the last day of the month in our interval
    month_start = Timex.beginning_of_month(the_date)
    month_end = Timex.shift(Timex.end_of_month(the_date), days: 1)
    
    day_index = hd @day_map[x]
    
    # For each day in month, select only those with the same weekday number as x
    Timex.Interval.new(from: month_start, until: month_end)
    |> Enum.filter(fn d ->
      Timex.weekday(d) == day_index
    end)
    |> Enum.map(&Timex.to_date/1)
  end
end