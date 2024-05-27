defmodule Sonar.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SonarWeb.Telemetry,
      Sonar.Repo,
      {DNSCluster, query: Application.get_env(:sonar, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: :sonar_pubsub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sonar.Finch},
      # Start a worker by calling: Sonar.Worker.start_link(arg)
      # {Sonar.Worker, arg},
      # Start to serve requests, typically the last entry
      SonarWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sonar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SonarWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
