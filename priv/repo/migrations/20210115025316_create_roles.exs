defmodule DirectHomeApi.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :role, :string

      timestamps()
    end

  end
end
