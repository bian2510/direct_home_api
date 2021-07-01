defmodule DirectHomeApiWeb.AddressController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.CrudBase
  alias DirectHomeApi.Model.Address

  def index(conn, _params) do
    json(conn, CrudBase.all(Address, []))
  end

  def show(conn, %{"id" => id}) do
    json(conn, CrudBase.find(Address, id, []))
  end

  def create(conn, %{"address" => address_params}) do
    CrudBase.create(Address, %Address{}, address_params, [])
    |> case do
      %Address{} = address -> json(conn, address)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def update(conn, %{"id" => id, "address" => address_params}) do
    CrudBase.update(Address, id, address_params, [])
    |> case do
      %Address{} = address -> json(conn, address)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def delete(conn, %{"id" => id}) do
    CrudBase.delete(Address, id)
    conn |> put_status(201) |> json(%{})
  end
end
