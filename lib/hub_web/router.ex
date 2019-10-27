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

  scope "/auth", HubWeb do
    pipe_through :api

    get "/validate", AuthController, :validate
    # get "/:provider", AuthController, :request
    # get "/:provider/callback", AuthController, :callback
  end
end
