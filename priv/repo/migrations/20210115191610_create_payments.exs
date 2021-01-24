defmodule DirectHomeApi.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :currency, :string
      add :payment_date, :date
      add :payment_amount, :integer
      add :payment_method, :string
      add :transaction_number, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:payments, [:user_id])
  end
end
