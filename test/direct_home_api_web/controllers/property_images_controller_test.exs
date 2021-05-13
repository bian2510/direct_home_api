defmodule DirectHomeApiWeb.Controllers.PropertyImagesControllerTest do
  use DirectHomeApiWeb.ConnCase
  use ExUnit.Case, async: true

  import Mox

  alias DirectHomeApi.Model.{PropertyImages, User}
  alias DirectHomeApi.Repo
  alias DirectHomeApiWeb.{UserControllerTest, PropertyControllerTest}

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :password]}

  @create_attrs %{"image" => "", "property_id" => nil}

  @invalid_attrs %{"image" => "", "property_id" => nil}

  @update_attrs %{"image" => "", "property_id" => nil}

  @update_invalid_attr %{"image" => "", "property_id" => nil}

  describe "list all property images" do
    test "return an empty array without property images", %{conn: conn} do
      conn = get(conn, Routes.property_images_path(conn, :index))
      assert conn.status == 200
      assert {:ok, []} = Jason.decode(conn.resp_body)
    end

    test "return an array with property images", %{conn: conn} do
      create_property_images()
      create_property_images()
      conn = get(conn, Routes.property_images_path(conn, :index))
      assert conn.status == 200

      assert [
               %{
                 "property_id" => _id_1,
                 "image" => _path_1
               },
               %{
                 "property_id" => _id_2,
                 "image" => _path_2
               }
             ] = Jason.decode!(conn.resp_body)
    end
  end

  describe "create property images" do
    test "create property images with valid params", %{conn: conn} do
      DirectHomeApi.Aws.MockS3
      |> expect(:upload_files, fn _image -> {:ok, "encodefilename"} end)

      image = %Plug.Upload{
        content_type: "image/jpeg",
        filename: "test.jpeg",
        path: "test/images/some_image.jpeg"
      }

      property = PropertyControllerTest.create_property()
      property_id = property.id
      user = User.get_user(property.user_id)

      property_image_param = @create_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.property_images_path(conn, :create), property: property_image_param)

      assert conn.status == 200

      assert {:ok,
              %{
                "image" => _image,
                "property_id" => _property_id
              }} = Jason.decode(conn.resp_body)
    end

    #
    #  test "create property with invalid param", %{conn: conn} do
    #    user = UserControllerTest.create_user()
    #    user_id = user.id
    #    property_param = @invalid_attrs |> put_in(["user_id"], user_id)
    #
    #    conn =
    #      UserControllerTest.sigin_and_put_token(conn, user)
    #      |> post(Routes.property_path(conn, :create), property: property_param)
    #
    #    assert conn.status == 400
    #
    #    assert {:ok,
    #            %{
    #              "error" => %{
    #                "currency" => ["is invalid"],
    #                "description" => ["can't be blank"],
    #                "price" => ["can't be blank"],
    #                "property_type" => ["can't be blank"],
    #                "spaces" => ["is invalid"]
    #              }
    #            }} = Jason.decode(conn.resp_body)
    #  end
  end

  #
  # describe "update property" do
  #  test "return property when data is valid", %{conn: conn} do
  #    user = UserControllerTest.create_user()
  #    property = create_property()
  #    property_param = @update_attrs |> put_in(["user_id"], property.id)
  #
  #    conn =
  #      UserControllerTest.sigin_and_put_token(conn, user)
  #      |> put(Routes.property_path(conn, :update, property.id), property: property_param)
  #
  #    assert 200 = conn.status
  #    assert {:ok, property_updated} = Jason.decode(conn.resp_body)
  #
  #    updated_description = @update_attrs["description"]
  #    updated_price = @update_attrs["price"]
  #    updated_currency = @update_attrs["currency"]
  #    updated_spaces = @update_attrs["spaces"]
  #
  #    assert %{
  #             "address" => _address,
  #             "id" => _user_id,
  #             "description" => _description,
  #             "price" => _price,
  #             "currency" => _currency,
  #             "spaces" => _spaces,
  #             "property_type" => _property_type
  #           } = property_updated
  #
  #    assert updated_description == property_updated["description"]
  #    assert updated_price == property_updated["price"]
  #    assert updated_currency == property_updated["currency"]
  #    assert updated_spaces == property_updated["spaces"]
  #  end
  #
  #  test "return errors when data is invalid", %{conn: conn} do
  #    user = UserControllerTest.create_user()
  #    property = create_property()
  #
  #    conn =
  #      UserControllerTest.sigin_and_put_token(conn, user)
  #      |> put(Routes.property_path(conn, :update, property.id), property: @invalid_attrs)
  #
  #    assert 400 = conn.status
  #
  #    assert {:ok, %{"error" => %{"currency" => ["is invalid"], "spaces" => ["is invalid"]}}} =
  #             Jason.decode(conn.resp_body)
  #  end
  #
  #  test "return the same property when a field not could be modificated", %{conn: conn} do
  #    user = UserControllerTest.create_user()
  #    property = create_property()
  #    _property_user_id = property.user_id
  #    _user_id = property.user_id
  #
  #    conn =
  #      UserControllerTest.sigin_and_put_token(conn, user)
  #      |> put(Routes.property_path(conn, :update, property.id), property: @update_invalid_attr)
  #
  #    _property_created = %{
  #      "address" => property.address,
  #      "id" => property.user_id,
  #      "description" => property.description,
  #      "price" => property.price,
  #      "currency" => property.currency,
  #      "spaces" => property.spaces,
  #      "property_type" => property.property_type
  #    }
  #
  #    assert 200 = conn.status
  #    assert {:ok, _property_created} = Jason.decode(conn.resp_body)
  #    assert _property_user_id = Jason.decode!(conn.resp_body) |> get_in(["user_id"])
  #  end
  # end
  #
  # describe "delete property" do
  #  test "when the property exist", %{conn: conn} do
  #    user = UserControllerTest.create_user()
  #    property = create_property()
  #
  #    conn =
  #      UserControllerTest.sigin_and_put_token(conn, user)
  #      |> delete(Routes.property_path(conn, :delete, property.id))
  #
  #    assert 201 = conn.status
  #  end
  # end

  def create_property_images() do
    property_id = PropertyControllerTest.create_property().id

    Repo.insert!(%PropertyImages{
      property_id: property_id,
      image: "test/images/some_image.jpeg"
    })
  end
end
