defmodule ReadableApi.Clubs.ClubUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias ReadableApi.Clubs.Club
  alias ReadableApi.Accounts.User
  alias ReadableApi.Clubs.ClubRole

  schema "club_users" do
    belongs_to :club, Club
    belongs_to :user, User
    belongs_to :club_role, ClubRole
    timestamps()
  end

  @doc false
  def changeset(club_user, attrs) do
    club_user
    |> cast(attrs, [:club_id, :user_id, :club_role_id])
    |> validate_required([:club_id, :user_id, :club_role_id])
  end
end
