defmodule HumanTime do
  @moduledoc """
  Human Time is a function to convert a string such as "every other tuesday", "every weekday" or "next friday at 2pm" and convert it into a one or a sequence of date times as allowed by the string.
  """

  alias HumanTime.Repeating
  alias HumanTime.Relative

  @doc """
  Generates a stream of datetimes for the string given.
  
  ## Options
  `from` The datetime from when the sequence will be generated, defaults to the current time.
  
  `until` The datetime when the sequence will be terminated, defaults to nil. When nil the sequence will never be terminated.
  
  ## Example
      HumanTime.repeating("Every wednesday at 1530")
      |> Stream.take(3)
      |> Enum.to_list
      
      #=> [
      #=>   #DateTime<2018-08-15 15:30:00.848218Z>,
      #=>   #DateTime<2018-08-22 15:30:00.848218Z>,
      #=>   #DateTime<2018-08-29 15:30:00.848218Z>
      #=> ]
  """
  @spec repeating(String.t(), [term]) :: {:ok, Enumerable.t} | {:error, String.t}
  def repeating(timestring, opts \\ []) do
    from = opts[:from] || Timex.now()
    until = opts[:until]
    
    while_function = Repeating.Generators.while_function(until)
    result = Repeating.Parser.build_functions(timestring)
    
    case result do
      {:error, msg} -> {:error, msg}
      {:ok, {generator_function, filter_function, mapper_function}} ->
        {:ok, from
        |> Stream.iterate(generator_function)
        |> Stream.take_while(while_function)
        |> Stream.filter(filter_function)
        |> Stream.map(mapper_function)
        |> Stream.filter(&(&1 != nil))}
    end
  end

  @doc """
  Repeats the time string and raises an exception in case of errors
  """
  @spec repeating!(String.t(), [term]) :: Enumerable.t
  def repeating!(timestring, opts \\ []) do
    case repeating(timestring, opts) do
      {:ok, enumerable} -> enumerable
      {:error, msg} -> raise msg
    end
  end

  @doc """
  Generates a single datetime for the string given.

  ## Options
  `from` The datetime from when the sequence will be generated, defaults to the current time.

  ## Example
      HumanTime.relative("Next wednesday at 1530")
      
      #=> {:ok, #DateTime<2018-08-15 15:30:00.848218Z>}
  """
  @spec relative(String.t(), [term]) :: {:ok, DateTime.t} | {:error, String.t}
  def relative(timestring, opts \\ []) do
    from = opts[:from] || Timex.now()
    
    Relative.Parser.parse(timestring, from)
  end

  @doc """
  Creates the time string and raises an exception in case of errors
  """
  @spec relative!(String.t(), [term]) :: DateTime.t
  def relative!(timestring, opts \\ []) do
    case relative(timestring, opts) do
      {:ok, the_datetime} -> the_datetime
      {:error, msg} -> raise msg
    end
  end
  
end
