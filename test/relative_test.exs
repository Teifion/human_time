defmodule HumanTime.RelativeTest do
  use ExUnit.Case
  doctest HumanTime
  
  test "complete statements" do
    values = [
      {"5s", {{2013, 12, 4}, {06, 20, 10}}},
      {"5m", {{2013, 12, 4}, {06, 25, 05}}},
      {"5h", {{2013, 12, 4}, {11, 20, 05}}},
      {"5d", {{2013, 12, 9}, {06, 20, 05}}},

      {"4/11/2013", {{2013, 11, 4}, {0, 0, 0}}},
      {"4/11/2013 12:44:55", {{2013, 11, 4}, {12, 44, 55}}},
      {"2013-11-4", {{2013, 11, 4}, {0, 0, 0}}},

      {"now", {{2013, 12, 4}, {06, 20, 05}}},
      {"In an hour", {{2013, 12, 4}, {07, 20, 05}}},
      {"In 5 minutes", {{2013, 12, 4}, {06, 25, 05}}},

      {"13:43:59 24/11/2013", {{2013, 11, 24}, {13, 43, 59}}},

      {"4/11/2013 07:30:00", {{2013, 11, 4}, {07, 30, 0}}},
      {"4/11/2013 at 0730", {{2013, 11, 4}, {07, 30, 0}}},
      {"4/11/2013 at noon", {{2013, 11, 4}, {12, 0, 0}}},

      {"this wednesday at noon", {{2013, 12, 4}, {12, 0, 0}}},
      {"next wednesday at 1500", {{2013, 12, 11}, {15, 0, 0}}},
      {"tomorrow at 5pm", {{2013, 12, 5}, {17, 0, 0}}},
      {"tomorrow", {{2013, 12, 5}, {06, 20, 5}}},
      {"yesterday", {{2013, 12, 3}, {06, 20, 5}}},
      {"today at 8pm", {{2013, 12, 4}, {20, 0, 0}}},
      {"this time next friday", {{2013, 12, 13}, {06, 20, 05}}},
      {"week friday", {{2013, 12, 13}, {06, 20, 05}}},
      {"week next friday at 2am", {{2013, 12, 20}, {2, 0, 0}}},

      {"* * * * *", {{2013, 12, 4}, {06, 21, 0}}},
    ]
    
    # A calendar of December 2013 (the month this date falls into)
    # for your reference.
    
    #    December 2013
    # Su Mo Tu We Th Fr Sa
    #  1  2  3  4  5  6  7
    #  8  9 10 11 12 13 14
    # 15 16 17 18 19 20 21
    # 22 23 24 25 26 27 28
    # 29 30 31
    
    from = Timex.to_datetime({{2013, 12, 4}, {06, 20, 5}}, "Europe/London")
    
    for {input_string, expected_tuple} <- values do
      expected = Timex.to_datetime(expected_tuple, "Europe/London")
      
      case HumanTime.relative(input_string, from: from) do
        {:ok, result} ->
          assert expected == result, message: "Error with: '#{input_string}, expected #{expected}, got #{result}"
        {:error, "No match found"} ->
          flunk "No match found for '#{input_string}'"
      end
    end
  end
  
  test "no match" do
    assert_raise RuntimeError, fn ->
      "no match found!"
      |> HumanTime.relative!
    end
  end
end
