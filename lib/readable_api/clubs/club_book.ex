defmodule ReadableApi.Clubs.ClubBook do
  use Ecto.Schema
  import Ecto.Changeset
  alias ReadableApi.Library.Book
  alias ReadableApi.Clubs.Club

  schema "club_books" do
    belongs_to :club, Club
    belongs_to :book, Book
    timestamps()
  end

  @doc false
  def changeset(club_book, attrs) do
    club_book
    |> cast(attrs, [:club_id, :book_id])
    |> validate_required([:club_id, :book_id])
  end
end
