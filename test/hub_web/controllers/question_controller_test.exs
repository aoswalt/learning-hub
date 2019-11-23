defmodule HubWeb.QuestionControllerTest do
  use HubWeb.ConnCase, async: true

  import HubWeb.Helpers

  alias HubDB.Question

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, Routes.question_path(conn, :index))
      assert [] = json_response(conn, 200)

      question(nil)

      conn = get(conn, Routes.question_path(conn, :index))
      assert [_] = json_response(conn, 200)
    end

    # TODO(adam): add tests by filterable entries exposed by controller?
    test "filters by tags", %{conn: conn} do
      conn = get(conn, Routes.question_path(conn, :index), %{"tags" => ["sql"]})
      assert [] = json_response(conn, 200)

      %{tags: [tag | _]} = HubWeb.Helpers.create_by_ctrl(HubWeb.QuestionController)

      conn = get(conn, Routes.question_path(conn, :index), %{"tags" => [tag]})
      assert [_] = json_response(conn, 200)

      conn = get(conn, Routes.question_path(conn, :index), %{"tags" => []})
      assert [] = json_response(conn, 200)
    end
  end

  describe "create question" do
    setup [:create_params, :invalid_create_params]

    test "renders question when data is valid", %{conn: conn, create_params: create_params} do
      conn = post(conn, Routes.question_path(conn, :create), create_params)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.question_path(conn, :show, id))
      response = json_response(conn, 200)

      assert Norm.conform!(response, HubWeb.QuestionController.resource_s())
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      invalid_create_params: invalid_create_params
    } do
      conn = post(conn, Routes.question_path(conn, :create), invalid_create_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update question" do
    setup [:question, :update_params, :invalid_update_params]

    test "renders question when data is valid", %{
      conn: conn,
      question: %Question{id: id} = question,
      update_params: update_params
    } do
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

    test "renders errors when data is invalid", %{
      conn: conn,
      question: question,
      invalid_update_params: invalid_update_params
    } do
      conn = put(conn, Routes.question_path(conn, :update, question), invalid_update_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete question" do
    setup [:question]

    test "deletes chosen question", %{conn: conn, question: question} do
      conn = delete(conn, Routes.question_path(conn, :delete, question))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.question_path(conn, :show, question))
      end
    end
  end

  defp question(_) do
    [question: HubWeb.Helpers.create_by_ctrl(HubWeb.QuestionController)]
  end

  defp create_params(_) do
    [create_params: gen_params(HubWeb.QuestionController, :create)]
  end

  defp invalid_create_params(_) do
    invalid_create_params =
      HubWeb.QuestionController
      |> gen_params(:create)
      |> with_nil_param()

    [invalid_create_params: invalid_create_params]
  end

  defp update_params(_) do
    [update_params: gen_params(HubWeb.QuestionController, :update)]
  end

  defp invalid_update_params(_) do
    invalid_update_params =
      HubWeb.QuestionController
      |> gen_params(:update)
      |> with_nil_param()

    [invalid_update_params: invalid_update_params]
  end
end
