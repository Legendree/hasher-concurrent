defmodule Hasher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    path = Application.get_env(:hasher, :path)
    worker_count = Application.get_env(:hasher, :worker_count)

    children = [
      Hasher.Results,
      {Hasher.Store, path},
      Hasher.WorkerSupervisor,
      {Hasher.Manager, worker_count}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hasher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
