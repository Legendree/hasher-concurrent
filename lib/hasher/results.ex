defmodule Hasher.Results do
  use GenServer

  @me Hasher.Results

  def start_link(_) do
    GenServer.start_link(@me, :no_args, name: @me)
  end

  def add_result(result) do
    GenServer.cast(@me, {:add_result, result})
  end

  def get, do: GenServer.call(@me, :get)

  # Server implementation

  def init(:no_args) do
    {:ok, []}
  end

  def handle_cast({:add_result, result}, state) do
    {:noreply, [result | state]}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
