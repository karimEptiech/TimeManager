defmodule Project.Repo.Migrations.RenamingClockUserField do
  use Ecto.Migration

  def change do
    Ecto.Migration.rename table("clocks"), :user, to: :user_id
  end
end
