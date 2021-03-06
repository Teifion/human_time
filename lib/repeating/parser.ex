defmodule HumanTime.Repeating.Parser do
  @moduledoc false

  alias HumanTime.Common.StringLib
  alias HumanTime.Repeating.Matchers
  require Logger

  @doc """
  Run the timestring through each filter pattern
  With matches, create a set of filter functions to test
  """
  @spec build_functions(String.t()) :: {:ok, {fun, fun, fun}} | {:error, String.t()}
  def build_functions(timestring) do
    # Logger.debug "Calling build_functions with timestring: '#{timestring}'"
    timestring = StringLib.clean(timestring)
    # Logger.debug "Cleaned timestring: '#{timestring}'"

    Matchers.get_matchers()
    |> Enum.map(fn {_name, pattern, blocker, generator, filter_functions, mapper_functions} ->
      regex_result = Regex.named_captures(pattern, timestring)

      if regex_result do
        # Logger.debug "Matched with #{name}, result: #{Kernel.inspect regex_result}"
      end

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
    |> Enum.map(fn {_pattern, _blocker, generator, filter_functions, mapper_functions,
                    regex_result} ->
      {generator, filter_functions, mapper_functions, regex_result}
    end)
    |> compose
  end

  @spec compose(List) :: {:ok, {fun, fun, fun}} | {:error, String.t()}
  defp compose([]), do: {:error, "No match found"}

  defp compose(first_pass) do
    # Build generator
    funcs =
      first_pass
      |> Enum.map(fn {generator, _filter_functions, _, regex_result} ->
        {generator, regex_result}
      end)
      |> Enum.filter(fn {g, _} -> g != nil end)
      |> Enum.uniq()

    generator_function =
      case funcs do
        [] ->
          nil

        # Logger.debug "Error: No generator funcs for first_pass: '#{Kernel.inspect first_pass}'"
        [{builder, regex_result} | _] ->
          # Logger.debug "Found the following generator functions '#{Kernel.inspect funcs}'"
          # Some generators already know what they want to use
          # while others need to do it based on the regex result
          case builder do
            {func, args} -> func.(args)
            _ -> builder.(regex_result)
          end
      end

    # Build filter function
    filter_function =
      first_pass
      |> Enum.map(fn {_, filter_functions, _, regex_result} ->
        filter_functions
        |> Enum.map(fn f -> f.(regex_result) end)
      end)
      |> List.flatten()
      |> compose_filters

    # Build mapper function
    mapper_function =
      first_pass
      |> Enum.map(fn {_, _, mapper_functions, regex_result} ->
        mapper_functions
        |> Enum.map(fn f -> f.(regex_result) end)
      end)
      |> List.flatten()
      |> compose_mappers

    {:ok, {generator_function, filter_function, mapper_function}}
  end

  @spec compose_filters([fun]) :: fun
  def compose_filters(filter_functions) do
    fn value ->
      filter_functions
      |> Stream.map(fn f -> f.(value) end)
      |> Enum.all?()
    end
  end

  @spec compose_mappers([fun]) :: fun
  def compose_mappers(mapper_functions) do
    fn value ->
      mapper_functions
      |> Enum.reduce(value, fn f, acc -> f.(acc) end)
    end
  end
end
