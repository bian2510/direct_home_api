defmodule DirectHomeApiWeb.PropertyController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.Repo
  alias DirectHomeApi.Model.Property

  def index(conn, _params) do
    properties =
      Repo.all(Property) |> Repo.preload([:address, :subscriptions, :property_features])

    json(conn, properties)
  end

  def create(conn(%{"property" => property_params})) do
  end
end
