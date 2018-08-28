defmodule HumanTime.Common.StringLib do
  # Removes double-spacing from the string,
  # downcases the string as we don't want it to have
  # to watch for case in the regex
  @doc false
  @spec clean(String.t()) :: String.t()
  def clean(timestring) do
    timestring
    # |> String.replace("every", "")
    |> String.replace("  ", " ")
    |> String.replace("  ", " ")
    |> String.replace("  ", " ")
    |> String.trim
    |> String.downcase
  end
  
  # Used to convert from a string into a numrical value
  @doc false
  @spec convert_amount(String.t) :: Integer
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
end