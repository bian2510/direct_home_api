defmodule DirectHomeApiWeb.UserController do
  use DirectHomeApiWeb, :controller

  alias DirectHomeApi.Model.User
  alias DirectHomeApi.CrudBase
  alias DirectHomeApiWeb.Auth.Guardian

  def index(conn, _params) do
    json(conn, CrudBase.all(User, [:properties]))
  end

  def create(conn, %{"user" => user_params}) do
    CrudBase.create(User, %User{}, user_params, [:properties])
    |> case do
      %User{} = user -> return_user_created(conn, user)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def show(conn, %{"id" => id}) do
    json(conn, CrudBase.find(User, id, [:properties]))
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    CrudBase.update(User, id, user_params, [:properties])
    |> case do
      %User{} = user -> json(conn, user)
      {:error, error} -> conn |> put_status(400) |> json(%{error: error})
    end
  end

  def delete(conn, %{"id" => id}) do
    CrudBase.delete(User, id)
    conn |> put_status(201) |> json(%{})
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> put_req_header("token", token)
      |> json(%{user: user})
    end
  end

  defp return_user_created(conn, user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn
    |> put_status(:created)
    |> put_resp_header("token", token)

    json(conn, %{user: user})
  end
end
