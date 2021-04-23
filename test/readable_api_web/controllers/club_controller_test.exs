defmodule ReadableApiWeb.ClubControllerTest do
  use ReadableApiWeb.ConnCase

  alias ReadableApi.Clubs
  alias ReadableApi.Clubs.Club

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:club) do
    {:ok, club} = Clubs.create_club(@create_attrs)
    club
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clubs", %{conn: conn} do
      conn = get(conn, Routes.club_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create club" do
    test "renders club when data is valid", %{conn: conn} do
      conn = post(conn, Routes.club_path(conn, :create), club: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.club_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.club_path(conn, :create), club: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update club" do
    setup [:create_club]

    test "renders club when data is valid", %{conn: conn, club: %Club{id: id} = club} do
      conn = put(conn, Routes.club_path(conn, :update, club), club: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.club_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, club: club} do
      conn = put(conn, Routes.club_path(conn, :update, club), club: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete club" do
    setup [:create_club]

    test "deletes chosen club", %{conn: conn, club: club} do
      conn = delete(conn, Routes.club_path(conn, :delete, club))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.club_path(conn, :show, club))
      end
    end
  end

  defp create_club(_) do
    club = fixture(:club)
    %{club: club}
  end
end
