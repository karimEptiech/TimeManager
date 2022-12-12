defmodule ProjectWeb.UserController do
  use ProjectWeb, :controller
  alias Project.Repo
  alias Project.Schemas.User
  alias Project.Schemas.Workingtime
  alias Project.Schemas.Clock
  import Ecto.Query
  def update(conn, params) do
    user = Repo.get(User, conn.assigns.claims["userID"])
    IO.inspect(user)
    user =  User.changeset(user, %{username: params["username"], email: params["email"], password: params["password"]})
    case Repo.update(user) do
      {:ok, user} ->
        Plug.Conn.resp(conn, 200, Jason.encode!(user))
      {:error, _changeset} ->
        Plug.Conn.resp(conn, 400, "Failed")
    end
  end

  def delete(conn, _params) do
    user = Repo.get(User, conn.assigns.claims["userID"])
    case Repo.delete(user) do
      {:ok, user} ->
        Plug.Conn.resp(conn, 202, Jason.encode!(user))
      {Ecto.StaleEntryError, _changeset} ->
        Plug.Conn.resp(conn, 404, "Not found")
    end
  end

  def clock_in(conn, _params) do
    user = Repo.get_by(User, id: conn.assigns.claims["userID"])
    clocks = Repo.all(from c in Clock, where: c.user_id == ^user.id)
    time = DateTime.utc_now()
    time_formated = DateTime.truncate(time, :second)
    case clocks do
      [] ->
        clock = Ecto.build_assoc(user, :clocks, %{time: time_formated, status: true})
        case Repo.insert(clock) do
          {:ok, clock} ->
            Plug.Conn.resp(conn, 201, Jason.encode!(clock))
          {:error, _changeset} ->
            Plug.Conn.resp(conn, 400, "Failed")
        end
      _ ->
        last_clock = Enum.at(clocks, -1)
        clock = Ecto.build_assoc(user, :clocks, %{time: time_formated, status: !last_clock.status})
        case Repo.insert(clock) do
          {:ok, clock} ->
            Plug.Conn.resp(conn, 201, Jason.encode!(clock))
          {:error, _changeset} ->
            Plug.Conn.resp(conn, 400, "Failed")
        end
    end
  end

  def get_clocks_by_user_id(conn, _params) do
    query = from c in Clock,
      where: c.user_id == ^conn.assigns.claims["userID"]
    clocks = Repo.all(query)
    case clocks do
      [] ->
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        Plug.Conn.resp(conn, 200, Jason.encode!(clocks))
    end
  end

  def get_workingtimes_from_to_by_user_id(conn, params) do
    {:ok, datetimeStart, 0} = DateTime.from_iso8601(params["start"])
    {:ok, datetimeEnd, 0} = DateTime.from_iso8601(params["end"])
    user = Repo.get_by(User, id: conn.assigns.claims["userID"])
    query = from w in Workingtime,
      where: w.user_id == ^user.id and w.start >= ^datetimeStart and w.end <= ^datetimeEnd
    worktimes = Repo.all(query)
    case worktimes do
      [] ->
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        Plug.Conn.resp(conn, 200, Jason.encode!(worktimes))
    end
  end
end
