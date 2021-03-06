defmodule ReadableApiWeb.API.V1.ClubController do
  use ReadableApiWeb, :controller

  alias ReadableApi.Clubs
  alias ReadableApi.Clubs.Club
  alias ReadableApi.Library

  action_fallback ReadableApiWeb.FallbackController

  def index(conn, _params) do
    user = conn.assigns.current_user
    clubs = Clubs.list_clubs(user)
    IO.inspect (clubs)
    render(conn, "index.json", clubs: clubs)
  end

  def club_books(conn, _params) do
    books = Library.list_books()
    IO.inspect("Got books")
    render(conn, "books.json", books: books)
  end

  def create(conn, %{"club" => club_params}) do
    user = conn.assigns.current_user
    with {:ok, %{club: club, club_user: club_user}} <- Clubs.create_club(club_params, user) do
      conn
      |> put_status(:created)
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
