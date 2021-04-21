defmodule DirectHomeApiWeb.PropertyFeaturesControllerTest do
  use DirectHomeApiWeb.ConnCase

  alias DirectHomeApi.Model.PropertyFeatures
  alias DirectHomeApi.Repo
  alias DirectHomeApiWeb.PropertyControllerTest

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at]}

  describe "list all property features" do
    test "return an empty array without features", %{conn: conn} do
      conn = get(conn, Routes.property_features_path(conn, :index))
      assert conn.status == 200
      assert {:ok, []} = Jason.decode(conn.resp_body)
    end

    test "return an array with two property features", %{conn: conn} do
      create_property_features()
      create_property_features()
      conn = get(conn, Routes.property_features_path(conn, :index))
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


  def create_property_features do
    property_id = PropertyControllerTest.create_property().id

    Repo.insert!(%PropertyFeatures{
      bathrooms: 2,
      rooms: 2,
      livings: 1,
      kitchens: 1,
      size: 80,
      property_id: property_id
    })
  end
end
