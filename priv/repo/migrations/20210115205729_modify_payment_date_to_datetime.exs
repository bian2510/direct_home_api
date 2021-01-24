defmodule DirectHomeApi.Repo.Migrations.ModifyPaymentDateToDatetime do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      modify :payment_date, :naive_datetime
    end
  end
end
