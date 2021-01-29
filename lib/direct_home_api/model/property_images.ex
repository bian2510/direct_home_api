defmodule DirectHomeApi.Model.PropertyImages do
  use Ecto.Schema
  import Ecto.Changeset
  alias DirectHomeApi.Model.Property

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
end
