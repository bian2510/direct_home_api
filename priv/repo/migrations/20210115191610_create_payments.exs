defmodule DirectHomeApi.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :currency, :string, null: false
      add :payment_date, :date, null: false
      add :payment_amount, :integer, null: false
      add :payment_method, :string, null: false
      add :transaction_number, :integer, null: false
      add :customer_name, :string, null: false
      add :customer_email, :string

      timestamps()
    end
  end
end
