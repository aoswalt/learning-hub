defmodule HubWeb.HomeController do
  use HubWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
