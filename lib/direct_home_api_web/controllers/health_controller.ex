defmodule DirectHomeApiWeb.HealthController do
  use DirectHomeApiWeb, :controller

  def health_check(conn, params) do
    params["test"].path |> IO.inspect(label: "parametros")
    ExAws.S3.put_object("dudiprops", "test.jpeg", File.read!(params["test"].path)) |> ExAws.request!() |> IO.inspect()
    conn
    |> json(%{"status" => "available"})
  end
end
