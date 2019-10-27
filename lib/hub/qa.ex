defmodule Hub.QA do
  @moduledoc """
  The QA context.
  """

  import Ecto.Query, warn: false

  alias Hub.Repo
  alias Hub.QA.{Question, Answer, Profile}

  def list_questions do
    Repo.all(Question)
  end

  def list_answers do
    Repo.all(Answer)
  end

  def list_answers_for_question(question_id) do
    Answer
    |> where([a], a.question_id == ^question_id)
    |> Repo.all()
  end

  def get_question!(id), do: Repo.get!(Question, id)
  def get_answer!(id), do: Repo.get!(Answer, id)

  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  def change_question(%Question{} = question) do
    Question.changeset(question, %{})
  end

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
