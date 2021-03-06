defmodule DirectHomeApiWeb.PropertyController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.CrudBase
  alias DirectHomeApi.Model.Property

  def index(conn, _params) do
    json(
      conn,
      CrudBase.all(Property, Property.preloads())
    )
  end

  def show(conn, %{"id" => id}) do
    json(
      conn,
      CrudBase.find(Property, id, Property.preloads())
    )
  end

  def create(conn, %{"property" => property_params}) do
    CrudBase.create(Property, %Property{}, property_params, Property.preloads())
    |> case do
      %Property{} = property -> json(conn, property)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def show(conn, %{"id" => id}) do
    json(conn, CrudBase.find(Property, id, Property.preloads()))
  end

  def update(conn, %{"id" => id, "property" => property_params}) do
    CrudBase.update(Property, id, property_params, Property.preloads())
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
