defmodule ReadableApiWeb.ClubView do
  use ReadableApiWeb, :view
  alias ReadableApiWeb.ClubView

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
