defmodule ReadableApi.Repo.Migrations.CreateUserClubBooks do
  use Ecto.Migration

  def change do
    create table(:user_club_books) do
      add :user_id, references(:users, on_delete: :nothing)
      add :book_id, references(:books, on_delete: :nothing)
      add :club_id, references(:clubs, on_delete: :nothing)

      timestamps()
    end

    create index(:user_club_books, [:user_id])
    create index(:user_club_books, [:book_id])
    create index(:user_club_books, [:club_id])
  end
end
