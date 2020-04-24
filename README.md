# HumanTime
Human Time is a function to convert a string such as "every other tuesday", "every weekday" or "every friday at 2pm" and convert it into a sequence of date times as allowed by the string. Adapted from my [human_time library for Python](https://github.com/Teifion/human_time_py).

## Usage
Human Time can parse both repeating intervals (e.g. "every other day") and also one off relative times (e.g. "next tuesday at 3pm").

```elixir
  HumanTime.repeating("Every wednesday at 1530")
  |> Stream.take(3)
  |> Enum.to_list

  > [
      #DateTime<2018-08-15 15:30:00Z>,
      #DateTime<2018-08-22 15:30:00Z>,
      #DateTime<2018-08-29 15:30:00Z>
    ]

  HumanTime.relative("Next wednesday at 1530")

  > {:ok, #DateTime<2018-08-15 15:30:00.848218Z>}
```

If a time is not part of the string, datetimes will be outputted as being at midnight. You can set a time such as "at 1500" or "at noon" but you can also say "at the current time" or "at this time" and it will take the time of parsing and repeat that.

### Example formats - Repeating
every 5 seconds/minutes/hours/days/weeks/months/years
every weekday at midnight
every weekend at 1500
first monday of every month
second wednesday of every month at midnight
last Friday of every month at 9am
15th of every month at midnight
every other Sunday at this time
first monday after second sunday of every month at midnight

### Example formats - Relative
5m
15/04/2020
2020-04-15 10:15:00
next wednesday at 1500
this time next friday
week next friday at 2am


For a more complete list of examples, check out the [relative](test/relative_test.exs) and [repeating](test/repeating_test.exs) test files.

### Options
`from`: Dictates the date the sequence will begin from (defaults to starting from now)  
`until`: Dictates the date the sequence will end at (defaults to never finish)

## Installation
To add Human Time to your project, you only need to add it as a dependency and start it as an application in your mix.exs file.

```elixir
def deps do
  [
    {:human_time, "~> 0.2.3"}
  ]
end

defp application do
  [applications: [:human_time]]
end
```

## Roadmap / TODO
 - Allow for combining strings with "and", e.g. "every friday and every other thursday"
 - Allow for exceptions with "except", e.g. "every weekday except fridays"
 - Optimise the function calls, some of the filters will iterate through every day in a month for every day in a month
 - Add time jumps such as "25th minute of every other hour"
 - Enable other generators with strings such as "every other second"


## License

This software is licensed under [the MIT license](LICENSE.md).