defmodule KQ.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Run migrations
    KQ.Release.migrate()

    children = [
      # Start the Telemetry supervisor
      KQWeb.Telemetry,
      # Start the Ecto repository
      KQ.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: KQ.PubSub},
      # Start the Endpoint (http/https)
      KQWeb.Endpoint
      # Start a worker by calling: KQ.Worker.start_link(arg)
      # {KQ.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KQ.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KQWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
