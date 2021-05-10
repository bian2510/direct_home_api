defmodule DirectHomeApi.Aws.S3 do
  @callback upload_files(arg :: any) :: {:ok, map()} | {:ok, map()}

  def upload_files(image) do
    content_type = image.content_type
    file_name = image.filename
    file_path = image.path
    bucket = System.get_env("BUCKET_NAME")

    ExAws.S3.put_object(bucket, file_name, File.read!(file_path), [
      {:content_type, content_type}
    ])
    |> ExAws.request()
    |> case do
      {:ok, _} -> {:ok, file_name}
      {:error, error} -> {:error, error}
    end
  end
end
