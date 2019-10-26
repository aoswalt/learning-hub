defmodule Hub.QA.Profile do
  use Ecto.Schema

  import Ecto.Changeset

  alias Hub.QA.Profile

  schema "profiles" do
    field :name, :string
    field :cohort, :string
    field :tags, {:array, :string}
    field :bio, :string
    field :userId, :string

  end

    @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:name, :cohort, :tags, :bio, :userId])
    |> validate_required([:name, :cohort, :tags, :bio, :userId])
  end

end
