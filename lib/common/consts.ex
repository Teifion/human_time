defmodule HumanTime.Common.Consts do
  @moduledoc false
  
  # Regex.compile
  @selector_names "first|1st|second|2nd|third|3rd|fourth|4th|last"
  @day_names "monday|tuesday|wednesday|thursday|friday|saturday|sunday"
  @all_day_names @day_names <> "|weekday|day|weekend"
  # @month_names "january|february|march|april|may|june|july|august|september|october|november|december"
  
  @relative_name "(today|tomorrow|yesterday)"
  @relative_adjuster "(this|next|last|week this|week next|week)"
  @amounts "([0-9]+|one|two|three|four|five|six|seven|eight|nine|ten|\\ba\\b|\\ban\\b)"
  @iterators "every|every other"
  
  @sep "[-/]"
  @dmy_date "((?<dmy_d>[0-9]{1,2})#{@sep}(?<dmy_m>[0-9]{1,2})#{@sep}(?<dmy_y>[0-9]{2,4}))"
  @ymd_date "((?<ymd_y>[0-9]{4})#{@sep}(?<ymd_m>[0-9]{1,2})#{@sep}(?<ymd_d>[0-9]{1,2}))"
  @date "(?:#{@dmy_date}|#{@ymd_date})"
  
  @time_term "(midnight|noon|midday|morning)"
  @time_current "(this|current) time"
  @time_12h "(?P<hour12>[0-9]|1[0-2])(:(?P<minute12>[0-5][0-9]))?(?P<period>am|pm)"
  @time_24h "(?P<hour24>[01]?[0-9]|2[0-3]):?(?P<minute24>[0-5][0-9])(:(?P<second>[0-5][0-9]))?"
  @time_all "(?:#{@time_12h}|#{@time_24h}|#{@time_term}|#{@time_current})"

  @period "(second|minute|hour|day|week|month|year)"

  @time_term_compiled @time_term |> Regex.compile!
  @time_current_compiled @time_current |> Regex.compile!
  @time_12h_compiled @time_12h |> Regex.compile!
  @time_24h_compiled @time_24h |> Regex.compile!
  @time_all_compiled @time_all |> Regex.compile!
  
  
  @day_map %{
    "monday"    => [1],
    "tuesday"   => [2],
    "wednesday" => [3],
    "thursday"  => [4],
    "friday"    => [5],
    "saturday"  => [6],
    "sunday"    => [7],
    "weekday"   => [1, 2, 3, 4, 5],
    "weekend"   => [6, 7],
    "day"       => [1, 2, 3, 4, 5, 6, 7],
  }
  
  
  @spec create_pattern(String.t()) :: Regex.t
  def create_pattern(patten_string) do
    patten_string
    |> String.replace("#SELECTOR_NAMES#", @selector_names)
    |> String.replace("#DAY_NAMES#", @day_names)
    |> String.replace("#ALL_DAY_NAMES#", @all_day_names)
    |> String.replace("#TIME_ALL#", @time_all)
    |> String.replace("#DATE#", @date)
    |> String.replace("#ITERATORS#", @iterators)
    |> String.replace("#AMOUNT#", @amounts)
    |> String.replace("#RELATIVE_NAME#", @relative_name)
    |> String.replace("#RELATIVE_ADJUSTER#", @relative_adjuster)
    |> String.replace("#PERIOD#", @period)
    |> Regex.compile!
  end
  
  def compiled_time_term(), do: @time_term_compiled
  def compiled_time_current(), do: @time_current_compiled
  def compiled_time_12h(), do: @time_12h_compiled
  def compiled_time_24h(), do: @time_24h_compiled
  def compiled_time_all(), do: @time_all_compiled
  
  def get_day_map(), do: @day_map
end