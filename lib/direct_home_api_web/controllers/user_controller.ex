defmodule DirectHomeApiWeb.UserController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.Model.User
  alias DirectHomeApi.Repo

  def index(conn, _params) do
    json(conn, User.all(User))
  end

  def create(conn, %{"user" => user_params}) do
    User.create(%User{}, user_params)
    |> case do
      %User{} = user -> json(conn, user)
      {:error, error} -> conn |> put_status(400) |> json(%{error: "error"})
    end
  end

  def show(conn, %{"id" => id}) do
    json(conn, User.show(User, id))
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    User.update(id, User, %User{}, user_params)
    |> case do
      %User{} = user -> json(conn, user)
      {:error, _error} -> conn |> put_status(400) |> json(%{error: "error"})
    end
  end

  def delete(conn, %{"id" => id}) do
    User.delete(User, id)
    conn |> put_status(201) |> json(%{})
  end
end
