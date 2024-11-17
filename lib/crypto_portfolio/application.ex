defmodule CryptoPortfolio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CryptoPortfolioWeb.Telemetry,
      # Start the Ecto repository
      CryptoPortfolio.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: CryptoPortfolio.PubSub},
      # Start Finch
      {Finch, name: CryptoPortfolio.Finch},
      # Start the Endpoint (http/https)
      CryptoPortfolioWeb.Endpoint
      # Start a worker by calling: CryptoPortfolio.Worker.start_link(arg)
      # {CryptoPortfolio.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CryptoPortfolio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CryptoPortfolioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
