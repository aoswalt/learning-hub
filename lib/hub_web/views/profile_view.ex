defmodule HubWeb.ProfileView do
  use HubWeb, :view
  alias HubWeb.ProfileView

  def render("index.json", %{profiles: profiles}) do
    %{data: render_many(profiles, ProfileView, "profile.json")}
  end

  def render("show.json", %{profile: profile}) do
    %{data: render_one(profile, ProfileView, "profile.json")}
  end

  def render("profile.json", %{profile: profile}) do
    %{id: profile.id,
      name: profile.name,
      cohort: profile.cohort,
      tags: profile.tags,
      bio: profile.bio,
      userId: profile.userId}
  end
end
