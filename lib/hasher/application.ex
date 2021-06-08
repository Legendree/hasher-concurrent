defmodule Hasher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Hasher.Results,
      {Hasher.Store, ["helo", "sdasdsa"]},
      Hasher.WorkerSupervisor,
      {Hasher.Manager, 1}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hasher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
