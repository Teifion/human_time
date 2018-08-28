defmodule HumanTime.Relative.Matchers do
  @moduledoc false
  
  alias HumanTime.Common.Consts
  alias HumanTime.Relative.Mappers
  
  # Each matcher consists of a tuple of:
  # A matcher, if this matches we will test for the blocker
  # A block, if this also matches we will skip this match, this allows us to have similar but different matchers which don't overlap. If nil there is no block.
  # A function to create the datetime based on the timestring and options
  @matchers [
    {
      # Xd, Xdays
      # 5d, 5days
      Consts.create_pattern("(?P<amount>#AMOUNT#) ?(m|min|minute|mins|minutes)$"),
      nil,
      &Mappers.x_minutes/2
    },
    {
      # Xd, Xdays
      # 5d, 5days
      Consts.create_pattern("(?P<amount>#AMOUNT#) ?(h|hour|hours)$"),
      nil,
      &Mappers.x_hours/2
    },
    {
      # Xd, Xdays
      # 5d, 5days
      Consts.create_pattern("(?P<amount>#AMOUNT#) ?(d|day|days)$"),
      nil,
      &Mappers.x_days/2
    },
    
    {
      Consts.create_pattern("(?P<date>#DATE#)"),
      Consts.create_pattern("(?P<date>#DATE#) at"),
      &Mappers.date/2
    },
    {
      Consts.create_pattern("(?P<date>#DATE#) at (?P<time>#TIME_ALL#)"),
      nil,
      &Mappers.date_and_time/2
    }
  ]
  
  @spec get_matchers() :: list
  def get_matchers(), do: @matchers
end