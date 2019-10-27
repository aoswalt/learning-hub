defmodule Hub.QA.Profile do
  use Ecto.Schema

  import Ecto.Changeset


  schema "profiles" do
    field :name, :string
    field :cohort, :string
    field :tags, {:array, :string}
    field :bio, :string
    field :userId, :string

    timestamps()
  end

    @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :cohort, :tags, :bio, :userId])
    |> validate_required([:name, :cohort, :tags, :bio, :userId])
  end

end
