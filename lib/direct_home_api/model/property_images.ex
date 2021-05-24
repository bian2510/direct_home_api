defmodule DirectHomeApi.Model.PropertyImages do
  use Ecto.Schema
  import Ecto.Changeset
  alias DirectHomeApi.Model.Property
  alias DirectHomeApi.Repo
  alias DirectHomeApi.Errors.ErrorHandler

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :property]}

  schema "property_images" do
    field :image, :string
    belongs_to :property, Property

    timestamps()
  end

  @doc false
  def changeset(property_images, attrs) do
    property_images
    |> cast(attrs, [
      :image,
      :property_id
    ])
    |> validate_required([
      :image,
      :property_id
    ])
  end

  def create(model, property_images, attrs) do
    s3_provider().upload_files(attrs["image"])
    |> case do
      {:ok, filename} ->
        changeset =
          changeset(property_images, %{
            "image" => "filename",
            "property_id" => attrs["property_id"]
          })

        case changeset.valid? do
          true ->
            Repo.insert!(changeset)
            {:ok, %{"sucess" => "The image was saved sucessfully"}}

          false ->
            {:error, ErrorHandler.changeset_error_to_map(changeset)}
        end

      {:error, _} ->
        {:error, %{"error" => "The image not could be storage in s3"}}
    end
  end

  def update(id, model, attrs) do
    s3_provider().upload_files(attrs["image"])
    |> case do
      {:ok, filename} ->
        changeset =
          Repo.get!(model, id)
          |> cast(%{"image" => filename}, [:image])

        case changeset.valid? do
          true ->
            Repo.update!(changeset)
            {:ok, %{"sucess" => "The image was saved sucessfully"}}

          false ->
            {:error, ErrorHandler.changeset_error_to_map(changeset)}
        end

      {:error, _} ->
        {:error, %{"error" => "The image not could be storage in s3"}}
    end
  end

  def s3_provider, do: Application.fetch_env!(:direct_home_api, :s3_provider)
end
