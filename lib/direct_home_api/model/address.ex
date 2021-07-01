defmodule DirectHomeApi.Model.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias DirectHomeApi.Model.Property

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :property]}

  schema "addresses" do
    field :city, :string
    field :country, :string
    field :floor, :string
    field :latitude, :string
    field :locality, :string
    field :longitude, :string
    field :number, :string
    field :postal_code, :string
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
      :number,
      :property_id
    ])
  end

  def changeset_create(address, attrs) do
    changeset(address, attrs)
  end

  def changeset_update(address, attrs) do
    changeset(address, attrs)
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
      :floor
    ])
  end
end
