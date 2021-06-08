defmodule Hasher.Worker do
  use GenServer, restart: :transient

  alias Hasher.Manager
  alias Hasher.Store
  alias Hasher.Results

  def start_link(_), do: GenServer.start_link(__MODULE__, nil)

  # Server implementation

  def init(_) do
    Process.send_after(self(), :get_word_to_hash, 0)
    {:ok, nil}
  end

  def handle_info(:get_word_to_hash, _) do
    Store.get_one_word() |> hash_word()
  end

  defp hash_word(nil) do
    Manager.done()
    {:stop, :normal, nil}
  end

  defp hash_word(word) when is_bitstring(word) do
    result = :crypto.hash(:md5, word)
    Results.add_result(result)
    send(self(), :get_word_to_hash)
    {:noreply, nil}
  end
end
