Code.require_file("support/helpers.exs", __DIR__)
Code.require_file("support/resource_controller_test.exs", __DIR__)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(HubDB.Repo, :manual)
