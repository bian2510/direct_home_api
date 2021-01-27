defmodule DirectHomeApi.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :country, :string
      add :city, :string
      add :locality, :string
      add :neighborhood, :string
      add :street, :string
      add :postal_code, :integer
      add :number, :integer
      add :reference, :string
      add :latitude, :string
      add :longitude, :string
      add :floor, :integer
      add :property_id, references(:properties, on_delete: :nothing)

      timestamps()
    end

    create index(:addresses, [:property_id])
  end
end
