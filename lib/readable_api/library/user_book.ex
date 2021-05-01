defmodule ReadableApi.Library.UserBook do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_books" do
    field :user_id, :id
    field :book_id, :id

    timestamps()
  end

  @doc false
  def changeset(user_book, attrs) do
    user_book
    |> cast(attrs, [])
    |> validate_required([])
  end
end
