defmodule Project.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hashed, :string
    field :password, :string, virtual: true
    has_many :workingtimes, Project.Schemas.Workingtime, on_delete: :delete_all
    has_many :clocks, Project.Schemas.Clock, on_delete: :delete_all
    belongs_to :role, Project.Schemas.Role


    timestamps()
    @derive {Jason.Encoder, except: [:__meta__, :workingtimes, :clocks, :role]}
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :email, :password])
    |> cast_assoc(:role)
    |> validate_required([:username, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> hash_pwd
  end

  defp hash_pwd(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pwd}} ->
        put_change(changeset, :password_hashed, Bcrypt.hash_pwd_salt(pwd))
      _ -> changeset
    end
  end
end
