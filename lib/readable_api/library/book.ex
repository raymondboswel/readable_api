defmodule ReadableApi.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :image_url, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :image_url])
    |> validate_required([:title, :image_url])
  end
end