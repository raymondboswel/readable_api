defmodule ReadableApi.Clubs.UserClubBook do
  use Ecto.Schema
  import Ecto.Changeset
  alias ReadableApi.Clubs.Club
  alias ReadableApi.Library.Book
  alias ReadableApi.Accounts.User

  schema "user_club_books" do
    belongs_to(:user, User)
    belongs_to(:book, Book)
    belongs_to(:club, Club)

    timestamps()
  end

  @doc false
  def changeset(user_club_book, attrs) do
    user_club_book
    |> cast(attrs, [:user_id, :book_id, :club_id])
    |> validate_required([:user_id, :book_id, :club_id])
  end
end
