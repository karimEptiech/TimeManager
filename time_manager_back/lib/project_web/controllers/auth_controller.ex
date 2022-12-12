defmodule ProjectWeb.AuthController do
  use ProjectWeb, :controller
  alias Project.Schemas.Role
  alias Project.Repo
  alias Project.Schemas.User
  alias Project.Token
  import Bcrypt

  def login(conn, params) do
    email = params["email"]
    password = params["password"]
    user = Repo.get_by(User, email: email)
    case user do
      nil ->
        Plug.Conn.resp(conn, 404, "Not found")
      _ ->
        hash = user.password_hashed
        if Bcrypt.verify_pass(password, hash) do
          signer = Joken.Signer.create("HS256", "secretword")
          csrf = Plug.CSRFProtection.get_csrf_token()
          extra_claims = %{"userID" => user.id, "xsrf" => csrf, "roleID" => user.role_id}
          :ets.insert(:csrf, {user.id, csrf})
          IO.inspect(:ets.lookup(:csrf, user.id))
          {:ok, token, _claims} = Token.generate_and_sign(extra_claims, signer)
          Plug.Conn.resp(conn, 200, token)
        else
          Plug.Conn.resp(conn, 400, "Failed")
        end
    end
  end

  def register(conn, params) do
    #Repo.insert(%Role{title: "user"})
    #Repo.insert(%Role{title: "admin"})
    #Repo.insert(%Role{title: "manager"})
    role = Repo.get_by(Role, title: "user")
    user = User.changeset(%User{}, %{username: params["username"], email: params["email"], password: params["password"]})
    user_changeset = Ecto.build_assoc(role, :users, user.changes)
    IO.inspect(user_changeset)
    case Repo.insert(user_changeset) do
          {:ok, user} ->
            Plug.Conn.resp(conn, 201, Jason.encode!(user))
          {:error, _changeset} ->
            Plug.Conn.resp(conn, 400, "Failed")
        end
  end
end
