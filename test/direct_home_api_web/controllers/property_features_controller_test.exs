defmodule DirectHomeApiWeb.PropertyFeaturesControllerTest do
  use DirectHomeApiWeb.ConnCase

  alias DirectHomeApi.Model.{PropertyFeatures, Property}
  alias DirectHomeApi.Repo
  alias DirectHomeApiWeb.{PropertyControllerTest, UserControllerTest}

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :property]}

  @create_attrs %{
    "bathrooms" => 2,
    "rooms" => 2,
    "livings" => 1,
    "kitchens" => 1,
    "size" => 150,
    "property_id" => nil
  }

  @invalid_attrs %{
    "bathrooms" => nil,
    "rooms" => nil,
    "livings" => "una palabra",
    "kitchens" => nil,
    "size" => "otra",
    "property_id" => nil
  }

  describe "list all property features" do
    test "return unauthorized", %{conn: conn} do
      conn = get(conn, Routes.property_features_path(conn, :index))
      assert conn.status == 401
    end

    test "return an array with two property features", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      create_property_features(property)
      create_property_features(property)
      conn = UserControllerTest.sigin_and_put_token(conn, user) |> get(Routes.property_features_path(conn, :index))
      assert conn.status == 200

      assert [
              %{
                "bathrooms" => _bathrooms,
                "rooms" => _rooms,
                "livings" => _livings,
                "kitchens" => _kitchens,
                "size" => _size,
                "property_id" => _property_id
              },
              %{
                "bathrooms" => _bathrooms1,
                "rooms" => _rooms1,
                "livings" => _livings1,
                "kitchens" => _kitchenS1,
                "size" => _size1,
                "property_id" => _property_id1
              }
            ] = Jason.decode!(conn.resp_body)
      end
  end

  describe "create property_features" do
    test "create features with valid params", %{conn: conn} do
      user = UserControllerTest.create_user()
      property= create_property(user.id)
      property_id = property.id

      features_param = @create_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.property_features_path(conn, :create), property_features: features_param)

      assert conn.status == 200

      assert {:ok,
      %{
        "bathrooms" => _bathrooms,
        "rooms" => _rooms,
        "livings" => _livings,
        "kitchens" => _kitchens,
        "size" => _size,
        "property_id" => _property_id
      }} = Jason.decode(conn.resp_body)

    end

    test "create features with invalid params", %{conn: conn} do
      user = UserControllerTest.create_user()
      property= create_property(user.id)
      property_id = property.id

      features_param = @invalid_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.property_features_path(conn, :create), property_features: features_param)

      assert conn.status == 400

      assert {:ok,
              %{
                "error" => %{
                  "bathrooms" => ["can't be blank"],
                  "rooms" => ["can't be blank"],
                  "livings" => ["is invalid"],
                  "kitchens" => ["can't be blank"],
                  "size" => ["is invalid"],
                  "property_id" => ["can't be blank"]
                }
              }} = Jason.decode(conn.resp_body)
    end
  end

  describe "update property_features" do
    test "return features when data is valid", %{conn: conn} do
      user = UserControllerTest.create_user()
      property= create_property(user.id)
      property_id = property.id

      features_param = @create_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.property_features_path(conn, :update), property_features: features_param)

        assert 200 = conn.status
        assert {:ok, property_features_updated} = Jason.decode(conn.resp_body)


    end
  end



  def create_property_features(property) do
    Repo.insert!(%PropertyFeatures{
      bathrooms: 2,
      rooms: 2,
      livings: 1,
      kitchens: 1,
      size: 80,
      property_id: property.id
    })
  end

  def create_property(user_id) do

    Repo.insert(%Property{
      description: "Depto 2 ambientes",
      price: 260_000,
      currency: "USD",
      spaces: 2,
      status: true,
      property_type: "department",
      user_id: user_id
    })

  end
end
