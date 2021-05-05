defmodule DirectHomeApiWeb.HealthController do
  use DirectHomeApiWeb, :controller

  def health_check(conn, _params) do
    conn
    |> json(%{"status" => "available"})
  end
end
