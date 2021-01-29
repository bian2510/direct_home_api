defmodule DirectHomeApi.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias DirectHomeApi.Repo

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
    field :role_id, :id

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
  end

  def create(user, attrs) do
    changeset =
      changeset(user, attrs)
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
      |> unique_constraint([:email])
      |> unique_constraint([:document])
      |> unsafe_validate_unique([:email], Repo)
      |> unsafe_validate_unique([:document], Repo)
      |> put_change(:password, Bcrypt.hash_pwd_salt(attrs["password"]))

    case changeset.valid? do
      true -> Repo.insert(changeset)
      false -> {:error, changeset.errors}
    end
  end

  def update(id, module, user, attrs) do
    changeset = Repo.get!(module, id) |> changeset(attrs)

    case changeset.valid? do
      true -> Repo.update(changeset) |> IO.inspect()
      false -> {:error, changeset.errors}
    end
  end
end
