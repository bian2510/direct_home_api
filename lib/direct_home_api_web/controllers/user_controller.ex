defmodule DirectHomeApiWeb.UserController do
  @callback upload_files(arg :: any) :: {:ok, map()} | {:ok, map()}
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
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        conn
        |> put_status(:created)
        |> put_resp_header("authorization", token)
        |> json(%{user: user})

      {:error, error} ->
        conn
        |> put_status(401)
        |> json(%{error: error})
    end
  end

  def upload_image(conn, %{"id" => id, "photo" => user_image}) do
    response = User.update_image(id, %{"photo" => user_image})

    case response do
      {:ok, body} -> json(conn, body)
      {:error, body} -> json(conn, body)
    end
  end

  defp return_user_created(conn, user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn
    |> put_status(:created)
    |> put_resp_header("authorization", token)
    |> json(%{user: user})
  end
end
