defmodule HubWeb.QuestionController do
  use HubWeb, :controller

  import Norm

  alias HubDB.Question

  action_fallback HubWeb.FallbackController

  def resource_s(type \\ nil) do
    s =
      schema(%{
        "id" => spec(is_integer() and (&(&1 > 0))),
        "text" =>
          with_gen(
            spec(is_binary() and fn str -> String.length(str) > 0 end),
            StreamData.string(:printable, min_length: 1)
          ),
        "tags" =>
          with_gen(
            spec(is_list() and fn tags -> Enum.all?(tags, &is_binary/1) end),
            StreamData.list_of(StreamData.string(:printable, min_length: 1))
          ),
        "createdBy" =>
          with_gen(
            spec(is_binary() and fn str -> String.length(str) > 0 end),
            StreamData.string(:printable, min_length: 1)
          )
      })

    case type do
      :create -> selection(s, ["text", "tags", "createdBy"])
      :update -> selection(s, ["text", "tags"])
      _ -> s
    end
  end

  def index(conn, params) do
    tags = Map.get(params, "tags")

    questions = Hub.list_questions(tags: tags)

    render(conn, "index.json", questions: questions)
  end

  def create(conn, question_params) do
    with {:ok, %Question{} = question} <- Hub.create_question(question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.question_path(conn, :show, question))
      |> render("show.json", question: question)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Hub.get_question!(id)
    render(conn, "show.json", question: question)
  end

  def update(conn, %{"id" => id} = question_params) do
    question = Hub.get_question!(id)

    with {:ok, %Question{} = question} <- Hub.update_question(question, question_params) do
      render(conn, "show.json", question: question)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Hub.get_question!(id)

    with {:ok, %Question{}} <- Hub.delete_question(question) do
      send_resp(conn, :no_content, "")
    end
  end
end
