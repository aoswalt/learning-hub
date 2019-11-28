defmodule HubJSON.ProfileController do
  use HubJSON.ResourceController, for: HubDB.Profile, camelize?: true

  import Hub.Spec
  import Norm

  @impl HubJSON.ResourceController
  def serializable_fields(), do: [:id, :name, :cohort, :tags, :bio, :user_id]

  @impl HubJSON.ResourceController
  def resource_s(type \\ nil) do
    spec = schema(%{
      "id" => positive_integer(),
      "name" => nonempty_string(),
      "cohort" => nonempty_string(),
      "tags" => coll_of(tag(), min_count: 1),
      "bio" => nonempty_string(),
      "userId" => nonempty_string()
    })

    case type do
      :create -> selection(spec, ["name", "cohort", "tags", "bio", "userId"])
      :update -> selection(spec, ["name", "cohort", "tags", "bio"])
      _ -> spec
    end
  end
end
