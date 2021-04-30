defmodule DirectHomeApi.Aws.S3Test do
    import Mox
    use ExUnit.Case, async: true
    doctest DirectHomeApi.Aws.S3
  
   setup :verify_on_exit!

      test "all is ok" do
        
        DirectHomeApi.Aws.MockS3
        |> expect(:upload_files, fn {_image} -> {:ok, "response"} end)

        File.open("some_path", [:write])

        image = %Plug.Upload{
          content_type: "image/jpeg",
          filename: "test.jpeg",
          path: "some_path"
        }
        
        assert DirectHomeApi.Aws.MockS3.upload_files("image") ==
                {:error, "response"}
      end
  end
