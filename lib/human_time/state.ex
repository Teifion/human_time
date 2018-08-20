defmodule HumanTime.State do
  @moduledoc false
  
  use GenServer
  
  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end
  
  @spec set(pid, any) :: no_return
  def set(pid, new_state) do
    GenServer.cast(pid, {:set, new_state})
  end
  
  @spec get(pid) :: any
  def get(pid) do
    GenServer.call(pid, :get)
  end
  
  # Server (callbacks)
  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:set, new_state}, _state) do
    {:noreply, new_state}
  end
end