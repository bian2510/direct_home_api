defmodule DirectHomeApi.PropertyImages do
  use Ecto.Schema
  import Ecto.Changeset

  schema "property_images" do
    field :image_1, :string
    field :image_10, :string
    field :image_11, :string
    field :image_12, :string
    field :image_14, :string
    field :image_15, :string
    field :image_16, :string
    field :image_17, :string
    field :image_18, :string
    field :image_19, :string
    field :image_2, :string
    field :image_20, :string
    field :image_3, :string
    field :image_4, :string
    field :image_5, :string
    field :image_6, :string
    field :image_7, :string
    field :image_8, :string
    field :image_9, :string

    timestamps()
  end

  @doc false
  def changeset(property_images, attrs) do
    property_images
    |> cast(attrs, [
      :image_1,
      :image_2,
      :image_3,
      :image_4,
      :image_5,
      :image_6,
      :image_7,
      :image_8,
      :image_9,
      :image_10,
      :image_11,
      :image_12,
      :image_14,
      :image_15,
      :image_16,
      :image_17,
      :image_18,
      :image_19,
      :image_20
    ])
    |> validate_required([
      :image_1,
      :image_2,
      :image_3,
      :image_4,
      :image_5,
      :image_6,
      :image_7,
      :image_8,
      :image_9,
      :image_10,
      :image_11,
      :image_12,
      :image_14,
      :image_15,
      :image_16,
      :image_17,
      :image_18,
      :image_19,
      :image_20
    ])
  end
end
