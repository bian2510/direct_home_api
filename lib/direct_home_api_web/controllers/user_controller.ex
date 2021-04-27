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
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        conn
        |> put_status(:created)
        |> put_resp_header("authorization", token)
        |> json(%{user: user})

      {:error, error} ->
        conn
        |> put_status(401)
        |> json(%{"error" => error})
    end
  end

  def logout(conn, _) do
    jwt = Guardian.Plug.current_token(conn) |> IO.inspect()
    Guardian.revoke(conn, jwt)
    #token = Guardian.Plug.current_token(conn) |> IO.inspect()
    #token = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJkaXJlY3RfaG9tZV9hcGkiLCJleHAiOjE2MjE3MjA1OTYsImlhdCI6MTYxOTMwMTM5NiwiaXNzIjoiZGlyZWN0X2hvbWVfYXBpIiwianRpIjoiODA3ZjZmN2QtYmRkYS00MDlmLWJmMTAtNzNmZmU4OWE2YjJkIiwibmJmIjoxNjE5MzAxMzk1LCJzdWIiOiIyNCIsInR5cCI6ImFjY2VzcyJ9.1DBYP2xRmRPw3B4ZfXug1DRj5jsXGYDuPMo0QSd4Ca3JVWRf5OFxAGcv9LQoLMa1gNCwahKnG_ZLaJgnt9UpHg"#Guardian.Plug.current_token(conn) #|> IO.inspect()
    #{:ok, claims} = Guardian.revoke(token) |> IO.inspect()
    #Guardian.Plug.sign_out(conn) #|> IO.inspect()
    json(conn, %{})
    #Guardian.Plug.current_token(conn) |> IO.inspect()
    #conn 
    #|> Guardian.revoke
    #|> put_status(:ok)
    #|> json(%{})
  end

  defp return_user_created(conn, user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn
    |> put_status(:created)
    |> put_resp_header("authorization", token)

    json(conn, %{user: user})
  end
end
