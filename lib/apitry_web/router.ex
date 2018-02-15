defmodule ApitryWeb.Router do
  use ApitryWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApitryWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit] do
      resources "/posts", PostController, except: [:new, :edit]
    end

  end
end
