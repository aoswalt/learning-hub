defmodule HubHTML do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use HubWeb, :controller
      use HubWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: HubHTML

      import Plug.Conn
      import HubWeb.Gettext

      alias HubWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      use Phoenix.View,
        root: "lib/hub_html/templates",
        namespace: HubHTML

      import HubHTML.ViewHelpers
      import HubWeb.ErrorHelpers
      import HubWeb.Gettext
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      alias HubWeb.Router.Helpers, as: Routes
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      import HubWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
