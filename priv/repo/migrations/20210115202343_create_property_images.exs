defmodule DirectHomeApi.Repo.Migrations.CreatePropertyImages do
  use Ecto.Migration

  def change do
    create table(:property_images) do
      add :image_1, :string
      add :image_2, :string
      add :image_3, :string
      add :image_4, :string
      add :image_5, :string
      add :image_6, :string
      add :image_7, :string
      add :image_8, :string
      add :image_9, :string
      add :image_10, :string
      add :image_11, :string
      add :image_12, :string
      add :image_14, :string
      add :image_15, :string
      add :image_16, :string
      add :image_17, :string
      add :image_18, :string
      add :image_19, :string
      add :image_20, :string

      timestamps()
    end
  end
end
