defmodule Hub.Profile do
  use Ecto.Schema

  import Ecto.Changeset

  schema "profiles" do
    field(:name, :string)
    field(:cohort, :string)
    field(:tags, {:array, :string})
    field(:bio, :string)
    field(:user_id, :string)

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :cohort, :tags, :bio, :user_id])
    |> validate_required([:name, :cohort, :tags, :bio, :user_id])
  end
end
