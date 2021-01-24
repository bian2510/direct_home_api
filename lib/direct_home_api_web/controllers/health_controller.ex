defmodule DirectHomeApiWeb.HealthController do
  use DirectHomeApiWeb, :controller

  def health_check(conn, _params) do
    conn
    |> send_resp(200, "available")
  end
end
