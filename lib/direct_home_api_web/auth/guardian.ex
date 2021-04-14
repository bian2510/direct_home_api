defmodule DirectHomeApiWeb.Auth.Guardian do
  use Guardian, otp_app: :direct_home_api

  alias DirectHomeApi.Model.User

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = User.get_user(id)
    {:ok, resource}
  end

  def authenticate(email, password) do
    with {:ok, user} <- User.get_by_email(email) do
      IO.inspect(user)

      case validate_password(password, user.encrypted_password) do
        true ->
          create_token(user)

        false ->
          {:error, :unauthorized}
      end
    end
  end

  defp validate_password(password, encrypted_password) do
    Bcrypt.verify_pass(password, encrypted_password) |> IO.inspect(label: "VERIFY PASS")
  end

  def create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
