defmodule Hub.Spec.Generators do
  import StreamData

  @time_zones ["Etc/UTC"]

  def date() do
    tuple({integer(1970..2050), integer(1..12), integer(1..31)})
    |> bind_filter(fn tuple ->
      case Date.from_erl(tuple) do
        {:ok, date} -> {:cont, constant(date)}
        _ -> :skip
      end
    end)
  end

  def date_string() do
    date() |> map(&Date.to_string/1)
  end

  def time() do
    tuple({integer(0..23), integer(0..59), integer(0..59)})
    |> map(&Time.from_erl!/1)
  end

  def time_string() do
    date() |> map(&Time.to_string/1)
  end

  def naive_datetime() do
    tuple({date(), time()})
    |> map(fn {date, time} ->
      {:ok, naive_datetime} = NaiveDateTime.new(date, time)
      naive_datetime
    end)
  end

  def naive_datetime_string() do
    date() |> map(&NaiveDateTime.to_string/1)
  end

  def datetime() do
    tuple({naive_datetime(), member_of(@time_zones)})
    |> map(fn {naive_datetime, time_zone} ->
      DateTime.from_naive!(naive_datetime, time_zone)
    end)
  end

  def datetime_string() do
    date() |> map(&DateTime.to_string/1)
  end
end
