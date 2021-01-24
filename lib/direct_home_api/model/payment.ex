defmodule DirectHomeApi.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :currency, :string
    field :payment_amount, :integer
    field :payment_date, :date
    field :payment_method, :string
    field :transaction_number, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:currency, :payment_date, :payment_amount, :payment_method, :transaction_number])
    |> validate_required([:currency, :payment_date, :payment_amount, :payment_method, :transaction_number])
  end
end
