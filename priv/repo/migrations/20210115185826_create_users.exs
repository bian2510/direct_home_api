defmodule DirectHomeApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :last_name, :string, null: false
      add :phone, :integer, null: false
      add :email, :string, null: false
      add :photo, :string
      add :document, :integer
      add :document_type, :string
      add :password, :string, null: false
      add :type, :string, null: false

      timestamps()
    end

  end
end
