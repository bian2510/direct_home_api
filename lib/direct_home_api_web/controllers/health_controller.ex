defmodule DirectHomeApiWeb.HealthController do
  use DirectHomeApiWeb, :controller

  def health_check(conn, params) do
    params["test"].path |> IO.inspect(label: "parametros")
    ExAws.S3.put_object("dudiprops", "testeando ando", File.read!(params["test"].path), [{:content_type, "image/jpeg"}]) |> ExAws.request!() |> IO.inspect()
    conn
    |> json(%{"status" => "available"})
  end
end
