defmodule ReadableApi.Clubs.BookAvailabilityType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book_availability_types" do
    field :availability_type, :string
    field :reference, :string

    timestamps()
  end

  @doc false
  def changeset(book_availability_type, attrs) do
    book_availability_type
    |> cast(attrs, [:availability_type, :reference])
    |> validate_required([:availability_type, :reference])
  end
end
