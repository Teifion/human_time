defmodule HumanTime.Repeating.Generators do
  @moduledoc false

  # @spec seconds(DateTime.t) :: DateTime.t
  def seconds(now, _match), do: Timex.shift(now, seconds: 1)

  # @spec minutes(DateTime.t) :: DateTime.t
  def minutes(now, _match), do: Timex.shift(now, minutes: 1)

  # @spec hours(DateTime.t) :: DateTime.t
  def hours(now, _match), do: Timex.shift(now, hours: 1)

  # @spec days(DateTime.t) :: DateTime.t
  def days(now, _match), do: Timex.shift(now, days: 1)

  # @spec weeks(DateTime.t) :: DateTime.t
  def weeks(now, _match), do: Timex.shift(now, days: 7)

  # @spec months(DateTime.t) :: DateTime.t
  def months(now, _match), do: Timex.shift(now, months: 1)

  # @spec years(DateTime.t) :: DateTime.t
  def years(now, _match), do: Timex.shift(now, years: 1)

  # @spec by_type(DateTime.t) :: DateTime.t
  def by_match_type(match) do
    gc = match["generator_component"]

    cond do
      Enum.member?(~w(second seconds), gc) -> "seconds"
      Enum.member?(~w(minute minutes), gc) -> "minutes"
      Enum.member?(~w(hour hours), gc) -> "hours"
      Enum.member?(~w(day days), gc) -> "days"
      Enum.member?(~w(week weeks), gc) -> "weeks"
      Enum.member?(~w(month months), gc) -> "months"
      Enum.member?(~w(year years), gc) -> "years"
    end
    |> by_known_type
  end

  def by_known_type(type) do
    case type do
      "seconds" -> fn now -> Timex.shift(now, seconds: 1) end
      "minutes" -> fn now -> Timex.shift(now, minutes: 1) end
      "hours" -> fn now -> Timex.shift(now, hours: 1) end
      "days" -> fn now -> Timex.shift(now, days: 1) end
      "weeks" -> fn now -> Timex.shift(now, weeks: 1) end
      "months" -> fn now -> Timex.shift(now, months: 1) end
      "years" -> fn now -> Timex.shift(now, years: 1) end
    end
  end

  # def while_function(nil), do: fn _ -> true end
  @spec while_function(DateTime.t()) :: fun
  def while_function(until) do
    fn v -> Timex.compare(v, until) != 1 end
  end
end
