defmodule DirectHomeApiWeb.PropertyController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.CrudBase
  alias DirectHomeApi.Model.Property

  def index(conn, _params) do
    json(conn, CrudBase.all(Property, [:address, :subscriptions, :property_features, :property_images]))
  end

  def create(conn, %{"property" => property_params}) do
    CrudBase.create(Property, %Property{}, property_params, [
      :address,
      :subscriptions,
      :property_features,
      :property_images
    ])
    |> case do
      %Property{} = property -> json(conn, property)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def update(conn, %{"id" => id, "property" => property_params}) do
    CrudBase.update(Property, id, property_params, [:address, :subscriptions, :property_features, :property_images])
    |> case do
      %Property{} = property -> json(conn, property)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def delete(conn, %{"id" => id}) do
    CrudBase.delete(Property, id)
    conn |> put_status(201) |> json(%{})
  end
end
