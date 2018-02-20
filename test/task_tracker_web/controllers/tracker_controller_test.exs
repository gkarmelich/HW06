defmodule TaskTrackerWeb.TrackerControllerTest do
  use TaskTrackerWeb.ConnCase

  alias TaskTracker.Task

  @create_attrs %{completed: true, description: "some description", name: "some name", time: 42}
  @update_attrs %{completed: false, description: "some updated description", name: "some updated name", time: 43}
  @invalid_attrs %{completed: nil, description: nil, name: nil, time: nil}

  def fixture(:tracker) do
    {:ok, tracker} = Task.create_tracker(@create_attrs)
    tracker
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get conn, tracker_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Tasks"
    end
  end

  describe "new tracker" do
    test "renders form", %{conn: conn} do
      conn = get conn, tracker_path(conn, :new)
      assert html_response(conn, 200) =~ "New Tracker"
    end
  end

  describe "create tracker" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, tracker_path(conn, :create), tracker: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == tracker_path(conn, :show, id)

      conn = get conn, tracker_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Tracker"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, tracker_path(conn, :create), tracker: @invalid_attrs
      assert html_response(conn, 200) =~ "New Tracker"
    end
  end

  describe "edit tracker" do
    setup [:create_tracker]

    test "renders form for editing chosen tracker", %{conn: conn, tracker: tracker} do
      conn = get conn, tracker_path(conn, :edit, tracker)
      assert html_response(conn, 200) =~ "Edit Tracker"
    end
  end

  describe "update tracker" do
    setup [:create_tracker]

    test "redirects when data is valid", %{conn: conn, tracker: tracker} do
      conn = put conn, tracker_path(conn, :update, tracker), tracker: @update_attrs
      assert redirected_to(conn) == tracker_path(conn, :show, tracker)

      conn = get conn, tracker_path(conn, :show, tracker)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, tracker: tracker} do
      conn = put conn, tracker_path(conn, :update, tracker), tracker: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Tracker"
    end
  end

  describe "delete tracker" do
    setup [:create_tracker]

    test "deletes chosen tracker", %{conn: conn, tracker: tracker} do
      conn = delete conn, tracker_path(conn, :delete, tracker)
      assert redirected_to(conn) == tracker_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, tracker_path(conn, :show, tracker)
      end
    end
  end

  defp create_tracker(_) do
    tracker = fixture(:tracker)
    {:ok, tracker: tracker}
  end
end
