defmodule ReadableApi.Repo.Migrations.AddClubBooks do
  use Ecto.Migration

  def up do
    create table(:club_books) do
      add :club_id, references(:clubs, on_delete: :nothing)
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create index(:club_books, [:club_id])
    create index(:club_books, [:book_id])
  end

  def down do
    drop table(:club_books)
  end
end
