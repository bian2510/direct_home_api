defmodule DirectHomeApi.Errors.ErrorHandler do
  use Ecto.Schema

  def changeset_error_to_map(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        value =
          case value do
            [value | _] -> value
            _ -> value
          end

        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
