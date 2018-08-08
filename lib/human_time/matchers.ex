defmodule HumanTime.Matchers do
  alias HumanTime.Consts
  alias HumanTime.Filters
  
  @matchers [
    # {
    #   Consts.create_pattern("other (#ALL_DAY_NAMES#)"),
    #   # [filters._filter_everyother, filters._filter_weekday]
    #   []
    # },
    # (
    #   # first monday after second sunday of month
    #   r"(?P<selector>%(SELECTOR_NAMES)s) (?P<principle>%(DAY_NAMES)s) after (?P<selector2>%(SELECTOR_NAMES)s) (?P<principle2>%(DAY_NAMES)s) of month" % vars(DatePattern),
    #   [filters._filter_identifier_in_month_after]
    # ),
    # (
    #   # first monday of month
    #   r"(?P<selector>%(SELECTOR_NAMES)s) (?P<principle>%(DAY_NAMES)s) of month" % vars(DatePattern),
    #   [filters._filter_identifier_in_month],
    # ),
    # (
    #   # 1st of month
    #   r"(?P<selector>[0-9]{1,2})(?:st|nd|rd|th)? of (?P<principle>month)",
    #   [filters._filter_day_number_in_month],
    # ),
    # (
    #   # end of month
    #   r"end of month",
    #   [filters._filter_end_of_month],
    # ),
    {
      # Filter by day name
      Consts.create_pattern("(?P<principle>(#ALL_DAY_NAMES#))"),
      [&Filters.weekday/1],
      [],
    },
  # ),
  # (
  #   (
  #     r"at (?P<applicant>%(TIME_ALL)s)" % vars(TimePattern),
  #     [filters._apply_time]
  #   ),
  #   (
  #       r"^((?!at (?P<applicant>%(TIME_ALL)s)).)*$" % vars(TimePattern),
  #       [filters._cut_time]
  #   )
  ]
  
  def get_matchers(), do: @matchers
end