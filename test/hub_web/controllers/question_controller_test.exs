defmodule HubWeb.QuestionControllerTest do
  use HubWeb.ConnCase, async: true

  alias HubDB.Question
  alias HubWeb.Helpers.Question, as: QuestionHelpers

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, Routes.question_path(conn, :index))
      assert [] = json_response(conn, 200)

      create_question()

      conn = get(conn, Routes.question_path(conn, :index))
      assert [_] = json_response(conn, 200)
    end
  end

  describe "create question" do
    test "renders question when data is valid", %{conn: conn} do
      conn = post(conn, Routes.question_path(conn, :create), QuestionHelpers.gen_params(:create))
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.question_path(conn, :show, id))
      response = json_response(conn, 200)

      assert Norm.conform!(response, HubWeb.QuestionController.resource_s())
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.question_path(conn, :create), QuestionHelpers.invalid_params(:create))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update question" do
    setup [:create_question]

    test "renders question when data is valid", %{
      conn: conn,
      question: %Question{id: id} = question
    } do
      update_params = QuestionHelpers.gen_params(:update)

      conn = put(conn, Routes.question_path(conn, :update, question), update_params)
      assert %{"id" => ^id} = json_response(conn, 200)

      response =
        conn
        |> get(Routes.question_path(conn, :show, id))
        |> json_response(200)

      assert Norm.conform!(response, HubWeb.QuestionController.resource_s())

      assert %{"id" => ^id} = response
      assert update_params = response
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = put(conn, Routes.question_path(conn, :update, question), QuestionHelpers.invalid_params(:update))
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

  defp create_question(_ \\ nil) do
    {:ok, question: QuestionHelpers.create()}
  end
end
