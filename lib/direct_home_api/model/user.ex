defmodule DirectHomeApi.Model.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias DirectHomeApi.Model.{Repo, Property}

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at, :password]}

  schema "users" do
    field :document, :integer
    field :document_type, :string
    field :email, :string
    field :last_name, :string
    field :name, :string
    field :password, :string
    field :phone, :integer
    field :photo, :string
    field :type, Ecto.Enum, values: [:admin, :client]
    has_many :properties, Property

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :last_name,
      :phone,
      :email,
      :photo,
      :document,
      :document_type,
      :password
    ])
    |> validate_required([
      :name,
      :last_name,
      :phone,
      :email,
      :photo,
      :document,
      :document_type,
      :password
    ])
    |> unique_constraint([:email, :document])
    |> put_change(:password, Bcrypt.hash_pwd_salt(attrs["password"]))
  end

  def create(user, attrs) do
    changeset = changeset(user, attrs)

    case changeset.valid? do
      true -> Repo.insert(changeset)
      false -> {:error, changeset.errors}
    end
  end
end
