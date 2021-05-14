defmodule DirectHomeApi.Aws.S3Test do
  import Mox
  use ExUnit.Case, async: true
  doctest DirectHomeApi.Aws.S3

  setup :verify_on_exit!

  describe "upload file to s3" do
    test "the file was upload correctly" do
      DirectHomeApi.Aws.MockS3
      |> expect(:upload_files, fn _image -> {:ok, %{}} end)

      image = %Plug.Upload{
        content_type: "image/jpeg",
        filename: "test.jpeg",
        path: "some_path"
      }

      assert DirectHomeApi.Aws.MockS3.upload_files(image) ==
               {:ok, %{}}
    end

    test "the file not was upload" do
      DirectHomeApi.Aws.MockS3
      |> expect(:upload_files, fn _image -> {:error, %{}} end)

      image = %Plug.Upload{
        content_type: "image/jpeg",
        filename: "test.jpeg",
        path: "some_path"
      }

      assert DirectHomeApi.Aws.MockS3.upload_files(image) ==
               {:error, %{}}
    end
  end
end
