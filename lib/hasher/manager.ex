defmodule Hasher.Manager do
  use GenServer

  @me Hasher.Manager

  alias Hasher.WorkerSupervisor
  alias Hasher.Results

  def start_link(worker_count) do
    GenServer.start_link(@me, worker_count, name: @me)
  end

  def done do
    GenServer.cast(@me, :done)
  end

  # Server implementation

  def init(initial_state) do
    Process.send_after(self(), :kickoff, 0)
    {:ok, initial_state}
  end

  def handle_info(:kickoff, worker_count) do
    1..worker_count |> Enum.each(fn _ -> WorkerSupervisor.spawn_worker() end)
    {:noreply, worker_count}
  end

  def handle_cast(:done, _worker_count = 1) do
    show_results()
    System.halt(0)
  end

  def handle_cast(:done, worker_count) do
    {:noreply, worker_count - 1}
  end

  defp show_results() do
    IO.puts("\n")
    IO.puts("---------------------Results---------------------\n")
    Results.get() |> Enum.each(&IO.inspect/1)
    IO.puts("Done with #{length(Results.get())} words.")
    IO.puts("\n-------------------------------------------------")
    IO.puts("\n")
  end
end
