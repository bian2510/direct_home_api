defmodule DirectHomeApi.Model.PropertyImages do
  use Ecto.Schema
  import Ecto.Changeset
  alias DirectHomeApi.Model.Property

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

  def changeset_create(property_images, attrs) do
    s3_provider().upload_files(attrs["image"])
    |> case do
      {:ok, filename} ->
        changeset(property_images, %{"image" => "filename", "property_id" => attrs["property_id"]})

      {:error, _} ->
        {:error, %{"error" => "The image not could be storage in s3"}}
    end
  end

  def changeset_update(property_images, attrs) do
    changeset(property_images, attrs)
  end

  def s3_provider, do: Application.fetch_env!(:direct_home_api, :s3_provider)
end
