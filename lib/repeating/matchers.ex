defmodule HumanTime.Repeating.Matchers do
  @moduledoc false

  alias HumanTime.Common.Consts
  alias HumanTime.Repeating.Filters
  alias HumanTime.Repeating.Mappers
  alias HumanTime.Repeating.Generators

  # Each matcher consists of a tuple of:
  # The name, used for debugging
  # A matcher, if this matches we will test for the blocker
  # A block, if this also matches we will skip this match, this allows us to have similar but different matchers which don't overlap. If nil there is no block.
  # The generator function
  # A list of filter functions to narrow down the dates, can be an empty list
  # A mapper function, alters the date (generally to add a time) after being filtered. If nil no change is applied.
  @matchers [
    {
      # N X, where N is a number and X is a unit of time
      # 5 seconds
      "Repeating amount of seconds",
      Consts.create_pattern("(?P<repeat_amount>#AMOUNT#) ?(s|sec|second|secs|seconds)$"),
      nil,
      {&Generators.by_known_type/1, "seconds"},
      [],
      [&Mappers.every_x/1]
    },{
      # N X, where N is a number and X is a unit of time
      # 5 minutes
      "Repeating amount of minutes",
      Consts.create_pattern("(?P<repeat_amount>#AMOUNT#) ?(m|min|minute|mins|minutes)$"),
      nil,
      {&Generators.by_known_type/1, "minutes"},
      [],
      [&Mappers.every_x/1]
    },{
      # N X, where N is a number and X is a unit of time
      # 5 hours
      "Repeating amount of hours",
      Consts.create_pattern("(?P<repeat_amount>#AMOUNT#) ?(h|hour|hours)$"),
      nil,
      {&Generators.by_known_type/1, "hours"},
      [],
      [&Mappers.every_x/1]
    },{
      # N X, where N is a number and X is a unit of time
      # 5 days
      "Repeating amount of days",
      Consts.create_pattern("(?P<repeat_amount>#AMOUNT#) ?(d|day|days)$"),
      nil,
      {&Generators.by_known_type/1, "days"},
      [],
      [&Mappers.every_x/1]
    },{
      # N X, where N is a number and X is a unit of time
      # 5 weeks
      "Repeating amount of weeks",
      Consts.create_pattern("(?P<repeat_amount>#AMOUNT#) ?(w|week|weeks)$"),
      nil,
      {&Generators.by_known_type/1, "weeks"},
      [],
      [&Mappers.every_x/1]
    },{
      # N X, where N is a number and X is a unit of time
      # 5 months
      "Repeating amount of months",
      Consts.create_pattern("(?P<repeat_amount>#AMOUNT#) months?"),
      nil,
      {&Generators.by_known_type/1, "months"},
      [],
      [&Mappers.every_x/1]
    },{
      # N X, where N is a number and X is a unit of time
      # 5 years
      "Repeating amount of years",
      Consts.create_pattern("(?P<repeat_amount>#AMOUNT#) years?"),
      nil,
      {&Generators.by_known_type/1, "years"},
      [],
      [&Mappers.every_x/1]
    },{
      # X1 Y1 after X2 Y2 of month
      # first monday after second sunday of month
      "X1 Y1 after X2 Y2 of month",
      Consts.create_pattern("(?P<selector1>#SELECTOR_NAMES#) (?P<principle1>#DAY_NAMES#) after (?P<selector2>#SELECTOR_NAMES#) (?P<principle2>#DAY_NAMES#) of (?P<ITERATOR>#ITERATORS#) month"),
      nil,
      {&Generators.by_known_type/1, "days"},
      [&Filters.identifier_in_month_after/1],
      []
    },
    {
      # X Y of month
      # e.g. first monday of month
      "X Y of month",
      Consts.create_pattern("(?P<after_catch>after )?(?P<selector>#SELECTOR_NAMES#) (?P<principle>#DAY_NAMES#) of (?P<ITERATOR>#ITERATORS#) month"),
      Consts.create_pattern("(?P<after_catch>after) (?P<selector>#SELECTOR_NAMES#)"),
      {&Generators.by_known_type/1, "days"},
      [&Filters.identifier_in_month/1],
      []
    },
    {
      # X of month
      # e.g. 2nd of month
      "X of month",
      Consts.create_pattern("(?P<selector>[0-9]{1,2})(?:st|nd|rd|th)? of (?P<ITERATOR>#ITERATORS#) (?P<principle>month)"),
      nil,
      {&Generators.by_known_type/1, "days"},
      [&Filters.day_number_in_month/1],
      []
    },
    {
      # end of month
      "end of month",
      Consts.create_pattern("end of (?P<ITERATOR>#ITERATORS#) month"),
      nil,
      {&Generators.by_known_type/1, "days"},
      [&Filters.end_of_month/1],
      []
    },
    {
      # Day name
      # e.g. Every Tuesday
      "day name",
      Consts.create_pattern("(?P<ITERATOR>#ITERATORS#) (?P<principle>(#ALL_DAY_NAMES#))"),
      nil,
      {&Generators.by_known_type/1, "days"},
      [&Filters.weekday/1],
      [],
    },
    
    
    # Adding a time component
    {
      "at time",
      Consts.create_pattern("at (?P<applicant>#TIME_ALL#)"),
      nil,
      {&Generators.by_known_type/1, "days"},
      [],
      [&Mappers.apply_time/1],
    },
    
    # No time component
    # {
    #   Consts.create_pattern("^(.+)(?<!at) (#TIME_ALL#)$") |> IO.inspect,
    #   [],
    #   [&Mappers.remove_time/1],
    # },
    
    # Every other, this needs to be at the end of the list or it may 
    {
      "every skip component",
      Consts.create_pattern("every (?P<skip>#SKIPS#)?( )?(?P<generator_component>#NAMED_TERMS#)"),
      nil,
      &Generators.by_match_type/1,
      [],
      [&Mappers.every_skip/1]
    },
    
    # Temporarily disabled as every skip component might work better
    # Every other, this needs to be at the end of the list or it may interfere
    # {
    #   "every skip",
    #   Consts.create_pattern("every (?P<skip>#SKIPS#)"),
    #   nil,
    #   nil,
    #   [],
    #   [&Mappers.every_skip/1]
    # },
  ]

  @spec get_matchers() :: list
  def get_matchers(), do: @matchers
end