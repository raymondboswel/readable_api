defmodule ReadableApiWeb.API.V1.ClubView do
  use ReadableApiWeb, :view
  alias ReadableApiWeb.API.V1.ClubView
  alias ReadableApiWeb.API.V1.BookView

  def render("books.json", %{books: books}) do
    %{data: render_many(books, BookView, "book.json")}
  end

  def render("index.json", %{clubs: clubs}) do
    %{data: render_many(clubs, ClubView, "club.json")}
  end

  def render("show.json", %{club: club}) do
    %{data: render_one(club, ClubView, "club.json")}
  end

  def render("club.json", %{club: club}) do
    %{id: club.id,
      name: club.name}
  end
end
