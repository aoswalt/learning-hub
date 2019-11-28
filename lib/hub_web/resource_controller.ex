defmodule HubWeb.ResourceController do
  use HubWeb, :controller

  import Ecto.Query

  alias HubDB.Repo

  defp map_filter({key, args}, overrides) do
    fun = Map.get(overrides, key, &where(&1, ^[{String.to_atom(key), &2}]))
    &fun.(&1, args)
  end

  def index(module, conn, params) do
    valid_keys =
      :fields
      |> module.__resource__().__schema__()
      |> Enum.map(&Atom.to_string/1)

    filters =
      params
      |> Map.take(valid_keys)
      |> Enum.map(&map_filter(&1, module.filter_overrides()))
      |> Enum.reject(&is_nil/1)

    filters
    |> Enum.reduce(module.__resource__(), fn clause, q -> clause.(q) end)
    |> Repo.all()
    |> respond(conn, :ok, module)
  end

  def create(module, conn, params) do
    resource_module = module.__resource__()
    changeset = resource_module.changeset(struct(resource_module), params)

    with {:ok, %^resource_module{} = resource} <- Repo.insert(changeset) do
      respond(resource, conn, :created, module)
    end
  end

  def show(module, conn, %{"id" => id}) do
    resource_module = module.__resource__()

    resource_module
    |> Repo.get!(id)
    |> respond(conn, :ok, module)
  end

  def update(module, conn, %{"id" => id} = params) do
    resource_module = module.__resource__()
    resource = Repo.get!(resource_module, id)
    changeset = resource_module.changeset(resource, params)

    with {:ok, %^resource_module{} = resource} <- Repo.update(changeset) do
      respond(resource, conn, :ok, module)
    end
  end

  def delete(module, conn, %{"id" => id}) do
    resource_module = module.__resource__()
    resource = Repo.get!(resource_module, id)

    with {:ok, %^resource_module{}} <- Repo.delete(resource) do
      send_resp(conn, :no_content, "")
    end
  end

  def respond(data, conn, status \\ :ok, module)

  def respond(data, conn, :created = status, module) do
    resource_module = module.__resource__()
    response_data = convert_to_serializable(data, module)

    path_fun =
      resource_module
      |> Phoenix.Naming.resource_name()
      |> Kernel.<>("_path")
      |> String.to_atom()

    path = apply(HubWeb.Router.Helpers, path_fun, [conn, :show, data])

    conn
    |> put_status(status)
    |> put_resp_header("location", path)
    |> put_resp_content_type("application/json")
    |> json(response_data)
  end

  def respond(data, conn, _status, module) do
    response_data =
      case data do
        d when is_list(d) -> Enum.map(d, &convert_to_serializable(&1, module))
        d when is_map(d) -> convert_to_serializable(d, module)
      end

    json(conn, response_data)
  end

  def camelize(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> camelize()
  end

  def camelize(key) when is_binary(key) do
    downcase_first = fn _, c, rest -> String.downcase(c) <> rest end

    key
    |> Phoenix.Naming.camelize()
    |> (fn k -> Regex.replace(~r/^(\w)(.+)/, k, downcase_first) end).()
  end

  defp convert_to_serializable(resource, module) do
    mapper =
      if module.__camelize__?() do
        &Map.new(&1, fn {key, val} -> {camelize(key), val} end)
      else
        & &1
      end

    response =
      resource
      |> Map.take(module.serializable_fields())
      |> module.to_serializable()
      |> mapper.()

    if Kernel.function_exported?(module, :resource_s, 0) do
      Norm.conform!(response, module.resource_s())
    else
      response
    end
  end

  @callback index(Plug.Conn.t(), params :: map) :: Plug.Conn.t()
  @callback create(Plug.Conn.t(), params :: map) :: Plug.Conn.t()
  @callback show(Plug.Conn.t(), params :: map) :: Plug.Conn.t()
  @callback update(Plug.Conn.t(), params :: map) :: Plug.Conn.t()
  @callback delete(Plug.Conn.t(), params :: map) :: Plug.Conn.t()
  @callback to_serializable(resource :: struct) :: any
  @callback filter_overrides() :: map
  @callback serializable_fields() :: [atom]
  @callback resource_s() :: %Norm.Schema{}
  @callback resource_s(any) :: %Norm.Schema{}

  @optional_callbacks resource_s: 0, resource_s: 1

  defmacro __using__(opts) do
    resource_module = Keyword.fetch!(opts, :for)
    camelize? = Keyword.get(opts, :camelize?, false)

    alias __MODULE__, as: Res

    quote do
      use Phoenix.Controller, namespace: HubWeb

      import Plug.Conn
      import HubWeb.Gettext

      alias HubWeb.Router.Helpers, as: Routes

      action_fallback HubWeb.FallbackController

      @behaviour Res

      @impl Res
      def index(conn, params) do
        Res.index(__MODULE__, conn, params)
      end

      @impl Res
      def create(conn, params) do
        Res.create(__MODULE__, conn, params)
      end

      @impl Res
      def show(conn, params) do
        Res.show(__MODULE__, conn, params)
      end

      @impl Res
      def update(conn, params) do
        Res.update(__MODULE__, conn, params)
      end

      @impl Res
      def delete(conn, params) do
        Res.delete(__MODULE__, conn, params)
      end

      def __resource__(), do: unquote(resource_module)

      def __camelize__?(), do: unquote(camelize?)

      @impl Res
      def to_serializable(res), do: res

      @impl Res
      def filter_overrides(), do: %{}

      @impl Res
      def serializable_fields(), do: unquote(resource_module).__schema__(:fields)

      resource_name = Phoenix.Naming.resource_name(unquote(resource_module))

      defdelegate path(conn_or_endpoint, action),
        to: Routes,
        as: String.to_atom(resource_name <> "_path")

      defdelegate path(conn_or_endpoint, action, params),
        to: Routes,
        as: String.to_atom(resource_name <> "_path")

      defdelegate path(conn_or_endpoint, action, id, params),
        to: Routes,
        as: String.to_atom(resource_name <> "_path")

      defoverridable Res
    end
  end
end
