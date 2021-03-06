defmodule ReadableApi.Clubs.Club do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clubs" do
    field :name, :string
    field :deactivated, :boolean
    has_many(:club_users, ReadableApi.Clubs.ClubUser)
    has_many(:users,  through: [:club_users, :user])
    timestamps()
  end

  @doc false
  def changeset(club, attrs) do
    club
    |> cast(attrs, [:name, :deactivated])
    |> validate_required([:name])
  end
end
