defmodule HumanTime do
  @moduledoc """
  Documentation for HumanTime.
  """
  
  @doc """
  Returns datetime generator with applied filters
    @param timestring: human time expression
    @param start_time: initial time
  
  ## Examples
  
      iex> HumanTime.hello
      :world

  """
  def parse(timestring, opts \\ []) do
    from = opts[:from] | Timex.now
    
    # if gen_func is None:
    #     gen_func = generators._generator_day

    # filter_functions = _find_pipes(_clean(timestring))
    # chained = consts.compose(filter_functions)

    # for v in chained(gen_func(now=start_time)):
    #   yield v
    
  end
end
