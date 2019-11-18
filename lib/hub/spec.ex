defmodule Hub.Spec do
  import Norm

  alias Hub.Spec.Generators

  def positive_integer() do
    spec(is_integer() and (&(&1 > 0)))
  end

  def nonempty_string() do
    with_gen(
      spec(is_binary() and fn str -> String.length(str) > 0 end),
      StreamData.string(:printable, min_length: 1)
    )
  end

  def naive_datetime() do
    with_gen(
      spec(&match?(%NaiveDateTime{}, &1)),
      Generators.naive_datetime()
    )
  end

  def naive_datetime_string() do
    with_gen(
      spec(&match?({:ok, %NaiveDateTime{}}, NaiveDateTime.from_iso8601(&1))),
      Generators.naive_datetime_string()
    )
  end
end
