defmodule HubWeb.QuestionControllerTest do
  use HubWeb.ConnCase

  alias Hub.Question

  @create_attrs %{
    tags: [],
    text: "some text",
    created_by: "that guy"
  }
  @update_attrs %{
    tags: [],
    text: "some updated text"
  }
  @invalid_attrs %{tags: nil, text: nil}

  def fixture(:question) do
    {:ok, question} = Hub.create_question(@create_attrs)
    question
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, Routes.question_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create question" do
    test "renders question when data is valid", %{conn: conn} do
      conn = post(conn, Routes.question_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.question_path(conn, :show, id))

      assert %{
               "id" => id,
               "tags" => [],
               "text" => "some text"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.question_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update question" do
    setup [:create_question]

    test "renders question when data is valid", %{conn: conn, question: %Question{id: id} = question} do
      conn = put(conn, Routes.question_path(conn, :update, question), @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.question_path(conn, :show, id))

      assert %{
               "id" => id,
               "tags" => [],
               "text" => "some updated text"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = put(conn, Routes.question_path(conn, :update, question), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete question" do
    setup [:create_question]

    test "deletes chosen question", %{conn: conn, question: question} do
      conn = delete(conn, Routes.question_path(conn, :delete, question))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.question_path(conn, :show, question))
      end
    end
  end

  defp create_question(_) do
    question = fixture(:question)
    {:ok, question: question}
  end
end
