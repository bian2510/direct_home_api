defmodule DirectHomeApi.Repo.Migrations.ChangePhoneToString do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :phone, :string
    end
  end
end
