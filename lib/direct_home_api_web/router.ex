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
    resources "/address", AddressController, only: [:show]
    resources "/amenities", AmenitiesController, only: [:show]
    get "/health_check", HealthController, :health_check
    resources "/properties", PropertyController, only: [:index, :show]
    resources "/property_features", PropertyFeaturesController, only: [:show]
    resources "/property_images", PropertyImagesController, only: [:show]
    resources "/users", UserController, only: [:show]
    post "/users/signup", UserController, :create
    post "/users/signin", UserController, :signin
    get "/users/logout", UserController, :logout
    resources "/users", UserController, only: [:show]
  end

  scope "/api", DirectHomeApiWeb do
    pipe_through [:api, :auth]
    resources "/address", AddressController, except: [:show, :new]
    resources "/amenities", AmenitiesController, except: [:show, :new]
    resources "/properties", PropertyController, except: [:new, :index, :show]
    resources "/property_features", PropertyFeaturesController, except: [:show, :new]
    resources "/property_images", PropertyImagesController, except: [:show, :new]
    resources "/users", UserController, only: [:update, :delete, :index, :show]
    post "/users/upload_image", UserController, :upload_image
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
