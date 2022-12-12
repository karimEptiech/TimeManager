defmodule Project.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
alias Mix.Tasks.Hex.Repo

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Project.Repo,
      # Start the Telemetry supervisor
      ProjectWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Project.PubSub},
      # Start the Endpoint (http/https)
      ProjectWeb.Endpoint
      # Start a worker by calling: Project.Worker.start_link(arg)
      # {Project.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    :ets.new(:csrf, [:named_table, :public, :set])
    opts = [strategy: :one_for_one, name: Project.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProjectWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
