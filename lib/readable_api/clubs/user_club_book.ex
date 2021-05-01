defmodule ReadableApi.Clubs.UserClubBook do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_club_books" do
    field :user_id, :id
    field :book_id, :id
    field :club_id, :id

    timestamps()
  end

  @doc false
  def changeset(user_club_book, attrs) do
    user_club_book
    |> cast(attrs, [])
    |> validate_required([])
  end
end
