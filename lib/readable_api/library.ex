defmodule ReadableApi.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias ReadableApi.Repo

  alias ReadableApi.Library.Book
  alias ReadableApi.Clubs.ClubBook

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books(user) do
    query = from b in Book,
          where: b.owner_id == ^user.id

    Repo.all(query)
  end

  def list_books(user, club_id) do
    # TODO: Ensure user is in club
    query = from b in Book,
    inner_join: cb in ClubBook,
    where: cb.club_id == ^club_id and b.owner_id != ^user.id,
    select: %{id: b.id, title: b.title, image_url: nil}

    Repo.all(query)
  end

  def list_user_club_books(user, club_id) do
    query = from b in Book,
    inner_join: cb in ClubBook,
    where: cb.club_id == ^club_id and b.owner_id == ^user.id,
    select: %{id: b.id, title: b.title, image_url: nil}

    Repo.all(query)
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
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}, user) do
    %Book{}
    |> Book.changeset(Map.put(attrs, "owner_id", user.id))
    |> Repo.insert()
  end

  def assign_book_to_club(club_id, book_id, _user) do
    # TODO? Should not allow same book to be added to club twice
    # TODO: Ensure that user is in club

    club_book = %ClubBook{club_id: club_id, book_id: book_id}

    Repo.insert(club_book)

    # book = Repo.get!(Book, book_id)
    # post = Ecto.Changeset.change post, title: "New title"
    # case MyRepo.update post do
    #   {:ok, struct}       -> # Updated with success
    #   {:error, changeset} -> # Something went wrong
    # end
  end

  def assign_book_to_clubs(book_id, clubs, user) do
    Repo.transaction(fn ->
      Enum.each(clubs, fn club ->
        {int_book_id, _} = Integer.parse(book_id)
        assign_book_to_club(club["id"], int_book_id, user)
      end)
    end)

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
end
