defmodule DirectHomeApi.Model.Property do
  use Ecto.Schema
  import Ecto.Changeset

  alias DirectHomeApi.Model.{
    Address,
    Amenities,
    Subscription,
    User,
    PropertyFeatures,
    PropertyImages
  }

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :user]}

  schema "properties" do
    field :spaces, :integer
    field :currency, :string
    field :description, :string
    field :price, :integer
    field :property_type, :string
    field :status, :boolean, default: false
    belongs_to :user, User
    has_one :address, Address
    has_one :property_features, PropertyFeatures
    has_many :subscriptions, Subscription
    has_many :property_images, PropertyImages
    has_one :amenities, Amenities

    timestamps()
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:description, :price, :currency, :spaces, :property_type, :user_id])
    |> validate_required([
      :description,
      :price,
      :currency,
      :spaces,
      :property_type,
      :user_id
    ])
  end

  def changeset_create(property, attrs) do
    changeset(property, attrs)
  end

  def changeset_update(property, attrs) do
    property
    |> cast(attrs, [:description, :price, :currency, :spaces, :property_type])
  end

  def preloads do
    [:address, :amenities, :subscriptions, :property_features, :property_images]
  end
end
