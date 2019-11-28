defmodule HubJSON.ProfileControllerTest do
  use HubJSON.ResourceControllerTest, ctrl: HubJSON.ProfileController

  defp resource(_) do
    user = HubWeb.Helpers.gen_resource(HubDB.User)
    [resource: HubWeb.Helpers.gen_resource(HubDB.Profile, %{user_id: user.id})]
  end
end
