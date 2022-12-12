defmodule :"Elixir.Project.Repo.Migrations.Cascade delete" do
  use Ecto.Migration

  def change do
    alter table ("workingtimes") do
      modify :user_id, references(:users, on_delete: :delete_all), null: false

    end
  end
end
defmodule :"Elixir.Project.Repo.Migrations.Cascade delete workingtime" do
  use Ecto.Migration

  def change do
    alter table ("workingtimes") do
      modify :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
