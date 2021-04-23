defmodule ReadableApiWeb.ClubController do
  use ReadableApiWeb, :controller

  alias ReadableApi.Clubs
  alias ReadableApi.Clubs.Club

  action_fallback ReadableApiWeb.FallbackController

  def index(conn, _params) do
    clubs = Clubs.list_clubs()
    render(conn, "index.json", clubs: clubs)
  end

  def create(conn, %{"club" => club_params}) do
    with {:ok, %Club{} = club} <- Clubs.create_club(club_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.club_path(conn, :show, club))
      |> render("show.json", club: club)
    end
  end

  def show(conn, %{"id" => id}) do
    club = Clubs.get_club!(id)
    render(conn, "show.json", club: club)
  end

  def update(conn, %{"id" => id, "club" => club_params}) do
    club = Clubs.get_club!(id)

    with {:ok, %Club{} = club} <- Clubs.update_club(club, club_params) do
      render(conn, "show.json", club: club)
    end
  end

  def delete(conn, %{"id" => id}) do
    club = Clubs.get_club!(id)

    with {:ok, %Club{}} <- Clubs.delete_club(club) do
      send_resp(conn, :no_content, "")
    end
  end
end
