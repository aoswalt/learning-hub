defmodule HubWeb.AnswerController do
  use HubWeb, :controller

  import Norm

  alias HubPersistence.Answer

  action_fallback HubWeb.FallbackController

  def resource_s(type \\ nil) do
    s =
      schema(%{
        "id" => spec(is_integer() and (&(&1 > 0))),
        "questionId" => spec(is_integer() and (&(&1 > 0))),
        "text" =>
          with_gen(
            spec(is_binary() and fn str -> String.length(str) > 0 end),
            StreamData.string(:printable, min_length: 1)
          ),
        "createdBy" =>
          with_gen(
            spec(is_binary() and fn str -> String.length(str) > 0 end),
            StreamData.string(:printable, min_length: 1)
          ),
        "createdAt" =>
          with_gen(
            spec(&match?({:ok, %NaiveDateTime{}}, NaiveDateTime.from_iso8601(&1))),
            HubPersistence.Spec.Generators.naive_datetime(true)
          )
      })

    case type do
      :create -> selection(s, ["text", "questionId", "createdBy"])
      :update -> selection(s, ["text"])
      _ -> s
    end
  end

  def index(conn, params) do
    question_id = Map.get(params, "question_id")

    answers =
      if question_id do
        Hub.list_answers_for_question(question_id)
      else
        Hub.list_answers()
      end

    render(conn, "index.json", answers: answers)
  end

  def create(conn, answer_params) do
    with {:ok, %Answer{} = answer} <- Hub.create_answer(answer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.answer_path(conn, :show, answer))
      |> render("show.json", answer: answer)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = Hub.get_answer!(id)
    render(conn, "show.json", answer: answer)
  end

  def update(conn, %{"id" => id} = answer_params) do
    answer = Hub.get_answer!(id)

    with {:ok, %Answer{} = answer} <- Hub.update_answer(answer, answer_params) do
      render(conn, "show.json", answer: answer)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Hub.get_answer!(id)

    with {:ok, %Answer{}} <- Hub.delete_answer(answer) do
      send_resp(conn, :no_content, "")
    end
  end
end
