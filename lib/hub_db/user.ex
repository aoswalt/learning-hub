defmodule HubDB.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias HubDB.{Answer, Profile, Question}

  @primary_key {:id, :string, autogenerate: {Nanoid, :generate, []}}
  schema "users" do
    has_many :questions, Question, foreign_key: :created_by
    has_many :answers, Answer, foreign_key: :created_by
    has_one :profile, Profile

    timestamps()
  end
end