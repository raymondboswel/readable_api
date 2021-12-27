defmodule ReadableApi.Repo.Migrations.AddClubsDeactivated do
  use Ecto.Migration

  def up do
    alter table(:clubs) do
      add :deactivated, :boolean, default: false
    end
  end

  def down do
    alter table(:clubs) do
      remove :deactivated
    end
  end
end
