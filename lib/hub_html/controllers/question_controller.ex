defmodule HubHTML.QuestionController do
  use HubHTML, :controller

  import Ecto.Query

  alias HubDB.Question
  alias HubDB.Repo

  def index(conn, _params) do
    questions = Repo.all(Question)

    render(conn, "index.html", questions: questions)
  end

  def show(conn, %{"id" => id}) do
    question = Question |> preload([:answers, :solution]) |> Repo.get!(id)

    remaining_answers = List.delete(question.answers, question.solution)

    render(conn, "show.html", question: question, remaining_answers: remaining_answers)
  end
end
