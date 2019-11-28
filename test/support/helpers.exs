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

  def gen_resource(module, set_params \\ %{}) do
    params =
      module.s(:new)
      |> take_one()
      |> case do
        %_{} = s -> Map.from_struct(s)
        m -> m
      end
      |> Map.merge(set_params)

    changeset_fun =
      if Kernel.function_exported?(module, :changeset, 2),
        do: &module.changeset(&1, &2),
        else: &Ecto.Changeset.cast(&1, &2, module.__schema__(:fields))

    module
    |> struct()
    |> changeset_fun.(params)
    |> HubDB.Repo.insert!()
  end
end
