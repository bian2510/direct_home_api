defmodule DirectHomeApi.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :initial_date, :naive_datetime, null: false
      add :finish_date, :naive_datetime, null: false
      add :property_id, references(:properties, on_delete: :delete_all)

      timestamps()
    end

    create index(:subscriptions, [:property_id])
  end
end
