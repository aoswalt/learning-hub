defmodule HubWeb.QuestionController do
  use HubWeb, :controller

  alias Hub.QA
  alias Hub.QA.Question

  action_fallback HubWeb.FallbackController

  def index(conn, params) do
    tags = Map.get(params, "tags")

    questions = QA.list_questions(tags: tags)

    render(conn, "index.json", questions: questions)
  end

  def create(conn, question_params) do
    with {:ok, %Question{} = question} <- QA.create_question(question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.question_path(conn, :show, question))
      |> render("show.json", question: question)
    end
  end

  def show(conn, %{"id" => id}) do
    question = QA.get_question!(id)
    render(conn, "show.json", question: question)
  end

  def update(conn, %{"id" => id} = question_params) do
    question = QA.get_question!(id)

    with {:ok, %Question{} = question} <- QA.update_question(question, question_params) do
      render(conn, "show.json", question: question)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = QA.get_question!(id)

    with {:ok, %Question{}} <- QA.delete_question(question) do
      send_resp(conn, :no_content, "")
    end
  end
end
