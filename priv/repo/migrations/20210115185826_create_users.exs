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
      add :type, :string

      timestamps()
    end

  end
end
