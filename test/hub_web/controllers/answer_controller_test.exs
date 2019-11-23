defmodule HubWeb.AnswerControllerTest do
  use HubWeb.ConnCase, async: true

  import HubWeb.Helpers

  alias HubDB.Answer

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all answers", %{conn: conn} do
      conn = get(conn, Routes.answer_path(conn, :index))
      assert [] = json_response(conn, 200)

      answer(nil)

      conn = get(conn, Routes.answer_path(conn, :index))
      assert [_] = json_response(conn, 200)
    end
  end

  describe "create answer" do
    setup [:create_params, :invalid_create_params]

    test "renders answer when data is valid", %{conn: conn, create_params: create_params} do
      conn = post(conn, Routes.answer_path(conn, :create), create_params)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.answer_path(conn, :show, id))
      response = json_response(conn, 200)

      assert Norm.conform!(response, HubWeb.AnswerController.resource_s())
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      invalid_create_params: invalid_create_params
    } do
      conn = post(conn, Routes.answer_path(conn, :create), invalid_create_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update answer" do
    setup [:answer, :update_params, :invalid_update_params]

    test "renders answer when data is valid", %{
      conn: conn,
      answer: %Answer{id: id} = answer,
      update_params: update_params
    } do
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

    test "renders errors when data is invalid", %{
      conn: conn,
      answer: answer,
      invalid_update_params: invalid_update_params
    } do
      conn = put(conn, Routes.answer_path(conn, :update, answer), invalid_update_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete answer" do
    setup [:answer]

    test "deletes chosen answer", %{conn: conn, answer: answer} do
      conn = delete(conn, Routes.answer_path(conn, :delete, answer))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.answer_path(conn, :show, answer))
      end
    end
  end

  defp answer(_) do
    question = HubWeb.Helpers.create_by_ctrl(HubWeb.QuestionController)
    params = %{"question_id" => question.id}
    [answer: HubWeb.Helpers.create_by_ctrl(HubWeb.AnswerController, params)]
  end

  defp create_params(_) do
    question = HubWeb.Helpers.create_by_ctrl(HubWeb.QuestionController)
    [create_params: gen_params(HubWeb.AnswerController, :create, %{"question_id" => question.id})]
  end

  defp invalid_create_params(_) do
    invalid_create_params =
      HubWeb.AnswerController
      |> gen_params(:create)
      |> with_nil_param()

    [invalid_create_params: invalid_create_params]
  end

  defp update_params(_) do
    [update_params: gen_params(HubWeb.AnswerController, :update)]
  end

  defp invalid_update_params(_) do
    invalid_update_params =
      HubWeb.AnswerController
      |> gen_params(:update)
      |> with_nil_param()

    [invalid_update_params: invalid_update_params]
  end
end
