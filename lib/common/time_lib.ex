defmodule HumanTime.Common.TimeLib do
  @moduledoc false

  alias HumanTime.Common.Consts
  alias HumanTime.Common.StringLib
  
  @time_indexes %{
    "noon"    => [hour: 12, minute: 0, second: 0, microsecond: {0, 0}],
    "midday"  => [hour: 12, minute: 0, second: 0, microsecond: {0, 0}],
    "morning" => [hour: 8, minute: 0, second: 0, microsecond: {0, 0}],
    "midnight" => [hour: 0, minute: 0, second: 0, microsecond: {0, 0}],
  }
  @spec get_time_indexes() :: list
  def get_time_indexes(), do: @time_indexes
  
  @spec match_time(String.t()) :: {atom, Regex.t}
  def match_time(the_time) do
    time_term    = Regex.named_captures(Consts.compiled_time_term(), the_time)
    time_current = Regex.named_captures(Consts.compiled_time_current(), the_time)
    time_12h     = Regex.named_captures(Consts.compiled_time_12h(), the_time)
    time_24h     = Regex.named_captures(Consts.compiled_time_24h(), the_time)
    # time_all     = Regex.named_captures(Consts.compiled_time_all(), the_time)
    
    cond do
      time_12h -> {:time_12h, time_12h}
      time_24h -> {:time_24h, time_24h}
      time_term -> {:time_term, time_term}
      time_current -> {:time_current, time_current}
      true -> {:no_time, nil}
    end
  end
  
  # @spec apply_time(arg_type) :: return_type
  def apply_time(the_date, ""), do: the_date
  def apply_time(the_date, time_match) do
    {time_type, match_result} = time_match
    |> match_time
    
    case time_type do
      :time_12h ->
        period_alteration = if match_result["period"] == "pm", do: 12, else: 0
        
        opts = [
          hour: StringLib.parse_int(match_result["hour12"]) + period_alteration,
          minute: StringLib.parse_int(match_result["minute12"]),
          second: 0,
          microsecond: {0, 0}
        ]
        Timex.set(the_date, opts)
      
      :time_24h ->
        opts = [
          hour: StringLib.parse_int(match_result["hour24"]),
          minute: StringLib.parse_int(match_result["minute24"]),
          second: StringLib.parse_int(match_result["second"] || ""),
          microsecond: {0, 0}
        ]
        Timex.set(the_date, opts)
      
      :time_term ->
        opts = @time_indexes[time_match]
        Timex.set(the_date, opts)
      
      :time_current ->
        the_date
    end
  end
end