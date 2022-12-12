defmodule Project.Repo.Migrations.RoleTable do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :title, :string
      timestamps()
    end
    alter table("users") do
      add :role_id, references(:roles, on_delete: :delete_all), null: false
    end
  end
end
