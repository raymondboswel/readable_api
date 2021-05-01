defmodule ReadableApi.Repo.Migrations.CreateUserClubBookAvailabilityTypes do
  use Ecto.Migration

  def change do
    create table(:user_club_book_availability_types) do
      add :book_availability_type_id, references(:book_availability_types, on_delete: :nothing)
      add :user_club_book_id, references(:user_club_books, on_delete: :nothing)

      timestamps()
    end

    create index(:user_club_book_availability_types, [:book_availability_type_id], name: :ucb_availability_type)
    create index(:user_club_book_availability_types, [:user_club_book_id])
  end
end
