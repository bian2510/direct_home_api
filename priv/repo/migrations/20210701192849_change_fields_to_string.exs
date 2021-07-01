defmodule DirectHomeApi.Repo.Migrations.ChangeFieldsToString do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      modify :floor, :string
      modify :number, :string
      modify :postal_code, :string
    end
  end
end
