defmodule ReadableApiWeb.PageController do
  use ReadableApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
