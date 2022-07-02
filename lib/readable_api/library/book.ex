defmodule ReadableApi.Library.Book do
  use Ecto.Schema
  alias ReadableApi.Accounts.User
  import Ecto.Changeset

  schema "books" do
    field :image_url, :string
    field :title, :string
    belongs_to :owner, User, foreign_key: :owner_id
    # Has one owner
    # Has one borrower, available if borrower -> nil
    # Many to Many -> clubs
    has_many(:club_books, ReadableApi.Clubs.ClubBook)
    has_many(:clubs,  through: [:club_books, :club])

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :owner_id])
    |> validate_required([:title])
  end
end
