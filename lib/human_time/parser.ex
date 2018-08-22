defmodule HumanTime.Parser do
  @moduledoc false
  
  alias HumanTime.Matchers
  
  @doc """
  Run the timestring through each filter pattern
  With matches, create a set of filter functions to test
  """
  @spec build_functions(String.t()) :: {fun, fun, fun}
  def build_functions(timestring) do
    timestring = clean(timestring)
    
    first_pass = Matchers.get_matchers()
    |> Enum.map(fn {pattern, blocker, generator, filter_functions, mapper_functions} ->
      regex_result = Regex.named_captures(pattern, timestring)
      
      {pattern, blocker, generator, filter_functions, mapper_functions, regex_result}
    end)
    |> Enum.filter(fn {_, _, _, _, _, regex_result} -> regex_result != nil end)
    |> Enum.filter(fn {_, blocker, _, _, _, _} ->
      if blocker do
        Regex.run(blocker, timestring) == nil
      else
        true
      end
    end)
    |> Enum.map(fn {_, _, generator, filter_functions, mapper_functions, regex_result} ->
      {generator, filter_functions, mapper_functions, regex_result}
    end)
    
    # Build generator
    generator_function = first_pass
    |> Enum.map(fn {generator, _filter_functions, _, _regex_result} ->
      generator
    end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.uniq
    |> hd
    
    # Temporary code to debug if there are the correct generator functions
    # generator_function = if Enum.count(generator_function) == 1 do
    #   hd(generator_function)
    # else
    #   raise ""
    # end
    
    # Build filter function
    filter_function = first_pass
    |> Enum.map(fn {_, filter_functions, _, regex_result} ->
      filter_functions
      |> Enum.map(fn f -> f.(regex_result) end)
    end)
    |> List.flatten
    |> compose_filters
    
    # Build mapper function
    mapper_function = first_pass
    |> Enum.map(fn {_, _, mapper_functions, regex_result} ->
      mapper_functions
      |> Enum.map(fn f -> f.(regex_result) end)
    end)
    |> List.flatten
    |> compose_mappers
    
    {generator_function, filter_function, mapper_function}
  end
  
  # def compose_filters([]) do
  #   compose_filters([HumanTime.Filters.always_true(nil)])
  # end
  @spec compose_filters([fun]) :: fun
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
  @spec compose_mappers([fun]) :: fun
  def compose_mappers(mapper_functions) do
    fn value -> 
      mapper_functions
      |> Enum.reduce(value, fn (f, acc) -> f.(acc) end)
    end
  end
  
  # Removes double-spacing from the string,
  # downcases the string as we don't want it to have
  # to watch for case in the regex
  @doc false
  @spec clean(String.t()) :: String.t()
  defp clean(timestring) do
    timestring
    # |> String.replace("every", "")
    |> String.replace("  ", " ")
    |> String.replace("  ", " ")
    |> String.replace("  ", " ")
    |> String.trim
    |> String.downcase
  end
end