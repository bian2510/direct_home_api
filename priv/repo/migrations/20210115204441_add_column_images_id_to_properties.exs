defmodule DirectHomeApi.Repo.Migrations.AddColumnImagesIdToProperties do
  use Ecto.Migration

  def change do
    alter table("properties") do
      add :images_id, references(:property_images, on_delete: :nothing)
    end
  end
end
