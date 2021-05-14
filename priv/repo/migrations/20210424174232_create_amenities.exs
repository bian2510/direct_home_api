defmodule DirectHomeApi.Repo.Migrations.CreateAmenities do
  use Ecto.Migration

  def change do
    create table(:amenities) do
      add :wifi, :boolean, default: false
      add :pets, :boolean, default: false
      add :pool, :boolean, default: false
      add :childrens, :boolean, default: false
      add :laundry, :boolean, default: false
      add :bbq, :boolean, default: false
      add :balcony, :boolean, default: false
      add :porter, :boolean, default: false
      add :gym, :boolean, default: false
      add :parking_lot, :boolean, default: false
      add :property_id, references(:properties, on_delete: :delete_all)

      timestamps()
    end

    create index(:amenities, [:property_id])

  end
end
