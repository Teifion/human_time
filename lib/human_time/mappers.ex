defmodule HumanTime.Mappers do
  alias HumanTime.Consts
  
  @time_indexes %{
    "noon"    => [hour: 12, minute: 0, second: 0],
    "midday"  => [hour: 12, minute: 0, second: 0],
    "morning" => [hour: 8, minute: 0, second: 0],
  }

  # @sector_indexes %{
  #   "first"  => 0,
  #   "second" => 1,
  #   "third"  => 2,
  #   "fourth" => 3,
  #   "last"   => -1,
  # }
  
  def remove_time(_) do
    fn value ->
      Timex.set(value, [hour: 0, minute: 0, second: 0])
    end
  end
  
  defp match_time(the_time) do
    time_term    = Regex.named_captures(Consts.compiled_time_term(), the_time)
    time_current = Regex.named_captures(Consts.compiled_time_current(), the_time)
    time_12h     = Regex.named_captures(Consts.compiled_time_12h(), the_time)
    time_24h     = Regex.named_captures(Consts.compiled_time_24h(), the_time)
    time_all     = Regex.named_captures(Consts.compiled_time_all(), the_time)
    
    cond do
      time_12h -> {:time_12h, time_12h}
      time_24h -> {:time_24h, time_24h}
      time_term -> {:time_term, time_term}
      time_current -> {:time_current, time_current}
      time_all -> {:time_all, time_all}
    end
  end
  
  def apply_time(match) do
    {time_type, regex_result} = match["applicant"]
    |> match_time
    
    case time_type do
      :time_12h ->
        period_alteration = if regex_result["period"] == "pm", do: 12, else: 0
        
        opts = [
          hour: parse_int(regex_result["hour12"]) + period_alteration,
          minute: parse_int(regex_result["minute12"]),
          second: 0
        ]
        fn the_date ->
          Timex.set(the_date, opts)
        end
      
      :time_24h ->
        opts = [
          hour: parse_int(regex_result["hour24"]),
          minute: parse_int(regex_result["minute24"]),
          second: 0
        ]
        fn the_date ->
          Timex.set(the_date, opts)
        end
      
      :time_term ->
        # hour, minute = TIME_INDEXES[r.groups()[0]]
        # return partial(f, hour=hour, minute=minute)      
        
        IO.puts ""
        IO.inspect regex_result
        IO.puts ""
        
        raise "Z"
        
      :time_current ->
        fn the_date -> 
          the_date
        end
        
      :time_all ->
        opts = @time_indexes[match["applicant"]]
        fn the_date ->
          Timex.set(the_date, opts)
        end
    end
  end
  
  # def cut_time(match) do
  #   IO.puts ""
  #   IO.inspect match
  #   IO.puts ""
    
  #   fn the_date ->
  #     # Timex.set(the_date, opts)
      
  #     IO.puts ""
  #     IO.inspect the_date
  #     IO.puts ""
      
  #     the_date
  #   end
  # end
  
  defp parse_int(""), do: 0
  defp parse_int(s), do: String.to_integer s
end