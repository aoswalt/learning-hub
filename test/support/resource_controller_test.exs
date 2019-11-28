defmodule HubJSON.ResourceControllerTest do
  defmacro __using__(opts) do
    ctrl = Keyword.fetch!(opts, :ctrl)

    quote do
      resource_name = Phoenix.Naming.resource_name(unquote(ctrl).__resource__())

      use HubWeb.ConnCase, async: true

      import HubWeb.Helpers

      setup %{conn: conn} do
        {:ok, conn: put_req_header(conn, "accept", "application/json")}
      end

      describe "index" do
        test "lists all #{resource_name}", %{conn: conn} do
          conn = get(conn, unquote(ctrl).path(conn, :index))
          assert [] = json_response(conn, 200)

          resource(nil)

          conn = get(conn, unquote(ctrl).path(conn, :index))
          assert [_] = json_response(conn, 200)
        end
      end

      describe "create #{resource_name}" do
        setup [:create_params, :invalid_create_params]

        test "renders #{resource_name} when data is valid", %{conn: conn, create_params: create_params} do
          conn = post(conn, unquote(ctrl).path(conn, :create), create_params)
          assert %{"id" => id} = json_response(conn, 201)

          conn = get(conn, unquote(ctrl).path(conn, :show, id))
          response = json_response(conn, 200)

          assert Norm.conform!(response, unquote(ctrl).resource_s())
        end

        test "renders errors when data is invalid", %{
          conn: conn,
          invalid_create_params: invalid_create_params
        } do
          conn = post(conn, unquote(ctrl).path(conn, :create), invalid_create_params)
          assert json_response(conn, 422)["errors"] != %{}
        end
      end

      describe "update #{resource_name}" do
        setup [:resource, :update_params, :invalid_update_params]

        test "renders #{resource_name} when data is valid", %{
          conn: conn,
          resource: %{id: id} = resource,
          update_params: update_params
        } do
          conn = put(conn, unquote(ctrl).path(conn, :update, resource), update_params)
          assert %{"id" => ^id} = json_response(conn, 200)

          response =
            conn
            |> get(unquote(ctrl).path(conn, :show, id))
            |> json_response(200)

          assert Norm.conform!(response, unquote(ctrl).resource_s())

          assert %{"id" => ^id} = response
          assert update_params = response
        end

        test "renders errors when data is invalid", %{
          conn: conn,
          resource: resource,
          invalid_update_params: invalid_update_params
        } do
          conn = put(conn, unquote(ctrl).path(conn, :update, resource), invalid_update_params)
          assert json_response(conn, 422)["errors"] != %{}
        end
      end

      describe "delete #{resource_name}" do
        setup [:resource]

        test "deletes chosen #{resource_name}", %{conn: conn, resource: resource} do
          conn = delete(conn, unquote(ctrl).path(conn, :delete, resource))
          assert response(conn, 204)

          assert_error_sent 404, fn ->
            get(conn, unquote(ctrl).path(conn, :show, resource))
          end
        end
      end

      defp resource(_) do
        [resource: HubWeb.Helpers.gen_resource(unquote(ctrl).__resource__())]
      end

      defp create_params(_) do
        [create_params: gen_params(unquote(ctrl), :create)]
      end

      defp invalid_create_params(_) do
        invalid_create_params =
          unquote(ctrl)
          |> gen_params(:create)
          |> with_nil_param()

        [invalid_create_params: invalid_create_params]
      end

      defp update_params(_) do
        [update_params: gen_params(unquote(ctrl), :update)]
      end

      defp invalid_update_params(_) do
        invalid_update_params =
          unquote(ctrl)
          |> gen_params(:update)
          |> with_nil_param()

        [invalid_update_params: invalid_update_params]
      end

      defoverridable resource: 1
      defoverridable create_params: 1
    end
  end
end
