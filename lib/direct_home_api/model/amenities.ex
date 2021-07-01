defmodule DirectHomeApi.Model.Amenities do
  use Ecto.Schema
  import Ecto.Changeset

  alias DirectHomeApi.Model.Property

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :property]}

  schema "amenities" do
    field :wifi, :boolean, default: false
    field :pets, :boolean, default: false
    field :pool, :boolean, default: false
    field :childrens, :boolean, default: false
    field :laundry, :boolean, default: false
    field :bbq, :boolean, default: false
    field :balcony, :boolean, default: false
    field :porter, :boolean, default: false
    field :gym, :boolean, default: false
    field :parking_lot, :boolean, default: false

    belongs_to :property, Property

    timestamps()
  end

  def changeset(amenities, attrs) do
    amenities
    |> cast(attrs, [
      :wifi,
      :pets,
      :pool,
      :childrens,
      :laundry,
      :bbq,
      :balcony,
      :porter,
      :gym,
      :parking_lot,
      :property_id
    ])
    |> validate_required([
      :property_id
    ])
  end

  def changeset_create(amenities, attrs) do
    changeset(amenities, attrs)
  end

  def changeset_update(amenities, attrs) do
    changeset(amenities, attrs)

    amenities
    |> cast(attrs, [
      :wifi,
      :pets,
      :pool,
      :childrens,
      :laundry,
      :bbq,
      :balcony,
      :porter,
      :gym,
      :parking_lot
    ])
  end
end
