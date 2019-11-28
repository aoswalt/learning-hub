defmodule HubJSON do
  def controller do
    quote do
      use Phoenix.Controller, namespace: HubJSON

      import Plug.Conn
      import HubWeb.Gettext

      alias HubWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
