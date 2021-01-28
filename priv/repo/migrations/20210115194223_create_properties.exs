defmodule DirectHomeApi.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    create table(:properties) do
      add :description, :string
      add :price, :integer, null: false
      add :currency, :string, null: false
      add :spaces, :integer
      add :status, :boolean, default: false, null: false
      add :property_type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:properties, [:user_id])
  end
end
