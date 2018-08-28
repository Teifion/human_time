defmodule HumanTime do
  @moduledoc """
  Human Time is a function to convert a string such as "every other tuesday", "every weekday" or "next friday at 2pm" and convert it into a one or a sequence of date times as allowed by the string.
  """
  
  alias HumanTime.Repeating
  alias HumanTime.Relative
  
  @doc """
  Generates a stream of datetimes for the string given.
  
  ## Options
  `from` The datetime from when the sequence will be generated, defaults to the current time.
  
  `until` The datetime when the sequence will be terminated, defaults to nil. When nil the sequence will never be terminated.
  
  ## Example
      HumanTime.repeating("Every wednesday at 1530")
      |> Stream.take(3)
      |> Enum.to_list
      
      #=> [
      #=>   #DateTime<2018-08-15 15:30:00.848218Z>,
      #=>   #DateTime<2018-08-22 15:30:00.848218Z>,
      #=>   #DateTime<2018-08-29 15:30:00.848218Z>
      #=> ]
  """
  @spec repeating(String.t(), [term]) :: Enumerable.t
  def repeating(timestring, opts \\ []) do
    from = opts[:from] || Timex.now()
    until = opts[:until]
    
    while_function = Repeating.Generators.while_function(until)
    
    {generator_function, filter_function, mapper_function} = timestring
    |> Repeating.Parser.build_functions
    
    Stream.iterate(from, generator_function)
    |> Stream.take_while(while_function)
    |> Stream.filter(filter_function)
    |> Stream.map(mapper_function)
    |> Stream.filter(&(&1 != nil))
  end
  
  @spec relative(String.t(), [term]) :: any
  def relative(timestring, opts \\ []) do
    from = opts[:from] || Timex.now()
    
    Relative.Parser.parse(timestring, from)
  end
  
end
