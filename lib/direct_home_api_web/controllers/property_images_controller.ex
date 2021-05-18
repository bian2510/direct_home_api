defmodule DirectHomeApiWeb.PropertyImagesController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.CrudBase
  alias DirectHomeApi.Model.PropertyImages

  def index(conn, _params) do
    json(conn, CrudBase.all(PropertyImages, []))
  end

  def create(conn, %{"property_images" => property_images_params}) do
    PropertyImages.create(PropertyImages, %PropertyImages{}, property_images_params)
    |> case do
      {:ok, body} -> json(conn, body)
      {:error, body} -> conn |> put_status(400) |> json(body)
    end
  end

  def show(conn, %{"id" => id}) do
    json(conn, CrudBase.find(PropertyImages, id, []))
  end

  def update(conn, %{"id" => id, "property_images" => property_images_params}) do
    PropertyImages.update(id, PropertyImages, property_images_params)
    |> case do
      {:ok, body} -> json(conn, body)
      {:error, body} -> conn |> put_status(400) |> json(body)
    end
  end

  def delete(conn, %{"id" => id}) do
    CrudBase.delete(PropertyImages, id)
    conn |> put_status(201) |> json(%{})
  end
end
