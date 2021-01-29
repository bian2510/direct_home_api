defmodule DirectHomeApiWeb.UserController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.User
  alias DirectHomeApi.Repo

  @derive {Jason.Encoder, except: [:__meta__]}

  def index(conn, _params) do
    users = Repo.all(User)
    json(conn, users)
  end

  def create(conn, %{"user" => user_params}) do
    User.create(%User{}, user_params)
    |> case do
      {:ok, %User{} = user} -> json(conn, user)
      {:error, _error} -> conn |> put_status(400) |> json(%{error: "error"})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    json(conn, user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    User.update(id, User, %User{}, user_params)
    |> case do
      {:ok, %User{} = user} -> json(conn, user)
      {:error, _error} -> conn |> put_status(400) |> json(%{error: "error"})
    end
  end


 def delete(conn, %{"id" => id}) do
  Repo.get!(User, id) |> Repo.delete()
  conn |> put_status(400) |> json(%{})
  end
end
