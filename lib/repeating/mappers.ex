defmodule HumanTime.Repeating.Mappers do
  @moduledoc false
  
  alias HumanTime.Common.Consts
  alias HumanTime.Repeating.State
  
  @time_indexes %{
    "noon"    => [hour: 12, minute: 0, second: 0, microsecond: {0, 0}],
    "midday"  => [hour: 12, minute: 0, second: 0, microsecond: {0, 0}],
    "morning" => [hour: 8, minute: 0, second: 0, microsecond: {0, 0}],
    "midnight" => [hour: 0, minute: 0, second: 0, microsecond: {0, 0}],
  }

  # @sector_indexes %{
  #   "first"  => 0,
  #   "second" => 1,
  #   "third"  => 2,
  #   "fourth" => 3,
  #   "last"   => -1,
  # }
  
  # def remove_time(%{"at_catch" => " at "}), do: fn value -> value end
  # def remove_time(v) do
  #   fn value ->
  #     value
  #     |> Timex.set([hour: 0, minute: 0, second: 0])
  #   end
  # end
  
  @spec match_time(String.t()) :: {atom, Regex.t}
  defp match_time(the_time) do
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
  
  @spec apply_time(map) :: fun
  def apply_time(match) do
    {time_type, regex_result} = match["applicant"]
    |> match_time
    
    case time_type do
      :time_12h ->
        period_alteration = if regex_result["period"] == "pm", do: 12, else: 0
        
        opts = [
          hour: parse_int(regex_result["hour12"]) + period_alteration,
          minute: parse_int(regex_result["minute12"]),
          second: 0,
          microsecond: {0, 0}
        ]
        fn the_date ->
          Timex.set(the_date, opts)
        end
      
      :time_24h ->
        opts = [
          hour: parse_int(regex_result["hour24"]),
          minute: parse_int(regex_result["minute24"]),
          second: 0,
          microsecond: {0, 0}
        ]
        fn the_date ->
          Timex.set(the_date, opts)
        end
      
      :time_term ->
        opts = @time_indexes[match["applicant"]]
        fn the_date ->
          Timex.set(the_date, opts)
        end
        
      :time_current ->
        fn the_date -> 
          the_date
        end
    end
  end
  
  @spec every_other(map) :: fun
  def every_other(_) do
    {:ok, state_pid} = State.start_link(true)
    
    fn the_date ->
      flag = State.get(state_pid)
      State.set(state_pid, not flag)
      
      if flag do
        the_date
      else
        nil
      end
    end
  end
  
  @spec parse_int(String.t()) :: integer
  defp parse_int(""), do: 0
  defp parse_int(s), do: String.to_integer s
end