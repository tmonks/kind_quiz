defmodule Quiz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Run migrations
    Quiz.Release.migrate()

    children = [
      # Start the Telemetry supervisor
      QuizWeb.Telemetry,
      # Start the Ecto repository
      Quiz.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Quiz.PubSub},
      # Start the Endpoint (http/https)
      QuizWeb.Endpoint
      # Start a worker by calling: Quiz.Worker.start_link(arg)
      # {Quiz.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Quiz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QuizWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
