defmodule HubJSON.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use HubJSON, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    response = %{errors: HubWeb.translate_errors(changeset)}

    conn
    |> put_status(:unprocessable_entity)
    |> json(response)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(HubWeb.ErrorView)
    |> render(:"404")
  end
end
