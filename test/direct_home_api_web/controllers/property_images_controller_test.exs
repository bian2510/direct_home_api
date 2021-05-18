defmodule DirectHomeApiWeb.Controllers.PropertyImagesControllerTest do
  use DirectHomeApiWeb.ConnCase
  use ExUnit.Case

  import Mox

  alias DirectHomeApi.Model.{PropertyImages, User}
  alias DirectHomeApiWeb.Controllers.{UserControllerTest, PropertyControllerTest}
  alias DirectHomeApi.Repo

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :property]}

  @create_attrs %{
    "image" => %Plug.Upload{
      content_type: "image/jpeg",
      filename: "test.jpeg",
      path: "test/images/some_image.jpeg"
    },
    "property_id" => nil
  }

  @invalid_attrs %{"image" => "invalid", "property_id" => nil}

  @update_attrs %{
    "image" => %Plug.Upload{
      content_type: "image/jpeg",
      filename: "test.jpeg",
      path: "test/images/some_image.jpeg"
    }
  }

  describe "list all property images" do
    test "return an array with property images", %{conn: conn} do
      user = UserControllerTest.create_user()

      PropertyControllerTest.create_property(user)
      |> create_property_images()

      UserControllerTest.create_user()
      |> PropertyControllerTest.create_property()
      |> create_property_images()

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> get(Routes.property_images_path(conn, :index))

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

    test "return unauthorized", %{conn: conn} do
      user = UserControllerTest.create_user()

      PropertyControllerTest.create_property(user)
      |> create_property_images()

      UserControllerTest.create_user()
      |> PropertyControllerTest.create_property()
      |> create_property_images()

      conn = get(conn, Routes.property_images_path(conn, :index))
      assert conn.status == 401

      assert %{"error" => "unauthenticated"} = Jason.decode!(conn.resp_body)
    end
  end

  describe "show property" do
    test "return a specific user", %{conn: conn} do
      property_images =
        UserControllerTest.create_user()
        |> PropertyControllerTest.create_property()
        |> create_property_images()

      conn = get(conn, Routes.property_images_path(conn, :show, property_images.id))
      assert 200 = conn.status

      assert %{
               "property_id" => _id_1,
               "image" => _path_1
             } = Jason.decode!(conn.resp_body)
    end
  end

  describe "create property images" do
    test "create property images with valid params", %{conn: conn} do
      DirectHomeApi.Aws.MockS3
      |> expect(:upload_files, fn _image ->
        {:ok, System.get_env("S3_URL") <> "encodefilename.jpeg"}
      end)

      property = UserControllerTest.create_user() |> PropertyControllerTest.create_property()
      property_id = property.id
      user = User.get_user(property.user_id)

      property_image_param = @create_attrs |> put_in(["property_id"], property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.property_images_path(conn, :create), property_images: property_image_param)

      assert conn.status == 200

      assert {:ok, %{"sucess" => "The image was saved sucessfully"}} =
               Jason.decode(conn.resp_body)
    end

    test "create property images with invalid param", %{conn: conn} do
      DirectHomeApi.Aws.MockS3
      |> expect(:upload_files, fn _image ->
        {:error, "error"}
      end)

      user = UserControllerTest.create_user()
      property_image = PropertyControllerTest.create_property(user) |> create_property_images()
      property_image_param = @invalid_attrs |> put_in(["property_id"], property_image.property_id)

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> post(Routes.property_images_path(conn, :create), property_images: property_image_param)

      assert conn.status == 400

      assert {:ok, %{"error" => "The image not could be storage in s3"}} =
               Jason.decode(conn.resp_body)
    end
  end

  describe "update property images" do
    test "return property images when data is valid", %{conn: conn} do
      DirectHomeApi.Aws.MockS3
      |> expect(:upload_files, fn _image ->
        {:ok, System.get_env("S3_URL") <> "encodefilename.jpeg"}
      end)

      user = UserControllerTest.create_user()
      property_image = PropertyControllerTest.create_property(user) |> create_property_images()
      property_image_param = @update_attrs

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> put(Routes.property_images_path(conn, :update, property_image.id),
          property_images: property_image_param
        )

      assert 200 = conn.status

      assert {:ok, %{"sucess" => "The image was saved sucessfully"}} =
               Jason.decode(conn.resp_body)
    end

    test "return errors when data is invalid", %{conn: conn} do
      DirectHomeApi.Aws.MockS3
      |> expect(:upload_files, fn _image ->
        {:error, "error"}
      end)

      user = UserControllerTest.create_user()
      property_image = PropertyControllerTest.create_property(user) |> create_property_images()

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> put(Routes.property_images_path(conn, :update, property_image.id),
          property_images: @invalid_attrs
        )

      assert 400 = conn.status

      assert {:ok, %{"error" => "The image not could be storage in s3"}} =
               Jason.decode(conn.resp_body)
    end
  end

  describe "delete property" do
    test "when the property exist", %{conn: conn} do
      user = UserControllerTest.create_user()
      property_image = PropertyControllerTest.create_property(user) |> create_property_images()

      conn =
        UserControllerTest.sigin_and_put_token(conn, user)
        |> delete(Routes.property_images_path(conn, :delete, property_image.id))

      assert 201 = conn.status
    end
  end

  def create_property_images(property) do
    Repo.insert!(%PropertyImages{
      property_id: property.id,
      image: "test/images/some_image.jpeg"
    })
  end
end
