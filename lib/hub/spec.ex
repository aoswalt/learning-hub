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

  def date() do
    with_gen(
      spec(&match?(%Date{}, &1)),
      Generators.date()
    )
  end

  def time() do
    with_gen(
      spec(&match?(%Time{}, &1)),
      Generators.time()
    )
  end

  def datetime() do
    with_gen(
      spec(&match?(%DateTime{}, &1)),
      Generators.datetime()
    )
  end

  def naive_datetime() do
    with_gen(
      spec(&match?(%NaiveDateTime{}, &1)),
      Generators.naive_datetime()
    )
  end

  # NOTE(adam): accpets either string or raw NaiveDateTime to account for controller serialization
  def naive_datetime_string() do
    with_gen(
      alt(
        raw: spec(&match?(%NaiveDateTime{}, &1)),
        string:
          spec(is_binary() and (&match?({:ok, %NaiveDateTime{}}, NaiveDateTime.from_iso8601(&1))))
      ),
      Generators.naive_datetime_string()
    )
  end

  def from_ecto_schema(module, set_specs \\ %{}) do
    module.__schema__(:fields)
    |> Enum.map(&{&1, module.__schema__(:type, &1)})
    |> Map.new(fn {field, type} -> {field, field_type_to_spec(type)} end)
    |> Map.merge(set_specs)
    |> Map.put(:__struct__, module)
    |> schema()
  end

  defp field_type_to_spec(type) do
    case type do
      :id -> positive_integer()
      # :binary_id -> spec(is_binary())
      :integer -> spec(is_integer())
      :float -> spec(is_float())
      # :decimal ->
      :boolean -> spec(is_boolean())
      :string -> nonempty_string()
      :binary -> spec(is_binary())
      {:array, inner_type} -> coll_of(field_type_to_spec(inner_type))
      :map -> spec(is_map())
      {:map, inner_type} -> map_of(spec(is_atom()), field_type_to_spec(inner_type))
      :date -> date()
      :time -> time()
      :time_usec -> time()
      :naive_datetime -> naive_datetime()
      :naive_datetime_usec -> naive_datetime()
      :utc_datetime -> datetime()
      :utc_datetime_usec -> datetime()
    end
  end
end
