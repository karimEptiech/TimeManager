defmodule ProjectWeb.Plugs.AuthPlug do
  import Plug.Conn
  import Joken
  alias Project.Token
  alias Project.Schemas.User
  alias Project.Repo

  def init(opts), do: opts

  def call(conn, _opts) do
    header = get_req_header(conn, "authorization")
    token = String.replace(List.first(header), "Bearer ", "")
    signer = Joken.Signer.create("HS256", "secretword")
    csrf = get_req_header(conn, "x-csrf-token")
    case Token.verify(token, signer) do
      {:ok, claims} ->
        if claims["xsrf"] === List.first(csrf) do
          user = Repo.get(User, claims["userID"])
          conn
          |> assign(:user, user)
          |> assign(:claims, claims)
          |> assign(:id, claims["userID"])
        else
          IO.puts("XSRF NOT MATCH")
          conn
          |> unauthorized()
        end
      {:error, _reason} ->
        IO.puts("TOKEN NOT VALID")
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
