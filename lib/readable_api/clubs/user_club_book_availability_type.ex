defmodule ReadableApi.Clubs.UserClubBookAvailabilityType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_club_book_availability_types" do
    field :book_availability_type_id, :id
    field :user_club_book_id, :id

    timestamps()
  end

  @doc false
  def changeset(user_club_book_availability_type, attrs) do
    user_club_book_availability_type
    |> cast(attrs, [])
    |> validate_required([])
  end
end
