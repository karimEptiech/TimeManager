defmodule ProjectWeb.UserView do
  use ProjectWeb, :view

  def render("test.json", %{message: message}) do
    %{
      message: message
    }
  end

  def render("all.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end
end
