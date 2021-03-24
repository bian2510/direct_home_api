defmodule DirectHomeApi.Model.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias DirectHomeApi.Errors.ErrorHandler
  alias DirectHomeApi.Repo
  alias DirectHomeApi.Model.Property

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
  #Falta agregar validaciones de documento y sus tests
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
      :password,
      :type
    ])
  end

  def changeset_create(user, attrs) do
    changeset =
      changeset(user, attrs)
      |> validate_required([
        :name,
        :last_name,
        :email,
        :password,
        :type
      ])
      |> unique_constraint([:email])
      |> validate_format(:email, ~r/@/)
      |> unsafe_validate_unique([:email], Repo)
      |> validate_length(:password, min: 8)
      |> put_change(:password, Bcrypt.hash_pwd_salt(attrs["password"]))
  end
end
