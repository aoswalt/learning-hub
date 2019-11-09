defmodule HubWeb.AnswerControllerTest do
  use HubWeb.ConnCase, async: true

  alias HubDB.Answer
  alias HubWeb.Helpers.Answer, as: AnswerHelpers
  alias HubWeb.Helpers.Question, as: QuestionHelpers

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all answers", %{conn: conn} do
      conn = get(conn, Routes.answer_path(conn, :index))
      assert [] = json_response(conn, 200)

      create_answer()

      conn = get(conn, Routes.answer_path(conn, :index))
      assert [_] = json_response(conn, 200)
    end
  end

  describe "create answer" do
    setup [:create_question]

    test "renders answer when data is valid", %{conn: conn, question: %{id: question_id}} do
      conn = post(conn, Routes.answer_path(conn, :create), AnswerHelpers.gen_params(:create, question_id))
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.answer_path(conn, :show, id))
      response = json_response(conn, 200)

      assert Norm.conform!(response, HubWeb.AnswerController.resource_s())
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.answer_path(conn, :create), AnswerHelpers.invalid_params(:create))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update answer" do
    setup [:create_answer]

    test "renders answer when data is valid", %{
      conn: conn,
      answer: %Answer{id: id} = answer
    } do
      update_params = AnswerHelpers.gen_params(:update)

      conn = put(conn, Routes.answer_path(conn, :update, answer), update_params)
      assert %{"id" => ^id} = json_response(conn, 200)

      response =
        conn
        |> get(Routes.answer_path(conn, :show, id))
        |> json_response(200)

      assert Norm.conform!(response, HubWeb.AnswerController.resource_s())

      assert %{"id" => ^id} = response
      assert update_params = response
    end

    test "renders errors when data is invalid", %{conn: conn, answer: answer} do
      conn = put(conn, Routes.answer_path(conn, :update, answer), AnswerHelpers.invalid_params(:update))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete answer" do
    setup [:create_answer]

    test "deletes chosen answer", %{conn: conn, answer: answer} do
      conn = delete(conn, Routes.answer_path(conn, :delete, answer))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.answer_path(conn, :show, answer))
      end
    end
  end

  defp create_question(_) do
    {:ok, question: QuestionHelpers.create()}
  end

  defp create_answer(_ \\ nil) do
    %{id: question_id} = QuestionHelpers.create()

    {:ok, answer: AnswerHelpers.create(question_id)}
  end
end
