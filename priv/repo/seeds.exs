# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DirectHomeApi.Repo.insert!(%DirectHomeApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DirectHomeApi.Repo
alias DirectHomeApi.{Address, Payment, PropertyFeatures, PropertyImages, Property, Subscription, User}

  Repo.insert! %User{
    document: 95935781,
    document_type: "dni",
    email: "bian251091@gmail.com",
    last_name: "hernandez",
    name: "carlos",
    password: "boni2510*",
    phone: 1173677873,
    photo: "unafoto",
    type: :client,
  }
