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
    generator_function = opts[:generator] || &Generators.days/1
    
    {filter_function, mapper_function} = timestring
    |> clean
    |> Parser.build_functions
    
    Stream.iterate(from, generator_function)
    |> Stream.filter(filter_function)
    |> Stream.map(mapper_function)
  end
  
  # Removes double-spacing from the string, removes the word
  # "every" which  is not needed to match against.
  # Also downcases the string as we don't want it to have
  # to watch for case in the regex
  defp clean(timestring) do
    timestring
    |> String.replace("  ", " ")
    |> String.replace("  ", " ")
    |> String.replace("  ", " ")
    |> String.replace("every", "")
    |> String.trim
    |> String.downcase
  end
end
