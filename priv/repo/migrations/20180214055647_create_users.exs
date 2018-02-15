defmodule Apitry.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :text

      timestamps()
    end

  end
end
