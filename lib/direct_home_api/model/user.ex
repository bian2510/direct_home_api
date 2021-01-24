defmodule DirectHomeApi.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :document, :integer
    field :document_type, :string
    field :email, :string
    field :last_name, :string
    field :name, :string
    field :password, :string
    field :phone, :integer
    field :photo, :string
    field :role_id, :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :last_name, :phone, :email, :photo, :document, :document_type, :password])
    |> validate_required([:name, :last_name, :phone, :email, :photo, :document, :document_type, :password])
  end
end
