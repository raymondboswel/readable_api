defmodule ReadableApi.Clubs.ClubUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "club_users" do
    field :club_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(club_user, attrs) do
    club_user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
