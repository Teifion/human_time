defmodule HumanTime do
  @moduledoc """
  Human Time is a function to convert a string such as "every other tuesday", "every weekday" or "every friday at 2pm" and convert it into a sequence of date times as allowed by the string.
  """
  
  alias HumanTime.Generators
  alias HumanTime.Parser
  
  @doc """
  Generates a stream of datetimes for the string given.
  
  ## Options
  `from` The datetime from when the sequence will be generated, defaults to the current time.
  
  `until` The datetime when the sequence will be terminated, defaults to nil. When nil the sequence will never be terminated.
  
  ## Example
      HumanTime.parse("Every wednesday at 1530")
      |> Stream.take(3)
      |> Enum.to_list
      
      #=> [
      #=>   #DateTime<2018-08-15 15:30:00.848218Z>,
      #=>   #DateTime<2018-08-22 15:30:00.848218Z>,
      #=>   #DateTime<2018-08-29 15:30:00.848218Z>
      #=> ]
  """
  @spec parse(String.t(), [term]) :: Enumerable.t
  def parse(timestring, opts \\ []) do
    from = opts[:from] || Timex.now()
    until = opts[:until]
    
    while_function = Generators.while_function(until)
    
    {generator_function, filter_function, mapper_function} = timestring
    |> clean
    |> Parser.build_functions
    
    Stream.iterate(from, generator_function)
    |> Stream.take_while(while_function)
    |> Stream.filter(filter_function)
    # |> Stream.map_reduce(mapper_function)
    |> Stream.map(mapper_function)
    |> Stream.filter(&(&1 != nil))
  end
  
  # Removes double-spacing from the string, removes the word
  # "every" which  is not needed to match against.
  # Also downcases the string as we don't want it to have
  # to watch for case in the regex
  @doc false
  @spec clean(String.t()) :: String.t()
  defp clean(timestring) do
    timestring
    |> String.replace("every", "")
    |> String.replace("  ", " ")
    |> String.replace("  ", " ")
    |> String.replace("  ", " ")
    |> String.trim
    |> String.downcase
  end
end
