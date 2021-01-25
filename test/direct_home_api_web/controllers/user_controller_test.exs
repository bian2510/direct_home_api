defmodule DirectHomeApiWeb.UserControllerTest do
  use DirectHomeApiWeb.ConnCase

  @create_attrs %{
    "document" => 95_935_781,
    "document_type" => "dni",
    "email" => "bian251091@gmail.com",
    "name" => "Carlos",
    "last_name" => "Hernandez",
    "phone" => 1_173_677_873,
    "password" => "boni2510*",
    "photo" => "algunaphoto",
    "role_id" => nil
  }

  @invalid_attrs %{
    "document" => "cuil",
    "document_type" => nil,
    "email" => nil,
    "phone" => nil,
    "password" => "boni2510*",
    "photo" => nil
  }

  @update_attrs %{
    "phone" => 1123423422,
    "photo" => "otra_photo"
  }

  describe "list all users" do
    test "return array empty", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert 200 = conn.status
      assert {:ok, array} = Jason.decode(conn.resp_body)
      assert [] = array
    end

    test "return array with users", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      conn = get(conn, Routes.user_path(conn, :index))
      assert 200 = conn.status
      assert {:ok, array} = Jason.decode(conn.resp_body)
      array_length = length(array)
      assert 1 = array_length
    end
  end

  describe "show user" do
    test "return a specific user", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      id = Jason.decode!(conn.resp_body)["id"]
      conn = get(conn, Routes.user_path(conn, :show, id))
      assert 200 = conn.status
    end
  end

  describe "create user" do
    test "return user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert 200 = conn.status
      assert {:ok, user} = Jason.decode(conn.resp_body)

      map = %{
        "id" => user["id"],
        "document" => 95_935_781,
        "document_type" => "dni",
        "email" => "bian251091@gmail.com",
        "name" => "Carlos",
        "last_name" => "Hernandez",
        "phone" => 1_173_677_873,
        "photo" => "algunaphoto",
        "role_id" => nil
      }

      assert map == user
    end

    test "return errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert 400 = conn.status
      assert {:ok, %{"error" => "error"}} = Jason.decode(conn.resp_body)
    end

    test "return errors when email or document exist", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert 400 = conn.status
      assert {:ok, %{"error" => "error"}} = Jason.decode(conn.resp_body)
    end
  end

  #describe "update user" do
  #  test "return user when data is valid", %{conn: conn, user: %User{id: id} = user} do
  #    id = post(conn, Routes.user_path(conn, :create, user), user: @create_attrs).resp_body |> Jason.decode!() |> get_in(["id"])
  #    Repo.get!(User, id)
  #    conn = put(conn, Routes.user_path(conn, :update, user), book: @update_attrs)
  #    assert 200 = conn.status |> IO.inspect(label: "ESTATUUS")
  #    assert {:ok, user} = Jason.decode(conn.resp_body)
  #    map = %{
  #      "id" => id,
  #      "document" => 95_935_781,
  #      "document_type" => "dni",
  #      "email" => "bian251091@gmail.com",
  #      "name" => "Carlos",
  #      "last_name" => "Hernandez",
  #      "phone" => 1123423422,
  #      "photo" => "otra_photo",
  #      "role_id" => nil
  #    }
#
  #    assert map == user
  #  end

    #test "return errors when data is invalid", %{conn: conn} do
    #  conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
    #  assert 400 = conn.status
    #  assert {:ok, %{"error" => "error"}} = Jason.decode(conn.resp_body)
    #end
#
    #test "return errors when email or document exist", %{conn: conn} do
    #  conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
    #  conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
    #  assert 400 = conn.status
    #  assert {:ok, %{"error" => "error"}} = Jason.decode(conn.resp_body)
    #end
  #end
end
