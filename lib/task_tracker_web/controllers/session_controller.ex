defmodule TaskTrackerWeb.SessionController do
  use TaskTrackerWeb, :controller

  # Attribution to Nat Tuck
  # http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/12-microblog/notes.html

  def create(conn, %{"email" => email}) do
    user = TaskTracker.Accounts.get_user_by_email(email)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome, #{user.name}")
      |> redirect(to: tracker_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Can't create session")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "You have successfully logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
