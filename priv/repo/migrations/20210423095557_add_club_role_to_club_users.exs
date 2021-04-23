defmodule ReadableApi.Repo.Migrations.AddClubRoleToClubUsers do
  use Ecto.Migration

  def up do
    alter table(:club_users) do
      add :club_role_id, references(:club_roles, on_delete: :nothing)
    end
  end

  def down do
    alter table(:club_users) do
      remove :club_role_id
    end
  end
end
