defmodule HubWeb.Helpers do
  def take_one(%StreamData{} = data) do
    data
    |> Enum.take(1)
    |> List.first()
  end

  def take_one(generatable) do
    generatable
    |> Norm.gen()
    |> take_one()
  end

  def with_nil_param(params) do
    bad_key = params |> Map.keys() |> Enum.random()

    Map.put(params, bad_key, nil)
  end

  def gen_params(ctrl, type \\ nil, set_params \\ %{}) do
    type
    |> ctrl.resource_s()
    |> take_one()
    |> Map.merge(set_params)
  end

  # TODO(adam): this should be moved in favor of genearting directly by resource
  def create_by_ctrl(ctrl, set_params \\ %{}) do
    resource_module = ctrl.__resource__()

    params =
      ctrl
      |> HubWeb.Helpers.gen_params(:create, set_params)
      |> Map.new(fn {k, v} -> {Phoenix.Naming.underscore(k), v} end)

    struct(resource_module)
    |> resource_module.changeset(params)
    |> HubDB.Repo.insert!()
  end
end
