defmodule DirectHomeApi.PropertyFeatures do
  use Ecto.Schema
  import Ecto.Changeset

  schema "property_features" do
    field :bathrooms, :integer
    field :kitchens, :integer
    field :livings, :integer
    field :meters, :integer
    field :rooms, :integer

    timestamps()
  end

  @doc false
  def changeset(property_features, attrs) do
    property_features
    |> cast(attrs, [:bathrooms, :rooms, :livings, :kitchens, :meters])
    |> validate_required([:bathrooms, :rooms, :livings, :kitchens, :meters])
  end
end
