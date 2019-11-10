defmodule HubDB.Profile do
  use Ecto.Schema

  import Ecto.Changeset

  alias HubDB.User

  schema "profiles" do
    field :name, :string
    field :cohort, :string
    field :tags, {:array, :string}
    field :bio, :string
    belongs_to :user, User, type: :string

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :cohort, :tags, :bio, :user_id])
    |> validate_required([:name, :cohort, :tags, :bio, :user_id])
    |> assoc_constraint(:user)
  end
end
