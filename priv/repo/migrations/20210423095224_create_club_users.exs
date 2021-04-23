defmodule ReadableApi.Repo.Migrations.CreateClubUsers do
  use Ecto.Migration

  def change do
    create table(:club_users) do
      add :club_id, references(:clubs, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:club_users, [:club_id])
    create index(:club_users, [:user_id])
  end
end
