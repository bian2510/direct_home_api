defmodule DirectHomeApi.Model.Property do
  use Ecto.Schema
  import Ecto.Changeset
  alias DirectHomeApi.Model.{Address, Subscription, User}

  schema "properties" do
    field :spaces, :integer
    field :currency, :string
    field :description, :string
    field :price, :integer
    field :property_type, :string
    field :status, :boolean, default: false
    belongs_to :user, User
    has_one    :address, Address
    has_many   :subscriptions, Subscription

    timestamps()
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:description, :price, :currency, :spaces, :status, :property_type, :user_id])
    |> validate_required([
      :description,
      :price,
      :currency,
      :spaces,
      :status,
      :property_type,
      :user_id
    ])
  end
end
