defmodule DirectHomeApi.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field :finish_date, :naive_datetime
    field :initial_date, :naive_datetime
    field :status, :boolean, default: false
    field :payment_id, :id
    field :property_id, :id

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:initial_date, :finish_date, :status])
    |> validate_required([:initial_date, :finish_date, :status])
  end
end
