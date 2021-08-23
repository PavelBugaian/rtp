defmodule Transmitter.Receiver do
  use GenServer
  require Logger

  def route(tweet, subscriber) do
    GenServer.cast(__MODULE__, {:get_tweet, tweet, subscriber})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    workers = []
    index = 0

    {:ok, {workers, index}}
  end

  defp get_worker(items, index) do
    len = length items
    index = rem(index, len)
    { Enum.at(items, index), index}
  end

  def set_workers(workers) do
    GenServer.cast(__MODULE__, {:set_workers, workers})
  end

  @impl true
  def handle_cast({:get_tweet, tweet, subscriber}, {workers, index}) do
    Transmitter.Worker.handle(tweet, subscriber)
    {:noreply, {workers, index}}
  end

  @impl true
  def handle_cast({:set_workers, workers}, {_workers, _index}) do
    {:noreply, {workers, 0}}
  end
end
