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
  
  @spec every_skip(map) :: fun
  def every_skip(map) do
    count_from = case map["skip"] do
      "other" -> 2
      "second" -> 2
      "third" -> 3
      "fourth" -> 4
      "fifth" -> 5
      "fith" -> 5
      "sixth" -> 6
    end

    # If we start it from 1 then the first instance
    # it comes across will trigger, there is a debate we
    # start from count_from
    {:ok, state_pid} = State.start_link(1)

    fn the_date ->
      counter = State.get(state_pid)

      if counter == 1 do
        State.set(state_pid, count_from)
        the_date
      else
        State.set(state_pid, counter - 1)
        nil
      end
    end
  end
  
  @spec every_x(map) :: fun
  def every_x(map) do
    {:ok, state_pid} = State.start_link(-1)
    period_amount = StringLib.parse_int(map["repeat_amount"])

    fn the_date ->
      counter = State.get(state_pid) + 1

      if counter == period_amount do
        State.set(state_pid, 0)
        the_date
      else
        State.set(state_pid, counter)
        nil
      end
    end
  end
end