defmodule ProjectWeb.Plugs.EnsureRole do
  alias Project.Schemas.Role
  import Plug.Conn
  alias Project.Repo
  def init(opts), do: opts

  def call(conn, opts) do
    role = Repo.get(Role, conn.assigns.claims["roleID"])
    if role.title in opts do
      conn
    else
      conn
      |> unauthorized()
    end
  end

  defp unauthorized(conn) do
    conn
    |> resp(401, "Unauthorized")
    |> send_resp()
    |> halt()
  end
end
