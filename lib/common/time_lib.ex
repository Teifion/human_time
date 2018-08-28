defmodule HumanTime.Common.TimeLib do
  alias HumanTime.Common.Consts
  
  
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
      # time_all -> {:time_all, time_all}
    end
  end
end