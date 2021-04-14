defmodule DirectHomeApiWeb.Router do
  use DirectHomeApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug DirectHomeApiWeb.Auth.Pipeline
  end

  scope "/api", DirectHomeApiWeb do
    pipe_through [:api]
    post "/users/signup", UserController, :create
    post "/users/signin", UserController, :signin
    resources "/properties", PropertyController, except: [:create, :edit, :delete]
    resources "/users", UserController, except: [:edit, :delete, :index]
    get "/health_check", HealthController, :health_check
  end

  scope "/api", DirectHomeApiWeb do
    pipe_through [:api, :auth]
    resources "/users", UserController, except: [:create, :show]
    resources "/properties", PropertyController, except: [:index, :show]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: DirectHomeApiWeb.Telemetry
    end
  end
end
