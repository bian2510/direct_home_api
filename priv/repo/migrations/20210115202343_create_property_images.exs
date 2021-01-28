defmodule DirectHomeApi.Repo.Migrations.CreatePropertyImages do
  use Ecto.Migration

  def change do
    create table(:property_images) do
      add :image, :string
      add :property_id, references(:properties, on_delete: :delete_all)

      timestamps()
    end

    create index(:property_images, [:property_id])
  end
end
