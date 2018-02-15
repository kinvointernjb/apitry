defmodule Apitry.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Apitry.Accounts.User
  alias Apitry.Blog.Post


  schema "users" do
    field :password, :string
    field :username, :string
    has_many :posts, Post

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
  end
end
