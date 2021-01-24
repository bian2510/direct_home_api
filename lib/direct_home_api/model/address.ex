defmodule DirectHomeApi.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field :city, :string
    field :country, :string
    field :floor, :integer
    field :latitude, :string
    field :locality, :string
    field :longitude, :string
    field :neighborhood, :string
    field :number, :integer
    field :postal_code, :integer
    field :reference, :string
    field :street, :string

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :country,
      :city,
      :locality,
      :neighborhood,
      :street,
      :postal_code,
      :number,
      :reference,
      :latitude,
      :longitude,
      :floor
    ])
    |> validate_required([
      :country,
      :city,
      :locality,
      :neighborhood,
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
