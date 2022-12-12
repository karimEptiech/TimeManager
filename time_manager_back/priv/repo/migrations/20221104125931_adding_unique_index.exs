defmodule Project.Repo.Migrations.AddingUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email])
  end
end
