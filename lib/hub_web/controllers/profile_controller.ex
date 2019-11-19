defmodule HubWeb.ProfileController do
  use HubWeb.ResourceController, for: HubDB.Profile, camelize?: true

  @impl HubWeb.ResourceController
  def serializable_fields(), do: [:id, :name, :cohort, :tags, :bio, :user_id]
end
