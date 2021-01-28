defmodule DirectHomeApi.Repo.Migrations.CreatePropertyFeatures do
  use Ecto.Migration

  def change do
    create table(:property_features) do
      add :bathrooms, :integer, null: false
      add :rooms, :integer, null: false
      add :livings, :integer, null: false
      add :kitchens, :integer, null: false
      add :size, :integer, null: false
      add :property_id, references(:properties, on_delete: :delete_all)

      timestamps()
    end

    create index(:property_features, [:property_id])
  end
end
