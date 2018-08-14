defmodule HumanTime do
  @moduledoc """
  Documentation for HumanTime.
  """
  
  alias HumanTime.Generators
  alias HumanTime.Parser
  
  @doc """
  Returns datetime generator with applied filters
    @param timestring: human time expression
    @param start_time: initial time
  
  """
  @spec parse(charlist, list) :: Stream.t
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
