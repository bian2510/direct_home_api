defmodule DirectHomeApi.Model.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias DirectHomeApi.Repo
  alias DirectHomeApi.Model.{User, Property}
  alias DirectHomeApi.Errors.ErrorHandler

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
  # Falta agregar validaciones de documento y sus tests
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

  def changeset_update(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :last_name,
      :phone,
      :photo,
      :document,
      :document_type,
      :password
    ])
  end

  def update_image(id, user_image) do
    s3_provider().upload_files(user_image["photo"])
    |> case do
      {:ok, filename} ->
        changeset =
          Repo.get!(User, id)
          |> cast(%{"photo" => filename}, [:photo])

        case changeset.valid? do
          true ->
            Repo.update!(changeset)
            {:ok, %{"sucess" => "The image was saved sucessfully"}}

          false ->
            {:error, ErrorHandler.changeset_error_to_map(changeset)}
        end

      {:error, _} ->
        {:error, %{"error" => "The image not could be storage in s3"}}
    end
  end

  def get_by_email(email) do
    Repo.get_by(User, email: email)
    |> Repo.preload(properties: [:address, :subscriptions, :property_features, :property_images])
    |> case do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  def get_user(id) do
    Repo.get!(User, id)
  end

  def s3_provider, do: Application.fetch_env!(:direct_home_api, :s3_provider)
end
