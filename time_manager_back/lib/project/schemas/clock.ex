defmodule Project.Schemas.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :time, :utc_datetime
    field :status, :boolean
    belongs_to :user, Project.Schemas.User

    timestamps()
    @derive {Jason.Encoder, except: [:__meta__, :user]}
  end

  def changeset(clock, params \\ %{}) do
    clock
    |> cast(params, [:time, :status, :user])
    |> validate_required([:time, :status, :user])
  end
end
