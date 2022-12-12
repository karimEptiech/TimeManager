defmodule Project.Repo.Migrations.AddingPwd do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_hashed, :string, required: true
    end
  end
end
