defmodule DirectHomeApiWeb.PropertyControllerTest do
  use DirectHomeApiWeb.ConnCase

  alias DirectHomeApi.Model.{Property, User}
  alias DirectHomeApi.Repo
  alias DirectHomeApiWeb.UserControllerTest

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :password]}

  @create_attrs %{
    "description" => "Depto 2 ambientes",
    "price" => 260_000,
    "currency" => "USD",
    "spaces" => 2,
    "property_type" => "department",
    "user_id" => nil
  }

  @invalid_attrs %{
    "description" => nil,
    "price" => nil,
    "currency" => 2,
    "spaces" => "algo",
    "user_id" => nil
  }

  describe "list all properties" do
    test "return an empty array without properties", %{conn: conn} do
      conn = get(conn, Routes.property_path(conn, :index))
      assert conn.status == 200
      assert {:ok, []} = Jason.decode(conn.resp_body)
    end

    test "return an array with properties", %{conn: conn} do
      user1 = UserControllerTest.create_user()
      create_property(user1)
      user1 = UserControllerTest.create_user()
      create_property(user1)
      conn = get(conn, Routes.property_path(conn, :index))
      assert conn.status == 200

      assert [
               %{
                 "address" => address,
                 "currency" => currency,
                 "description" => description,
                 "id" => id,
                 "price" => price,
                 "property_type" => property_type,
                 "spaces" => spaces,
                 "status" => status,
                 "subscriptions" => [],
                 "user_id" => user_id
               },
               %{
                 "address" => address2,
                 "currency" => currency2,
                 "description" => description2,
                 "id" => id2,
                 "price" => price2,
                 "property_type" => property_type2,
                 "property_features" => property_features2,
                 "spaces" => spaces2,
                 "status" => status2,
                 "subscriptions" => [],
                 "user_id" => user_id2
               }
             ] = Jason.decode!(conn.resp_body)
    end
  end

  describe "create properties" do
    test "create property with valid params", %{conn: conn} do
      user = UserControllerTest.create_user()
      property_param = Map.replace!(@create_attrs, "user_id", user.id)
      conn = post(conn, Routes.property_path(conn, :create), property: property_param)
      assert conn.status == 200

      assert {:ok,
              %{
                "address" => address2,
                "currency" => currency2,
                "description" => description2,
                "id" => id2,
                "price" => price2,
                "property_type" => property_type2,
                "property_features" => property_features2,
                "spaces" => spaces2,
                "status" => status2,
                "subscriptions" => [],
                "user_id" => user_id2
              }} = Jason.decode(conn.resp_body)
    end

    test "create property with invalid param", %{conn: conn} do
      user = UserControllerTest.create_user()
      property_param = Map.replace!(@invalid_attrs, "user_id", user.id)
      conn = post(conn, Routes.property_path(conn, :create), property: property_param)
      assert conn.status == 400

      assert {:ok,
              %{
                "error" => %{
                  "currency" => ["is invalid"],
                  "description" => ["can't be blank"],
                  "price" => ["can't be blank"],
                  "property_type" => ["can't be blank"],
                  "spaces" => ["is invalid"]
                }
              }} = Jason.decode(conn.resp_body)
    end
  end

  def create_property(user) do
    Repo.insert!(%Property{
      description: "Depto 2 ambientes",
      price: 260_000,
      currency: "USD",
      spaces: 2,
      status: true,
      property_type: "department",
      user_id: user.id
    })
  end
end
