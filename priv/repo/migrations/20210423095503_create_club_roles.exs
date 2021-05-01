defmodule ReadableApi.Repo.Migrations.CreateClubRoles do
  use Ecto.Migration

  def change do
    create table(:club_roles) do
      add :name, :string
      add :reference, :string

      timestamps()
    end
  end
end
