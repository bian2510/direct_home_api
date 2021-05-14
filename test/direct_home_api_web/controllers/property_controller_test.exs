defmodule DirectHomeApiWeb.PropertyControllerTest do
  use DirectHomeApiWeb.ConnCase

  alias DirectHomeApi.Model.Property
  alias DirectHomeApi.Repo
  alias DirectHomeApiWeb.UserControllerTest

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :password, :user]}

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

  @update_attrs %{
    "description" => "Monoambiente",
    "price" => 100_000,
    "currency" => "ARS",
    "spaces" => 1,
    "user_id" => nil
  }

  @update_invalid_attr %{
    "user_id" => 4
  }

  describe "list all properties" do
    test "return an empty array without properties", %{conn: conn} do
      conn = get(conn, Routes.property_path(conn, :index))
      assert conn.status == 200
      assert {:ok, []} = Jason.decode(conn.resp_body)
    end

    test "return an array with properties", %{conn: conn} do
      user_1 = UserControllerTest.create_user()
      user_2 = UserControllerTest.create_user()
      create_property(user_1)
      create_property(user_2)
      conn = get(conn, Routes.property_path(conn, :index))
      assert conn.status == 200

      assert [
               %{
                 "address" => _address,
                 "currency" => _currency,
                 "description" => _description,
                 "id" => _id,
                 "price" => _price,
                 "property_type" => _property_type,
                 "spaces" => _spaces,
                 "status" => _status,
                 "subscriptions" => [],
                 "user_id" => _user_id
               },
               %{
                 "address" => _address2,
                 "currency" => _currency2,
                 "description" => _description2,
                 "id" => _id2,
                 "price" => _price2,
                 "property_type" => _property_type2,
                 "property_features" => _property_features2,
                 "spaces" => _spaces2,
                 "status" => _status2,
                 "subscriptions" => [],
                 "user_id" => _user_id2
               }
             ] = Jason.decode!(conn.resp_body)
    end
  end

  describe "create properties" do
    test "create property with valid params", %{conn: conn} do
      user = UserControllerTest.create_user()
      user_id = user.id
      property_param = @create_attrs |> put_in(["user_id"], user_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.property_path(conn, :create), property: property_param)

      assert conn.status == 200

      assert {:ok,
              %{
                "address" => _address,
                "currency" => _currency,
                "description" => _description,
                "id" => _id,
                "price" => _price,
                "property_type" => _property_type,
                "property_features" => _property_features,
                "spaces" => _spaces,
                "status" => _status,
                "subscriptions" => [],
                "user_id" => _user_id
              }} = Jason.decode(conn.resp_body)
    end

    test "create property with invalid param", %{conn: conn} do
      user = UserControllerTest.create_user()
      user_id = user.id
      property_param = @invalid_attrs |> put_in(["user_id"], user_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.property_path(conn, :create), property: property_param)

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

  describe "update property" do
    test "return property when data is valid", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = create_property(user)
      property_param = @update_attrs |> put_in(["user_id"], property.id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> put(Routes.property_path(conn, :update, property.id), property: property_param)

      assert 200 = conn.status
      assert {:ok, property_updated} = Jason.decode(conn.resp_body)

      updated_description = @update_attrs["description"]
      updated_price = @update_attrs["price"]
      updated_currency = @update_attrs["currency"]
      updated_spaces = @update_attrs["spaces"]

      assert %{
               "address" => _address,
               "id" => _user_id,
               "description" => _description,
               "price" => _price,
               "currency" => _currency,
               "spaces" => _spaces,
               "property_type" => _property_type
             } = property_updated

      assert updated_description == property_updated["description"]
      assert updated_price == property_updated["price"]
      assert updated_currency == property_updated["currency"]
      assert updated_spaces == property_updated["spaces"]
    end

    test "return errors when data is invalid", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = create_property(user)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> put(Routes.property_path(conn, :update, property.id), property: @invalid_attrs)

      assert 400 = conn.status

      assert {:ok, %{"error" => %{"currency" => ["is invalid"], "spaces" => ["is invalid"]}}} =
               Jason.decode(conn.resp_body)
    end

    test "return the same property when a field not could be modificated", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = create_property(user)
      _property_user_id = property.user_id
      _user_id = property.user_id

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> put(Routes.property_path(conn, :update, property.id), property: @update_invalid_attr)

      _property_created = %{
        "address" => property.address,
        "id" => property.user_id,
        "description" => property.description,
        "price" => property.price,
        "currency" => property.currency,
        "spaces" => property.spaces,
        "property_type" => property.property_type
      }

      assert 200 = conn.status
      assert {:ok, _property_created} = Jason.decode(conn.resp_body)
      assert _property_user_id = Jason.decode!(conn.resp_body) |> get_in(["user_id"])
    end
  end

  describe "delete property" do
    test "when the property exist", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = create_property(user)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> delete(Routes.property_path(conn, :delete, property.id))

      assert 201 = conn.status
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
    }) |> Repo.preload([:address, :subscriptions, :property_features, :property_images]) |> IO.inspect
  end
end
