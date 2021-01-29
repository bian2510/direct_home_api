defmodule DirectHomeApi.Model.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias DirectHomeApi.Model.Property

  schema "subscriptions" do
    field :finish_date, :naive_datetime
    field :initial_date, :naive_datetime
    belongs_to :property, Property

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:initial_date, :finish_date, :property_id])
    |> validate_required([:initial_date, :finish_date, :property_id])
  end
end
