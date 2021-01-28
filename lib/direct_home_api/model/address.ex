defmodule DirectHomeApi.Model.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias DirectHomeApi.Model.Property

  schema "addresses" do
    field :city, :string
    field :country, :string
    field :floor, :integer
    field :latitude, :string
    field :locality, :string
    field :longitude, :string
    field :number, :integer
    field :postal_code, :integer
    field :reference, :string
    field :street, :string
    belongs_to :property, Property

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :country,
      :city,
      :locality,
      :street,
      :postal_code,
      :number,
      :reference,
      :latitude,
      :longitude,
      :floor,
      :property_id
    ])
    |> validate_required([
      :country,
      :city,
      :locality,
      :street,
      :postal_code,
      :number,
      :reference,
      :latitude,
      :longitude,
      :floor,
      :property_id
    ])
  end
end
