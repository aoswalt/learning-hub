defmodule HubWeb.AnswerController do
  use HubWeb, :controller

  alias Hub.QA
  alias Hub.QA.Answer

  action_fallback HubWeb.FallbackController

  def index(conn, params) do
    question_id = Map.get(params, "question_id")

    answers =
      if question_id do
        QA.get_answers(question_id)
      else
        QA.list_answers()
      end

    render(conn, "index.json", answers: answers)
  end

  def create(conn, %{"answer" => answer_params}) do
    with {:ok, %Answer{} = answer} <- QA.create_answer(answer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.answer_path(conn, :show, answer))
      |> render("show.json", answer: answer)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = QA.get_answer!(id)
    render(conn, "show.json", answer: answer)
  end

  def update(conn, %{"id" => id, "answer" => answer_params}) do
    answer = QA.get_answer!(id)

    with {:ok, %Answer{} = answer} <- QA.update_answer(answer, answer_params) do
      render(conn, "show.json", answer: answer)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = QA.get_answer!(id)

    with {:ok, %Answer{}} <- QA.delete_answer(answer) do
      send_resp(conn, :no_content, "")
    end
  end
end
