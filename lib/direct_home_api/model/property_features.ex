defmodule DirectHomeApi.Model.PropertyFeatures do
  use Ecto.Schema
  import Ecto.Changeset

  alias DirectHomeApi.Model.Property

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :property]}

  schema "property_features" do
    field :bathrooms, :integer
    field :kitchens, :integer
    field :livings, :integer
    field :size, :integer
    field :rooms, :integer
    belongs_to :property, Property

    timestamps()
  end

  @doc false
  def changeset(property_features, attrs) do
    property_features
    |> cast(attrs, [:bathrooms, :rooms, :livings, :kitchens, :size, :property_id])
    |> validate_required([
      :bathrooms,
      :rooms,
      :livings,
      :kitchens,
      :size,
      :property_id])
  end

  def changeset_create(property_features, attrs) do
    changeset = changeset(property_features, attrs)
  end

  def changeset_update(property_features, attrs) do
    property_features
    |> cast(attrs, [:bathrooms, :rooms, :livings, :kitchens, :size])
  end

end
