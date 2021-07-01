defmodule DirectHomeApiWeb.AmenitiesController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.CrudBase
  alias DirectHomeApi.Model.Amenities

  def index(conn, _params) do
    json(conn, CrudBase.all(Amenities, []))
  end

  def show(conn, %{"id" => id}) do
    json(conn, CrudBase.find(Amenities, id, []))
  end

  def create(conn, %{"amenities" => amenities_params}) do
    CrudBase.create(Amenities, %Amenities{}, amenities_params, [])
    |> case do
      %Amenities{} = amenities -> json(conn, amenities)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def update(conn, %{"id" => id, "amenities" => amenities_params}) do
    CrudBase.update(Amenities, id, amenities_params, [])
    |> case do
      %Amenities{} = amenities -> json(conn, amenities)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def delete(conn, %{"id" => id}) do
    CrudBase.delete(Amenities, id)
    conn |> put_status(201) |> json(%{})
  end
end
