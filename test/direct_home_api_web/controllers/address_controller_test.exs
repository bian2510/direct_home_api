defmodule DirectHomeApiWeb.AddressControllerTest do
  use DirectHomeApiWeb.ConnCase

  alias DirectHomeApi.Model.Address
  alias DirectHomeApi.Repo
  alias DirectHomeApiWeb.Controllers.{PropertyControllerTest, UserControllerTest}

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :property]}

  @create_attrs %{
    "country" => "Argentina",
    "city" => "CABA",
    "locality" => "Caballito",
    "street" => "El maestro",
    "postal_code" => "1424",
    "number" => "5",
    "reference" => "entre chaco y rivadavia",
    "latitude" => "",
    "longitude" => "",
    "floor" => "11D",
    "property_id" => nil
  }

  @invalid_attrs %{
    "reference" => 2,
    "latitude" => true,
    "longitude" => [],
    "property_id" => nil
  }

  describe "list all address" do
    test "return unauthorized", %{conn: conn} do
      conn = get(conn, Routes.address_path(conn, :index))
      assert conn.status == 401
    end

    test "return an array with address", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      create_address(property)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> get(Routes.address_path(conn, :index))

      assert conn.status == 200

      assert [
               %{
                 "country" => _country,
                 "city" => _city,
                 "locality" => _locality,
                 "street" => _street,
                 "postal_code" => _postal_code,
                 "number" => _number,
                 "reference" => _reference,
                 "latitude" => _latitude,
                 "longitude" => _longitude,
                 "floor" => _floor,
                 "property_id" => _property_id
               }
             ] = Jason.decode!(conn.resp_body)
    end
  end

  describe "show address" do
    test "return a specific address", %{conn: conn} do
      address =
        UserControllerTest.create_user()
        |> PropertyControllerTest.create_property()
        |> create_address()

      conn = get(conn, Routes.address_path(conn, :show, address.id))
      assert 200 = conn.status

      assert %{
               "country" => _country,
               "city" => _city,
               "locality" => _locality,
               "street" => _street,
               "postal_code" => _postal_code,
               "number" => _number,
               "reference" => _reference,
               "latitude" => _latitude,
               "longitude" => _longitude,
               "floor" => _floor,
               "property_id" => _property_id
             } = Jason.decode!(conn.resp_body)
    end
  end

  describe "create address" do
    test "create address with valid params", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      property_id = property.id

      address_param = @create_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.address_path(conn, :create), address: address_param)

      assert conn.status == 200

      assert %{
               "country" => _country,
               "city" => _city,
               "locality" => _locality,
               "street" => _street,
               "postal_code" => _postal_code,
               "number" => _number,
               "reference" => _reference,
               "latitude" => _latitude,
               "longitude" => _longitude,
               "floor" => _floor,
               "property_id" => _property_id
             } = Jason.decode!(conn.resp_body)
    end

    test "create address with invalid params", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      property_id = property.id

      address_param = @invalid_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.address_path(conn, :create), address: address_param)

      assert conn.status == 400

      assert {:ok,
              %{
                "error" => %{
                    "city" => ["can't be blank"],
                 "country" => ["can't be blank"],
                 "latitude" => ["is invalid"],
                 "locality" => ["can't be blank"],
                 "longitude" => ["is invalid"],
                 "number" => ["can't be blank"],
                 "reference" => ["is invalid"],
                 "street" => ["can't be blank"]
                }
              }} = Jason.decode(conn.resp_body)
    end
  end

  describe "update address" do
    test "return address when data is valid", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      property_id = property.id
      address = create_address(property)
      address_param = @create_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> put(Routes.address_path(conn, :update, address.id),
          address: address_param
        )

      assert 200 = conn.status
      assert {:ok, _address_updated} = Jason.decode(conn.resp_body)
    end

    test "return address when data is invalid", %{conn: conn} do
      user = UserControllerTest.create_user()
      property = PropertyControllerTest.create_property(user)
      property_id = property.id
      address = create_address(property)
      address_param = @invalid_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> put(Routes.address_path(conn, :update, address.id),
          address: address_param
        )

      assert 400 = conn.status

      assert {:ok,
              %{
                "error" => %{
                  "reference" => ["is invalid"],
                  "latitude" => ["is invalid"],
                  "longitude" => ["is invalid"]
                }
              }} = Jason.decode(conn.resp_body)
    end
  end

  describe "delete address" do
    test "when the address exist", %{conn: conn} do
      user = UserControllerTest.create_user()

      address = PropertyControllerTest.create_property(user) |> create_address()

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> delete(Routes.address_path(conn, :delete, address.id))

      assert 201 = conn.status
    end
  end

  def create_address(property) do
    Repo.insert!(%Address{
      country: "Argentina",
      city: "CABA",
      locality: "Caballito",
      street: "El maestro",
      postal_code: "1424",
      number: "5",
      reference: "entre chaco y rivadavia",
      latitude: "",
      longitude: "",
      floor: "11D",
      property_id: property.id
    })
  end
end
