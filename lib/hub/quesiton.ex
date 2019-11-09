defmodule Hub.Question do
  import Norm

  defstruct id: nil,
            tags: [],
            text: nil,
            timestamp: nil

  # author

  def s(),
    do:
      schema(%__MODULE__{
        id: spec(is_binary()),
        text: spec(is_binary()),
        tags:
          with_gen(
            spec(is_list() and fn tags -> Enum.all?(tags, &is_binary/1) end),
            StreamData.list_of(gen(spec(is_binary())))
          ),
        timestamp:
          with_gen(
            spec(&match?(%NaiveDateTime{}, &1)),
            HubDB.Spec.Generators.naive_datetime()
          )
      })

  def new(text, tags \\ []) do
    struct!(__MODULE__,
      id: Nanoid.generate(),
      text: text,
      tags: tags,
      timestamp: DateTime.utc_now()
    )
  end
end
