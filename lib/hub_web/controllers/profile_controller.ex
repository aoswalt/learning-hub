defmodule HubWeb.ProfileController do
  use HubWeb, :controller

  alias Hub.Profile

  action_fallback HubWeb.FallbackController

  def index(conn, _params) do
    profiles = Hub.list_profiles()
    render(conn, "index.json", profiles: profiles)
  end

  def create(conn, profile_params) do
    with {:ok, %Profile{} = profile} <- Hub.create_profile(profile_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.profile_path(conn, :show, profile))
      |> render("show.json", profile: profile)
    end
  end

  def show(conn, %{"id" => id}) do
    profile = Hub.get_profile!(id)
    render(conn, "show.json", profile: profile)
  end

  def update(conn, %{"id" => id} = profile_params) do
    profile = Hub.get_profile!(id)

    with {:ok, %Profile{} = profile} <- Hub.update_profile(profile, profile_params) do
      render(conn, "show.json", profile: profile)
    end
  end

  def delete(conn, %{"id" => id}) do
    profile = Hub.get_profile!(id)

    with {:ok, %Profile{}} <- Hub.delete_profile(profile) do
      send_resp(conn, :no_content, "")
    end
  end
end
