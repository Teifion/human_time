defmodule HumanTime.Relative.Matchers do
  @moduledoc false
  
  alias HumanTime.Common.Consts
  alias HumanTime.Relative.Mappers
  
  # Each matcher consists of a tuple of:
  # A matcher, if this matches we will test for the blocker
  # A block, if this also matches we will skip this match, this allows us to have similar but different matchers which don't overlap. If nil there is no block.
  # A function to create the datetime based on the timestring and options
  @matchers [
    # Relative amount shorthand
    {
      # Xm, Xminutes
      Consts.create_pattern("(?P<amount>#AMOUNT#) ?(m|min|minute|mins|minutes)$"),
      nil,
      &Mappers.x_minutes/2
    },
    {
      # Xh, Xhours
      Consts.create_pattern("(?P<amount>#AMOUNT#) ?(h|hour|hours)$"),
      nil,
      &Mappers.x_hours/2
    },
    {
      # Xd, Xdays
      Consts.create_pattern("(?P<amount>#AMOUNT#) ?(d|day|days)$"),
      nil,
      &Mappers.x_days/2
    },
    {
      # Xw, Xweeks
      Consts.create_pattern("(?P<amount>#AMOUNT#) ?(w|week|weeks)$"),
      nil,
      &Mappers.x_weeks/2
    },
    
    # Date parsing
    {
      Consts.create_pattern("(?P<date>#DATE#)((?: at)? (?P<time>#TIME_ALL#))?"),
      nil,
      &Mappers.set_value/2
    },
    
    # Relative names - e.g. yesterday
    {
      Consts.create_pattern("(?P<day_name>#RELATIVE_NAME#)( at (?P<time>#TIME_ALL#))?"),
      nil,
      &Mappers.relative_by_name/2
    },
    
    # Relative date - next wednesday
    {
      Consts.create_pattern("(?P<adjuster>#RELATIVE_ADJUSTER# )?(?P<day_name>#ALL_DAY_NAMES#)( at (?P<time>#TIME_ALL#))?"),
      nil,
      &Mappers.relative_by_date/2
    },
  ]
  
  @spec get_matchers() :: list
  def get_matchers(), do: @matchers
end