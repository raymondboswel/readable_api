defmodule ReadableApi.ClubsTest do
  use ReadableApi.DataCase

  alias ReadableApi.Clubs

  describe "clubs" do
    alias ReadableApi.Clubs.Club

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def club_fixture(attrs \\ %{}) do
      {:ok, club} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clubs.create_club()

      club
    end

    test "list_clubs/0 returns all clubs" do
      club = club_fixture()
      assert Clubs.list_clubs() == [club]
    end

    test "get_club!/1 returns the club with given id" do
      club = club_fixture()
      assert Clubs.get_club!(club.id) == club
    end

    test "create_club/1 with valid data creates a club" do
      assert {:ok, %Club{} = club} = Clubs.create_club(@valid_attrs)
      assert club.name == "some name"
    end

    test "create_club/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clubs.create_club(@invalid_attrs)
    end

    test "update_club/2 with valid data updates the club" do
      club = club_fixture()
      assert {:ok, %Club{} = club} = Clubs.update_club(club, @update_attrs)
      assert club.name == "some updated name"
    end

    test "update_club/2 with invalid data returns error changeset" do
      club = club_fixture()
      assert {:error, %Ecto.Changeset{}} = Clubs.update_club(club, @invalid_attrs)
      assert club == Clubs.get_club!(club.id)
    end

    test "delete_club/1 deletes the club" do
      club = club_fixture()
      assert {:ok, %Club{}} = Clubs.delete_club(club)
      assert_raise Ecto.NoResultsError, fn -> Clubs.get_club!(club.id) end
    end

    test "change_club/1 returns a club changeset" do
      club = club_fixture()
      assert %Ecto.Changeset{} = Clubs.change_club(club)
    end
  end
end
