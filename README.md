# HumanTime
Adapted from my [human_time library for Python](https://github.com/Teifion/human_time_py) but for Elixir.

The purpose of this library is to take written date/time such as "every other tuesday", "every weekday", "every friday at 2pm" etc, and convert it into a sequence of datetimes fitting the string.

## Usage
Human time has only a single function, `parse`. It only requires a string detailing a sequence of date or datetimes.

```elixir
  HumanTime.parse("Every wednesday at 1530")
  |> Stream.take(3)
  |> Enum.to_list
  
  > [
      #DateTime<2018-08-15 15:30:00.848218Z>,
      #DateTime<2018-08-22 15:30:00.848218Z>,
      #DateTime<2018-08-29 15:30:00.848218Z>
    ]
```

If a time is not part of the string, datetimes will be outputted as the current time. To get around this I suggest using "at midnight" to set them to 00:00.

### Options
from: Dictates the date the sequence will begin from (defaults to starting from now)
until: Dictates the date the sequence will end at (defaults to never finish)
generator: The step function the sequence will use (defaults to days)

## Installation
**Currently not in Hex**

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `human_time` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:human_time, "~> 0.1.0"}
  ]
end
```

## TODO
 - Handle state in the filter and mappers (to allow for things like "every other")
 - Optimise the function calls, some of the filters will iterate through every day in a month for every day in a month
 - Enable other generators with strings such as "every other second"

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/human_time](https://hexdocs.pm/human_time).

