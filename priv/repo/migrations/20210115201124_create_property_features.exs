defmodule DirectHomeApi.Repo.Migrations.CreatePropertyFeatures do
  use Ecto.Migration

  def change do
    create table(:property_features) do
      add :bathrooms, :integer
      add :rooms, :integer
      add :livings, :integer
      add :kitchens, :integer
      add :meters, :integer

      timestamps()
    end
  end
end
