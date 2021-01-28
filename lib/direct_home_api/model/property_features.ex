defmodule DirectHomeApi.Model.PropertyFeatures do
  use Ecto.Schema
  import Ecto.Changeset
  alias DirectHomeApi.Model.Property

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
    |> validate_required([:bathrooms, :rooms, :livings, :kitchens, :size, :property_id])
  end
end
