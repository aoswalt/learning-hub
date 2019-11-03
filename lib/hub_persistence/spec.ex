defmodule HubPersistence.Spec.Generators do
  import StreamData

  @time_zones ["Etc/UTC"]

  def date(to_string? \\ false) do
    tuple({integer(1970..2050), integer(1..12), integer(1..31)})
    |> bind_filter(fn tuple ->
      case Date.from_erl(tuple) do
        {:ok, date} -> {:cont, constant(date)}
        _ -> :skip
      end
    end)
    |> map(fn date ->
      if to_string? do
        Date.to_string(date)
      else
        date
      end
    end)
  end

  def time(to_string? \\ false) do
    tuple({integer(0..23), integer(0..59), integer(0..59)})
    |> map(&Time.from_erl!/1)
    |> map(fn date ->
      if to_string? do
        Time.to_string(date)
      else
        date
      end
    end)
  end

  def naive_datetime(to_string? \\ false) do
    tuple({date(), time()})
    |> map(fn {date, time} ->
      {:ok, naive_datetime} = NaiveDateTime.new(date, time)
      naive_datetime
    end)
    |> map(fn date ->
      if to_string? do
        NaiveDateTime.to_string(date)
      else
        date
      end
    end)
  end

  def datetime(to_string? \\ false) do
    tuple({naive_datetime(), member_of(@time_zones)})
    |> map(fn {naive_datetime, time_zone} ->
      DateTime.from_naive!(naive_datetime, time_zone)
    end)
    |> map(fn date ->
      if to_string? do
        DateTime.to_string(date)
      else
        date
      end
    end)
  end
end
