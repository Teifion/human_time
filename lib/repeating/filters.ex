defmodule HumanTime.Repeating.Filters do
  @moduledoc false
  
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
  
  # def always_true(_) do
  #   fn _ ->
  #     true
  #   end
  # end
  
  @spec weekday(map) :: (DateTime.t -> DateTime.t | nil)
  def weekday(match) do
    day_numbers = @day_map[match["principle"]]
    
    fn the_date ->
      Timex.weekday(the_date) in day_numbers
    end
  end
  
  # If we catch an after then it means this function was triggered incorrectly
  @spec identifier_in_month(map) :: (DateTime.t -> DateTime.t | nil)
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
  
  @spec identifier_in_month_after(map) :: (DateTime.t -> DateTime.t | nil)
  def identifier_in_month_after(match) do
    selector1  = match["selector1"]
    the_day1   = match["principle1"]
    selector2  = match["selector2"]
    the_day2   = match["principle2"]
    
    fn the_date ->
      # Calculate an "after date", we won't accept a value prior to this date
      selector_index = @sector_indexes[selector2]
      after_date = Enum.at(get_xs_in_month(the_day2, the_date), selector_index)
      
      # Get the Xs in a month which are after the after_date
      xs_in_month = get_xs_in_month(the_day1, the_date)
      |> Enum.filter(fn d -> Timex.compare(d, after_date) == 1 end)
      
      # Calcualte an acceptable day from the Xs
      selector_index = @sector_indexes[selector1]
      
      # Is today the date we find to be acceptable?
      Enum.at(xs_in_month, selector_index) == the_date |> Timex.to_date
    end
  end
  
  @spec day_number_in_month(map) :: (DateTime.t -> DateTime.t | nil)
  def day_number_in_month(match) do
    day_number = match["selector"]
    |> String.to_integer
    
    fn the_date ->
      Timex.to_date(the_date).day == day_number
    end
  end
  
  @spec end_of_month(map) :: (DateTime.t -> DateTime.t | nil)
  def end_of_month(_match) do
    fn the_date ->
      Timex.to_date(the_date) == Timex.end_of_month(the_date) |> Timex.to_date
    end
  end
  
  
  # Used to get all Xs from a month where X is something like tuesday
  @spec get_xs_in_month(String.t(), DateTime.t | Date.t) :: list
  defp get_xs_in_month(x, the_date) do
    the_date = the_date |> Timex.to_date
    
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