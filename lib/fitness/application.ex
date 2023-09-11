defmodule Fitness.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Fitness.Repo,
      # Start the Telemetry supervisor
      FitnessWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Fitness.PubSub},
      # Start the Endpoint (http/https)
      FitnessWeb.Endpoint,
      # Start a worker by calling: Fitness.Worker.start_link(arg)
      # {Fitness.Worker, arg}
      {Task.Supervisor, name: FitnessSeedSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fitness.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FitnessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
