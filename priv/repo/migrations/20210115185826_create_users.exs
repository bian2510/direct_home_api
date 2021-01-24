defmodule DirectHomeApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :last_name, :string
      add :phone, :integer
      add :email, :string
      add :photo, :string
      add :document, :integer
      add :document_type, :string
      add :password, :string
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:role_id])
  end
end
