defmodule HumanTime.Parser do
  alias HumanTime.Matchers
  
  @doc """
  Run the timestring through each filter pattern
  With matches, create a set of filter functions to test
  """
  def build_functions(timestring) do
    first_pass = Matchers.get_matchers()
    |> Enum.map(fn {pattern, filter_functions, mapper_functions} ->
      regex_result = Regex.named_captures(pattern, timestring)
      
      {pattern, filter_functions, mapper_functions, regex_result}
    end)
    |> Enum.filter(fn {_, _, _, regex_result} -> regex_result != nil end)
    
    # Build filter function
    filter_function = first_pass
    |> Enum.map(fn {_pattern, filter_functions, _, regex_result} ->
      filter_functions
      |> Enum.map(fn f -> f.(regex_result) end)
    end)
    |> List.flatten
    |> compose_filters
    
    # Build mapper function
    mapper_function = first_pass
    |> Enum.map(fn {_pattern, _, mapper_functions, regex_result} ->
      mapper_functions
      |> Enum.map(fn f -> f.(regex_result) end)
    end)
    |> List.flatten
    |> compose_mappers
    
    {filter_function, mapper_function}
  end
  
  # def compose_filters([]) do
  #   compose_filters([HumanTime.Filters.always_true(nil)])
  # end
  def compose_filters(filter_functions) do
    fn value -> 
      filter_functions
      |> Stream.map(fn f -> f.(value) end)
      |> Enum.all?
    end
  end
  
  # If no mapper functions, we want to set the out put to just a date
  # def compose_mappers([]) do
  #   compose_mappers([HumanTime.Mappers.remove_time(nil)])
  # end
  def compose_mappers(mapper_functions) do
    fn value -> 
      mapper_functions
      |> Enum.reduce(value, fn (f, acc) -> f.(acc) end)
    end
  end
end