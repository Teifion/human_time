defmodule HumanTime.Repeating.Matchers do
  @moduledoc false
  
  alias HumanTime.Common.Consts
  alias HumanTime.Repeating.Filters
  alias HumanTime.Repeating.Mappers
  alias HumanTime.Repeating.Generators
  
  # Each matcher consists of a tuple of:
  # A matcher, if this matches we will test for the blocker
  # A block, if this also matches we will skip this match, this allows us to have similar but different matchers which don't overlap. If nil there is no block.
  # A list of filter functions to narrow down the dates, can be an empty list
  # A mapper function, alters the date (generally to add a time) after being filtered. If nil no change is applied.
  @matchers [
    {
      # X1 Y1 after X2 Y2 of month
      # first monday after second sunday of month
      Consts.create_pattern("(?P<selector1>#SELECTOR_NAMES#) (?P<principle1>#DAY_NAMES#) after (?P<selector2>#SELECTOR_NAMES#) (?P<principle2>#DAY_NAMES#) of (?P<ITERATOR>#ITERATORS#) month"),
      nil,
      &Generators.days/1,
      [&Filters.identifier_in_month_after/1],
      []
    },
    {
      # X Y of month
      # e.g. first monday of month
      Consts.create_pattern("(?P<after_catch>after )?(?P<selector>#SELECTOR_NAMES#) (?P<principle>#DAY_NAMES#) of (?P<ITERATOR>#ITERATORS#) month"),
      Consts.create_pattern("(?P<after_catch>after) (?P<selector>#SELECTOR_NAMES#)"),
      &Generators.days/1,
      [&Filters.identifier_in_month/1],
      []
    },
    {
      # X of month
      # e.g. 2nd of month
      Consts.create_pattern("(?P<selector>[0-9]{1,2})(?:st|nd|rd|th)? of (?P<ITERATOR>#ITERATORS#) (?P<principle>month)"),
      nil,
      &Generators.days/1,
      [&Filters.day_number_in_month/1],
      []
    },
    {
      # end of month
      Consts.create_pattern("end of (?P<ITERATOR>#ITERATORS#) month"),
      nil,
      &Generators.days/1,
      [&Filters.end_of_month/1],
      []
    },
    {
      # Day name
      # e.g. Every Tuesday
      Consts.create_pattern("(?P<ITERATOR>#ITERATORS#) (?P<principle>(#ALL_DAY_NAMES#))"),
      nil,
      &Generators.days/1,
      [&Filters.weekday/1],
      [],
    },
    
    
    # Adding a time component
    {
      Consts.create_pattern("at (?P<applicant>#TIME_ALL#)"),
      nil,
      &Generators.days/1,
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
      Consts.create_pattern("other .*"),
      nil,
      nil,
      [],
      [&Mappers.every_other/1]
    },
  ]
  
  @spec get_matchers() :: list
  def get_matchers(), do: @matchers
end