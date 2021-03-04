defmodule DirectHomeApiWeb.PropertyController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.Repo
  alias DirectHomeApi.Model.Property

  def index(conn, _params) do
    properties = Repo.all(Property)
    json(conn, properties)
  end
end
