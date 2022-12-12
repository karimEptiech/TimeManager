defmodule :"Elixir.Project.Repo.Migrations." do
  use Ecto.Migration

  def change do
    Ecto.Migration.rename table("workingtimes"), :user, to: :user_id
  end
end
