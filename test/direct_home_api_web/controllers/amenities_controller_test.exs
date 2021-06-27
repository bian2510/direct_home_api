defmodule DirectHomeApiWeb.AmenitiesControllerTest do
  use DirectHomeApiWeb.ConnCase

  alias DirectHomeApi.Model.Amenities
  alias DirectHomeApi.Repo
  alias DirectHomeApiWeb.Controllers.{PropertyControllerTest, UserControllerTest}

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :property]}

  @create_attrs %{
    "wifi" => true,
    "pets" => true,
    "pool" => true,
    "childrens" => true,
    "laundry" => true,
    "bbq" => true,
    "balcony" => true,
    "porter" => true,
    "gym" => true,
    "parking_lot" => true,
    "property_id" => nil
  }

  @invalid_attrs %{
    "wifi" => "true",
    "pets" => 2,
    "pool" => [],
    "property_id" => nil
  }

  describe "list all amenities" do
    test "return unauthorized", %{conn: conn} do
      conn = get(conn, Routes.amenities_path(conn, :index))
      assert conn.status == 401
    end

    test "return an array with amenities", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      create_amenities(property)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> get(Routes.amenities_path(conn, :index))

      assert conn.status == 200

      assert [
               %{
                 "wifi" => _wifi,
                 "pets" => _pets,
                 "pool" => _pool,
                 "childrens" => _childrens,
                 "laundry" => _laundry,
                 "bbq" => _bbq,
                 "balcony" => _balcony,
                 "porter" => _porter,
                 "gym" => _gym,
                 "parking_lot" => _parking_lot,
                 "property_id" => _property_id
               }
             ] = Jason.decode!(conn.resp_body)
    end
  end

  describe "show amenities" do
    test "return a specific amenities", %{conn: conn} do
      amenities =
        UserControllerTest.create_user()
        |> PropertyControllerTest.create_property()
        |> create_amenities()

      conn = get(conn, Routes.amenities_path(conn, :show, amenities.id))
      assert 200 = conn.status

      assert %{
               "wifi" => _wifi,
               "pets" => _pets,
               "pool" => _pool,
               "childrens" => _childrens,
               "laundry" => _laundry,
               "bbq" => _bbq,
               "balcony" => _balcony,
               "porter" => _porter,
               "gym" => _gym,
               "parking_lot" => _parking_lot,
               "property_id" => _property_id
             } = Jason.decode!(conn.resp_body)
    end
  end

  describe "create amenities" do
    test "create amenities with valid params", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      property_id = property.id

      amenities_param = @create_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.amenities_path(conn, :create), amenities: amenities_param)

      assert conn.status == 200

      assert %{
               "wifi" => _wifi,
               "pets" => _pets,
               "pool" => _pool,
               "childrens" => _childrens,
               "laundry" => _laundry,
               "bbq" => _bbq,
               "balcony" => _balcony,
               "porter" => _porter,
               "gym" => _gym,
               "parking_lot" => _parking_lot,
               "property_id" => _property_id
             } = Jason.decode!(conn.resp_body)
    end

    test "create amenities with invalid params", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      property_id = property.id

      amenities_param = @invalid_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.amenities_path(conn, :create), amenities: amenities_param)

      assert conn.status == 400

      assert {:ok,
              %{
                "error" => %{
                  "pets" => ["is invalid"],
                  "pool" => ["is invalid"]
                }
              }} = Jason.decode(conn.resp_body)
    end
  end

  describe "update property_features" do
    test "return property_features when data is valid", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      property_id = property.id
      amenities = create_amenities(property)
      features_param = @create_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> put(Routes.amenities_path(conn, :update, amenities.id),
          amenities: features_param
        )

      assert 200 = conn.status
      assert {:ok, _amenities_updated} = Jason.decode(conn.resp_body)
    end

    test "return amenities when data is invalid", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      property_id = property.id
      amenities = create_amenities(property)
      features_param = @invalid_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> put(Routes.amenities_path(conn, :update, amenities.id),
          amenities: features_param
        )

      assert 400 = conn.status

      assert {:ok,
              %{
                "error" => %{
                  "pets" => ["is invalid"],
                  "pool" => ["is invalid"]
                }
              }} = Jason.decode(conn.resp_body)
    end
  end

  describe "delete amenities" do
    test "when the amenities exist", %{conn: conn} do
      user = UserControllerTest.create_user()

      amenities = PropertyControllerTest.create_property(user) |> create_amenities()

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> delete(Routes.amenities_path(conn, :delete, amenities.id))

      assert 201 = conn.status
    end
  end

  def create_amenities(property) do
    Repo.insert!(%Amenities{
      wifi: true,
      pets: true,
      pool: true,
      childrens: true,
      laundry: true,
      bbq: true,
      balcony: true,
      porter: true,
      gym: true,
      parking_lot: true,
      property_id: property.id
    })
  end
end
