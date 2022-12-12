defmodule ProjectWeb.AdminController do
  use ProjectWeb, :controller
  alias Project.Token
  alias Project.Repo
  alias Project.Schemas.User
  alias Project.Schemas.Workingtime
  alias Project.Schemas.Clock
  import Ecto.Query

  def index(conn, _params) do
    render(conn, "test.json", message: "HELLO WORLD!")
  end

  def get_all(conn, _params) do
    users = Repo.all(User)
    case users do
      [] ->
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        Plug.Conn.resp(conn, 200, Jason.encode!(users))
    end
  end

  def get_by_email_and_username(conn, params) do
    parameters = Plug.Conn.fetch_query_params(conn, params)
    email = parameters.query_params["email"]
    username = parameters.query_params["username"]
    user = Repo.get_by(User, email: email, username: username)
    case user do
      nil ->
        IO.puts("NOT FOUND")
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        Plug.Conn.resp(conn, 200, Jason.encode!(user))
    end
  end

  def get(conn, params) do
    user = Repo.get(User, params["userID"])
    case user do
      nil ->
        IO.puts("NOT FOUND")
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        Plug.Conn.resp(conn, 200, Jason.encode!(user))
    end
  end

  def update(conn, params) do
    user = Repo.get(User, params["userID"])
    user =  User.changeset(user, %{username: params["username"], email: params["email"], password: params["password"]})
    case Repo.update(user) do
      {:ok, user} ->
        Plug.Conn.resp(conn, 200, Jason.encode!(user))
      {:error, _changeset} ->
        Plug.Conn.resp(conn, 400, "Failed")
    end
  end

  def delete(conn, params) do
    user = Repo.get(User, params["userID"])
    case user do
      nil ->
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        case Repo.delete(user) do
          {:ok, user} ->
            Plug.Conn.resp(conn, 202, Jason.encode!(user))
          {Ecto.StaleEntryError, _changeset} ->
            Plug.Conn.resp(conn, 404, "Not found")
        end
    end
  end

  def get_clocks_by_user_id(conn, params) do
    query = from c in Clock,
      where: c.user_id == ^params["userID"]
    clocks = Repo.all(query)
    case clocks do
      [] ->
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        Plug.Conn.resp(conn, 200, Jason.encode!(clocks))
    end
  end
  def clock_in(conn, params) do
    user = Repo.get_by(User, id: params["userID"])
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
  def create_workingtime(conn, params) do
    {:ok, datetimeStart, 0} = DateTime.from_iso8601(params["start"])
    {:ok, datetimeEnd, 0} = DateTime.from_iso8601(params["end"])
    user = Repo.get_by(User, id: params["userID"])
    worktime = Ecto.build_assoc(user, :workingtimes, %{start: datetimeStart, end: datetimeEnd})
    case Repo.insert(worktime) do
      {:ok, worktime} ->
        Plug.Conn.resp(conn, 201, Jason.encode!(worktime))
      {:error, _changeset} ->
        Plug.Conn.resp(conn, 400, "Failed")
    end
  end

  def get_workingtimes_from_to_by_user_id(conn, params) do
    {:ok, datetimeStart, 0} = DateTime.from_iso8601(params["start"])
    {:ok, datetimeEnd, 0} = DateTime.from_iso8601(params["end"])
    user = Repo.get_by(User, id: params["userID"])
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

  def get_workingtimes_from_to(conn, params) do
    {:ok, datetimeStart, 0} = DateTime.from_iso8601(params["start"])
    {:ok, datetimeEnd, 0} = DateTime.from_iso8601(params["end"])
    query = from w in Workingtime,
      where: w.start >= ^datetimeStart and w.end <= ^datetimeEnd
    worktimes = Repo.all(query)
    case worktimes do
      [] ->
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        Plug.Conn.resp(conn, 200, Jason.encode!(worktimes))
    end
  end

  def get_workingtime_by_user_id_and_id(conn, params) do
    user = Repo.get_by(User, id: params["userID"])
    worktime = Repo.get_by(Workingtime, id: params["id"], user_id: user.id)
    case worktime do
      nil ->
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        Plug.Conn.resp(conn, 200, Jason.encode!(worktime))
    end
  end

  def update_workingtime(conn, params) do
    {:ok, datetimeStart, 0} = DateTime.from_iso8601(params["start"])
    {:ok, datetimeEnd, 0} = DateTime.from_iso8601(params["end"])
    worktime = Repo.get_by(Workingtime, id: params["id"])
    worktime = Workingtime.changeset(worktime, %{start: datetimeStart, end: datetimeEnd})
    case Repo.update(worktime) do
      {:ok, worktime} ->
        Plug.Conn.resp(conn, 200, Jason.encode!(worktime))
      {:error, _changeset} ->
        Plug.Conn.resp(conn, 400, "Failed")
    end
  end

  def delete_workingtime_by_id(conn, params) do
    worktime = Repo.get_by(Workingtime, id: params["id"])
    case worktime do
      nil ->
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        {:ok, res} = Repo.delete(worktime)
        Plug.Conn.resp(conn, 200, Jason.encode!(res))
    end
  end
end
