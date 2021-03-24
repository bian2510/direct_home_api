defmodule DirectHomeApi.Errors.ErrorHandler do
  use Ecto.Schema
  import Ecto.Changeset

  def changeset_error_to_map(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end