defmodule DirectHomeApi.Property do
  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :ambient_numbers, :integer
    field :currency, :string
    field :description, :string
    field :price, :integer
    field :property_type, :string
    field :status, :boolean, default: false
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:description, :price, :currency, :ambient_numbers, :status, :property_type])
    |> validate_required([
      :description,
      :price,
      :currency,
      :ambient_numbers,
      :status,
      :property_type
    ])
  end
end
