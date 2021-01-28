defmodule DirectHomeApi.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :country, :string, null: false
      add :city, :string, null: false
      add :locality, :string, null: false
      add :street, :string, null: false
      add :postal_code, :string
      add :number, :integer, null: false
      add :reference, :string
      add :latitude, :string
      add :longitude, :string
      add :floor, :integer
      add :property_id, references(:properties, on_delete: :delete_all)

      timestamps()
    end

    create index(:addresses, [:property_id])
  end
end
