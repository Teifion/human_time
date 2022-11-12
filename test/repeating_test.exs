defmodule HumanTime.RepeatingTest do
  use ExUnit.Case
  doctest HumanTime

  test "complete cycles" do
    values = [
      {["every 5 seconds", "5s"],
       [
         Timex.to_datetime({{2013, 12, 04}, {06, 20, 10}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 04}, {06, 20, 15}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 04}, {06, 20, 20}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 04}, {06, 20, 25}}, "Europe/London")
       ]},
      {["every 5 minutes", "5m"],
       [
         Timex.to_datetime({{2013, 12, 04}, {06, 25, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 04}, {06, 30, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 04}, {06, 35, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 04}, {06, 40, 5}}, "Europe/London")
       ]},
      {["every 5 hours", "5h"],
       [
         Timex.to_datetime({{2013, 12, 04}, {11, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 04}, {16, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 04}, {21, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 05}, {2, 20, 5}}, "Europe/London")
       ]},
      {["every 5 days", "5d"],
       [
         Timex.to_datetime({{2013, 12, 09}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 14}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 19}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 24}, {06, 20, 5}}, "Europe/London")
       ]},
      {["every 5 weeks", "5w"],
       [
         Timex.to_datetime({{2014, 01, 08}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2014, 02, 12}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2014, 03, 19}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2014, 04, 23}, {06, 20, 5}}, "Europe/London")
       ]},
      {["every 2 months"],
       [
         Timex.to_datetime({{2014, 02, 04}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2014, 04, 04}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2014, 06, 04}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2014, 08, 04}, {06, 20, 5}}, "Europe/London")
       ]},
      {["every 3 years"],
       [
         Timex.to_datetime({{2016, 12, 04}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2019, 12, 04}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2022, 12, 04}, {06, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2025, 12, 04}, {06, 20, 5}}, "Europe/London")
       ]},
      {["every tuesday at midnight"],
       [
         Timex.to_datetime({{2013, 12, 10}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 17}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 24}, {0, 0, 0}}, "Europe/London")
       ]},
      {["every weekday at midnight"],
       [
         Timex.to_datetime({{2013, 12, 4}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 5}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 6}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 9}, {0, 0, 0}}, "Europe/London")
       ]},
      {["every day at midnight"],
       [
         Timex.to_datetime({{2013, 12, 4}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 5}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 6}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 7}, {0, 0, 0}}, "Europe/London")
       ]},
      {["every weekday at noon"],
       [
         Timex.to_datetime({{2013, 12, 4}, {12, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 5}, {12, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 6}, {12, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 9}, {12, 0, 0}}, "Europe/London")
       ]},
      {["every weekend at 1500"],
       [
         Timex.to_datetime({{2013, 12, 7}, {15, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 8}, {15, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 14}, {15, 0, 0}}, "Europe/London")
       ]},
      {["every tuesday at 4:20am", "every tuesday at 4:20 am"],
       [
         Timex.to_datetime({{2013, 12, 10}, {4, 20, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 17}, {4, 20, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 24}, {4, 20, 0}}, "Europe/London")
       ]},
      {["every weekday at 1630"],
       [
         Timex.to_datetime({{2013, 12, 4}, {16, 30, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 5}, {16, 30, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 6}, {16, 30, 0}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 9}, {16, 30, 0}}, "Europe/London")
       ]},
      {["first monday of every month"],
       [
         Timex.to_datetime({{2014, 1, 6}, {6, 20, 05}}, "Europe/London"),
         Timex.to_datetime({{2014, 2, 3}, {6, 20, 05}}, "Europe/London"),
         Timex.to_datetime({{2014, 3, 3}, {6, 20, 05}}, "Europe/London")
       ]},
      {["second wednesday of every month at midnight"],
       [
         Timex.to_datetime({{2013, 12, 11}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 1, 8}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 2, 12}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 3, 12}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 4, 9}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 5, 14}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 6, 11}, {0, 0, 0}}, "Europe/London")
       ]},
      {["last Friday of every month at 9am"],
       [
         Timex.to_datetime({{2013, 12, 27}, {9, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 1, 31}, {9, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 2, 28}, {9, 0, 0}}, "Europe/London")
       ]},
      {["15th of every month at midnight"],
       [
         Timex.to_datetime({{2013, 12, 15}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 1, 15}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 2, 15}, {0, 0, 0}}, "Europe/London")
       ]},
      {["21 of every month at 1430"],
       [
         Timex.to_datetime({{2013, 12, 21}, {14, 30, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 1, 21}, {14, 30, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 2, 21}, {14, 30, 0}}, "Europe/London")
       ]},
      {["every Monday at this time"],
       [
         Timex.to_datetime({{2013, 12, 9}, {6, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 16}, {6, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 23}, {6, 20, 5}}, "Europe/London")
       ]},
      {["every other Sunday at current time", "every second Sunday at current time"],
       [
         Timex.to_datetime({{2013, 12, 8}, {6, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 22}, {6, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2014, 1, 5}, {6, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2014, 1, 19}, {6, 20, 5}}, "Europe/London")
       ]},
      {["every Monday at this time"],
       [
         Timex.to_datetime({{2013, 12, 9}, {6, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 16}, {6, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2013, 12, 23}, {6, 20, 5}}, "Europe/London")
       ]},

      # Currently commented out as I'm not sure how I want this to act
      # {["every other hour"], [
      #   Timex.to_datetime({{2013, 12, 4}, {08, 20, 05}}, "Europe/London"),
      #   Timex.to_datetime({{2013, 12, 4}, {10, 20, 05}}, "Europe/London"),
      #   Timex.to_datetime({{2013, 12, 4}, {12, 20, 05}}, "Europe/London"),
      #   Timex.to_datetime({{2013, 12, 4}, {14, 20, 05}}, "Europe/London"),
      # ]},

      {["15th of every month at this time"],
       [
         Timex.to_datetime({{2013, 12, 15}, {6, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2014, 1, 15}, {6, 20, 5}}, "Europe/London"),
         Timex.to_datetime({{2014, 2, 15}, {6, 20, 5}}, "Europe/London")
       ]},
      {["end of every month at midnight"],
       [
         Timex.to_datetime({{2013, 12, 31}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 1, 31}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 2, 28}, {0, 0, 0}}, "Europe/London")
       ]},
      {["end of every month at 18:00"],
       [
         Timex.to_datetime({{2013, 12, 31}, {18, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 1, 31}, {18, 0, 0}}, "Europe/London")
       ]},

      # Especially useful as the final step crosses a DST barrier and flagged up a bug
      # where the wrong day could be used
      {["first monday after second sunday of every month at midnight"],
       [
         Timex.to_datetime({{2013, 12, 9}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 1, 13}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 2, 10}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 3, 10}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 4, 14}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 5, 12}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 6, 9}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 7, 14}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 8, 11}, {0, 0, 0}}, "Europe/London"),
         Timex.to_datetime({{2014, 9, 15}, {0, 0, 0}}, "Europe/London")
       ]}
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
    until = Timex.shift(from, years: 20)

    for {string_list, expected} <- values do
      for input_string <- string_list do
        run_results =
          try do
            HumanTime.repeating(input_string, from: from, until: until)
          catch
            :error, e ->
              flunk("Runtime Error for '#{input_string}' - #{Kernel.inspect(e)}")
          end

        case run_results do
          {:ok, parse_result} ->
            time_results =
              parse_result
              |> Stream.take(Enum.count(expected))
              |> Enum.to_list()

            assert Enum.count(time_results) == Enum.count(expected),
              message:
                "Error with: #{input_string}, different number of time_results vs expected, expected #{Enum.count(expected)}, got #{Enum.count(time_results)}"

            for {{expected_item, result_item}, idx} <-
                  Enum.with_index(Enum.zip([expected, time_results])) do
              assert expected_item == result_item,
                message:
                  "Error with: #{input_string}, expected #{expected_item}, got #{result_item} as item ##{idx + 1}"
            end

          {:error, "No match found"} ->
            flunk("No match found for '#{input_string}'")
        end
      end
    end
  end

  test "no match" do
    assert_raise RuntimeError, fn ->
      "no match found!"
      |> HumanTime.repeating!()
    end
  end

  # We are using a genserver without a supervisor in the every other mapper
  # this test is to ensure we can have two operating at the same time
  test "concurrency" do
    from = Timex.to_datetime({{2013, 12, 4}, {06, 20, 5}}, "Europe/London")
    until = Timex.shift(from, years: 1)

    stream1 =
      "every other tuesday at midnight"
      |> HumanTime.repeating!(from: from, until: until)

    stream2 =
      "every other wednesday at midnight"
      |> HumanTime.repeating!(from: from, until: until)
      |> Stream.take(3)

    # We've run some of the 2nd stream, lets ensure 1 is still good
    stream1
    |> Stream.take(2)

    results1 =
      stream1
      |> Enum.to_list()

    results2 =
      stream2
      |> Enum.to_list()

    expected1 = [
      Timex.to_datetime({{2013, 12, 10}, {0, 0, 0}}, "Europe/London"),
      Timex.to_datetime({{2013, 12, 24}, {0, 0, 0}}, "Europe/London")
    ]

    expected2 = [
      Timex.to_datetime({{2013, 12, 4}, {0, 0, 0}}, "Europe/London"),
      Timex.to_datetime({{2013, 12, 18}, {0, 0, 0}}, "Europe/London"),
      Timex.to_datetime({{2014, 1, 1}, {0, 0, 0}}, "Europe/London")
    ]

    # Test first stream
    for {expected_item, result_item} <- Enum.zip([expected1, results1]) do
      assert expected_item == result_item,
        message: "Error with: first stream, expected #{expected_item}, got #{result_item}"
    end

    # Test second stream
    for {expected_item, result_item} <- Enum.zip([expected2, results2]) do
      assert expected_item == result_item,
        message: "Error with: first stream, expected #{expected_item}, got #{result_item}"
    end
  end

  test "compile regexs" do
    values = [
      {
        "(basic regex)",
        "basic regex string",
        "no match"
      },
      {
        "(#SELECTOR_NAMES#)",
        "first",
        "midday"
      }
    ]

    for {pattern, has_match, no_match} <- values do
      regex = HumanTime.Common.Consts.create_pattern(pattern)

      assert Regex.run(regex, has_match) != nil
      assert Regex.run(regex, no_match) == nil
    end
  end

  test "doesn't cause exception" do
    # Previously some strings have been found to cause exceptions, they should
    # instead reaturn an ok or error result
    inputs = [
      "arsdtarst",
      "in ten hours"
    ]

    from = Timex.to_datetime({{2013, 12, 4}, {06, 20, 5}}, "Europe/London")

    for input_string <- inputs do
      case HumanTime.repeating(input_string, from: from) do
        {:ok, _} -> :ok
        {:error, _msg} -> :ok
      end
    end
  end
end
