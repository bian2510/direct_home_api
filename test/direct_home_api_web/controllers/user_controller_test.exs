defmodule DirectHomeApiWeb.UserControllerTest do
  use DirectHomeApiWeb.ConnCase

  alias DirectHomeApi.Model.User
  alias DirectHomeApi.Repo

  # Falta agregar validaciones de documento y sus tests

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :password]}

  @create_attrs %{
    "document" => 95_935_781,
    "document_type" => "dni",
    "email" => "bian251091@gmail.com",
    "name" => "Carlos",
    "last_name" => "Hernandez",
    "phone" => 1_173_677_873,
    "password" => "boni2510*",
    "photo" => "algunaphoto",
    "type" => "client"
  }

  @invalid_attrs %{
    "document" => "otro beta",
    "document_type" => nil,
    "email" => nil,
    "phone" => nil,
    "password" => "boni2510*",
    "photo" => nil
  }

  #@update_attrs %{
  #  "phone" => 1_123_423_422,
  #  "photo" => "otra_photo"
  #}

  @update_invalid_attrs %{
    "email" => "algun otro mail"
  }

  describe "list all users" do
    test "return array empty", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert 200 = conn.status
      assert {:ok, array} = Jason.decode(conn.resp_body)
      assert [] = array
    end

    test "return array with users", %{conn: conn} do
      _user1 = create_user()
      _user2 = create_user()
      conn = get(conn, Routes.user_path(conn, :index))
      assert 200 = conn.status

      assert {:ok,
              [
                %{
                  "document" => _document1,
                  "document_type" => _document_type1,
                  "email" => _email1,
                  "name" => _name1,
                  "last_name" => _last_name1,
                  "phone" => _phone1,
                  "photo" => _photo1,
                  "type" => _type1,
                  "properties" => []
                },
                %{
                  "document" => _document2,
                  "document_type" => _document_type2,
                  "email" => _email2,
                  "name" => _name2,
                  "last_name" => _last_name2,
                  "phone" => _phone2,
                  "photo" => _photo2,
                  "type" => _type2,
                  "properties" => []
                }
              ]} = Jason.decode(conn.resp_body)
    end
  end

  describe "show user" do
    test "return a specific user", %{conn: conn} do
      id = create_user().id
      conn = get(conn, Routes.user_path(conn, :show, id))
      assert 200 = conn.status

      assert %{
               "document" => _document2,
               "document_type" => _document_type2,
               "email" => _email2,
               "name" => _name2,
               "last_name" => _last_name2,
               "phone" => _phone2,
               "photo" => _photo2,
               "type" => _type2,
               "properties" => []
             } = Jason.decode!(conn.resp_body)
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
        "properties" => [],
        "type" => "client"
      }

      assert map == user
    end

    test "return errors when data is invalid or is missing required params", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert 400 = conn.status

      assert {:ok,
              %{
                "error" => %{
                  "document" => ["is invalid"],
                  "email" => ["can't be blank"],
                  "last_name" => ["can't be blank"],
                  "name" => ["can't be blank"],
                  "type" => ["can't be blank"]
                }
              }} = Jason.decode(conn.resp_body)
    end

    test "return errors when email exist", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert 400 = conn.status

      assert {:ok,
              %{
                "error" => %{
                  "email" => ["has already been taken"]
                }
              }} = Jason.decode(conn.resp_body)
    end
  end

  describe "update user" do
    test "return user when data is valid", %{conn: conn} do
      user_id = create_user().id
      @update_attrs |> put_in(["id"], user_id)
      conn = put(conn, Routes.user_path(conn, :update, user_id), user: @update_attrs)
      assert 200 = conn.status
      assert {:ok, user} = Jason.decode(conn.resp_body)

      _updated_phone = @update_attrs["phone"]
      _updated_photo = @update_attrs["photo"]

      assert %{
               "id" => _user_id,
               "document" => _document,
               "document_type" => _document_type,
               "email" => _email,
               "name" => _name,
               "last_name" => _last_name,
               "phone" => _phone,
               "photo" => _photo,
               "type" => "client"
             } = user

      assert _updated_phone = user["phone"]
      assert _updated_photo = user["photo"]
    end

    test "return errors when data is invalid", %{conn: conn} do
      user_id = create_user().id
      @invalid_attrs |> put_in(["id"], user_id)
      conn = put(conn, Routes.user_path(conn, :update, user_id), user: @invalid_attrs)
      assert 400 = conn.status
      assert {:ok, error} = Jason.decode(conn.resp_body)

      assert %{
               "error" => %{"document" => ["is invalid"]}
             } = error
    end

    test "return the same user when a field not could be modificated", %{conn: conn} do
      user = create_user()   
      user_id = user.id
      @invalid_attrs |> put_in(["id"], user_id)
      conn = put(conn, Routes.user_path(conn, :update, user_id), user: @update_invalid_attrs)
      assert 200 = conn.status
      assert {:ok, user_updated} = Jason.decode(conn.resp_body)
      assert _user = user_updated
    end
  end

  describe "delete user" do
    test "return status 201 if a user could be deleted", %{conn: conn} do
      id = create_user().id
      conn = delete(conn, Routes.user_path(conn, :delete, id))
      assert conn.status == 201
    end
  end

  def create_user() do
    Repo.insert!(%User{
      name: "Fabian",
      last_name: "Hernandez",
      phone: random_num(),
      email: "bian#{random_num()}@gmail.com",
      photo: "unaphoto",
      document: random_num(),
      document_type: "DNI",
      password: "password",
      type: :client
    })
  end

  defp random_num, do: Enum.random(100_000_000..999_999_999)
end
