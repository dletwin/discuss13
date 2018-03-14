defmodule DiscussWeb.Router do
  use DiscussWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DiscussWeb.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DiscussWeb do
    pipe_through :browser # Use the default browser stack

    resources "/", TopicController
  end

  scope "/auth", DiscussWeb do
    pipe_through :browser

    get "/signout", UserController, :signout
    get "/:provider", UserController, :request
    get "/:provider/callback", UserController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", DiscussWeb do
  #   pipe_through :api
  # end
end
