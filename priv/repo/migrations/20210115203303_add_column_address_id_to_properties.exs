defmodule DirectHomeApi.Repo.Migrations.AddColumnAddressIdToProperties do
  use Ecto.Migration

  def change do
    alter table("properties") do
      add :address_id, references(:addresses, on_delete: :nothing)
    end
  end
end
