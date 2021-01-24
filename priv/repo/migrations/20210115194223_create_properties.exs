defmodule DirectHomeApi.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    create table(:properties) do
      add :description, :string
      add :price, :integer
      add :currency, :string
      add :ambient_numbers, :integer
      add :status, :boolean, default: false, null: false
      add :property_type, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:properties, [:user_id])
  end
end
