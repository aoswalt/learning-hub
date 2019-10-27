defmodule HubWeb.AuthView do
  use HubWeb, :view

  def render("token.json", %{token: token}) do
    %{"token" => token}
  end
end
