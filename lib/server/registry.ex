defmodule Server.Registry do
  use GenServer
  require Logger

  def start() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def add_subscriber(topic, subscriber) do
    if topic == "tweeter" do
      DynamicSupervisor.start_child(
        ConnectionSupervisor,
        {Transmitter.ConnectionItem, url: "127.0.0.1:4000/tweets/1", subscriber: subscriber}
      )

      DynamicSupervisor.start_child(
        ConnectionSupervisor,
        {Transmitter.ConnectionItem, url: "127.0.0.1:4000/tweets/2", subscriber: subscriber}
      )

    else
      GenServer.cast(__MODULE__, {:add, topic, subscriber})
    end
  end

  def get_all_subscribers() do
    GenServer.cast(__MODULE__, {:get_all_subscribers})
  end

  def get_subscribers_by_topic(topic) do
    GenServer.call(__MODULE__, {:get_subscribers_by_topic, topic})
  end

  @impl true
  def handle_cast({:add, topic, subscriber}, state) do
    {:noreply, [%{topic: topic, subscriber: subscriber} | state]}
  end

  @impl true
  def handle_cast({:get_all_subscribers}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_call({:get_subscribers_by_topic, topic}, _from, state) do
    {:reply, Enum.filter(state, fn map -> map.topic == topic end), state}
  end
end
