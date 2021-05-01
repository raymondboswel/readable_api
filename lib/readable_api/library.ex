defmodule ReadableApi.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias ReadableApi.Repo

  alias ReadableApi.Library.Book
  alias ReadableApi.Accounts.User
  alias ReadableApi.Clubs.UserClubBook

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:o%UserClubBookk, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    # TODO: Check if book exists, if so, return {:ok, book}. This
    # will make books reusable across users, preventing duplicates to an extent
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  def assoc_book_with_user(user, book) do
    user
    |> Repo.preload(:books)
    |> User.user_book_changeset(book)
    |> Repo.update!()
  end

  def make_available_in_club(user, book_id, club_id, availability_ids) do
    %UserClubBook{}
    |> UserClubBook.changeset(%{user_id: user.id, club_id: club_id, book_id: book_id})
    |> Repo.insert!
  end
end
