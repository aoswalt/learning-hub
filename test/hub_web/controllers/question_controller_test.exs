defmodule HubWeb.QuestionControllerTest do
  use HubWeb.ResourceControllerTest, ctrl: HubWeb.QuestionController

  describe "index filtering" do
    # TODO(adam): add tests by filterable entries exposed by controller?
    test "filters by tags", %{conn: conn} do
      conn = get(conn, Routes.question_path(conn, :index), %{"tags" => ["sql"]})
      assert [] = json_response(conn, 200)

      %{tags: [tag | _]} = HubWeb.Helpers.gen_resource(HubWeb.QuestionController.__resource__())

      conn = get(conn, Routes.question_path(conn, :index), %{"tags" => [tag]})
      assert [_] = json_response(conn, 200)

      conn = get(conn, Routes.question_path(conn, :index), %{"tags" => []})
      assert [] = json_response(conn, 200)
    end
  end
end
