defmodule ReadableApiWeb.API.V1.BookView do
  use ReadableApiWeb, :view

  def render("index.json", %{books: books}) do
    %{data: render_many(books, __MODULE__, "book.json")}
  end

  def render("show.json", %{book: book}) do
    %{data: render_one(book, __MODULE__, "book.json")}
  end

  def render("book.json", %{book: book}) do
    %{
      id: book.id,
      title: book.title,
      image_url: book.image_url
    }
  end

  def render("auth_fail.json", %{error_message: error_message}) do
    %{
      data: %{
        message: error_message
      }
    }
  end
end
