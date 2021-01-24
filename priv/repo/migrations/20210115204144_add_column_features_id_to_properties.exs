defmodule DirectHomeApi.Repo.Migrations.AddColumnFeaturesIdToProperties do
  use Ecto.Migration

  def change do
    alter table("properties") do
      add :features_id, references(:property_features, on_delete: :nothing)
    end
  end
end
