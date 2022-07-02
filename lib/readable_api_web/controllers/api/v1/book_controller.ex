defmodule ReadableApiWeb.API.V1.BookController do
  use ReadableApiWeb, :controller

  alias ReadableApi.Library
  alias ReadableApi.Library.Book

  action_fallback ReadableApiWeb.FallbackController

  def index(conn, _params) do
    user = conn.assigns.current_user
    books = Library.list_books(user)
    render(conn, "index.json", books: books)
  end

  def create(conn, %{"book" => book_params}) do
    user = conn.assigns.current_user

    with {:ok, %Book{} = book} <- Library.create_book(book_params, user) do
      conn
      |> put_status(:created)
      |> render("show.json", book: book)
    end
  end

  def add_book_to_club(conn, %{"id" => club_id, "book" => %{"book_id" => book_id}}) do
    user = conn.assigns.current_user

    with {:ok, _struct} <- Library.assign_book_to_club(club_id, book_id, user) do
      conn
      |> put_status(:created)
    end
  end

  #  def add_book_to_clubs(conn, %{"book_id" => book_id, "clubs" => clubs}) do
  #    user = conn.assigns.current_user
  #
  #  end

  def make_available(conn, %{"book_id" => book_id, "clubs" => clubs}) do
    user = conn.assigns.current_user
    with {:ok, _} <- Library.assign_book_to_clubs(book_id, clubs, user) do
      conn
      |> put_status(:ok)
      send_resp(conn, :ok, "")
    end
  end

  def show(conn, %{"id" => id}) do
    book = Library.get_book!(id)
    render(conn, "show.json", book: book)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Library.get_book!(id)

    with {:ok, %Book{} = book} <- Library.update_book(book, book_params) do
      render(conn, "show.json", book: book)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Library.get_book!(id)

    with {:ok, %Book{}} <- Library.delete_book(book) do
      send_resp(conn, :no_content, "")
    end
  end
end
