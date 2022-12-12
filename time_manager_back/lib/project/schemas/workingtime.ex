defmodule Project.Schemas.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :start, :utc_datetime
    field :end, :utc_datetime
    belongs_to :user, Project.Schemas.User
    timestamps()
    @derive {Jason.Encoder, except: [:__meta__, :user]}
  end

  def changeset(workingtime, params \\ %{}) do
    workingtime
    |> cast(params, [:start, :end])
    |> validate_required([:start, :end])
  end
end
