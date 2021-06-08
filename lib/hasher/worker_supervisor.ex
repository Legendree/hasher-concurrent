defmodule Hasher.WorkerSupervisor do
  use DynamicSupervisor

  @me Hasher.WorkerSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(@me, :no_args, name: @me)
  end

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def spawn_worker() do
    {:ok, _pid} = DynamicSupervisor.start_child(@me, Hasher.Worker)
  end
end
