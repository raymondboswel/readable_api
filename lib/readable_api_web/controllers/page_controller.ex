defmodule ReadableApiWeb.PageController do
  use ReadableApiWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/index.html")
  end
end
