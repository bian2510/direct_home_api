defmodule DirectHomeApi.Repo.Migrations.CreatePropertyFeatures do
  use Ecto.Migration

  def change do
    create table(:property_features) do
      add :bathrooms, :integer
      add :rooms, :integer
      add :livings, :integer
      add :kitchens, :integer
      add :meters, :integer
      add :property_id, references(:properties, on_delete: :nothing)

      timestamps()
    end

    create index(:property_features, [:property_id])
  end
end
