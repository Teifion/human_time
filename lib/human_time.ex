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
    
    # filter_functions = Parser.find_pipes(_clean(timestring))
    # chained = consts.compose(filter_functions)
    
    Stream.iterate(from, generator_function)
    # |> Stream.filter(filter_functions)
    # |> Stream.map()
  end
end
