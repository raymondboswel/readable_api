defmodule ReadableApi.Clubs.ClubRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "club_roles" do
    field :name, :string
    field :reference, :string

    timestamps()
  end

  @doc false
  def changeset(club_role, attrs) do
    club_role
    |> cast(attrs, [:name, :reference])
    |> validate_required([:name, :reference])
  end
end
