defmodule DirectHomeApiWeb.PropertyController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.CrudBase
  alias DirectHomeApi.Model.Property

  def index(conn, _params) do
    json(conn, CrudBase.all(Property, [:address, :subscriptions, :property_features]))
  end

  def create(conn, %{"property" => property_params}) do
    CrudBase.create(Property, %Property{}, property_params, [:address, :subscriptions, :property_features])
    |> case do
      %Property{} = property -> json(conn, property)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end
end
