defmodule Hub.Answer do
  import Norm

  defstruct [:id, :text, :timestamp]

  def s(),
    do:
      schema(%__MODULE__{
        id: spec(is_binary()),
        text: spec(is_binary()),
        timestamp:
          with_gen(
            spec(&match?(%NaiveDateTime{}, &1)),
            HubPersistence.Spec.Generators.naive_datetime()
          )
      })

  def new(text) do
    struct!(__MODULE__, id: Nanoid.generate(), text: text, timestamp: DateTime.utc_now())
  end
end
