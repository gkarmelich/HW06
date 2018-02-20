defmodule TaskTrackerWeb.TrackerController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Task
  alias TaskTracker.Task.Tracker

  def index(conn, _params) do
    tasks = Task.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Task.change_tracker(%Tracker{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tracker" => tracker_params}) do
    case Task.create_tracker(tracker_params) do
      {:ok, tracker} ->
        conn
        |> put_flash(:info, "Tracker created successfully.")
        |> redirect(to: tracker_path(conn, :show, tracker))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tracker = Task.get_tracker!(id)
    render(conn, "show.html", tracker: tracker)
  end

  def edit(conn, %{"id" => id}) do
    tracker = Task.get_tracker!(id)
    changeset = Task.change_tracker(tracker)
    render(conn, "edit.html", tracker: tracker, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tracker" => tracker_params}) do
    tracker = Task.get_tracker!(id)

    case Task.update_tracker(tracker, tracker_params) do
      {:ok, tracker} ->
        conn
        |> put_flash(:info, "Tracker updated successfully.")
        |> redirect(to: tracker_path(conn, :show, tracker))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tracker: tracker, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tracker = Task.get_tracker!(id)
    {:ok, _tracker} = Task.delete_tracker(tracker)

    conn
    |> put_flash(:info, "Tracker deleted successfully.")
    |> redirect(to: tracker_path(conn, :index))
  end
end
