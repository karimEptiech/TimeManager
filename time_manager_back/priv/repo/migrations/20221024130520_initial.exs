defmodule Project.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    create table ("users") do
      add :username, :string, null: false
      add :email, :string, null: false, format: ~r/@/

      timestamps()
    end
    create table ("clocks") do
      add :time, :utc_datetime, null: false
      add :status, :boolean, null: false
      add :user, references(:users, on_delete: :delete_all),null: false

      timestamps()
    end
    create table ("workingtimes") do
      add :start, :utc_datetime, null: false, format: "{YYYY-MM-DD HH:mm:ss}"
      add :end, :utc_datetime, null: false, format: "{YYYY-MM-DD HH:mm:ss}"
      add :user, references(:users, on_delete: :delete_all), null: false
      timestamps()

    end
  end
end
