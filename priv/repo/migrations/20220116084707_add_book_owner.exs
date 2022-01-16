defmodule ReadableApi.Repo.Migrations.AddBookOwner do
  use Ecto.Migration

  def up do
    alter table(:books) do
      add :owner_id, references(:users, on_delete: :nothing)
    end
  end

  def down do
    alter table(:books) do
      remove :owner_id
    end
  end
end
