defmodule HumanTime.Matchers do
  alias HumanTime.Consts
  alias HumanTime.Filters
  alias HumanTime.Mappers
  
  @matchers [
    # {
    #   Consts.create_pattern("other (#ALL_DAY_NAMES#)"),
    #   # [&Filters._filter_everyother, &Filters._filter_weekday]
    #   []
    # },
    {
      # X1 Y1 after X2 Y2 of month
      # first monday after second sunday of month
      Consts.create_pattern("(?P<selector1>#SELECTOR_NAMES#) (?P<principle1>#DAY_NAMES#) after (?P<selector2>#SELECTOR_NAMES#) (?P<principle2>#DAY_NAMES#) of month"),
      [&Filters.identifier_in_month_after/1],
      []
    },
    {
      # X Y of month
      # e.g. first monday of month
      Consts.create_pattern("(?P<after_catch>after )?(?P<selector>#SELECTOR_NAMES#) (?P<principle>#DAY_NAMES#) of month"),
      [&Filters.identifier_in_month/1],
      []
    },
    {
      # X of month
      # e.g. 2nd of month
      Consts.create_pattern("(?P<selector>[0-9]{1,2})(?:st|nd|rd|th)? of (?P<principle>month)"),
      [&Filters.day_number_in_month/1],
      []
    },
    {
      # end of month
      Consts.create_pattern("end of month"),
      [&Filters.end_of_month/1],
      []
    },
    {
      # Day name
      # e.g. Every Tuesday
      Consts.create_pattern("(?P<principle>(#ALL_DAY_NAMES#))"),
      [&Filters.weekday/1],
      [],
    },
    
    
    {
      # Set time
      Consts.create_pattern("at (?P<applicant>#TIME_ALL#)"),
      [],
      [&Mappers.apply_time/1],
    },
    # {
    #   # Cut time component
    #   Consts.create_pattern("^((?!at (?P<applicant>#TIME_ALL#))).*$"),
    #   [],
    #   [&Mappers.cut_time/1],
    # },
    
      # (
  #   (
  #     r"at (?P<applicant>%(TIME_ALL)s)" % vars(TimePattern),
  #     [&Filters._apply_time]
  #   ),
  #   (
  #       r"^((?!at (?P<applicant>%(TIME_ALL)s)).)*$" % vars(TimePattern),
  #       [&Filters._cut_time]
  #   )
  ]
  
  def get_matchers(), do: @matchers
end