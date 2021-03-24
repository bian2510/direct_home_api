defmodule DirectHomeApiWeb.CrudBase do
  alias DirectHomeApi.Repo
  alias DirectHomeApi.Errors.ErrorHandler

  def list_all(model, preloads) do
    Repo.all(model) |> Repo.preload([preloads])
  end

  def get_by_id(user, id, preloads) do
    Repo.get!(user, id) |> Repo.preload(preloads)
  end

  def create(model, struc, attrs, preloads) do
    changeset = model.changeset_create(struc, attrs)
    
    case changeset.valid? do
        true -> Repo.insert!(changeset) |> Repo.preload(preloads)
        false -> {:error, ErrorHandler.changeset_error_to_map(changeset)}
      end
  end
end
