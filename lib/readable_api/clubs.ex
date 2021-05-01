defmodule ReadableApi.Clubs do
  @moduledoc """
  The Clubs context.
  """

  import Ecto.Query, warn: false
  alias ReadableApi.Repo

  alias ReadableApi.Clubs.Club
  alias ReadableApi.Clubs.ClubUser
  alias ReadableApi.Clubs.ClubRole
  alias Ecto.Multi
  @doc """
  Returns the list of clubs.

  ## Examples

      iex> list_clubs()
      [%Club{}, ...]

  """
  def list_clubs do
    Repo.all(Club)
  end

  def list_clubs(user) do
    user = Repo.preload(user, :clubs)
    user.clubs
  end

  @doc """
  Gets a single club.

  Raises `Ecto.NoResultsError` if the Club does not exist.

  ## Examples

      iex> get_club!(123)
      %Club{}

      iex> get_club!(456)
      ** (Ecto.NoResultsError)

  """
  def get_club!(id), do: Repo.get!(Club, id)

  @doc """
  Creates a club.

  ## Examples

      iex> create_club(%{field: value})
      {:oClubRolek, %Club{}}

      iex> create_club(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_club(attrs \\ %{}, user) do
    club_changeset =  %Club{} |> Club.changeset(attrs)
    admin_role = Repo.get_by(ClubRole, reference: "admin")
    Multi.new()
    |> Multi.insert(:club, club_changeset)
    |> Multi.run(:club_user, fn repo, %{club: club} ->
      club_user_changeset = ClubUser.changeset(%ClubUser{}, %{"user_id" => user.id, "club_id" => club.id, "club_role_id" => admin_role.id})
      repo.insert(club_user_changeset)
    end )
    |> Repo.transaction

    # %Club{users: [user]}
    # |> Club.changeset(attrs)
    # |> Repo.insert()
  end

  @doc """
  Updates a club.

  ## Examples

      iex> update_club(club, %{field: new_value})
      {:ok, %Club{}}

      iex> update_club(club, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_club(%Club{} = club, attrs) do
    club
    |> Club.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a club.

  ## Examples

      iex> delete_club(club)
      {:ok, %Club{}}

      iex> delete_club(club)
      {:error, %Ecto.Changeset{}}

  """
  def delete_club(%Club{} = club) do
    Repo.delete(club)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking club changes.

  ## Examples

      iex> change_club(club)
      %Ecto.Changeset{data: %Club{}}

  """
  def change_club(%Club{} = club, attrs \\ %{}) do
    Club.changeset(club, attrs)
  end
end
