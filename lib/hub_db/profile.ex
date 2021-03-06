defmodule HubDB.Profile do
  use Ecto.Schema

  import Ecto.Changeset

  alias HubDB.Tag
  alias HubDB.User

  schema "profiles" do
    field :name, :string
    field :cohort, :string
    field :tags, {:array, Tag}
    field :bio, :string
    belongs_to :user, User, type: :string

    timestamps()
  end

  def s(type \\ nil) do
    spec =
      Hub.Spec.from_ecto_schema(__MODULE__, %{
        tags: Norm.coll_of(Hub.Spec.tag(), min_count: 1)
      })

    case type do
      :new -> Norm.selection(spec, [:name, :cohort, :tags, :bio])
      _ -> spec
    end
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :cohort, :tags, :bio, :user_id])
    |> validate_required([:name, :cohort, :tags, :bio, :user_id])
    |> assoc_constraint(:user)
  end
end
