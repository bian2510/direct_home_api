defmodule DirectHomeApi.Model.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :currency, :string
    field :payment_amount, :integer
    field :payment_date, :naive_datetime
    field :payment_method, :string
    field :transaction_number, :integer
    field :customer_name, :string
    field :customer_email, :string

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [
      :currency,
      :payment_date,
      :payment_amount,
      :payment_method,
      :transaction_number,
      :customer_name,
      :customer_email
    ])
    |> validate_required([
      :currency,
      :payment_date,
      :payment_amount,
      :payment_method,
      :transaction_number,
      :customer_name,
      :customer_email
    ])
  end
end
