defmodule HubWeb.Router do
  use HubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :parseltongue
  end

  scope "/", HubWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", HubWeb do
    pipe_through :api

    resources "/questions", QuestionController, except: [:new, :edit]
    resources "/profiles", ProfileController, except: [:new, :edit]
    resources "/answers", AnswerController, except: [:new, :edit]
  end

  defp parseltongue(conn, _opts) do
    snake_params = Map.new(conn.params, fn {k, v} -> {Macro.underscore(k), v} end)
    Map.put(conn, :params, snake_params)
  end
end
