defmodule TaskTracker.TaskTest do
  use TaskTracker.DataCase

  alias TaskTracker.Task

  describe "tasks" do
    alias TaskTracker.Task.Tracker

    @valid_attrs %{completed: true, description: "some description", name: "some name", time: 42}
    @update_attrs %{completed: false, description: "some updated description", name: "some updated name", time: 43}
    @invalid_attrs %{completed: nil, description: nil, name: nil, time: nil}

    def tracker_fixture(attrs \\ %{}) do
      {:ok, tracker} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Task.create_tracker()

      tracker
    end

    test "list_tasks/0 returns all tasks" do
      tracker = tracker_fixture()
      assert Task.list_tasks() == [tracker]
    end

    test "get_tracker!/1 returns the tracker with given id" do
      tracker = tracker_fixture()
      assert Task.get_tracker!(tracker.id) == tracker
    end

    test "create_tracker/1 with valid data creates a tracker" do
      assert {:ok, %Tracker{} = tracker} = Task.create_tracker(@valid_attrs)
      assert tracker.completed == true
      assert tracker.description == "some description"
      assert tracker.name == "some name"
      assert tracker.time == 42
    end

    test "create_tracker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_tracker(@invalid_attrs)
    end

    test "update_tracker/2 with valid data updates the tracker" do
      tracker = tracker_fixture()
      assert {:ok, tracker} = Task.update_tracker(tracker, @update_attrs)
      assert %Tracker{} = tracker
      assert tracker.completed == false
      assert tracker.description == "some updated description"
      assert tracker.name == "some updated name"
      assert tracker.time == 43
    end

    test "update_tracker/2 with invalid data returns error changeset" do
      tracker = tracker_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_tracker(tracker, @invalid_attrs)
      assert tracker == Task.get_tracker!(tracker.id)
    end

    test "delete_tracker/1 deletes the tracker" do
      tracker = tracker_fixture()
      assert {:ok, %Tracker{}} = Task.delete_tracker(tracker)
      assert_raise Ecto.NoResultsError, fn -> Task.get_tracker!(tracker.id) end
    end

    test "change_tracker/1 returns a tracker changeset" do
      tracker = tracker_fixture()
      assert %Ecto.Changeset{} = Task.change_tracker(tracker)
    end
  end
end
