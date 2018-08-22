# HumanTime
[![Coverage Status](https://coveralls.io/repos/github/Teifion/human_time/badge.svg?branch=master)](https://coveralls.io/github/Teifion/human_time?branch=master)

Adapted from my [human_time library for Python](https://github.com/Teifion/human_time_py) but for Elixir. Human Time is a function to convert a string such as "every other tuesday", "every weekday" or "every friday at 2pm" and convert it into a sequence of date times as allowed by the string.

This is my first attempt at putting a package onto hex so please feel free to give input on what should be changed but also be mindful I'm unlikely to have experience doing everything suggested.

## Usage
Human Time can parse both repeating intervals (e.g. "every other day") and also one off relative times (e.g. "next tuesday at 3pm").

```elixir
  HumanTime.repeating("Every wednesday at 1530")
  |> Stream.take(3)
  |> Enum.to_list
  
  > [
      #DateTime<2018-08-15 15:30:00.848218Z>,
      #DateTime<2018-08-22 15:30:00.848218Z>,
      #DateTime<2018-08-29 15:30:00.848218Z>
    ]
```

If a time is not part of the string, datetimes will be outputted as being at midnight. You can set a time such as "at 1500" or "at noon" but you can also say "at the current time" or "at this time" and it will take the time of parsing and repeat that.

### Options
from: Dictates the date the sequence will begin from (defaults to starting from now)
until: Dictates the date the sequence will end at (defaults to never finish)

## Installation
To add Human Time to your project, you only need to add it as a dependency and start it as an application in your mix.exs file.

```elixir
def deps do
  [
    {:human_time, "~> 0.1.0"}
  ]
end

defp application do
  [applications: [:human_time]]
end
```

## Roadmap / TODO
 - Handle one off times such as "next friday at 2pm"
 - Allow for combining strings with "and", e.g. "every friday and every other thursday"
 - Allow for exceptsions with "except", e.g. "every weekday except fridays"
 - Add blocker match in, if a matcher matches on a block it won't trigger, currently using a workaround for some of them
 - Better handle state in the filter and mappers (to allow for things like "every other")
 - Optimise the function calls, some of the filters will iterate through every day in a month for every day in a month
 - Add time jumps such as "25th minute of every other hour"
 - Enable other generators with strings such as "every other second"


## License

This software is licensed under [the MIT license](LICENSE.md).