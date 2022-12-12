defmodule Project.Schemas.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :title, :string, default: "user"
    has_many :users, Project.Schemas.User, on_delete: :delete_all
    timestamps()
  end

  def changeset(role, params \\ %{}) do
    role
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
