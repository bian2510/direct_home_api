defmodule DirectHomeApiWeb.PropertyImagesController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.CrudBase
  alias DirectHomeApi.Model.PropertyImages

  def index(conn, _params) do
    json(conn, CrudBase.all(PropertyImages, []))
  end

  def create(conn, %{"property_images" => property_images_params}) do
    CrudBase.create(PropertyImages, %PropertyImages{}, property_images_params, [])
    |> case do
      %PropertyImages{} = property_images -> json(conn, property_images)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def show(conn, %{"id" => id}) do
    json(conn, CrudBase.find(PropertyImages, id, []))
  end

  def update(conn, %{"id" => id, "property_images" => property_images_params}) do
    CrudBase.update(PropertyImages, id, property_images_params, [])
    |> case do
      %PropertyImages{} = property_images -> json(conn, property_images)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def delete(conn, %{"id" => id}) do
    CrudBase.delete(PropertyImages, id)
    conn |> put_status(201) |> json(%{})
  end
end
