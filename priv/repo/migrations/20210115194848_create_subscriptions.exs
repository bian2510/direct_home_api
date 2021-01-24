defmodule DirectHomeApi.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :initial_date, :naive_datetime
      add :finish_date, :naive_datetime
      add :status, :boolean, default: false, null: false
      add :payment_id, references(:payments, on_delete: :nothing)
      add :property_id, references(:properties, on_delete: :nothing)

      timestamps()
    end

    create index(:subscriptions, [:payment_id])
    create index(:subscriptions, [:property_id])
  end
end
