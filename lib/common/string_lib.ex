defmodule HumanTime.Common.StringLib do
  @moduledoc false

  # Removes double-spacing from the string,
  # downcases the string as we don't want it to have
  # to watch for case in the regex
  @doc false
  @spec clean(String.t()) :: String.t()
  def clean(timestring) do
    timestring
    |> String.replace("  ", " ")
    |> String.replace("  ", " ")
    |> String.replace("  ", " ")
    |> String.trim()
    |> String.downcase()
  end

  # Used to convert from a string into a numrical value
  @doc false
  @spec convert_amount(String.t()) :: Integer
  def convert_amount("a"), do: 1
  def convert_amount("an"), do: 1
  def convert_amount("one"), do: 1
  def convert_amount("two"), do: 2
  def convert_amount("three"), do: 3
  def convert_amount("four"), do: 4
  def convert_amount("five"), do: 5
  def convert_amount("six"), do: 6
  def convert_amount("seven"), do: 7
  def convert_amount("eight"), do: 8
  def convert_amount("nine"), do: 9
  def convert_amount("ten"), do: 10
  def convert_amount(a), do: String.to_integer(a)

  @spec convert_date(map) :: {:ok, Date.t()} | {:error, atom}
  def convert_date(%{"dmy_d" => d, "dmy_m" => m, "dmy_y" => y}) when d != "" do
    {y |> String.to_integer(), m |> String.to_integer(), d |> String.to_integer()}
    |> Timex.to_date()
  end

  def convert_date(%{"ymd_d" => d, "ymd_m" => m, "ymd_y" => y}) when d != "" do
    {y |> String.to_integer(), m |> String.to_integer(), d |> String.to_integer()}
    |> Timex.to_date()
  end

  # Specific handler for parsing time when we expect there
  # to be a possibility of empty strings which need to mean 0
  @spec parse_int(String.t()) :: integer
  def parse_int(""), do: 0
  def parse_int(s), do: String.to_integer(s)
end
