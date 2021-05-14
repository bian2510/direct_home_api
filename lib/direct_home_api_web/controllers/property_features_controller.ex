defmodule DirectHomeApiWeb.PropertyFeaturesController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.CrudBase
  alias DirectHomeApi.Model.PropertyFeatures

  def index(conn, _params) do
    json(conn, CrudBase.all(PropertyFeatures, [:property]))
  end

  def show(conn, %{"id" => id}) do
    json(conn, CrudBase.find(PropertyFeatures, id, []))
  end

  def create(conn, %{"property_features" => property_features_params}) do
    CrudBase.create(PropertyFeatures, %PropertyFeatures{}, property_features_params, [
      :property
    ])
    |> case do
      %PropertyFeatures{} = property_features -> json(conn, property_features)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def update(conn, %{"id" => id, "property_features" => property_features_params}) do
    CrudBase.update(PropertyFeatures, id, property_features_params, [
      :property
    ])
    |> case do
      %PropertyFeatures{} = property_features -> json(conn, property_features)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

end
