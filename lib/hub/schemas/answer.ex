defmodule Hub.Answer do
  use Ecto.Schema

  import Ecto.Changeset

  alias Hub.Question

  schema "answers" do
    field :text, :string
    field :created_by, :string
    belongs_to :question, Question

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text, :created_by, :question_id])
    |> validate_required([:text, :created_by, :question_id])
  end
end
