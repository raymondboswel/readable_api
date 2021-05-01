defmodule ReadableApiWeb.API.V1.BookController do
  use ReadableApiWeb, :controller

  alias ReadableApi.Library
  alias ReadableApi.Library.Book

  action_fallback ReadableApiWeb.FallbackController

  def index(conn, _params) do
    books = Library.list_books()
    IO.inspect("Got books")
    render(conn, "index.json", books: books)
  end

  def create(conn, %{"book" => book_params}) do
    user = conn.assigns.current_user

    with {:ok, %Book{} = book} <- Library.create_book(book_params),
         user <- Library.assoc_book_with_user(user, book) do
      conn
      |> put_status(:created)
      |> render("show.json", book: book)
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

  def make_book_available_in_club(conn, %{
        "id" => book_id,
        "club_id" => club_id,
        "availability_type_ids" => availability_type_ids
                                  }) do
    user = conn.assigns.current_user
    Library.make_available_in_club(user, book_id,  club_id, availability_type_ids)
  end
end
