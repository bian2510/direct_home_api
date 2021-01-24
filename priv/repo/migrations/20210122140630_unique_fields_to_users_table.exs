defmodule DirectHomeApi.Repo.Migrations.UniqueFieldsToUsersTable do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email, :document])
  end
end
