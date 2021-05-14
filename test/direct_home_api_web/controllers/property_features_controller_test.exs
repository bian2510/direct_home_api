defmodule DirectHomeApiWeb.PropertyFeaturesControllerTest do
  use DirectHomeApiWeb.ConnCase

  alias DirectHomeApi.Model.PropertyFeatures
  alias DirectHomeApi.Repo
  alias DirectHomeApiWeb.{PropertyControllerTest, UserControllerTest}

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :property]}

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

  describe "create property features" do
    #test "logged and with valid params", %{conn: conn} do
    #  
    #  get_user(id)
#
    #end
  end

  describe "update property features" do
    #test "logged and with valid params", %{conn: conn} do
    #  create_property_features()
    #  
    #end
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
end
