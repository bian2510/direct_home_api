defmodule DirectHomeApi.Repo do
  use Ecto.Repo,
    otp_app: :direct_home_api,
    adapter: Ecto.Adapters.Postgres
end
