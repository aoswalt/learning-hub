defmodule Hub do
  @moduledoc """
  Hub keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import Ecto.Query, warn: false

  alias HubDB.Repo
  alias HubDB.{Question, Answer, Profile}

  # questions

  def list_questions(options \\ []) do
    tags = Keyword.get(options, :tags)

    query = if tags, do: Question.where_has_tags(tags), else: Question

    Repo.all(query)
  end

  def get_question!(id), do: Repo.get!(Question, id)

  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  def change_question(%Question{} = question) do
    Question.changeset(question, %{})
  end

  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  # answers

  def list_answers do
    Repo.all(Answer)
  end

  def list_answers_for_question(question_id) do
    Answer
    |> where([a], a.question_id == ^question_id)
    |> Repo.all()
  end

  def get_answer!(id), do: Repo.get!(Answer, id)

  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  # profiles

  def list_profiles do
    Repo.all(Profile)
  end

  def get_profile!(id) do
    Repo.get!(Profile, id)
  end

  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end
end
