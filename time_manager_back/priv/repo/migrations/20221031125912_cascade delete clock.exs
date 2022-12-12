defmodule :"Elixir.Project.Repo.Migrations.Cascade delete clock" do
  use Ecto.Migration

  def change do
    alter table ("clocks") do
      modify :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
