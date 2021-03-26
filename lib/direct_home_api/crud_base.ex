defmodule DirectHomeApi.CrudBase do
  alias DirectHomeApi.Repo
  alias DirectHomeApi.Errors.ErrorHandler

  def all(model, preloads) do
    Repo.all(model) |> Repo.preload([preloads])
  end

  def find(model, id, preloads) do
    Repo.get!(model, id) |> Repo.preload(preloads)
  end

  def create(model, struc, attrs, preloads) do
    changeset = model.changeset_create(struc, attrs)

    case changeset.valid? do
      true -> Repo.insert!(changeset) |> Repo.preload(preloads)
      false -> {:error, ErrorHandler.changeset_error_to_map(changeset)}
    end
  end

  def update(model, id, attrs, preloads) do
    changeset = Repo.get!(model, id) |> model.changeset_update(attrs)

    case changeset.valid? do
      true -> Repo.update!(changeset) |> Repo.preload(preloads)
      false -> {:error, ErrorHandler.changeset_error_to_map(changeset)}
    end
  end

  def delete(model, id) do
    Repo.get!(model, id) |> Repo.delete()
  end
end
