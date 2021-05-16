defmodule DirectHomeApi.Model.Amenities do
  use Ecto.Schema

  alias DirectHomeApi.Model.Property

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
end
