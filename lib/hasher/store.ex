defmodule Hasher.Store do
  use GenServer

  @me Hasher.Store

  def start_link(path), do: GenServer.start_link(@me, path, name: @me)

  def get_one_word, do: GenServer.call(@me, :get)

  # Server implementation

  def init(path) do
    initial_words = File.stream!(path, [], :line) |> Enum.map(&String.trim/1)
    {:ok, initial_words}
  end

  def handle_call(:get, _from, []) do
    {:reply, nil, []}
  end

  def handle_call(:get, _from, [head | tail]) do
    {:reply, head, tail}
  end
end
