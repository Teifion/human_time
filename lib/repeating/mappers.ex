defmodule HumanTime.Repeating.Mappers do
  @moduledoc false
  
  # alias HumanTime.Common.Consts
  alias HumanTime.Common.StringLib
  alias HumanTime.Common.TimeLib
  alias HumanTime.Repeating.State
  
  @spec apply_time(map) :: fun
  def apply_time(match) do
    {time_type, regex_result} = match["applicant"]
    |> TimeLib.match_time
    
    case time_type do
      :time_12h ->
        period_alteration = if regex_result["period"] == "pm", do: 12, else: 0
        
        opts = [
          hour: StringLib.parse_int(regex_result["hour12"]) + period_alteration,
          minute: StringLib.parse_int(regex_result["minute12"]),
          second: 0,
          microsecond: {0, 0}
        ]
        fn the_date ->
          Timex.set(the_date, opts)
        end
      
      :time_24h ->
        opts = [
          hour: StringLib.parse_int(regex_result["hour24"]),
          minute: StringLib.parse_int(regex_result["minute24"]),
          second: StringLib.parse_int(regex_result["second"] || ""),
          microsecond: {0, 0}
        ]
        fn the_date ->
          Timex.set(the_date, opts)
        end
      
      :time_term ->
        opts = TimeLib.get_time_indexes[match["applicant"]]
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
end