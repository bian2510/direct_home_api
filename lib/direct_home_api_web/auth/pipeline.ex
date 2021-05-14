defmodule DirectHomeApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :direct_home_api,
    module: DirectHomeApiWeb.Auth.Guardian,
    error_handler: DirectHomeApiWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
