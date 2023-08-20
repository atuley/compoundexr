defmodule Compoundexr.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CompoundexrWeb.Telemetry,
      # Start the Ecto repository
      Compoundexr.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Compoundexr.PubSub},
      # Start Finch
      {Finch, name: Compoundexr.Finch},
      # Start the Endpoint (http/https)
      CompoundexrWeb.Endpoint
      # Start a worker by calling: Compoundexr.Worker.start_link(arg)
      # {Compoundexr.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Compoundexr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CompoundexrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
