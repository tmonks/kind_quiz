defmodule KindQuiz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Run migrations
    KindQuiz.Release.migrate()

    children = [
      # Start the Telemetry supervisor
      KindQuizWeb.Telemetry,
      # Start the Ecto repository
      KindQuiz.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: KindQuiz.PubSub},
      # Start the Endpoint (http/https)
      KindQuizWeb.Endpoint
      # Start a worker by calling: KindQuiz.Worker.start_link(arg)
      # {KindQuiz.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KindQuiz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KindQuizWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
