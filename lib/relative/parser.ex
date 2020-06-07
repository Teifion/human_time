defmodule HumanTime.Relative.Parser do
  @moduledoc false

  alias HumanTime.Common.StringLib
  alias HumanTime.Relative.Matchers

  @doc """
  Run the timestring through each filter pattern
  With matches, create a set of filter functions to test
  """
  @spec parse(String.t(), DateTime.t()) :: DateTime.t()
  def parse(timestring, from) do
    timestring = StringLib.clean(timestring)

    Matchers.get_matchers()
    |> Enum.map(fn {pattern, blocker, mapper} ->
      regex_result = Regex.named_captures(pattern, timestring)

      {pattern, blocker, mapper, regex_result}
    end)
    |> Enum.filter(fn {_, _, _, regex_result} -> regex_result != nil end)
    |> Enum.filter(fn {_, blocker, _, _} ->
      if blocker do
        Regex.run(blocker, timestring) == nil
      else
        true
      end
    end)
    |> Enum.map(fn {_, _, mapper, regex_result} ->
      {mapper, regex_result}
    end)
    |> compose(from)
  end

  @spec compose(list, Datetime.t()) :: {:ok, Datetime.t()} | {:error, String.t()}
  defp compose([], _), do: {:error, "No match found"}

  defp compose(results, from) do
    {mapper, regex_result} = hd(results)

    case mapper.(regex_result, from) do
      {:ok, the_datetime} -> {:ok, the_datetime}
      {:error, msg} -> raise msg
    end
  end
end
